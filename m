Date: Wed, 3 Feb 2021 16:57:59 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210203165759.352a7f64@bahia.lan>
In-Reply-To: <20210203113719.83633-4-stefanha@redhat.com>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-4-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v4 3/3] virtiofsd: prevent opening of
 special files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com

On Wed,  3 Feb 2021 11:37:19 +0000
Stefan Hajnoczi <stefanha@redhat.com> wrote:

> A well-behaved FUSE client does not attempt to open special files with
> FUSE_OPEN because they are handled on the client side (e.g. device nodes
> are handled by client-side device drivers).
> 
> The check to prevent virtiofsd from opening special files is missing in
> a few cases, most notably FUSE_OPEN. A malicious client can cause
> virtiofsd to open a device node, potentially allowing the guest to
> escape. This can be exploited by a modified guest device driver. It is
> not exploitable from guest userspace since the guest kernel will handle
> special files inside the guest instead of sending FUSE requests.
> 
> This patch fixes this issue by introducing the lo_inode_open() function
> to check the file type before opening it. This is a short-term solution
> because it does not prevent a compromised virtiofsd process from opening
> device nodes on the host.
> 
> Restructure lo_create() to try O_CREAT | O_EXCL first. Note that O_CREAT
> | O_EXCL does not follow symlinks, so O_NOFOLLOW masking is not
> necessary here. If the file exists and the user did not specify O_EXCL,
> open it via lo_do_open().
> 
> Reported-by: Alex Xu <alex@alxu.ca>
> Fixes: CVE-2020-35517
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
> v3:
>  * Restructure lo_create() to handle externally-created files (we need
>    to allocate an inode for them) [Greg]
> v3:
>  * Protect lo_create() [Greg]
> v2:
>  * Add doc comment clarifying that symlinks are traversed client-side
>    [Daniel]
> 
> This issue was diagnosed on public IRC and is therefore already known
> and not embargoed.
> 
> A stronger fix, and the long-term solution, is for users to mount the
> shared directory and any sub-mounts with nodev, as well as nosuid and
> noexec. Unfortunately virtiofsd cannot do this automatically because
> bind mounts added by the user after virtiofsd has launched would not be
> detected. I suggest the following:
> 
> 1. Modify libvirt and Kata Containers to explicitly set these mount
>    options.
> 2. Then modify virtiofsd to check that the shared directory has the
>    necessary options at startup. Refuse to start if the options are
>    missing so that the user is aware of the security requirements.
> 
> As a bonus this also increases the likelihood that other host processes
> besides virtiofsd will be protected by nosuid/noexec/nodev so that a
> malicious guest cannot drop these files in place and then arrange for a
> host process to come across them.
> 
> Additionally, user namespaces have been discussed. They seem like a
> worthwhile addition as an unprivileged or privilege-separated mode
> although there are limitations with respect to security xattrs and the
> actual uid/gid stored on the host file system not corresponding to the
> guest uid/gid.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 139 +++++++++++++++++++------------
>  1 file changed, 88 insertions(+), 51 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index c87a1f3d72..b607ef0f7e 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -555,6 +555,38 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino)
>      return fd;
>  }
>  
> +/*
> + * Open a file descriptor for an inode. Returns -EBADF if the inode is not a
> + * regular file or a directory.
> + *
> + * Use this helper function instead of raw openat(2) to prevent security issues
> + * when a malicious client opens special files such as block device nodes.
> + * Symlink inodes are also rejected since symlinks must already have been
> + * traversed on the client side.
> + */
> +static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
> +                         int open_flags)
> +{
> +    g_autofree char *fd_str = g_strdup_printf("%d", inode->fd);
> +    int fd;
> +
> +    if (!S_ISREG(inode->filetype) && !S_ISDIR(inode->filetype)) {
> +        return -EBADF;
> +    }
> +
> +    /*
> +     * The file is a symlink so O_NOFOLLOW must be ignored. We checked earlier
> +     * that the inode is not a special file but if an external process races
> +     * with us then symlinks are traversed here. It is not possible to escape
> +     * the shared directory since it is mounted as "/" though.
> +     */
> +    fd = openat(lo->proc_self_fd, fd_str, open_flags & ~O_NOFOLLOW);
> +    if (fd < 0) {
> +        return -errno;
> +    }
> +    return fd;
> +}
> +
>  static void lo_init(void *userdata, struct fuse_conn_info *conn)
>  {
>      struct lo_data *lo = (struct lo_data *)userdata;
> @@ -684,8 +716,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>          if (fi) {
>              truncfd = fd;
>          } else {
> -            sprintf(procname, "%i", ifd);
> -            truncfd = openat(lo->proc_self_fd, procname, O_RDWR);
> +            truncfd = lo_inode_open(lo, inode, O_RDWR);
>              if (truncfd < 0) {
>                  goto out_err;
>              }
> @@ -1664,19 +1695,24 @@ static void update_open_flags(int writeback, int allow_direct_io,
>      }
>  }
>  
> +/*
> + * Open a regular file, set up an fd mapping, and fill out the struct
> + * fuse_file_info for it. If existing_fd is not negative, use that fd instead
> + * opening a new one. Takes ownership of existing_fd.
> + */
>  static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
> -                      struct fuse_file_info *fi)
> +                      int existing_fd, struct fuse_file_info *fi)
>  {
> -    char buf[64];
>      ssize_t fh;
> -    int fd;
> +    int fd = existing_fd;
>  
>      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
>  
> -    sprintf(buf, "%i", inode->fd);
> -    fd = openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
> -    if (fd == -1) {
> -        return -errno;
> +    if (fd < 0) {
> +        fd = lo_inode_open(lo, inode, fi->flags);
> +        if (fd == -1) {
> +            return -errno;
> +        }

lo_inode_open() returns a negative errno already so
this should be converted to:

        if (fd < 0) {
            return fd;
        }

Apart from that LGTM.

>      }
>  
>      pthread_mutex_lock(&lo->mutex);
> @@ -1699,9 +1735,10 @@ static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
>  static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>                        mode_t mode, struct fuse_file_info *fi)
>  {
> -    int fd;
> +    int fd = -1;
>      struct lo_data *lo = lo_data(req);
>      struct lo_inode *parent_inode;
> +    struct lo_inode *inode = NULL;
>      struct fuse_entry_param e;
>      int err;
>      struct lo_cred old = {};
> @@ -1727,36 +1764,38 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>  
>      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
>  
> -    fd = openat(parent_inode->fd, name, (fi->flags | O_CREAT) & ~O_NOFOLLOW,
> -                mode);
> +    /* Try to create a new file but don't open existing files */
> +    fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
>      err = fd == -1 ? errno : 0;
> +
>      lo_restore_cred(&old);
>  
> -    if (!err) {
> -        ssize_t fh;
> -
> -        pthread_mutex_lock(&lo->mutex);
> -        fh = lo_add_fd_mapping(lo, fd);
> -        pthread_mutex_unlock(&lo->mutex);
> -        if (fh == -1) {
> -            close(fd);
> -            err = ENOMEM;
> -            goto out;
> -        }
> +    /* Ignore the error if file exists and O_EXCL was not given */
> +    if (err && !(err == EEXIST && !(fi->flags & O_EXCL))) {
> +        goto out;
> +    }
>  
> -        fi->fh = fh;
> -        err = lo_do_lookup(req, parent, name, &e, NULL);
> +    err = lo_do_lookup(req, parent, name, &e, &inode);
> +    if (err) {
> +        goto out;
>      }
> -    if (lo->cache == CACHE_NONE) {
> -        fi->direct_io = 1;
> -    } else if (lo->cache == CACHE_ALWAYS) {
> -        fi->keep_cache = 1;
> +
> +    err = lo_do_open(lo, inode, fd, fi);
> +    fd = -1; /* lo_do_open() takes ownership of fd */
> +    if (err) {
> +        /* Undo lo_do_lookup() nlookup ref */
> +        unref_inode_lolocked(lo, inode, 1);
>      }
>  
>  out:
> +    lo_inode_put(lo, &inode);
>      lo_inode_put(lo, &parent_inode);
>  
>      if (err) {
> +        if (fd >= 0) {
> +            close(fd);
> +        }
> +
>          fuse_reply_err(req, err);
>      } else {
>          fuse_reply_create(req, &e, fi);
> @@ -1770,7 +1809,6 @@ static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
>                                                        pid_t pid, int *err)
>  {
>      struct lo_inode_plock *plock;
> -    char procname[64];
>      int fd;
>  
>      plock =
> @@ -1787,12 +1825,10 @@ static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
>      }
>  
>      /* Open another instance of file which can be used for ofd locks. */
> -    sprintf(procname, "%i", inode->fd);
> -
>      /* TODO: What if file is not writable? */
> -    fd = openat(lo->proc_self_fd, procname, O_RDWR);
> -    if (fd == -1) {
> -        *err = errno;
> +    fd = lo_inode_open(lo, inode, O_RDWR);
> +    if (fd < 0) {
> +        *err = -fd;
>          free(plock);
>          return NULL;
>      }
> @@ -1949,7 +1985,7 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>          return;
>      }
>  
> -    err = lo_do_open(lo, inode, fi);
> +    err = lo_do_open(lo, inode, -1, fi);
>      lo_inode_put(lo, &inode);
>      if (err) {
>          fuse_reply_err(req, err);
> @@ -2014,39 +2050,40 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>  static void lo_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
>                       struct fuse_file_info *fi)
>  {
> +    struct lo_inode *inode = lo_inode(req, ino);
> +    struct lo_data *lo = lo_data(req);
>      int res;
>      int fd;
> -    char *buf;
>  
>      fuse_log(FUSE_LOG_DEBUG, "lo_fsync(ino=%" PRIu64 ", fi=0x%p)\n", ino,
>               (void *)fi);
>  
> +    if (!inode) {
> +        fuse_reply_err(req, EBADF);
> +        return;
> +    }
> +
>      if (!fi) {
> -        struct lo_data *lo = lo_data(req);
> -
> -        res = asprintf(&buf, "%i", lo_fd(req, ino));
> -        if (res == -1) {
> -            return (void)fuse_reply_err(req, errno);
> -        }
> -
> -        fd = openat(lo->proc_self_fd, buf, O_RDWR);
> -        free(buf);
> -        if (fd == -1) {
> -            return (void)fuse_reply_err(req, errno);
> +        fd = lo_inode_open(lo, inode, O_RDWR);
> +        if (fd < 0) {
> +            res = -fd;
> +            goto out;
>          }
>      } else {
>          fd = lo_fi_fd(req, fi);
>      }
>  
>      if (datasync) {
> -        res = fdatasync(fd);
> +        res = fdatasync(fd) == -1 ? errno : 0;
>      } else {
> -        res = fsync(fd);
> +        res = fsync(fd) == -1 ? errno : 0;
>      }
>      if (!fi) {
>          close(fd);
>      }
> -    fuse_reply_err(req, res == -1 ? errno : 0);
> +out:
> +    lo_inode_put(lo, &inode);
> +    fuse_reply_err(req, res);
>  }
>  
>  static void lo_read(fuse_req_t req, fuse_ino_t ino, size_t size, off_t offset,

