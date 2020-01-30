Date: Thu, 30 Jan 2020 09:58:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200130145855.GA26448@redhat.com>
References: <20200128101819.21766-1-misono.tomohiro@jp.fujitsu.com>
	<20200128101819.21766-2-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128101819.21766-2-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH v2 1/2] virtiofsd: Fix xattr operations
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

On Tue, Jan 28, 2020 at 07:18:18PM +0900, Misono Tomohiro wrote:
> Current virtiofsd has problems about xattr operations and
> they does not work properly for directory/symlink/special file.
> 
> The fundamental cause is that virtiofsd uses openat() + f...xattr()
> systemcalls for xattr operation but we should not open symlink/special
> file in the daemon. Therefore the function is restricted.
> 
> Fix this problem by:
>  1. during setup of each thread, call unshare(CLONE_FS) so that chdir
>     would not affect other threads
>  2. in xattr operations (i.e. lo_getxattr), use
>     fchdir(proc_loot_fd) + ...xattr() + fchdir(root.fd)
>     instead of openat() + f...xattr() to avoid open files
> 
> With this patch, xfstests generic/062 passes on virtiofs.
> This fix is suggested by Miklos Szeredi and Stefan Hajnoczi.
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> ---
>  tools/virtiofsd/fuse_virtio.c    |  13 ++++
>  tools/virtiofsd/passthrough_ll.c | 100 +++++++++++++++++++------------
>  tools/virtiofsd/seccomp.c        |  10 ++--
>  3 files changed, 81 insertions(+), 42 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 1aac6b8687..ad03a7dcc0 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -463,6 +463,8 @@ err:
>      return ret;
>  }
>  
> +static __thread bool clone_fs_called;
> +
>  /* Process one FVRequest in a thread pool */
>  static void fv_queue_worker(gpointer data, gpointer user_data)
>  {
> @@ -478,6 +480,17 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
>  
>      assert(se->bufsize > sizeof(struct fuse_in_header));
>  
> +    if (!clone_fs_called) {
> +        int ret;
> +
> +        /* unshare FS for xattr operation */
> +        ret = unshare(CLONE_FS);
> +        /* should not fail */
> +        assert(ret == 0);
> +
> +        clone_fs_called = true;
> +    }
> +
>      /*
>       * An element contains one request and the space to send our response
>       * They're spread over multiple descriptors in a scatter/gather set
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index f0093ab84e..6bcc33e0eb 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2362,6 +2362,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
>      ssize_t ret;
>      int saverr;
>      int fd = -1;
> +    bool dir_changed = false;
>  
>      inode = lo_inode(req, ino);
>      if (!inode) {
> @@ -2377,17 +2378,14 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
>      fuse_log(FUSE_LOG_DEBUG, "lo_getxattr(ino=%" PRIu64 ", name=%s size=%zd)\n",
>               ino, name, size);
>  
> -    if (inode->is_symlink) {
> -        /* Sorry, no race free way to getxattr on symlink. */
> -        saverr = EPERM;
> -        goto out;
> -    }
> -
>      sprintf(procname, "%i", inode->fd);
> -    fd = openat(lo->proc_self_fd, procname, O_RDONLY);
> -    if (fd < 0) {
> +    ret = fchdir(lo->proc_self_fd);
> +    if (ret < 0) {
> +        /* should not happen */
> +        fuse_log(FUSE_LOG_ERR, "lo_getxattr: fail fchdir to proc_self_fd\n");
>          goto out_err;
>      }
> +    dir_changed = true;
>  
>      if (size) {
>          value = malloc(size);

I am wondering, is it better to allocate memory first (if need be) and
then do fchdir(). If memory allocation fails, we can return error right
away without having to do fchdir() twice.

Also do we need dir_changed variable? I think if we organize labels
properly, we should be able to get rid of this dir_changed variable.

Same comments apply to lo_listxattr() as well.

Thanks
Vivek

