Date: Mon, 18 Oct 2021 15:18:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YW3ImM9WhNrZnSxN@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
	<20210916084045.31684-8-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916084045.31684-8-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 07/12] virtiofsd: Let lo_inode_open()
	return a TempFd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Reitz <hreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, Sep 16, 2021 at 10:40:40AM +0200, Hanna Reitz wrote:
> Strictly speaking, this is not necessary, because lo_inode_open() will
> always return a new FD owned by the caller, so TempFd.owned will always
> be true.
> 
> The auto-cleanup is nice, though.  Also, we get a more unified interface
> where you always get a TempFd when you need an FD for an lo_inode
> (regardless of whether it is an O_PATH FD or a non-O_PATH FD).
> 
> Signed-off-by: Hanna Reitz <hreitz@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 156 +++++++++++++++----------------
>  1 file changed, 75 insertions(+), 81 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 3bf20b8659..d257eda129 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -293,10 +293,8 @@ static void temp_fd_clear(TempFd *temp_fd)
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
> @@ -309,10 +307,8 @@ static __attribute__((unused)) int temp_fd_steal(TempFd *temp_fd)
>  /**
>   * Create a borrowing copy of an existing TempFd.  Note that *to is
>   * only valid as long as *from is valid.
> - *
> - * (TODO: Remove __attribute__ once this is used.)
>   */
> -static __attribute__((unused)) void temp_fd_copy(const TempFd *from, TempFd *to)
> +static void temp_fd_copy(const TempFd *from, TempFd *to)
>  {
>      *to = (TempFd) {
>          .fd = from->fd,
> @@ -689,9 +685,12 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino, TempFd *tfd)
>   * when a malicious client opens special files such as block device nodes.
>   * Symlink inodes are also rejected since symlinks must already have been
>   * traversed on the client side.
> + *
> + * The fd is returned in tfd->fd.  The return value is 0 on success and -errno
> + * otherwise.
>   */
>  static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
> -                         int open_flags)
> +                         int open_flags, TempFd *tfd)
>  {
>      g_autofree char *fd_str = g_strdup_printf("%d", inode->fd);
>      int fd;
> @@ -710,7 +709,13 @@ static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
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
> @@ -854,7 +859,8 @@ static int lo_fi_fd(fuse_req_t req, struct fuse_file_info *fi)
>  static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>                         int valid, struct fuse_file_info *fi)
>  {
> -    g_auto(TempFd) path_fd = TEMP_FD_INIT;
> +    g_auto(TempFd) path_fd = TEMP_FD_INIT; /* at least an O_PATH fd */

What does atleast O_PATH fd mean?

> +    g_auto(TempFd) rw_fd = TEMP_FD_INIT; /* O_RDWR fd */
>      int saverr;
>      char procname[64];
>      struct lo_data *lo = lo_data(req);
> @@ -868,7 +874,15 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>          return;
>      }
>  
> -    res = lo_inode_fd(inode, &path_fd);
> +    if (!fi && (valid & FUSE_SET_ATTR_SIZE)) {
> +        /* We need an O_RDWR FD for ftruncate() */
> +        res = lo_inode_open(lo, inode, O_RDWR, &rw_fd);
> +        if (res >= 0) {
> +            temp_fd_copy(&rw_fd, &path_fd);

I am lost here. If lo_inode_open() failed, why are we calling this
temp_fd_copy()? path_fd is not even a valid fd yet.

Still beats me that why open rw_fd now instead of down in
FUSE_SET_ATTR_SIZE block. I think we had this discussion and you
had some reasons to move it up.

Vivek

> +        }
> +    } else {
> +        res = lo_inode_fd(inode, &path_fd);
> +    }
>      if (res < 0) {
>          saverr = -res;
>          goto out_err;
> @@ -916,18 +930,12 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>          if (fi) {
>              truncfd = fd;
>          } else {
> -            truncfd = lo_inode_open(lo, inode, O_RDWR);
> -            if (truncfd < 0) {
> -                saverr = -truncfd;
> -                goto out_err;
> -            }
> +            assert(rw_fd.fd >= 0);
> +            truncfd = rw_fd.fd;
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
> @@ -935,9 +943,6 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>              res = drop_effective_cap("FSETID", &cap_fsetid_dropped);
>              if (res != 0) {
>                  saverr = res;
> -                if (!fi) {
> -                    close(truncfd);
> -                }
>                  goto out_err;
>              }
>          }
> @@ -950,9 +955,6 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>                  fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_FSETID\n");
>              }
>          }
> -        if (!fi) {
> -            close(truncfd);
> -        }
>          if (res == -1) {
>              goto out_err;
>          }
> @@ -1840,11 +1842,13 @@ static struct lo_dirp *lo_dirp(fuse_req_t req, struct fuse_file_info *fi)
>  static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
>                         struct fuse_file_info *fi)
>  {
> +    g_auto(TempFd) rd_fd = TEMP_FD_INIT;
>      int error = ENOMEM;
>      struct lo_data *lo = lo_data(req);
>      struct lo_inode *inode;
>      struct lo_dirp *d = NULL;
>      int fd;
> +    int res;
>      ssize_t fh;
>  
>      inode = lo_inode(req, ino);
> @@ -1858,14 +1862,16 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
>          goto out_err;
>      }
>  
> -    fd = lo_inode_open(lo, inode, O_RDONLY);
> -    if (fd < 0) {
> -        error = -fd;
> +    res = lo_inode_open(lo, inode, O_RDONLY, &rd_fd);
> +    if (res < 0) {
> +        error = -res;
>          goto out_err;
>      }
>  
> +    fd = temp_fd_steal(&rd_fd);
>      d->dp = fdopendir(fd);
>      if (d->dp == NULL) {
> +        close(fd);
>          goto out_errno;
>      }
>  
> @@ -1895,8 +1901,6 @@ out_err:
>      if (d) {
>          if (d->dp) {
>              closedir(d->dp);
> -        } else if (fd != -1) {
> -            close(fd);
>          }
>          free(d);
>      }
> @@ -2096,6 +2100,7 @@ static void update_open_flags(int writeback, int allow_direct_io,
>  static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
>                        int existing_fd, struct fuse_file_info *fi)
>  {
> +    g_auto(TempFd) opened_fd = TEMP_FD_INIT;
>      ssize_t fh;
>      int fd = existing_fd;
>      int err;
> @@ -2112,16 +2117,18 @@ static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
>              }
>          }
>  
> -        fd = lo_inode_open(lo, inode, fi->flags);
> +        err = lo_inode_open(lo, inode, fi->flags, &opened_fd);
>  
>          if (cap_fsetid_dropped) {
>              if (gain_effective_cap("FSETID")) {
>                  fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_FSETID\n");
>              }
>          }
> -        if (fd < 0) {
> -            return -fd;
> +        if (err < 0) {
> +            return -err;
>          }
> +        fd = temp_fd_steal(&opened_fd);
> +
>          if (fi->flags & (O_TRUNC)) {
>              int err = drop_security_capability(lo, fd);
>              if (err) {
> @@ -2231,8 +2238,9 @@ static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
>                                                        uint64_t lock_owner,
>                                                        pid_t pid, int *err)
>  {
> +    g_auto(TempFd) rw_fd = TEMP_FD_INIT;
>      struct lo_inode_plock *plock;
> -    int fd;
> +    int res;
>  
>      plock =
>          g_hash_table_lookup(inode->posix_locks, GUINT_TO_POINTER(lock_owner));
> @@ -2249,15 +2257,15 @@ static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
>  
>      /* Open another instance of file which can be used for ofd locks. */
>      /* TODO: What if file is not writable? */
> -    fd = lo_inode_open(lo, inode, O_RDWR);
> -    if (fd < 0) {
> -        *err = -fd;
> +    res = lo_inode_open(lo, inode, O_RDWR, &rw_fd);
> +    if (res < 0) {
> +        *err = -res;
>          free(plock);
>          return NULL;
>      }
>  
>      plock->lock_owner = lock_owner;
> -    plock->fd = fd;
> +    plock->fd = temp_fd_steal(&rw_fd);
>      g_hash_table_insert(inode->posix_locks, GUINT_TO_POINTER(plock->lock_owner),
>                          plock);
>      return plock;
> @@ -2473,6 +2481,7 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>  static void lo_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
>                       struct fuse_file_info *fi)
>  {
> +    g_auto(TempFd) rw_fd = TEMP_FD_INIT;
>      struct lo_inode *inode = lo_inode(req, ino);
>      struct lo_data *lo = lo_data(req);
>      int res;
> @@ -2487,11 +2496,12 @@ static void lo_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
>      }
>  
>      if (!fi) {
> -        fd = lo_inode_open(lo, inode, O_RDWR);
> -        if (fd < 0) {
> -            res = -fd;
> +        res = lo_inode_open(lo, inode, O_RDWR, &rw_fd);
> +        if (res < 0) {
> +            res = -res;
>              goto out;
>          }
> +        fd = rw_fd.fd;
>      } else {
>          fd = lo_fi_fd(req, fi);
>      }
> @@ -2501,9 +2511,6 @@ static void lo_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
>      } else {
>          res = fsync(fd) == -1 ? errno : 0;
>      }
> -    if (!fi) {
> -        close(fd);
> -    }
>  out:
>      lo_inode_put(lo, &inode);
>      fuse_reply_err(req, res);
> @@ -3065,7 +3072,6 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>      struct lo_inode *inode;
>      ssize_t ret;
>      int saverr;
> -    int fd = -1;
>  
>      if (block_xattr(lo, in_name)) {
>          fuse_reply_err(req, EOPNOTSUPP);
> @@ -3117,12 +3123,14 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>       * Otherwise, call fchdir() to avoid open().
>       */
>      if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
> -        fd = lo_inode_open(lo, inode, O_RDONLY);
> -        if (fd < 0) {
> -            saverr = -fd;
> +        g_auto(TempFd) rd_fd = TEMP_FD_INIT;
> +
> +        ret = lo_inode_open(lo, inode, O_RDONLY, &rd_fd);
> +        if (ret < 0) {
> +            saverr = -ret;
>              goto out;
>          }
> -        ret = fgetxattr(fd, name, value, size);
> +        ret = fgetxattr(rd_fd.fd, name, value, size);
>          saverr = ret == -1 ? errno : 0;
>      } else {
>          g_auto(TempFd) path_fd = TEMP_FD_INIT;
> @@ -3153,10 +3161,6 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>          fuse_reply_xattr(req, ret);
>      }
>  out_free:
> -    if (fd >= 0) {
> -        close(fd);
> -    }
> -
>      lo_inode_put(lo, &inode);
>      return;
>  
> @@ -3176,7 +3180,6 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
>      struct lo_inode *inode;
>      ssize_t ret;
>      int saverr;
> -    int fd = -1;
>  
>      inode = lo_inode(req, ino);
>      if (!inode) {
> @@ -3200,12 +3203,14 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
>      }
>  
>      if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
> -        fd = lo_inode_open(lo, inode, O_RDONLY);
> -        if (fd < 0) {
> -            saverr = -fd;
> +        g_auto(TempFd) rd_fd = TEMP_FD_INIT;
> +
> +        ret = lo_inode_open(lo, inode, O_RDONLY, &rd_fd);
> +        if (ret < 0) {
> +            saverr = -ret;
>              goto out;
>          }
> -        ret = flistxattr(fd, value, size);
> +        ret = flistxattr(rd_fd.fd, value, size);
>          saverr = ret == -1 ? errno : 0;
>      } else {
>          g_auto(TempFd) path_fd = TEMP_FD_INIT;
> @@ -3294,10 +3299,6 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
>          fuse_reply_xattr(req, ret);
>      }
>  out_free:
> -    if (fd >= 0) {
> -        close(fd);
> -    }
> -
>      lo_inode_put(lo, &inode);
>      return;
>  
> @@ -3312,14 +3313,14 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>                          const char *value, size_t size, int flags,
>                          uint32_t extra_flags)
>  {
> -    g_auto(TempFd) path_fd = TEMP_FD_INIT;
> +    g_auto(TempFd) path_fd = TEMP_FD_INIT; /* O_PATH fd */
> +    g_auto(TempFd) rd_fd = TEMP_FD_INIT; /* O_RDONLY fd */
>      const char *name;
>      char *mapped_name;
>      struct lo_data *lo = lo_data(req);
>      struct lo_inode *inode;
>      ssize_t ret;
>      int saverr;
> -    int fd = -1;
>      bool switched_creds = false;
>      bool cap_fsetid_dropped = false;
>      struct lo_cred old = {};
> @@ -3364,9 +3365,9 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>       * setxattr() on the link's filename there.
>       */
>      if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
> -        fd = lo_inode_open(lo, inode, O_RDONLY);
> -        if (fd < 0) {
> -            saverr = -fd;
> +        ret = lo_inode_open(lo, inode, O_RDONLY, &rd_fd);
> +        if (ret < 0) {
> +            saverr = -ret;
>              goto out;
>          }
>      } else {
> @@ -3401,8 +3402,8 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>          }
>          switched_creds = true;
>      }
> -    if (fd >= 0) {
> -        ret = fsetxattr(fd, name, value, size, flags);
> +    if (rd_fd.fd >= 0) {
> +        ret = fsetxattr(rd_fd.fd, name, value, size, flags);
>          saverr = ret == -1 ? errno : 0;
>      } else {
>          char procname[64];
> @@ -3424,10 +3425,6 @@ out:
>          FCHDIR_NOFAIL(lo->root.fd);
>      }
>  
> -    if (fd >= 0) {
> -        close(fd);
> -    }
> -
>      lo_inode_put(lo, &inode);
>      g_free(mapped_name);
>      fuse_reply_err(req, saverr);
> @@ -3442,7 +3439,6 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
>      struct lo_inode *inode;
>      ssize_t ret;
>      int saverr;
> -    int fd = -1;
>  
>      if (block_xattr(lo, in_name)) {
>          fuse_reply_err(req, EOPNOTSUPP);
> @@ -3478,12 +3474,14 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
>               name);
>  
>      if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
> -        fd = lo_inode_open(lo, inode, O_RDONLY);
> -        if (fd < 0) {
> -            saverr = -fd;
> +        g_auto(TempFd) rd_fd = TEMP_FD_INIT;
> +
> +        ret = lo_inode_open(lo, inode, O_RDONLY, &rd_fd);
> +        if (ret < 0) {
> +            saverr = -ret;
>              goto out;
>          }
> -        ret = fremovexattr(fd, name);
> +        ret = fremovexattr(rd_fd.fd, name);
>          saverr = ret == -1 ? errno : 0;
>      } else {
>          g_auto(TempFd) path_fd = TEMP_FD_INIT;
> @@ -3502,10 +3500,6 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
>      }
>  
>  out:
> -    if (fd >= 0) {
> -        close(fd);
> -    }
> -
>      lo_inode_put(lo, &inode);
>      g_free(mapped_name);
>      fuse_reply_err(req, saverr);
> -- 
> 2.31.1
> 

