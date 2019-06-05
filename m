Date: Wed, 5 Jun 2019 14:35:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190605183514.GA22236@redhat.com>
References: <20190605030233.19567-1-tao.peng@linux.alibaba.com>
	<20190605030233.19567-2-tao.peng@linux.alibaba.com>
	<20190605180645.jso3eo3ype5faeh7@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605180645.jso3eo3ype5faeh7@US-160370MP2.local>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: FUSE_REMOVEMAPPING remove
 multiple entries in one call
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>

On Wed, Jun 05, 2019 at 11:06:46AM -0700, Liu Bo wrote:

[..]
> > -/*
> > - * It is called from evict_inode() and by that time inode is going away. So
> > - * this function does not take any locks like fi->i_dmap_sem for traversing
> > - * that fuse inode interval tree. If that lock is taken then lock validator
> > - * complains of deadlock situation w.r.t fs_reclaim lock.
> > - */
> > -void fuse_removemapping(struct inode *inode)
> > +static int dmap_list_send_removemappings(struct inode *inode, unsigned num,
> > +					 struct list_head *to_remove)
> >  {
> > -	struct fuse_conn *fc = get_fuse_conn(inode);
> > -	struct fuse_inode *fi = get_fuse_inode(inode);
> > -	ssize_t err;
> > +	struct fuse_removemapping_one *remove_one, *ptr;
> > +	struct fuse_removemapping_in inarg;
> >  	struct fuse_dax_mapping *dmap;
> > +	int ret, i = 0, nr_alloc;
> >  
> > -	/* Clear the mappings list */
> > -	while (true) {
> > -		WARN_ON(fi->nr_dmaps < 0);
> > +	nr_alloc = min_t(unsigned int, num, FUSE_REMOVEMAPPING_MAX_ENTRY);
> > +	remove_one = kmalloc_array(nr_alloc, sizeof(*remove_one), GFP_NOIO);
> 
> GFP_NOIO's comments implies that memalloc_noio_{save,restore} are preferred,
> also would GFP_NOFS be better?

GFP_NOFS sounds reasonable. I am not sure how memalloc_noio_{save,restore}
API is better as opposed to using GFP_NOFS.

[..]
> > +/*
> > + * Cleanup dmap entry and add back to free list. This should be called with
> > + * fc->lock held.
> > + */
> > +static void fuse_dax_do_free_mapping_locked(struct fuse_conn *fc,
> > +					    struct fuse_dax_mapping *dmap)
> > +{
> > +	__dmap_remove_busy_list(fc, dmap);
> > +	dmap->inode = NULL;
> > +	dmap->start = dmap->end = 0;
> > +	__free_dax_mapping(fc, dmap);
> > +	pr_debug("fuse: freed memory range start=0x%llx end=0x%llx "
> > +		"window_offset=0x%llx length=0x%llx\n", dmap->start,
> > +		dmap->end, dmap->window_offset, dmap->length);
> 
> pr_debug() needs to be placed at the beginning as dmap->start & end have been
> zero'd.
> 

Good point. Will fix.

Vivek

