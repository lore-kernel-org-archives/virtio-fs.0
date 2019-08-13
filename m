Date: Tue, 13 Aug 2019 17:39:41 +0800
From: Eric Ren <renzhen@linux.alibaba.com>
Message-ID: <20190813093941.GD13456@ali-6c96cfe09cf9.local>
References: <1565636335-120345-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565636335-120345-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 1/2] Virtio-fs: fix hang due to ENOSPC in
 shared backend fs
Reply-To: Eric Ren <renzhen@linux.alibaba.com>
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

On Tue, Aug 13, 2019 at 02:58:54AM +0800, Liu Bo wrote:
> Currently fuse/virtio-fs de-allocation doesn't clean up dax mapping range,
> which may result in hang problems when the shared backend fs experiences
> "NO Space Error".
> 
> The root cause is that the first writing to a dax mapping range triggers a
> WRITE page fault on host side, which calls ->page_mkwrite() where block
> allocation is required, if the fs is already full, ->page_mkwrite() returns
> error so that page fault fails, however, for kvm is not able to propogate
> errors while handling EPT_VIOLATION, thus guest keeps trying to resolve the
> fault.
> 
> Fortunately, we can fix/work around the problem by dropping dax mapping
> range for de-allocation operations.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Hi,

This issue can be reproduced by xfstest generic/476 on a share dir
hosted by 10G loop device.

With this patch, this testcase can pass.

Tested-by: Eric Ren <renzhen@linux.alibaba.com>

Eric

> ---
>  fs/fuse/dir.c    | 3 +++
>  fs/fuse/file.c   | 9 +++++++--
>  fs/fuse/fuse_i.h | 2 +-
>  fs/fuse/inode.c  | 2 +-
>  4 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index ed740a5..99a218c 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1805,6 +1805,9 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
>  
>  		truncate_pagecache(inode, outarg.attr.size);
>  		invalidate_inode_pages2(inode->i_mapping);
> +		if (IS_DAX(inode) && oldsize > outarg.attr.size)
> +			fuse_cleanup_inode_mappings(inode, outarg.attr.size,
> +						    (loff_t)-1);
>  		up_write(&fi->i_mmap_sem);
>  	}
>  
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index c52260c..4f2d908 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -417,6 +417,7 @@ static void inode_reclaim_dmap_range(struct fuse_conn *fc, struct inode *inode,
>  	start = ALIGN(start, FUSE_DAX_MEM_RANGE_SZ);
>  	end = ALIGN_DOWN(end, FUSE_DAX_MEM_RANGE_SZ);
>  
> +	down_write(&fi->i_dmap_sem);
>  	while (1) {
>  		dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, start,
>  							 end);
> @@ -426,6 +427,7 @@ static void inode_reclaim_dmap_range(struct fuse_conn *fc, struct inode *inode,
>  		num++;
>  		list_add(&dmap->list, &to_remove);
>  	}
> +	up_write(&fi->i_dmap_sem);
>  
>  	/* Nothing to remove */
>  	if (list_empty(&to_remove))
> @@ -478,7 +480,7 @@ static int dmap_removemapping_one(struct inode *inode,
>   * that fuse inode interval tree. If that lock is taken then lock validator
>   * complains of deadlock situation w.r.t fs_reclaim lock.
>   */
> -void fuse_cleanup_inode_mappings(struct inode *inode)
> +void fuse_cleanup_inode_mappings(struct inode *inode, loff_t start, loff_t end)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  	/*
> @@ -486,7 +488,7 @@ void fuse_cleanup_inode_mappings(struct inode *inode)
>  	 * before we arrive here. So we should not have to worry about
>  	 * any pages/exception entries still associated with inode.
>  	 */
> -	inode_reclaim_dmap_range(fc, inode, 0, -1);
> +	inode_reclaim_dmap_range(fc, inode, start, end);
>  }
>  
>  void fuse_finish_open(struct inode *inode, struct file *file)
> @@ -3867,6 +3869,9 @@ static long __fuse_file_fallocate(struct file *file, int mode,
>  		}
>  
>  		truncate_pagecache_range(inode, offset, offset + length - 1);
> +		if (IS_DAX(inode))
> +			fuse_cleanup_inode_mappings(inode, offset,
> +						    offset + length - 1);
>  		up_write(&fi->i_mmap_sem);
>  	}
>  	fuse_invalidate_attr(inode);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 6956b62..6104d61 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1213,6 +1213,6 @@ ssize_t fuse_getxattr(struct inode *inode, const char *name, void *value,
>   */
>  u64 fuse_get_unique(struct fuse_iqueue *fiq);
>  void fuse_dax_free_mem_worker(struct work_struct *work);
> -void fuse_cleanup_inode_mappings(struct inode *inode);
> +void fuse_cleanup_inode_mappings(struct inode *inode, loff_t start, loff_t end);
>  
>  #endif /* _FS_FUSE_I_H */
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index e0d792b..629c1a7 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -125,7 +125,7 @@ static void fuse_evict_inode(struct inode *inode)
>  		struct fuse_conn *fc = get_fuse_conn(inode);
>  		struct fuse_inode *fi = get_fuse_inode(inode);
>  		if (IS_DAX(inode)) {
> -			fuse_cleanup_inode_mappings(inode);
> +			fuse_cleanup_inode_mappings(inode, 0, (loff_t)-1);
>  			WARN_ON(fi->nr_dmaps);
>  		}
>  		fuse_queue_forget(fc, fi->forget, fi->nodeid, fi->nlookup);
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

