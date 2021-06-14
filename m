Date: Mon, 14 Jun 2021 17:28:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210614212808.GD869400@redhat.com>
References: <20200722090758.3221812-1-chirantan@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722090758.3221812-1-chirantan@chromium.org>
Subject: Re: [Virtio-fs] [RESEND] [PATCHv4 1/2] uapi: fuse: Add
	FUSE_SECURITY_CTX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net, Stephen Smalley <stephen.smalley.work@gmail.com>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs@redhat.com, selinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>

On Wed, Jul 22, 2020 at 06:07:57PM +0900, Chirantan Ekbote wrote:
> Add the FUSE_SECURITY_CTX flag for the `flags` field of the
> fuse_init_out struct.  When this flag is set the kernel will append the
> security context for a newly created inode to the request (create,
> mkdir, mknod, and symlink).  The server is responsible for ensuring that
> the inode appears atomically with the requested security context.
> 
> For example, if the server is backed by a "real" linux file system then
> it can write the security context value to
> /proc/thread-self/attr/fscreate before making the syscall to create the
> inode.
> 
> Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>

Hi Chirantan,

I am wondering what's the status of this work now. Looks like it
was not merged.

We also need the capability to set selinux security xattrs on newly
created files in virtiofs.  

Will you be interested in reviving this work and send patches again
and copy the selinux as well as linux security module list
(linux-security-module@vger.kernel.org) as suggested by casey.

How are you managing in the meantime. Carrying patches in your own
kernel?

Thanks
Vivek

> ---
> Changes in v4:
>   * Added signoff to commit message.
> 
>  include/uapi/linux/fuse.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 373cada898159..e2099b45fd44b 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -172,6 +172,10 @@
>   *  - add FUSE_WRITE_KILL_PRIV flag
>   *  - add FUSE_SETUPMAPPING and FUSE_REMOVEMAPPING
>   *  - add map_alignment to fuse_init_out, add FUSE_MAP_ALIGNMENT flag
> + *
> + *  7.32
> + *  - add FUSE_SECURITY_CTX flag for fuse_init_out
> + *  - add security context to create, mkdir, symlink, and mknod requests
>   */
>  
>  #ifndef _LINUX_FUSE_H
> @@ -207,7 +211,7 @@
>  #define FUSE_KERNEL_VERSION 7
>  
>  /** Minor version number of this interface */
> -#define FUSE_KERNEL_MINOR_VERSION 31
> +#define FUSE_KERNEL_MINOR_VERSION 32
>  
>  /** The node ID of the root inode */
>  #define FUSE_ROOT_ID 1
> @@ -314,6 +318,7 @@ struct fuse_file_lock {
>   * FUSE_NO_OPENDIR_SUPPORT: kernel supports zero-message opendir
>   * FUSE_EXPLICIT_INVAL_DATA: only invalidate cached pages on explicit request
>   * FUSE_MAP_ALIGNMENT: map_alignment field is valid
> + * FUSE_SECURITY_CTX: add security context to create, mkdir, symlink, and mknod
>   */
>  #define FUSE_ASYNC_READ		(1 << 0)
>  #define FUSE_POSIX_LOCKS	(1 << 1)
> @@ -342,6 +347,7 @@ struct fuse_file_lock {
>  #define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
>  #define FUSE_EXPLICIT_INVAL_DATA (1 << 25)
>  #define FUSE_MAP_ALIGNMENT	(1 << 26)
> +#define FUSE_SECURITY_CTX	(1 << 27)
>  
>  /**
>   * CUSE INIT request/reply flags
> -- 
> 2.27.0.383.g050319c2ae-goog
> 

