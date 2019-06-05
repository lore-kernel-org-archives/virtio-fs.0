Date: Wed, 5 Jun 2019 11:06:46 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190605180645.jso3eo3ype5faeh7@US-160370MP2.local>
References: <20190605030233.19567-1-tao.peng@linux.alibaba.com>
	<20190605030233.19567-2-tao.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605030233.19567-2-tao.peng@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: FUSE_REMOVEMAPPING remove
	multiple	entries in one call
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jun 05, 2019 at 11:02:33AM +0800, Peng Tao wrote:
> Enhance FUSE_REMOVEMAPPING wire protocol to remove multiple mappings
> in one call. So that fuse_removemapping() can send just one fuse request
> for many dmap entries.
> 
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> ---
>  fs/fuse/file.c            | 205 +++++++++++++++++++++++++++-----------
>  fs/fuse/fuse_i.h          |   6 +-
>  fs/fuse/inode.c           |   2 +-
>  include/uapi/linux/fuse.h |   7 ++
>  4 files changed, 160 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index d0979dc32f08..5a0b80719815 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -27,6 +27,9 @@ INTERVAL_TREE_DEFINE(struct fuse_dax_mapping, rb, __u64, __subtree_last,
>  
>  static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
>  				struct inode *inode);
> +static void fuse_dax_free_mappings_range(struct fuse_conn *fc,
> +				struct inode *inode, loff_t start, loff_t end);
> +
>  static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
>  			  int opcode, struct fuse_open_out *outargp)
>  {
> @@ -319,75 +322,87 @@ static int fuse_setup_one_mapping(struct inode *inode,
>  	return 0;
>  }
>  
> -static int fuse_removemapping_one(struct inode *inode,
> -					struct fuse_dax_mapping *dmap)
> +static int
> +fuse_send_removemapping(struct inode *inode,
> +			struct fuse_removemapping_in *inargp,
> +			struct fuse_removemapping_one *remove_one)
>  {
>  	struct fuse_inode *fi = get_fuse_inode(inode);
>  	struct fuse_conn *fc = get_fuse_conn(inode);
> -	struct fuse_removemapping_in inarg;
>  	FUSE_ARGS(args);
>  
> -	memset(&inarg, 0, sizeof(inarg));
> -	inarg.moffset = dmap->window_offset;
> -	inarg.len = dmap->length;
>  	args.in.h.opcode = FUSE_REMOVEMAPPING;
>  	args.in.h.nodeid = fi->nodeid;
> -	args.in.numargs = 1;
> -	args.in.args[0].size = sizeof(inarg);
> -	args.in.args[0].value = &inarg;
> +	args.in.numargs = 2;
> +	args.in.args[0].size = sizeof(*inargp);
> +	args.in.args[0].value = inargp;
> +	args.in.args[1].size = inargp->count * sizeof(*remove_one);
> +	args.in.args[1].value = remove_one;
>  	return fuse_simple_request(fc, &args);
>  }
>  
> -/*
> - * It is called from evict_inode() and by that time inode is going away. So
> - * this function does not take any locks like fi->i_dmap_sem for traversing
> - * that fuse inode interval tree. If that lock is taken then lock validator
> - * complains of deadlock situation w.r.t fs_reclaim lock.
> - */
> -void fuse_removemapping(struct inode *inode)
> +static int dmap_list_send_removemappings(struct inode *inode, unsigned num,
> +					 struct list_head *to_remove)
>  {
> -	struct fuse_conn *fc = get_fuse_conn(inode);
> -	struct fuse_inode *fi = get_fuse_inode(inode);
> -	ssize_t err;
> +	struct fuse_removemapping_one *remove_one, *ptr;
> +	struct fuse_removemapping_in inarg;
>  	struct fuse_dax_mapping *dmap;
> +	int ret, i = 0, nr_alloc;
>  
> -	/* Clear the mappings list */
> -	while (true) {
> -		WARN_ON(fi->nr_dmaps < 0);
> +	nr_alloc = min_t(unsigned int, num, FUSE_REMOVEMAPPING_MAX_ENTRY);
> +	remove_one = kmalloc_array(nr_alloc, sizeof(*remove_one), GFP_NOIO);

GFP_NOIO's comments implies that memalloc_noio_{save,restore} are preferred,
also would GFP_NOFS be better?

> +	if (!remove_one)
> +		return -ENOMEM;
>  
> -		dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, 0,
> -								-1);
> -		if (dmap) {
> -			fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
> -			fi->nr_dmaps--;
> -			dmap_remove_busy_list(fc, dmap);
> +	ptr = remove_one;
> +	list_for_each_entry(dmap, to_remove, list) {
> +		ptr->moffset = dmap->window_offset;
> +		ptr->len = dmap->length;
> +		ptr++;
> +		i++;
> +		num--;
> +		if (i >= nr_alloc || num == 0) {
> +			memset(&inarg, 0, sizeof(inarg));
> +			inarg.count = i;
> +			ret = fuse_send_removemapping(inode, &inarg,
> +						      remove_one);
> +			if (ret)
> +				goto out;
> +			ptr = remove_one;
> +			i = 0;
>  		}
> +	}
> +out:
> +	kfree(remove_one);
> +	return ret;
> +}
>  
> -		if (!dmap)
> -			break;
> +static int fuse_removemapping_one(struct inode *inode,
> +					struct fuse_dax_mapping *dmap)
> +{
> +	struct fuse_removemapping_in inarg;
> +	struct fuse_removemapping_one remove_one;
>  
> -		/*
> -		 * During umount/shutdown, fuse connection is dropped first
> -		 * and later evict_inode() is called later. That means any
> -		 * removemapping messages are going to fail. Send messages
> -		 * only if connection is up. Otherwise fuse daemon is
> -		 * responsible for cleaning up any leftover references and
> -		 * mappings.
> -		 */
> -		if (fc->connected) {
> -			err = fuse_removemapping_one(inode, dmap);
> -			if (err) {
> -				pr_warn("Failed to removemapping. offset=0x%llx"
> -					" len=0x%llx\n", dmap->window_offset,
> -					dmap->length);
> -			}
> -		}
> +	memset(&inarg, 0, sizeof(inarg));
> +	/* TODO: fill in inarg.fh when available */
> +	inarg.count = 1;
> +	memset(&remove_one, 0, sizeof(remove_one));
> +	remove_one.moffset = dmap->window_offset;
> +	remove_one.len = dmap->length;
>  
> -		dmap->inode = NULL;
> +	return fuse_send_removemapping(inode, &inarg, &remove_one);
> +}
>  
> -		/* Add it back to free ranges list */
> -		free_dax_mapping(fc, dmap);
> -	}
> +/*
> + * It is called from evict_inode() and by that time inode is going away. So
> + * this function does not take any locks like fi->i_dmap_sem for traversing
> + * that fuse inode interval tree. If that lock is taken then lock validator
> + * complains of deadlock situation w.r.t fs_reclaim lock.
> + */
> +void fuse_cleanup_inode_mappings(struct inode *inode)
> +{
> +	struct fuse_conn *fc = get_fuse_conn(inode);
> +	fuse_dax_free_mappings_range(fc, inode, 0, -1);
>  }
>  
>  void fuse_finish_open(struct inode *inode, struct file *file)
> @@ -3980,6 +3995,88 @@ static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
>  	}
>  }
>  
> +/*
> + * Cleanup dmap entry and add back to free list. This should be called with
> + * fc->lock held.
> + */
> +static void fuse_dax_do_free_mapping_locked(struct fuse_conn *fc,
> +					    struct fuse_dax_mapping *dmap)
> +{
> +	__dmap_remove_busy_list(fc, dmap);
> +	dmap->inode = NULL;
> +	dmap->start = dmap->end = 0;
> +	__free_dax_mapping(fc, dmap);
> +	pr_debug("fuse: freed memory range start=0x%llx end=0x%llx "
> +		"window_offset=0x%llx length=0x%llx\n", dmap->start,
> +		dmap->end, dmap->window_offset, dmap->length);

pr_debug() needs to be placed at the beginning as dmap->start & end have been
zero'd.

Other parts look good to me.
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
-liubo
> +}
> +
> +/*
> + * Free inode dmap entries whose range falls entirely inside [start, end].
> + * Does not take any locks. Caller must take care of any lock requirements.
> + * Lock ordering follows fuse_dax_free_one_mapping().
> + * inode->i_rwsem, fuse_inode->i_mmap_sem and fuse_inode->i_dmap_sem must be
> + * held exclusively, unless it is called from evict_inode() where no one else
> + * is accessing the inode.
> + */
> +static void fuse_dax_free_mappings_range(struct fuse_conn *fc,
> +					 struct inode *inode, loff_t start,
> +					 loff_t end)
> +{
> +	struct fuse_inode *fi = get_fuse_inode(inode);
> +	struct fuse_dax_mapping *dmap, *n;
> +	int err, num = 0;
> +	LIST_HEAD(to_remove);
> +
> +	pr_debug("fuse: %s: start=0x%llx, end=0x%llx\n", __func__, start, end);
> +
> +	/*
> +	 * Interval tree search matches intersecting entries. Adjust the range
> +	 * to avoid dropping partial valid entries.
> +	 */
> +	start = ALIGN(start, FUSE_DAX_MEM_RANGE_SZ);
> +	end = ALIGN_DOWN(end, FUSE_DAX_MEM_RANGE_SZ);
> +
> +	while (1) {
> +		dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, start,
> +							 end);
> +		if (!dmap)
> +			break;
> +		fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
> +		num++;
> +		WARN_ON(!list_empty(&dmap->list));
> +		list_add_tail(&dmap->list, &to_remove);
> +	}
> +
> +	/* Nothing to remove */
> +	if (list_empty(&to_remove))
> +		return;
> +
> +	WARN_ON(fi->nr_dmaps < num);
> +	fi->nr_dmaps -= num;
> +	/*
> +	 * During umount/shutdown, fuse connection is dropped first
> +	 * and evict_inode() is called later. That means any
> +	 * removemapping messages are going to fail. Send messages
> +	 * only if connection is up. Otherwise fuse daemon is
> +	 * responsible for cleaning up any leftover references and
> +	 * mappings.
> +	 */
> +	if (fc->connected) {
> +		err = dmap_list_send_removemappings(inode, num, &to_remove);
> +		if (err) {
> +			pr_warn("Failed to removemappings. start=0x%llx"
> +				" end=0x%llx\n", start, end);
> +		}
> +	}
> +	spin_lock(&fc->lock);
> +	list_for_each_entry_safe(dmap, n, &to_remove, list) {
> +		list_del(&dmap->list);
> +		fuse_dax_do_free_mapping_locked(fc, dmap);
> +	}
> +	spin_unlock(&fc->lock);
> +}
> +
>  int fuse_dax_free_one_mapping_locked(struct fuse_conn *fc, struct inode *inode,
>  				u64 dmap_start)
>  {
> @@ -4003,15 +4100,9 @@ int fuse_dax_free_one_mapping_locked(struct fuse_conn *fc, struct inode *inode,
>  
>  	/* Cleanup dmap entry and add back to free list */
>  	spin_lock(&fc->lock);
> -	__dmap_remove_busy_list(fc, dmap);
> -	dmap->inode = NULL;
> -	dmap->start = dmap->end = 0;
> -	__free_dax_mapping(fc, dmap);
> +	fuse_dax_do_free_mapping_locked(fc, dmap);
>  	spin_unlock(&fc->lock);
>  
> -	pr_debug("fuse: freed memory range window_offset=0x%llx,"
> -				" length=0x%llx\n", dmap->window_offset,
> -				dmap->length);
>  	return ret;
>  }
>  
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 7ac7f9a0b81b..17784dbd49a7 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -117,7 +117,9 @@ struct fuse_dax_mapping {
>  	/* Pointer to inode where this memory range is mapped */
>  	struct inode *inode;
>  
> -	/* Will connect in fc->free_ranges to keep track of free memory */
> +	/* Will connect in fc->free_ranges to keep track of free memory.
> +	 * When the mapping is in fc->busy_ranges, the field can also be
> +	 * used by temporary lists */
>  	struct list_head list;
>  
>  	/* For interval tree in file/inode */
> @@ -1286,6 +1288,6 @@ unsigned fuse_len_args(unsigned numargs, struct fuse_arg *args);
>   */
>  u64 fuse_get_unique(struct fuse_iqueue *fiq);
>  void fuse_dax_free_mem_worker(struct work_struct *work);
> -void fuse_removemapping(struct inode *inode);
> +void fuse_cleanup_inode_mappings(struct inode *inode);
>  
>  #endif /* _FS_FUSE_I_H */
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 302f7e04b645..4277324a7c3b 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -123,7 +123,7 @@ static void fuse_evict_inode(struct inode *inode)
>  		struct fuse_conn *fc = get_fuse_conn(inode);
>  		struct fuse_inode *fi = get_fuse_inode(inode);
>  		if (IS_DAX(inode)) {
> -			fuse_removemapping(inode);
> +			fuse_cleanup_inode_mappings(inode);
>  			WARN_ON(fi->nr_dmaps);
>  		}
>  		fuse_queue_forget(fc, fi->forget, fi->nodeid, fi->nlookup);
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 5042e227e8a8..b588a028f099 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -850,10 +850,17 @@ struct fuse_setupmapping_out {
>  struct fuse_removemapping_in {
>          /* An already open handle */
>          uint64_t	fh;
> +	/* number of fuse_removemapping_one follows */
> +	uint32_t	count;
> +};
> +
> +struct fuse_removemapping_one {
>  	/* Offset into the dax window start the unmapping */
>  	uint64_t        moffset;
>          /* Length of mapping required */
>          uint64_t	len;
>  };
> +#define FUSE_REMOVEMAPPING_MAX_ENTRY	\
> +		(PAGE_SIZE / sizeof(struct fuse_removemapping_one))
>  
>  #endif /* _LINUX_FUSE_H */
> -- 
> 2.17.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

