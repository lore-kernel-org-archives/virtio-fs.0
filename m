Date: Thu, 9 Dec 2021 16:59:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YbJ8MjbX96EiwDxr@redhat.com>
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
	<20211102055646.103337-7-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102055646.103337-7-jefflexu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v7 6/6] virtiofsd: implement file size based
	dax policy
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

On Tue, Nov 02, 2021 at 01:56:46PM +0800, Jeffle Xu wrote:
> When DAX window is fully utilized and needs to be expanded to avoid the
> performance fluctuation triggered by DAX window recaliming, it may not
> be wise to allocate DAX window for files with size smaller than some
> specific point, considering from the perspective of reducing memory
> overhead.
> 
> To maintain one DAX window chunk (e.g., 2MB in size), 32KB
> (512 * 64 bytes) memory footprint will be consumed for page descriptors
> inside guest. Thus it'd better disable DAX for those files smaller than
> 32KB, to reduce the demand for DAX window and thus avoid the unworthy
> memory overhead.
> 
> Thus only flag the file with FUSE_ATTR_DAX when the file size is greater
> than 32 KB. The guest will enable DAX only for those files flagged with
> FUSE_ATTR_DAX, when virtiofs is mounted with '-o dax=inode'.
> 
> To be noted that both FUSE_LOOKUP and FUSE_READDIRPLUS are affected, and
> will convey FUSE_ATTR_DAX flag to the guest.
> 
> This policy will be used when '-o dax=filesize' option is specified for
> virtiofsd.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index dac5063594..cbf81d1593 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -54,6 +54,7 @@
>  #include <sys/syscall.h>
>  #include <sys/wait.h>
>  #include <sys/xattr.h>
> +#include <sys/user.h>
>  #include <syslog.h>
>  #include <linux/fs.h>
>  
> @@ -61,6 +62,20 @@
>  #include "passthrough_helpers.h"
>  #include "passthrough_seccomp.h"
>  
> +/*
> + * One page descriptor (64 bytes in size) needs to be maintained for every page
> + * in the DAX window chunk, i.e., there is certain guest memory overhead when
> + * DAX is enabled. Thus disable DAX for those with file size smaller than this
> + * certain memory overhead if virtiofs is mounted in per inode DAX mode. In
> + * this case, the guest page cache will consume less memory than that when DAX
> + * is enabled.
> + */
> +#define FUSE_DAX_SHIFT      21

Hmm.., this is hardcoded value. If we change chunk size down the
line then it will not be valid anymore.

I guess when we change chunk size, we can think of negotiating
this with server and that will help.

I guess for now it is ok.

Vivek

> +#define PAGE_DESC_SHIFT     6
> +#define FUSE_INODE_DAX_SHIFT \
> +    (FUSE_DAX_SHIFT - PAGE_SHIFT + PAGE_DESC_SHIFT)
> +#define FUSE_INODE_DAX_THRESH  (1 << FUSE_INODE_DAX_SHIFT)
> +
>  /* Keep track of inode posix locks for each owner. */
>  struct lo_inode_plock {
>      uint64_t lock_owner;
> @@ -1052,6 +1067,10 @@ static bool lo_should_enable_dax(struct lo_data *lo, struct lo_inode *inode,
>          return ret;
>      }
>  
> +    if (lo->dax == INODE_DAX_FILESIZE) {
> +        return e->attr.st_size > FUSE_INODE_DAX_THRESH;
> +    }
> +
>      return false;
>  }
>  
> -- 
> 2.27.0
> 

