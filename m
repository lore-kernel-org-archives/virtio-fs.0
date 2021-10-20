Date: Wed, 20 Oct 2021 13:54:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YXBX0flS4CocXyDk@redhat.com>
References: <20211011030938.109206-1-jefflexu@linux.alibaba.com>
	<20211011030938.109206-6-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011030938.109206-6-jefflexu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [virtiofsd PATCH v6 5/6] virtiofsd: implement file
 size based dax policy
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

On Mon, Oct 11, 2021 at 11:09:37AM +0800, Jeffle Xu wrote:
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
> This policy will be used when '-o dax=server' option is specified for
> virtiofsd.

So enabling DAX based on size is just one type of policy. Tomorrow one
could think of enabling DAX on some other attribute. So only enable it
for non-executable files etc. 

We could be more specific and define a policy say "-o dax=filesize". This
will allow defining other policies easily later. 

But problem with this option is that defining more complex policies
will be hard. Say I want to enable DAX on non-executable files which
have size greater than 32K. Being able to combine multiple policies
will be easy if we implement separate options/knobs to control them
and that will allow turning on multiple policies together.

Say, -o dax_size_threshold=1MB -o dax_no_exec_file

So I guess a generic "-o dax=server" is not a bad idea. As of now this
will implement a default size based policy of 32K size. But one can add
options later to tweak this.

Vivek

> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index b4de86e317..a5a5061906 100644
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
> @@ -61,6 +62,19 @@
>  #include "passthrough_helpers.h"
>  #include "passthrough_seccomp.h"
>  
> +/*
> + * One page descriptor (64 bytes in size) needs to be maintained for every page
> + * in the DAX window chunk, i.e., there is certain guest memory overhead when
> + * DAX is enabled. Thus disable DAX for those files smaller than this certain
> + * memory overhead if virtiofs is mounted in per-file DAX mode, in which case
> + * the guest page cache will consume less memory when DAX is disabled.
> + */
> +#define FUSE_DAX_SHIFT	21
> +#define PAGE_DESC_SHIFT	6
> +#define FUSE_PERFILE_DAX_SHIFT \
> +    (FUSE_DAX_SHIFT - PAGE_SHIFT + PAGE_DESC_SHIFT)
> +#define FUSE_PERFILE_DAX_POINT	(1 << FUSE_PERFILE_DAX_SHIFT)
> +
>  /* Keep track of inode posix locks for each owner. */
>  struct lo_inode_plock {
>      uint64_t lock_owner;
> @@ -986,6 +1000,20 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
>      return 0;
>  }
>  
> +static bool lo_should_enable_dax(struct lo_data *lo,
> +                                 struct fuse_entry_param *e)
> +{
> +    if (lo->dax == DAX_NONE || !S_ISREG(e->attr.st_mode)) {
> +        return false;
> +    }
> +
> +    if (lo->dax & DAX_SERVER) {
> +        return e->attr.st_size > FUSE_PERFILE_DAX_POINT;
> +    }
> +
> +    return false;
> +}
> +
>  /*
>   * Increments nlookup on the inode on success. unref_inode_lolocked() must be
>   * called eventually to decrement nlookup again. If inodep is non-NULL, the
> @@ -1076,6 +1104,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>      }
>      e->ino = inode->fuse_ino;
>  
> +    if (lo_should_enable_dax(lo, e)) {
> +        e->attr_flags |= FUSE_ATTR_DAX;
> +    }
> +
>      /* Transfer ownership of inode pointer to caller or drop it */
>      if (inodep) {
>          *inodep = inode;
> -- 
> 2.27.0
> 

