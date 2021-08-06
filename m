Date: Fri, 6 Aug 2021 10:16:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YQ1EJxcBlUHA8uek@redhat.com>
References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-2-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730150134.216126-2-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 01/10] virtiofsd: Limit setxattr()'s
 creds-dropped region
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

On Fri, Jul 30, 2021 at 05:01:25PM +0200, Max Reitz wrote:
> We only need to drop/switch our credentials for the (f)setxattr() call
> alone, not for the openat() or fchdir() around it.
> 
> (Right now, this may not be that big of a problem, but with inodes being
> identified by file handles instead of an O_PATH fd, we will need
> open_by_handle_at() calls here, which is really fickle when it comes to
> credentials being dropped.)
> 
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 34 +++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 38b2af8599..1f27eeabc5 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -3121,6 +3121,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>      bool switched_creds = false;
>      bool cap_fsetid_dropped = false;
>      struct lo_cred old = {};
> +    bool open_inode;
>  
>      if (block_xattr(lo, in_name)) {
>          fuse_reply_err(req, EOPNOTSUPP);
> @@ -3155,7 +3156,24 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>      fuse_log(FUSE_LOG_DEBUG, "lo_setxattr(ino=%" PRIu64
>               ", name=%s value=%s size=%zd)\n", ino, name, value, size);
>  
> +    /*
> +     * We can only open regular files or directories.  If the inode is
> +     * something else, we have to enter /proc/self/fd and use
> +     * setxattr() on the link's filename there.
> +     */
> +    open_inode = S_ISREG(inode->filetype) || S_ISDIR(inode->filetype);
>      sprintf(procname, "%i", inode->fd);
> +    if (open_inode) {
> +        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
> +        if (fd < 0) {
> +            saverr = errno;
> +            goto out;
> +        }
> +    } else {
> +        /* fchdir should not fail here */
> +        FCHDIR_NOFAIL(lo->proc_self_fd);
> +    }
> +
>      /*
>       * If we are setting posix access acl and if SGID needs to be
>       * cleared, then switch to caller's gid and drop CAP_FSETID
> @@ -3176,20 +3194,13 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>          }
>          switched_creds = true;
>      }
> -    if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
> -        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
> -        if (fd < 0) {
> -            saverr = errno;
> -            goto out;
> -        }
> +    if (open_inode) {
> +        assert(fd >= 0);
>          ret = fsetxattr(fd, name, value, size, flags);
>          saverr = ret == -1 ? errno : 0;
>      } else {
> -        /* fchdir should not fail here */
> -        FCHDIR_NOFAIL(lo->proc_self_fd);
>          ret = setxattr(procname, name, value, size, flags);
>          saverr = ret == -1 ? errno : 0;
> -        FCHDIR_NOFAIL(lo->root.fd);
>      }
>      if (switched_creds) {
>          if (cap_fsetid_dropped)
> @@ -3198,6 +3209,11 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>              lo_restore_cred(&old, false);
>      }
>  
> +    if (!open_inode) {
> +        /* Change CWD back, fchdir should not fail here */
> +        FCHDIR_NOFAIL(lo->root.fd);
> +    }
> +

This FCHDIR_NOFAIL() will also need to be called if lo_drop_cap_change_cred()
fails. 

        ret = lo_drop_cap_change_cred(req, &old, false, "FSETID",
                                      &cap_fsetid_dropped);
        if (ret) {
            saverr = ret;
            goto out;
        }

Vivek

>  out:
>      if (fd >= 0) {
>          close(fd);
> -- 
> 2.31.1
> 

