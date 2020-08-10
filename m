Date: Tue, 11 Aug 2020 08:22:38 +1000
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20200810222238.GD2079@dread.disaster.area>
References: <20200807195526.426056-1-vgoyal@redhat.com>
	<20200807195526.426056-16-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200807195526.426056-16-vgoyal@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v2 15/20] fuse,
 dax: Take ->i_mmap_sem lock during dax page fault
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Fri, Aug 07, 2020 at 03:55:21PM -0400, Vivek Goyal wrote:
> We need some kind of locking mechanism here. Normal file systems like
> ext4 and xfs seems to take their own semaphore to protect agains
> truncate while fault is going on.
> 
> We have additional requirement to protect against fuse dax memory range
> reclaim. When a range has been selected for reclaim, we need to make sure
> no other read/write/fault can try to access that memory range while
> reclaim is in progress. Once reclaim is complete, lock will be released
> and read/write/fault will trigger allocation of fresh dax range.
> 
> Taking inode_lock() is not an option in fault path as lockdep complains
> about circular dependencies. So define a new fuse_inode->i_mmap_sem.

That's precisely why filesystems like ext4 and XFS define their own
rwsem.

Note that this isn't a DAX requirement - the page fault
serialisation is actually a requirement of hole punching...

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/dir.c    |  2 ++
>  fs/fuse/file.c   | 15 ++++++++++++---
>  fs/fuse/fuse_i.h |  7 +++++++
>  fs/fuse/inode.c  |  1 +
>  4 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 26f028bc760b..f40766c0693b 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1609,8 +1609,10 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
>  	 */
>  	if ((is_truncate || !is_wb) &&
>  	    S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
> +		down_write(&fi->i_mmap_sem);
>  		truncate_pagecache(inode, outarg.attr.size);
>  		invalidate_inode_pages2(inode->i_mapping);
> +		up_write(&fi->i_mmap_sem);
>  	}
>  
>  	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index be7d90eb5b41..00ad27216cc3 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -2878,11 +2878,18 @@ static vm_fault_t __fuse_dax_fault(struct vm_fault *vmf,
>  
>  	if (write)
>  		sb_start_pagefault(sb);
> -
> +	/*
> +	 * We need to serialize against not only truncate but also against
> +	 * fuse dax memory range reclaim. While a range is being reclaimed,
> +	 * we do not want any read/write/mmap to make progress and try
> +	 * to populate page cache or access memory we are trying to free.
> +	 */
> +	down_read(&get_fuse_inode(inode)->i_mmap_sem);
>  	ret = dax_iomap_fault(vmf, pe_size, &pfn, NULL, &fuse_iomap_ops);
>  
>  	if (ret & VM_FAULT_NEEDDSYNC)
>  		ret = dax_finish_sync_fault(vmf, pe_size, pfn);
> +	up_read(&get_fuse_inode(inode)->i_mmap_sem);
>  
>  	if (write)
>  		sb_end_pagefault(sb);
> @@ -3849,9 +3856,11 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
>  			file_update_time(file);
>  	}
>  
> -	if (mode & FALLOC_FL_PUNCH_HOLE)
> +	if (mode & FALLOC_FL_PUNCH_HOLE) {
> +		down_write(&fi->i_mmap_sem);
>  		truncate_pagecache_range(inode, offset, offset + length - 1);
> -
> +		up_write(&fi->i_mmap_sem);
> +	}
>  	fuse_invalidate_attr(inode);


I'm not sure this is sufficient. You have to lock page faults out
for the entire time the hole punch is being performed, not just while
the mapping is being invalidated.

That is, once you've taken the inode lock and written back the dirty
data over the range being punched, you can then take a page fault
and dirty the page again. Then after you punch the hole out,
you have a dirty page with non-zero data in it, and that can get
written out before the page cache is truncated.

IOWs, to do a hole punch safely, you have to both lock the inode
and lock out page faults *before* you write back dirty data. Then
you can invalidate the page cache so you know there is no cached
data over the range about to be punched. Once the punch is done,
then you can drop all locks....

The same goes for any other operation that manipulates extents
directly (other fallocate ops, truncate, etc).

/me also wonders if there can be racing AIO+DIO in progress over the
range that is being punched and whether fuse needs to call
inode_dio_wait() before punching holes, running truncates, etc...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

