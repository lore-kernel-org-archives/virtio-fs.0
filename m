Date: Wed, 24 Jul 2019 17:08:58 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190725000858.qhyh5qncg727u5vr@US-160370MP2.local>
References: <20190724210721.9185-1-vgoyal@redhat.com>
	<20190724210721.9185-4-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724210721.9185-4-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 3/3] fuse: Add logic to upgrade a read-only
 mapping to read-write
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

On Wed, Jul 24, 2019 at 05:07:21PM -0400, Vivek Goyal wrote:
> Do not always map a dax mapping read-write. There are use cases like
> executing a file where we want to map file read-only. virtio-fs dir on
> host might be backed by overlayfs. We don't want to open file read-write
> on overlayfs otherwise it will unnecessariliy be copied-up nullyifying
> the advantages of sharing page cache between vms for unmodified files.
> 
> Hence, create a read-only mapping if user did not ask for writable mapping.
> Later upgrade it to read-write mapping when users requests it.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/file.c   | 114 ++++++++++++++++++++++++++++++++++++-----------
>  fs/fuse/fuse_i.h |   3 ++
>  2 files changed, 91 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index a2c19e4a28b5..bcd8ddcc0fdf 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -265,7 +265,8 @@ static void dmap_add_to_free_pool(struct fuse_conn *fc,
>  
>  /* offset passed in should be aligned to FUSE_DAX_MEM_RANGE_SZ */
>  static int fuse_setup_one_mapping(struct inode *inode, loff_t offset,
> -				  struct fuse_dax_mapping *dmap)
> +				  struct fuse_dax_mapping *dmap, bool writable,
> +				  bool upgrade)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  	struct fuse_inode *fi = get_fuse_inode(inode);
> @@ -283,7 +284,8 @@ static int fuse_setup_one_mapping(struct inode *inode, loff_t offset,
>  	inarg.moffset = dmap->window_offset;
>  	inarg.len = FUSE_DAX_MEM_RANGE_SZ;
>  	inarg.flags |= FUSE_SETUPMAPPING_FLAG_READ;
> -	inarg.flags |= FUSE_SETUPMAPPING_FLAG_WRITE;
> +	if (writable)
> +		inarg.flags |= FUSE_SETUPMAPPING_FLAG_WRITE;
>  	args.in.h.opcode = FUSE_SETUPMAPPING;
>  	args.in.h.nodeid = fi->nodeid;
>  	args.in.numargs = 1;
> @@ -296,26 +298,30 @@ static int fuse_setup_one_mapping(struct inode *inode, loff_t offset,
>  		return err;
>  	}
>  
> -	pr_debug("fuse_setup_one_mapping() succeeded. offset=0x%llx err=%zd\n", offset, err);
> +	pr_debug("fuse_setup_one_mapping() succeeded. offset=0x%llx writable=%d"
> +		 " err=%zd\n", offset, writable, err);
>  
> -	/*
> -	 * We don't take a refernce on inode. inode is valid right now and
> -	 * when inode is going away, cleanup logic should first cleanup
> -	 * dmap entries.
> -	 *
> -	 * TODO: Do we need to ensure that we are holding inode lock
> -	 * as well.
> -	 */
> -	dmap->inode = inode;
> -	dmap->start = offset;
> -	dmap->end = offset + FUSE_DAX_MEM_RANGE_SZ - 1;
> -	/* Protected by fi->i_dmap_sem */
> -	fuse_dax_interval_tree_insert(dmap, &fi->dmap_tree);
> -	fi->nr_dmaps++;
> -	spin_lock(&fc->lock);
> -	list_add_tail(&dmap->busy_list, &fc->busy_ranges);
> -	fc->nr_busy_ranges++;
> -	spin_unlock(&fc->lock);
> +	dmap->writable = writable;
> +	if (!upgrade) {
> +		/*
> +		 * We don't take a refernce on inode. inode is valid right now
> +		 * and when inode is going away, cleanup logic should first
> +		 * cleanup dmap entries.
> +		 *
> +		 * TODO: Do we need to ensure that we are holding inode lock
> +		 * as well.
> +		 */
> +		dmap->inode = inode;
> +		dmap->start = offset;
> +		dmap->end = offset + FUSE_DAX_MEM_RANGE_SZ - 1;
> +		/* Protected by fi->i_dmap_sem */
> +		fuse_dax_interval_tree_insert(dmap, &fi->dmap_tree);
> +		fi->nr_dmaps++;
> +		spin_lock(&fc->lock);
> +		list_add_tail(&dmap->busy_list, &fc->busy_ranges);
> +		fc->nr_busy_ranges++;
> +		spin_unlock(&fc->lock);
> +	}
>  	return 0;
>  }
>  
> @@ -1890,6 +1896,7 @@ static int iomap_begin_setup_new_mapping(struct inode *inode, loff_t pos,
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  	struct fuse_dax_mapping *dmap, *alloc_dmap = NULL;
>  	int ret;
> +	bool writable = flags & IOMAP_WRITE;
>  
>  	/* Can't do reclaim in fault path yet due to lock ordering.
>  	 * Read path takes shared inode lock and that's not sufficient
> @@ -1930,10 +1937,11 @@ static int iomap_begin_setup_new_mapping(struct inode *inode, loff_t pos,
>  
>  	/* Setup one mapping */
>  	ret = fuse_setup_one_mapping(inode,
> -		ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ), alloc_dmap);
> +				     ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ),
> +				     alloc_dmap, writable, false);
>  	if (ret < 0) {
>  		printk("fuse_setup_one_mapping() failed. err=%d"
> -			" pos=0x%llx\n", ret, pos);
> +			" pos=0x%llx, writable=%d\n", ret, pos, writable);
>  		dmap_add_to_free_pool(fc, alloc_dmap);
>  		up_write(&fi->i_dmap_sem);
>  		return ret;
> @@ -1943,6 +1951,45 @@ static int iomap_begin_setup_new_mapping(struct inode *inode, loff_t pos,
>  	return 0;
>  }
>  
> +static int iomap_begin_upgrade_mapping(struct inode *inode, loff_t pos,
> +					 loff_t length, unsigned flags,
> +					 struct iomap *iomap)
> +{
> +	struct fuse_inode *fi = get_fuse_inode(inode);
> +	struct fuse_dax_mapping *dmap;
> +	int ret;
> +
> +	/*
> +	 * Take exclusive lock so that only one caller can try to setup
> +	 * mapping and others wait.
> +	 */
> +	down_write(&fi->i_dmap_sem);
> +	dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, pos, pos);
> +
> +	/* We are holding either inode lock or i_mmap_sem, and that should
> +	 * ensure that dmap can't reclaimed or truncated and it should still
> +	 * be there in tree despite the fact we dropped and re-acquired the
> +	 * lock.
> +	 */
> +	if (WARN_ON(!dmap))
> +		return -EIO;

up_write() is missed here.

And I posted a similar patch[1] but with inode_lock being dropped in
mind, anything wrong with that patch?

[1]
virtiofs: add dmap flags to differentiate write mapping from read mapping

thanks,
-liubo

> +
> +	WARN_ON(dmap->writable);
> +	ret = fuse_setup_one_mapping(inode,
> +				     ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ),
> +				     dmap, true, true);
> +	if (ret < 0) {
> +		printk("fuse_setup_one_mapping() failed. err=%d pos=0x%llx\n",
> +		       ret, pos);
> +		up_write(&fi->i_dmap_sem);
> +		return ret;
> +	}
> +
> +	fuse_fill_iomap(inode, pos, length, iomap, dmap, flags);
> +	up_write(&fi->i_dmap_sem);
> +	return 0;
> +}
> +
>  /* This is just for DAX and the mapping is ephemeral, do not use it for other
>   * purposes since there is no block device with a permanent mapping.
>   */
> @@ -1952,6 +1999,7 @@ static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
>  	struct fuse_inode *fi = get_fuse_inode(inode);
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  	struct fuse_dax_mapping *dmap;
> +	bool writable = flags & IOMAP_WRITE;
>  
>  	/* We don't support FIEMAP */
>  	BUG_ON(flags & IOMAP_REPORT);
> @@ -1982,9 +2030,23 @@ static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
>  	dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, pos, pos);
>  
>  	if (dmap) {
> -		fuse_fill_iomap(inode, pos, length, iomap, dmap, flags);
> -		up_read(&fi->i_dmap_sem);
> -		return 0;
> +		if (writable && !dmap->writable) {
> +			/* Upgrade read-only mapping to read-write. This will
> +			 * require exclusive i_dmap_sem lock as we don't want
> +			 * two threads to be trying to this simultaneously
> +			 * for same dmap. So drop shared lock and acquire
> +			 * exclusive lock.
> +			 */
> +			up_read(&fi->i_dmap_sem);
> +			pr_debug("%s: Upgrading mapping at offset 0x%llx"
> +				 " length 0x%llx\n", __func__, pos, length);
> +			return iomap_begin_upgrade_mapping(inode, pos, length,
> +							   flags, iomap);
> +		} else {
> +			fuse_fill_iomap(inode, pos, length, iomap, dmap, flags);
> +			up_read(&fi->i_dmap_sem);
> +			return 0;
> +		}
>  	} else {
>  		up_read(&fi->i_dmap_sem);
>  		pr_debug("%s: no mapping at offset 0x%llx length 0x%llx\n",
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index e899a06e29d7..34ca8b90a1e1 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -134,6 +134,9 @@ struct fuse_dax_mapping {
>  
>  	/** Length of mapping, in bytes */
>  	loff_t length;
> +
> +	/* Is this mapping read-only or read-write */
> +	bool writable;
>  };
>  
>  /** FUSE inode */
> -- 
> 2.17.2

