Date: Fri, 31 May 2019 10:38:22 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190531173821.q7fkvgeuo3236ieq@US-160370MP2.local>
References: <20190531092403.77976-1-tao.peng@linux.alibaba.com>
	<20190531132228.GA26058@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531132228.GA26058@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] fuse: refcount FORGET requests
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
Cc: virtio-fs@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>

On Fri, May 31, 2019 at 09:22:28AM -0400, Vivek Goyal wrote:
> On Fri, May 31, 2019 at 05:24:03PM +0800, Peng Tao wrote:
> > Right now FORGET requests are not tracked and they might be sent
> > after DESTROY request.
> 
> How does that happen?
> 
> > Normally this is OK, since user space should
> > be able to reject them knowing that the file system is already umounted.
> > But if the same file system is mounted right again and the file is
> > opened again, user space can be confused by the refcount decrement
> > carried by the old FORGET requests.
> > 
> > E.g., it can trigger an assertion in virtiofsd when running xfstests
> > generic/129 and generic/130 together:
> > 
> > unique: 23, opcode: FORGET (2), nodeid: 4, insize: 64, pid: 0
> >   forget 4 1 -2
> > virtiofsd: contrib/virtiofsd/passthrough_ll.c:1044: unref_inode: Assertion `inode->refcount >= n' failed.
> > 
> > To avoid confusing user space in such case, refcount FORGET requests so
> > that fuse_sb_destroy() waits for all inflight requests before returning.
> 
> forgets are optional and destroy is supposed to cleanup any pending
> state.

Since we've ensured that DESTROY is the last fuse_request sent to userspace
daemon, we only need to deal with those FORGET requests sent before DESTROY.

Given that FORGET is sent via HIGHPRI vq, in order to solve the problem, would
it make sense to route DESTROY to HIGHPRI vq as well?

Or, we can let lo_init to clear reqs in HIGHPRI vq?

thanks,
-liubo

> 
> If this is a real issue, we probably need some notion of generation 
> number (either for the mount or for inode) and ignore forgets if
> they don't belong to same generation. 
> 
> Given this is per mount, probably some sort of number per init request
> should make sense.
> 
> Thanks
> Vivek
> 
> 
> > 
> > Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> > ---
> >  fs/fuse/dev.c       |  8 +++++++-
> >  fs/fuse/fuse_i.h    |  8 ++++++++
> >  fs/fuse/virtio_fs.c | 10 ++++++++--
> >  3 files changed, 23 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> > index ee9dd38bc0f0..8f5617e07309 100644
> > --- a/fs/fuse/dev.c
> > +++ b/fs/fuse/dev.c
> > @@ -164,7 +164,7 @@ static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
> >  	return !fc->initialized || (for_background && fc->blocked);
> >  }
> >  
> > -static void fuse_drop_waiting(struct fuse_conn *fc)
> > +void fuse_drop_waiting(struct fuse_conn *fc)
> >  {
> >  	/*
> >  	 * lockess check of fc->connected is okay, because atomic_dec_and_test()
> > @@ -177,6 +177,7 @@ static void fuse_drop_waiting(struct fuse_conn *fc)
> >  		wake_up_all(&fc->blocked_waitq);
> >  	}
> >  }
> > +EXPORT_SYMBOL_GPL(fuse_drop_waiting);
> >  
> >  static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
> >  				       bool for_background)
> > @@ -414,6 +415,7 @@ void fuse_queue_forget(struct fuse_conn *fc, struct fuse_forget_link *forget,
> >  
> >  	spin_lock(&fiq->waitq.lock);
> >  	if (fiq->connected) {
> > +		atomic_inc(&fc->num_waiting);
> >  		fiq->forget_list_tail->next = forget;
> >  		fiq->forget_list_tail = forget;
> >  		fiq->ops->wake_forget_and_unlock(fiq);
> > @@ -1207,6 +1209,7 @@ static struct fuse_forget_link *dequeue_forget(struct fuse_iqueue *fiq,
> >  					       unsigned max,
> >  					       unsigned *countp)
> >  {
> > +	struct fuse_conn *fc = get_fuse_iqueue_conn(fiq);
> >  	struct fuse_forget_link *head = fiq->forget_list_head.next;
> >  	struct fuse_forget_link **newhead = &head;
> >  	unsigned count;
> > @@ -1222,6 +1225,9 @@ static struct fuse_forget_link *dequeue_forget(struct fuse_iqueue *fiq,
> >  	if (countp != NULL)
> >  		*countp = count;
> >  
> > +	while(count-- > 0)
> > +		fuse_drop_waiting(fc);
> > +
> >  	return head;
> >  }
> >  
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 7ac7f9a0b81b..609eafd60c30 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -923,6 +923,11 @@ static inline struct fuse_conn *get_fuse_conn(struct inode *inode)
> >  	return get_fuse_conn_super(inode->i_sb);
> >  }
> >  
> > +static inline struct fuse_conn *get_fuse_iqueue_conn(struct fuse_iqueue *fiq)
> > +{
> > +	return container_of(fiq, struct fuse_conn, iq);
> > +}
> > +
> >  static inline struct fuse_inode *get_fuse_inode(struct inode *inode)
> >  {
> >  	return container_of(inode, struct fuse_inode, inode);
> > @@ -975,6 +980,9 @@ struct fuse_forget_link *fuse_alloc_forget(void);
> >  /* Used by READDIRPLUS */
> >  void fuse_force_forget(struct file *file, u64 nodeid);
> >  
> > +/* Used by FORGET callback */
> > +void fuse_drop_waiting(struct fuse_conn *fc);
> > +
> >  /**
> >   * Initialize READ or READDIR request
> >   */
> > diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> > index 18fc0dca0abc..466b88b944c0 100644
> > --- a/fs/fuse/virtio_fs.c
> > +++ b/fs/fuse/virtio_fs.c
> > @@ -172,6 +172,7 @@ static void virtio_fs_hiprio_done_work(struct work_struct *work)
> >  {
> >  	struct virtio_fs_vq *fsvq = container_of(work, struct virtio_fs_vq,
> >  						 done_work);
> > +	struct fuse_conn *fc = fsvq->fud->fc;
> >  	struct virtqueue *vq = fsvq->vq;
> >  
> >  	/* Free completed FUSE_FORGET requests */
> > @@ -182,8 +183,10 @@ static void virtio_fs_hiprio_done_work(struct work_struct *work)
> >  
> >  		virtqueue_disable_cb(vq);
> >  
> > -		while ((req = virtqueue_get_buf(vq, &len)) != NULL)
> > +		while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
> >  			kfree(req);
> > +			fuse_drop_waiting(fc);
> > +		}
> >  	} while (!virtqueue_enable_cb(vq) && likely(!virtqueue_is_broken(vq)));
> >  	spin_unlock(&fsvq->lock);
> >  }
> > @@ -695,7 +698,7 @@ __releases(fiq->waitq.lock)
> >  	struct virtio_fs_vq *fsvq;
> >  	bool notify;
> >  	u64 unique;
> > -	int ret;
> > +	int ret = -ENOMEM;
> >  
> >  	BUG_ON(!fiq->forget_list_head.next);
> >  	link = fiq->forget_list_head.next;
> > @@ -757,6 +760,9 @@ __releases(fiq->waitq.lock)
> >  	if (notify)
> >  		virtqueue_notify(vq);
> >  out:
> > +	if (ret < 0)
> > +		fuse_drop_waiting(fsvq->fud->fc);
> > +
> >  	kfree(link);
> >  }
> >  
> > -- 
> > 2.17.1
> > 

