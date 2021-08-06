Date: Fri, 6 Aug 2021 15:55:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YQ2TleuDejJY4O4V@redhat.com>
References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-7-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730150134.216126-7-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 06/10] virtiofsd: Let lo_inode_open()
	return a TempFd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Fri, Jul 30, 2021 at 05:01:30PM +0200, Max Reitz wrote:
> Strictly speaking, this is not necessary, because lo_inode_open() will
> always return a new FD owned by the caller, so TempFd.owned will always
> be true.
> 
> However, auto-cleanup is nice, and in some cases this plays nicely with
> an lo_inode_fd() call in another conditional branch (see lo_setattr()).
> 
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 138 +++++++++++++------------------
>  1 file changed, 59 insertions(+), 79 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 9e1bc37af8..292b7f7e27 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -291,10 +291,8 @@ static void temp_fd_clear(TempFd *temp_fd)
>  /**
>   * Return an owned fd from *temp_fd that will not be closed when
>   * *temp_fd goes out of scope.
> - *
> - * (TODO: Remove __attribute__ once this is used.)
>   */
> -static __attribute__((unused)) int temp_fd_steal(TempFd *temp_fd)
> +static int temp_fd_steal(TempFd *temp_fd)
>  {
>      if (temp_fd->owned) {
>          temp_fd->owned = false;
> @@ -673,9 +671,12 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino, TempFd *tfd)
>   * when a malicious client opens special files such as block device nodes.
>   * Symlink inodes are also rejected since symlinks must already have been
>   * traversed on the client side.
> + *
> + * The fd is returned in tfd->fd.  The return value is 0 on success and -errno
> + * otherwise.
>   */
> -static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
> -                         int open_flags)
> +static int lo_inode_open(const struct lo_data *lo, const struct lo_inode *inode,
> +                         int open_flags, TempFd *tfd)
>  {
>      g_autofree char *fd_str = g_strdup_printf("%d", inode->fd);
>      int fd;
> @@ -694,7 +695,13 @@ static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
>      if (fd < 0) {
>          return -errno;
>      }
> -    return fd;
> +
> +    *tfd = (TempFd) {
> +        .fd = fd,
> +        .owned = true,
> +    };
> +
> +    return 0;
>  }
>  
>  static void lo_init(void *userdata, struct fuse_conn_info *conn)
> @@ -852,7 +859,12 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>          return;
>      }
>  
> -    res = lo_inode_fd(inode, &inode_fd);
> +    if (!fi && (valid & FUSE_SET_ATTR_SIZE)) {
> +        /* We need an O_RDWR FD for ftruncate() */
> +        res = lo_inode_open(lo, inode, O_RDWR, &inode_fd);
> +    } else {
> +        res = lo_inode_fd(inode, &inode_fd);
> +    }

A minor nit.

So inode_fd could hold either an O_PATH fd returned by lo_inode_fd()
or a O_RDWR fd returned by lo_inode_open().

Previous code held these fds in two different variables, inode_fd and
truncfd respectively. I kind of found that easier to read because looking
at variable name, I knew whether I am dealing with O_PATH fd or an
O_RDWR fd I just opened. 

So a minor nit. We could continue to have two variables, say
inode_fd and trunc_fd. Just that type of trunc_fd will now be TempFd.

Also I liked previous style easier to read where I always got hold
of O_PATH fd first. And later opened a O_RDWR fd if operation
is FUSE_ATTR_SIZE. So "valid & FUSE_SET_ATTR_SIZE" check was not
at two places.

Anyway, this is a minor nit. If you don't like the idea of using
two separate variables to hold O_PATH fd and O_RDWR fd, that's ok.


>      if (res < 0) {
>          saverr = -res;
>          goto out_err;
> @@ -900,18 +912,11 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>          if (fi) {
>              truncfd = fd;
>          } else {
> -            truncfd = lo_inode_open(lo, inode, O_RDWR);
> -            if (truncfd < 0) {
> -                saverr = -truncfd;
> -                goto out_err;
> -            }
> +            truncfd = inode_fd.fd;
>          }
>  
>          saverr = drop_security_capability(lo, truncfd);
>          if (saverr) {
> -            if (!fi) {
> -                close(truncfd);
> -            }
>              goto out_err;
>          }
>  
> @@ -919,9 +924,6 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>              res = drop_effective_cap("FSETID", &cap_fsetid_dropped);
>              if (res != 0) {
>                  saverr = res;
> -                if (!fi) {
> -                    close(truncfd);
> -                }
>                  goto out_err;
>              }
>          }
> @@ -934,9 +936,6 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>                  fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_FSETID\n");
>              }
>          }
> -        if (!fi) {
> -            close(truncfd);
> -        }
>          if (res == -1) {
>              goto out_err;
>          }
> @@ -1822,11 +1821,12 @@ static struct lo_dirp *lo_dirp(fuse_req_t req, struct fuse_file_info *fi)
>  static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
>                         struct fuse_file_info *fi)
>  {
> +    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
>      int error = ENOMEM;
>      struct lo_data *lo = lo_data(req);
>      struct lo_inode *inode;
>      struct lo_dirp *d = NULL;
> -    int fd;
> +    int res;
>      ssize_t fh;
>  
>      inode = lo_inode(req, ino);
> @@ -1840,13 +1840,13 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
>          goto out_err;
>      }
>  
> -    fd = lo_inode_open(lo, inode, O_RDONLY);
> -    if (fd < 0) {
> -        error = -fd;
> +    res = lo_inode_open(lo, inode, O_RDONLY, &inode_fd);
> +    if (res < 0) {
> +        error = -res;
>          goto out_err;
>      }
>  
> -    d->dp = fdopendir(fd);
> +    d->dp = fdopendir(temp_fd_steal(&inode_fd));

So we are using temp_fd_steal(), because if fdopendir() is succesful,
we don't want to close fd instead it will be closed during closedir()
call. inode_fd will be closed once lo_opendir(), so we get fd ownership
which will need to close explicitly, when appropriate.

Who closes the stolen fd returned by temp_fd_steal() if fdopendir() fails?

>      if (d->dp == NULL) {
>          goto out_errno;
>      }
> @@ -1876,8 +1876,6 @@ out_err:
>      if (d) {
>          if (d->dp) {
>              closedir(d->dp);
> -        } else if (fd != -1) {
> -            close(fd);
>          }
>          free(d);
>      }
> @@ -2077,6 +2075,7 @@ static void update_open_flags(int writeback, int allow_direct_io,
>  static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
>                        int existing_fd, struct fuse_file_info *fi)
>  {
> +    g_auto(TempFd) inode_fd = TEMP_FD_INIT;

It bothers me that we are using variable inode_fd both to hold O_PATH
fd as well as regular fd. Will be nice if just by looking at variable
name I could figure out which type of fd it is.

Will it make sense to use path_fd, or ipath_fd, or inode_path_fd to
represent where we are using O_PATH fd.


Thanks
Vivek

