Date: Thu, 9 Dec 2021 14:33:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YbJaJ90FldHUo1/C@redhat.com>
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
	<20211102055646.103337-2-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102055646.103337-2-jefflexu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v7 1/6] virtiofsd: add .ioctl() support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, miklos@szeredi.hu

On Tue, Nov 02, 2021 at 01:56:41PM +0800, Jeffle Xu wrote:
> For passthrough, it passes corresponding ioctls to host directly.
> 
> Currently only these ioctls that handling persistent inode flags, i.e.,
> FS_IOC_[G|S]ETFLAGS and FS_IOC_FS[G|S]ETXATTR are supported for security
> concern, though it's implemented in a quite general way, so that we can
> expand the scope of allowed ioctls if it is really needed later.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  tools/virtiofsd/passthrough_ll.c      | 65 +++++++++++++++++++++++++++
>  tools/virtiofsd/passthrough_seccomp.c |  1 +
>  2 files changed, 66 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index b7c1fa71b5..2768497be4 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -47,6 +47,7 @@
>  #include <dirent.h>
>  #include <pthread.h>
>  #include <sys/file.h>
> +#include <sys/ioctl.h>
>  #include <sys/mount.h>
>  #include <sys/prctl.h>
>  #include <sys/resource.h>
> @@ -54,6 +55,7 @@
>  #include <sys/wait.h>
>  #include <sys/xattr.h>
>  #include <syslog.h>
> +#include <linux/fs.h>
>  
>  #include "qemu/cutils.h"
>  #include "passthrough_helpers.h"
> @@ -2188,6 +2190,68 @@ out:
>      fuse_reply_err(req, saverr);
>  }
>  
> +
> +static void lo_ioctl(fuse_req_t req, fuse_ino_t ino, unsigned int cmd,
> +                     void *arg, struct fuse_file_info *fi,
> +                     unsigned flags, const void *in_buf,
> +                     size_t in_bufsz, size_t out_bufsz)
> +{
> +    int res, dir;
> +    int fd = lo_fi_fd(req, fi);
> +    int saverr = ENOSYS;
> +    void *buf = NULL;
> +    size_t size = 0;
> +
> +    fuse_log(FUSE_LOG_DEBUG, "lo_ioctl(ino=%" PRIu64 ", cmd=0x%x, flags=0x%x, "
> +            "in_bufsz = %lu, out_bufsz = %lu)\n",
> +            ino, cmd, flags, in_bufsz, out_bufsz);
> +
> +    if (!(cmd == FS_IOC_SETFLAGS || cmd == FS_IOC_GETFLAGS ||
> +          cmd == FS_IOC_FSSETXATTR || cmd == FS_IOC_FSGETXATTR)) {
> +        goto out;

Good that you allowed only two operations. Still I think people might
have concern about all the inode attrs and whether it is safe to
allow that. For example immutable flag. Now even host can't delete
that file without first clearing that flag. I think it is doable
just that involves extra step.

So we probably might have to block certain attrs if it becomes an
issue or make it configurable.

> +    }
> +
> +    /* unrestricted ioctl is not supported yet */
> +    if (flags & FUSE_IOCTL_UNRESTRICTED) {
> +        goto out;
> +    }
> +
> +    dir = _IOC_DIR(cmd);
> +
> +    if (dir & _IOC_READ) {
> +        size = out_bufsz;
> +        buf = malloc(size);
> +        if (!buf) {
> +            goto out_err;
> +        }
> +
> +        if (dir & _IOC_WRITE) {
> +            memcpy(buf, in_buf, size);
> +        }
> +
> +        res = ioctl(fd, cmd, buf);
> +    } else if (dir & _IOC_WRITE) {
> +        res = ioctl(fd, cmd, in_buf);
> +    } else {
> +        res = ioctl(fd, cmd, arg);
> +    }

I do not understand this if block. So if _IOC_READ and _IOC_WRITE
is not set, then we just send "arg" as third argument. Can you
shed some light on how this third argument works for file attr
flags. I am assuming that "lsattr" will use the _IOC_READ path,
while chattr will use "_IOC_WRITE" path? If that's the case,
as of now third condition is not even required. Until and unless
we are supporting more ioctls.

Thanks
Vivek
> +
> +    if (res < 0) {
> +        goto out_err;
> +    }
> +
> +    fuse_reply_ioctl(req, 0, buf, size);
> +    free(buf);
> +
> +    return;
> +
> +out_err:
> +    saverr = errno;
> +out:
> +    fuse_reply_err(req, saverr);
> +    free(buf);
> +}
> +
>  static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
>                          struct fuse_file_info *fi)
>  {
> @@ -3474,6 +3538,7 @@ static struct fuse_lowlevel_ops lo_oper = {
>      .fsyncdir = lo_fsyncdir,
>      .create = lo_create,
>      .getlk = lo_getlk,
> +    .ioctl = lo_ioctl,
>      .setlk = lo_setlk,
>      .open = lo_open,
>      .release = lo_release,
> diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
> index f49ed94b5e..eaed5b151b 100644
> --- a/tools/virtiofsd/passthrough_seccomp.c
> +++ b/tools/virtiofsd/passthrough_seccomp.c
> @@ -62,6 +62,7 @@ static const int syscall_allowlist[] = {
>      SCMP_SYS(gettid),
>      SCMP_SYS(gettimeofday),
>      SCMP_SYS(getxattr),
> +    SCMP_SYS(ioctl),
>      SCMP_SYS(linkat),
>      SCMP_SYS(listxattr),
>      SCMP_SYS(lseek),
> -- 
> 2.27.0
> 

