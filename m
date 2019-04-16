Date: Tue, 16 Apr 2019 11:43:57 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190416184356.dbehyhbusyhnaejr@US-160370MP2.local>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-4-bo.liu@linux.alibaba.com>
	<20190416182849.GD2222@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416182849.GD2222@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 3/9] fuse: export fuse_drop_waiting()
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

On Tue, Apr 16, 2019 at 02:28:49PM -0400, Vivek Goyal wrote:
> On Wed, Apr 17, 2019 at 02:03:16AM +0800, Liu Bo wrote:
> > virtio-fs will need to do ref count against FORGET requests from
> > outside fs/fuse/dev.c.  Make the symbol visible.
> > 
> 
> Who needs it? virtio-fs does not seem to be calling it?
>

Ah, this is a preparation for patch 4.

thanks,
-liubo

> Vivek
> 
> > Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
> > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> > ---
> >  fs/fuse/dev.c    | 3 ++-
> >  fs/fuse/fuse_i.h | 1 +
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> > index 07ae706..7e6afd0 100644
> > --- a/fs/fuse/dev.c
> > +++ b/fs/fuse/dev.c
> > @@ -128,7 +128,7 @@ static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
> >  	return !fc->initialized || (for_background && fc->blocked);
> >  }
> >  
> > -static void fuse_drop_waiting(struct fuse_conn *fc)
> > +void fuse_drop_waiting(struct fuse_conn *fc)
> >  {
> >  	if (fc->connected) {
> >  		atomic_dec(&fc->num_waiting);
> > @@ -137,6 +137,7 @@ static void fuse_drop_waiting(struct fuse_conn *fc)
> >  		wake_up_all(&fc->blocked_waitq);
> >  	}
> >  }
> > +EXPORT_SYMBOL_GPL(fuse_drop_waiting);
> >  
> >  static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
> >  				       bool for_background)
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 2c32846..171aee8 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -1199,6 +1199,7 @@ ssize_t fuse_getxattr(struct inode *inode, const char *name, void *value,
> >   * Get the next unique ID for a request
> >   */
> >  u64 fuse_get_unique(struct fuse_iqueue *fiq);
> > +void fuse_drop_waiting(struct fuse_conn *fc);
> >  void fuse_dax_free_mem_worker(struct work_struct *work);
> >  void fuse_removemapping(struct inode *inode);
> >  
> > -- 
> > 1.8.3.1
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs

