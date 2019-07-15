Date: Mon, 15 Jul 2019 14:38:06 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190715213805.crgid6njeq6faavs@US-160370MP2.local>
References: <1562225131-23463-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190715203739.GB22193@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715203739.GB22193@redhat.com>
Subject: Re: [Virtio-fs] [PATCH RFC] virtiofs: use fine-grained lock for
 dmap reclaim
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com

On Mon, Jul 15, 2019 at 04:37:39PM -0400, Vivek Goyal wrote:
> On Thu, Jul 04, 2019 at 03:25:31PM +0800, Liu Bo wrote:
> > With free fuse dax mapping reducing, read performance is impacted
> > significantly because reads need to wait for a free fuse dax mapping.
> > 
> > Although reads will trigger reclaim work to try to reclaim fuse dax
> > mapping, reclaim code can barely make any progress if most of fuse dax
> > mappings are used by the file we're reading since inode lock is required
> > by reclaim code.
> > 
> > However, we don't have to take inode lock for reclaiming if dax mapping
> > has its own reference count, reference counting is to tell reclaim code to
> > skip those in use dax mappings, such that we can avoid the risk of
> > accidentally reclaiming a dax mapping that other readers are using.
> > 
> > On the other hand, holding ->i_dmap_sem during reclaim can be used to
> > prevent the follwing reads to get a dax mapping under reclaim.
> > 
> > Another reason is that reads/writes only use fuse dax mapping within
> > dax_iomap_rw(), so we can do such a trick, while mmap/faulting is a
> > different story and we have to take ->i_mmap_sem prior to reclaiming a dax
> > mapping in order to avoid the race.
> > 
> > This adds reference count for fuse dax mapping and removes the acquisition
> > of inode lock during reclaim.
> 
> I am not sure that this reference count implementation is safe. For
> example, what prevents atomic_dec() from being reordered so that it
> could be executed before actually copying to user space is finished.
> 
> Say cpu1 is reading a dax page and cpu 2 is freeing memory. 
> 
> cpu1 read				cpu2 free dmap
> ---------				-------------
> atomic_inc()				atomic_read()			
> copy data to user space
> atomic_dec
> 
> Say atomic_dec() gets reordered w.r.t copy_data_to_user_space.
> 
> cpu1 read				cpu2 free dmap
> ---------				-------------
> atomic_inc()				atomic_read()			
> atomic_dec
> copy data to user space
> 
> Now cpu2 will free up dax range while it is still being read?

Yep, I think this is possible.

For this specific reorder, barriers like smp_mb__{before,after}_atomic could fix
it.

thanks,
-liubo
> 
> Thanks
> Vivek
> 
> > 
> > 
> > RESULTS:
> > 
> > virtiofsd -cache_size=2G
> > 
> > vanilla kernel: IOPS=378
> > patched kernel: IOPS=4508
> > 
> > 
> > *********************************
> > $ cat fio-rand-read.job
> > ; fio-rand-read.job for fiotest
> > 
> > [global]
> > name=fio-rand-read
> > filename=fio_file
> > rw=randread
> > bs=4K
> > direct=1
> > numjobs=1
> > time_based=1
> > runtime=120
> > directory=/mnt/test/
> > fsync=1
> > group_reporting=1
> > 
> > [file1]
> > size=5G
> > # use sync/libaio
> > ioengine=sync
> > iodepth=1
> > 
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >  fs/fuse/file.c   | 55 +++++++++++++++++++++++++++++++++++++------------------
> >  fs/fuse/fuse_i.h |  3 +++
> >  fs/fuse/inode.c  |  1 +
> >  3 files changed, 41 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 4ed45a7..e3ec646 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -1870,6 +1870,17 @@ static void fuse_fill_iomap(struct inode *inode, loff_t pos, loff_t length,
> >  		if (flags & IOMAP_FAULT)
> >  			iomap->length = ALIGN(len, PAGE_SIZE);
> >  		iomap->type = IOMAP_MAPPED;
> > +
> > +		/*
> > +		 * increace refcnt so that reclaim code knows this dmap is in
> > +		 * use.
> > +		 */
> > +		atomic_inc(&dmap->refcnt);
> > +
> > +		/* iomap->private should be NULL */
> > +		WARN_ON_ONCE(iomap->private);
> > +		iomap->private = dmap;
> > +
> >  		pr_debug("%s: returns iomap: addr 0x%llx offset 0x%llx"
> >  				" length 0x%llx\n", __func__, iomap->addr,
> >  				iomap->offset, iomap->length);
> > @@ -2024,6 +2035,11 @@ static int fuse_iomap_end(struct inode *inode, loff_t pos, loff_t length,
> >  			  ssize_t written, unsigned flags,
> >  			  struct iomap *iomap)
> >  {
> > +	struct fuse_dax_mapping *dmap = iomap->private;
> > +
> > +	if (dmap)
> > +		atomic_dec(&dmap->refcnt);
> > +
> >  	/* DAX writes beyond end-of-file aren't handled using iomap, so the
> >  	 * file size is unchanged and there is nothing to do here.
> >  	 */
> > @@ -3959,6 +3975,10 @@ static int reclaim_one_dmap_locked(struct fuse_conn *fc, struct inode *inode,
> >  	int ret;
> >  	struct fuse_inode *fi = get_fuse_inode(inode);
> >  
> > +	/*
> > +	 * igrab() was done to make sure inode won't go under us, and this
> > +	 * further avoids the race with evict().
> > +	 */
> >  	ret = dmap_writeback_invalidate(inode, dmap);
> >  
> >  	/* TODO: What to do if above fails? For now,
> > @@ -4053,23 +4073,25 @@ static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
> >  	}
> >  }
> >  
> > -int lookup_and_reclaim_dmap_locked(struct fuse_conn *fc, struct inode *inode,
> > -				   u64 dmap_start)
> > +static int lookup_and_reclaim_dmap_locked(struct fuse_conn *fc,
> > +					  struct inode *inode, u64 dmap_start)
> >  {
> >  	int ret;
> >  	struct fuse_inode *fi = get_fuse_inode(inode);
> >  	struct fuse_dax_mapping *dmap;
> >  
> > -	WARN_ON(!inode_is_locked(inode));
> > -
> >  	/* Find fuse dax mapping at file offset inode. */
> >  	dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, dmap_start,
> > -							dmap_start);
> > +						 dmap_start);
> >  
> >  	/* Range already got cleaned up by somebody else */
> >  	if (!dmap)
> >  		return 0;
> >  
> > +	/* still in use. */
> > +	if (atomic_read(&dmap->refcnt))
> > +		return 0;
> > +
> >  	ret = reclaim_one_dmap_locked(fc, inode, dmap);
> >  	if (ret < 0)
> >  		return ret;
> > @@ -4084,29 +4106,21 @@ int lookup_and_reclaim_dmap_locked(struct fuse_conn *fc, struct inode *inode,
> >  /*
> >   * Free a range of memory.
> >   * Locking.
> > - * 1. Take inode->i_rwsem to prever further read/write.
> > - * 2. Take fuse_inode->i_mmap_sem to block dax faults.
> > - * 3. Take fuse_inode->i_dmap_sem to protect interval tree. It might not
> > + * 1. Take fuse_inode->i_mmap_sem to block dax faults.
> > + * 2. Take fuse_inode->i_dmap_sem to protect interval tree. It might not
> >   *    be strictly necessary as lock 1 and 2 seem sufficient.
> >   */
> > -int lookup_and_reclaim_dmap(struct fuse_conn *fc, struct inode *inode,
> > -			    u64 dmap_start)
> > +static int lookup_and_reclaim_dmap(struct fuse_conn *fc, struct inode *inode,
> > +				   u64 dmap_start)
> >  {
> >  	int ret;
> >  	struct fuse_inode *fi = get_fuse_inode(inode);
> >  
> > -	/*
> > -	 * If process is blocked waiting for memory while holding inode
> > -	 * lock, we will deadlock. So continue to free next range.
> > -	 */
> > -	if (!inode_trylock(inode))
> > -		return -EAGAIN;
> >  	down_write(&fi->i_mmap_sem);
> >  	down_write(&fi->i_dmap_sem);
> >  	ret = lookup_and_reclaim_dmap_locked(fc, inode, dmap_start);
> >  	up_write(&fi->i_dmap_sem);
> >  	up_write(&fi->i_mmap_sem);
> > -	inode_unlock(inode);
> >  	return ret;
> >  }
> >  
> > @@ -4134,6 +4148,12 @@ static int try_to_free_dmap_chunks(struct fuse_conn *fc,
> >  
> >  		list_for_each_entry_safe(pos, temp, &fc->busy_ranges,
> >  						busy_list) {
> > +			dmap = pos;
> > +
> > +			/* skip this range if it's in use. */
> > +			if (atomic_read(&dmap->refcnt))
> > +				continue;
> > +
> >  			inode = igrab(pos->inode);
> >  			/*
> >  			 * This inode is going away. That will free
> > @@ -4147,7 +4167,6 @@ static int try_to_free_dmap_chunks(struct fuse_conn *fc,
> >  			 * inode lock can't be obtained, this will help with
> >  			 * selecting new element
> >  			 */
> > -			dmap = pos;
> >  			list_move_tail(&dmap->busy_list, &fc->busy_ranges);
> >  			dmap_start = dmap->start;
> >  			window_offset = dmap->window_offset;
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 94cfde0..31ecdac 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -143,6 +143,9 @@ struct fuse_dax_mapping {
> >  
> >  	/* indicate if the mapping is set up for write purpose */
> >  	unsigned flags;
> > +
> > +	/* reference count when the mapping is used by dax iomap. */
> > +	atomic_t refcnt;
> >  };
> >  
> >  /** FUSE inode */
> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > index 288daee..27c6055 100644
> > --- a/fs/fuse/inode.c
> > +++ b/fs/fuse/inode.c
> > @@ -671,6 +671,7 @@ static int fuse_dax_mem_range_init(struct fuse_conn *fc,
> >  		range->length = FUSE_DAX_MEM_RANGE_SZ;
> >  		list_add_tail(&range->list, &mem_ranges);
> >  		INIT_LIST_HEAD(&range->busy_list);
> > +		atomic_set(&range->refcnt, 0);
> >  		allocated_ranges++;
> >  	}
> >  
> > -- 
> > 1.8.3.1
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs

