Date: Fri, 10 Jan 2020 11:13:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200110161334.GD28043@redhat.com>
References: <20200110010722.27491-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110010722.27491-1-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix xattr operations
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: virtio-fs@redhat.com

On Fri, Jan 10, 2020 at 10:07:22AM +0900, Misono Tomohiro wrote:
[..]
> @@ -2345,6 +2347,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
>      ssize_t ret;
>      int saverr;
>      int fd = -1;
> +    bool dir_changed = false;
>  
>      inode = lo_inode(req, ino);
>      if (!inode) {

> @@ -2360,16 +2363,20 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
>      fuse_log(FUSE_LOG_DEBUG, "lo_getxattr(ino=%" PRIu64 ", name=%s size=%zd)\n",
>               ino, name, size);
>  
> -    if (inode->is_symlink) {
> -        /* Sorry, no race free way to getxattr on symlink. */
> -        saverr = EPERM;
> -        goto out;
> -    }
> -

What was the race previously on symlinks and how does this code get rid
of that race?

>      sprintf(procname, "%i", inode->fd);
> -    fd = openat(lo->proc_self_fd, procname, O_RDONLY);
> -    if (fd < 0) {
> -        goto out_err;
> +    if (inode->is_regular) {
> +        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
> +        if (fd < 0) {
> +          goto out_err;
> +        }
> +    } else {
> +        ret = fchdir(lo->proc_self_fd);
> +        if (ret < 0) {
> +            /* should not happen */
> +            fuse_log(FUSE_LOG_ERR, "lo_getxattr: fail fchdir to proc_self_fd\n");
> +            goto out_err;
> +        }
> +        dir_changed = true;
>      }
>  
>      if (size) {
> @@ -2378,7 +2385,11 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
>              goto out_err;
>          }
>  
> -        ret = fgetxattr(fd, name, value, size);
> +        if (inode->is_regular) {
> +            ret = fgetxattr(fd, name, value, size);
> +        } else {
> +            ret = getxattr(procname, name, value, size);
> +        }

Do we need "lgetxattr()" instead of "getxattr()" for symlinks?

Say I have following setup.

foo-symlink -> foo.txt

Now lo_lookup(foo-symlink.txt, O_PATH | O_NOFOLLOW), will get fd on
symlink, say 3. And proc should show something similar.

And /proc/self/fd/3 -> /foo-symlink.txt

Now if we do getxattr(3), will it not resolve symlinks and get xattr value
from "foo.txt" instead?

I think in practice that's not happening. So I am misunderstanding
something. What's that?

Thanks
Vivek

