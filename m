Date: Wed, 14 Aug 2019 13:51:14 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190814205113.oy7ioyejl5ddktn7@US-160370MP2.local>
References: <1565634725-89726-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190814195338.GC7475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814195338.GC7475@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/2] virtio-fs: try hard to do inline reclaim
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

On Wed, Aug 14, 2019 at 03:53:38PM -0400, Vivek Goyal wrote:
> On Tue, Aug 13, 2019 at 02:32:04AM +0800, Liu Bo wrote:
> > The difference between inline dmap reclaim and background dmap reclaim is
> > that dmaps got from inline reclaim get reused for another mapping
> > immediately, according to how we implement REMOVEMAPPING in daemon, it's
> > unnecessary to involve a REMOVEMAPPING to reuse a dmap.
> > 
> > Currently we always kick background reclaim before doing inline reclaim,
> > but some lock contention on i_dmap_lock from background reclaim results in
> > performance loss for dax read/write.
> > 
> > This makes read/write first try hard to do inline reclaim, then kick
> > background reclaim if it makes no progress.
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >  fs/fuse/file.c | 17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index ae197be..2ea670a 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -203,7 +203,8 @@ static void kick_dmap_free_worker(struct fuse_conn *fc, unsigned long delay_ms)
> >  	spin_unlock(&fc->lock);
> >  }
> >  
> > -static struct fuse_dax_mapping *alloc_dax_mapping(struct fuse_conn *fc)
> > +static struct fuse_dax_mapping *__alloc_dax_mapping(struct fuse_conn *fc,
> > +						    bool bg_reclaim)
> >  {
> >  	struct fuse_dax_mapping *dmap = NULL;
> >  
> > @@ -224,9 +225,14 @@ static struct fuse_dax_mapping *alloc_dax_mapping(struct fuse_conn *fc)
> >  	spin_unlock(&fc->lock);
> >  
> >  out_kick:
> > -	kick_dmap_free_worker(fc, 0);
> > +	if (bg_reclaim)
> > +		kick_dmap_free_worker(fc, 0);
> >  	return dmap;
> >  }
> > +static struct fuse_dax_mapping *alloc_dax_mapping(struct fuse_conn *fc)
> > +{
> > +	return __alloc_dax_mapping(fc, true);
> > +}
> >  
> >  /* This assumes fc->lock is held */
> >  static void __dmap_remove_busy_list(struct fuse_conn *fc,
> > @@ -4085,7 +4091,7 @@ static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
> >  	struct fuse_inode *fi = get_fuse_inode(inode);
> >  
> >  	while(1) {
> > -		dmap = alloc_dax_mapping(fc);
> > +		dmap = __alloc_dax_mapping(fc, false);
> 
> So all you are doing is first try inline reclaim before kicking in worker
> thread. Well it might work well for a single inode case but if more than
> one inodes are consuming free memory, might not help much.
>

I'll verify that.

> Also, as of now inline reclaims are enabled only for writes. (no reads, no
> mmap). So this should not help with the randread improvements you posted
> in second patch.
>

I explained it in another email under the thread.

> Does this work without deadlocks with cache_size=2M.

Well, with or without these 2 changes, on cache_size=2M kernel build end up with
waiting for dmap "forever", at least lockdep didn't report deadlocks.

IMO this patch doesn't change the current reclaim logic,
1) try inline reclaim first
2) wait for background reclaim to make progress

The only difference is that this changes step 1) to not kick background thread,
I think the performance gain mainly comes from less lock contention on
fi->i_dmap_sem, which we can easily observe without these two patches.

thanks,
-liubo

> 
> Thanks
> Vivek
> 
> >  		if (dmap)
> >  			return dmap;
> >  
> > @@ -4099,6 +4105,11 @@ static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
> >  		 * Wait for one.
> >  		 */
> >  		if (!(fc->nr_free_ranges > 0)) {
> > +			/* try again with background reclaim. */
> > +			dmap = alloc_dax_mapping(fc);
> > +			if (dmap)
> > +				return dmap;
> > +
> >  			if (wait_event_killable_exclusive(fc->dax_range_waitq,
> >  					(fc->nr_free_ranges > 0)))
> >  				return ERR_PTR(-EINTR);
> > -- 
> > 1.8.3.1
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs

