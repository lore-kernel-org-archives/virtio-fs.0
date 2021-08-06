Date: Fri, 6 Aug 2021 14:25:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YQ1+qPISUq5AhBtT@redhat.com>
References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-5-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730150134.216126-5-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 04/10] virtiofsd: Add lo_inode_fd() helper
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

On Fri, Jul 30, 2021 at 05:01:28PM +0200, Max Reitz wrote:

[..]
> @@ -1335,12 +1359,18 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
>          return;
>      }
>  
> +    res = lo_inode_fd(dir, &dir_fd);
> +    if (res < 0) {
> +        saverr = -res;
> +        goto out;
> +    }
> +
>      saverr = lo_change_cred(req, &old, lo->change_umask && !S_ISLNK(mode));
>      if (saverr) {
>          goto out;
>      }
>  
> -    res = mknod_wrapper(dir->fd, name, link, mode, rdev);
> +    res = mknod_wrapper(dir_fd.fd, name, link, mode, rdev);
>  
>      saverr = errno;
>  
> @@ -1388,6 +1418,8 @@ static void lo_symlink(fuse_req_t req, const char *link, fuse_ino_t parent,
>  static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
>                      const char *name)
>  {
> +    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
> +    g_auto(TempFd) parent_fd = TEMP_FD_INIT;
>      int res;
>      struct lo_data *lo = lo_data(req);
>      struct lo_inode *parent_inode;
> @@ -1413,18 +1445,31 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
>          goto out_err;
>      }
>  
> +    res = lo_inode_fd(inode, &inode_fd);
> +    if (res < 0) {
> +        errno = -res;

In previous function, we saved error to "saverr" and jumped to "out"
label, instead of overwriting to errno.

I would think that it will be good to use a single pattern. Either
save error in saverr or overwrite errno. I personally prefer saving
error into "saverr".

> +        goto out_err;
> +    }
> +
> +    res = lo_inode_fd(parent_inode, &parent_fd);
> +    if (res < 0) {
> +        errno = -res;
> +        goto out_err;
> +    }
> +
>      memset(&e, 0, sizeof(struct fuse_entry_param));
>      e.attr_timeout = lo->timeout;
>      e.entry_timeout = lo->timeout;
>  
> -    sprintf(procname, "%i", inode->fd);
> -    res = linkat(lo->proc_self_fd, procname, parent_inode->fd, name,
> +    sprintf(procname, "%i", inode_fd.fd);
> +    res = linkat(lo->proc_self_fd, procname, parent_fd.fd, name,
>                   AT_SYMLINK_FOLLOW);
>      if (res == -1) {
>          goto out_err;
>      }
>  
> -    res = fstatat(inode->fd, "", &e.attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
> +    res = fstatat(inode_fd.fd, "", &e.attr,
> +                  AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
>      if (res == -1) {
>          goto out_err;
>      }
> @@ -1453,23 +1498,33 @@ out_err:
>  static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
>                                      const char *name)
>  {
> +    g_auto(TempFd) dir_fd = TEMP_FD_INIT;
>      int res;
>      uint64_t mnt_id;
>      struct stat attr;
>      struct lo_data *lo = lo_data(req);
>      struct lo_inode *dir = lo_inode(req, parent);
> +    struct lo_inode *inode = NULL;
>  
>      if (!dir) {
> -        return NULL;
> +        goto out;

Should we continue to just call "return NULL". dir is NULL. That means
lo_inode() failed. That means we never got the reference. So we don't
have to put the reference. If we do "goto out", it will call
lo_inode_put() which is not needed.

>      }
>  
> -    res = do_statx(lo, dir->fd, name, &attr, AT_SYMLINK_NOFOLLOW, &mnt_id);
> -    lo_inode_put(lo, &dir);
> +    res = lo_inode_fd(dir, &dir_fd);
> +    if (res < 0) {
> +        goto out;
> +    }
> +
> +    res = do_statx(lo, dir_fd.fd, name, &attr, AT_SYMLINK_NOFOLLOW, &mnt_id);
>      if (res == -1) {
> -        return NULL;
> +        goto out;
>      }
>  
> -    return lo_find(lo, &attr, mnt_id);
> +    inode = lo_find(lo, &attr, mnt_id);
> +
> +out:
> +    lo_inode_put(lo, &dir);
> +    return inode;
>  }


Thanks
Vivek

