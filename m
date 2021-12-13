Date: Mon, 13 Dec 2021 13:09:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YbeMXQaUPj0kHxyi@redhat.com>
References: <20211125070530.79602-1-jefflexu@linux.alibaba.com>
	<20211125070530.79602-4-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125070530.79602-4-jefflexu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v8 3/7] fuse: support per inode DAX in fuse
	protocol
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, joseph.qi@linux.alibaba.com, miklos@szeredi.hu

On Thu, Nov 25, 2021 at 03:05:26PM +0800, Jeffle Xu wrote:
> Expand the fuse protocol to support per inode DAX.
> 
> FUSE_HAS_INODE_DAX flag is added indicating if fuse server/client
> supporting per inode DAX. It can be conveyed in both FUSE_INIT request
> and reply.
> 
> FUSE_ATTR_DAX flag is added indicating if DAX shall be enabled for
> corresponding file. It is conveyed in FUSE_LOOKUP reply.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
> ---
>  include/uapi/linux/fuse.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index a1dc3ee1d17c..63a9a963f4d9 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -187,6 +187,7 @@
>   *
>   *  7.35
>   *  - add FOPEN_NOFLUSH
> + *  - add FUSE_HAS_INODE_DAX, FUSE_ATTR_DAX
>   */
>  
>  #ifndef _LINUX_FUSE_H
> @@ -341,6 +342,7 @@ struct fuse_file_lock {
>   *			write/truncate sgid is killed only if file has group
>   *			execute permission. (Same as Linux VFS behavior).
>   * FUSE_SETXATTR_EXT:	Server supports extended struct fuse_setxattr_in
> + * FUSE_HAS_INODE_DAX:  use per inode DAX
>   */
>  #define FUSE_ASYNC_READ		(1 << 0)
>  #define FUSE_POSIX_LOCKS	(1 << 1)
> @@ -372,6 +374,7 @@ struct fuse_file_lock {
>  #define FUSE_SUBMOUNTS		(1 << 27)
>  #define FUSE_HANDLE_KILLPRIV_V2	(1 << 28)
>  #define FUSE_SETXATTR_EXT	(1 << 29)
> +#define FUSE_HAS_INODE_DAX	(1 << 30)
>  
>  /**
>   * CUSE INIT request/reply flags
> @@ -454,8 +457,10 @@ struct fuse_file_lock {
>   * fuse_attr flags
>   *
>   * FUSE_ATTR_SUBMOUNT: Object is a submount root
> + * FUSE_ATTR_DAX: Enable DAX for this file in per inode DAX mode
>   */
>  #define FUSE_ATTR_SUBMOUNT      (1 << 0)
> +#define FUSE_ATTR_DAX		(1 << 1)
>  
>  /**
>   * Open flags
> -- 
> 2.27.0
> 

