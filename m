Date: Tue, 7 May 2019 14:29:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190507182943.GB19622@redhat.com>
References: <1557208691-43817-1-git-send-email-bo.liu@linux.alibaba.com>
	<1557208691-43817-2-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557208691-43817-2-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 1/2] virtio-fs: send setupmapping with write
 flag only if IOMAP_WRITE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Tue, May 07, 2019 at 01:58:10PM +0800, Liu Bo wrote:
> This is to let virtiofs daemon to do inline fallocate to preallocate
> space for this mapping.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  fs/fuse/file.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 488e932f..6f403c8 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -251,8 +251,8 @@ static void free_dax_mapping(struct fuse_conn *fc,
>  
>  /* offset passed in should be aligned to FUSE_DAX_MEM_RANGE_SZ */
>  static int fuse_setup_one_mapping(struct inode *inode,
> -				struct file *file, loff_t offset,
> -				struct fuse_dax_mapping *dmap)
> +				  struct file *file, loff_t offset, unsigned flags,
> +				  struct fuse_dax_mapping *dmap)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  	struct fuse_inode *fi = get_fuse_inode(inode);
> @@ -276,14 +276,21 @@ static int fuse_setup_one_mapping(struct inode *inode,
>  		inarg.fh = -1;
>  	inarg.moffset = dmap->window_offset;
>  	inarg.len = FUSE_DAX_MEM_RANGE_SZ;
> +
> +       /*
> +	* with IOMAP_WRITE, virtiofs daemon will make sure space is
> +	* allocated for the range.
> +	*/
>  	if (file) {
> -		inarg.flags |= (file->f_mode & FMODE_WRITE) ?
> -				FUSE_SETUPMAPPING_FLAG_WRITE : 0;
> +		if (file->f_mode & FMODE_WRITE &&
> +		    flags & IOMAP_WRITE)
> +			inarg.flags |= FUSE_SETUPMAPPING_FLAG_WRITE;
>  		inarg.flags |= (file->f_mode & FMODE_READ) ?
>  				FUSE_SETUPMAPPING_FLAG_READ : 0;
>  	} else {
>  		inarg.flags |= FUSE_SETUPMAPPING_FLAG_READ;
> -		inarg.flags |= FUSE_SETUPMAPPING_FLAG_WRITE;
> +		if (flags & IOMAP_WRITE)
> +			inarg.flags |= FUSE_SETUPMAPPING_FLAG_WRITE;

Not sure we can afford to map a mapping read only. We don't have a
mechanism yet to upgrade a mapping. IOW, what if one process opens
file read only and does some read. This will lead to a mapping setup
with FUSE_SETUPMAPPING_FLAG_READ which will be cached. Now another process
might open file read/write and try to write to same mapping without
having to go through setupmapping path again and will run into this
-ENOSPC again.

Vivek

>  	}
>  	args.in.h.opcode = FUSE_SETUPMAPPING;
>  	args.in.h.nodeid = fi->nodeid;
> @@ -1847,8 +1854,8 @@ static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
>  
>  		/* Setup one mapping */
>  		ret = fuse_setup_one_mapping(inode, NULL,
> -				ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ),
> -				alloc_dmap);
> +					ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ),
> +					     flags, alloc_dmap);
>  		if (ret < 0) {
>  			printk("fuse_setup_one_mapping() failed. err=%d"
>  				" pos=0x%llx\n", ret, pos);
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

