Date: Wed, 24 Apr 2019 17:16:33 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190425001633.u7mmy32dmwf5tgnw@US-160370MP2.local>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-5-bo.liu@linux.alibaba.com>
	<20190423195141.GA6547@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423195141.GA6547@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 4/9] virtio-fs: fix use-after-free against
 virtio_fs_vq's fuse_dev info
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

On Tue, Apr 23, 2019 at 03:51:41PM -0400, Vivek Goyal wrote:
> Hi,
> 
> fuse code does not really track forget requests. If anyting has not been
> sent to fuse daemon, that is dropped during abort connection time.
> 
> So it makes sense not to wait for these forget requests even in case of
> virtio-fs. All we are doing in completion is free request and fuse
> device does not have to be around by then.
> 
> Problem seems to be dependeny on fud->fpq->lock. How about if we use
> a different lock to provide locking around sending/receiving requests
> from vq. That way we don't have to use fpq->lock in this path and
> this problem should not happen. 
> 
> Can you try following patch and see if it fixes the problem.
>

Hi Vivek,

This logic looks reasonable to me.  Tested 100 times with this one, no
panic showed up.

As the original race is not 100% producible, I'm not able to run into
the panic with reverting
"virtio-fs: fix use-after-free against virtio_fs_vq's fuse_dev info"

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
-liubo

> Thanks
> Vivek
> 
> Subject: virtio-fs: Use virtio_fs_vq->lock for locking vq
> 
> Instead of using fuse_pqueue->lock, use virtio_fs_vq->lock for locking. That
> seems more logical as well as helps decouple fuse device and virtio_fs_vq.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c |   41 ++++++++++++++++++++---------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
> 
> Index: rhvgoyal-linux-fuse/fs/fuse/virtio_fs.c
> ===================================================================
> --- rhvgoyal-linux-fuse.orig/fs/fuse/virtio_fs.c	2019-04-16 11:34:34.805036786 -0400
> +++ rhvgoyal-linux-fuse/fs/fuse/virtio_fs.c	2019-04-23 15:03:40.139017074 -0400
> @@ -24,7 +24,8 @@ enum {
>  
>  /* Per-virtqueue state */
>  struct virtio_fs_vq {
> -	struct virtqueue *vq;     /* protected by fpq->lock */
> +	spinlock_t lock;
> +	struct virtqueue *vq;     /* protected by lock */
>  	struct work_struct done_work;
>  	struct list_head queued_reqs;
>  	struct delayed_work dispatch_work;
> @@ -180,11 +181,10 @@ static void virtio_fs_hiprio_done_work(s
>  {
>  	struct virtio_fs_vq *fsvq = container_of(work, struct virtio_fs_vq,
>  						 done_work);
> -	struct fuse_pqueue *fpq = &fsvq->fud->pq;
>  	struct virtqueue *vq = fsvq->vq;
>  
>  	/* Free completed FUSE_FORGET requests */
> -	spin_lock(&fpq->lock);
> +	spin_lock(&fsvq->lock);
>  	do {
>  		unsigned len;
>  		void *req;
> @@ -194,7 +194,7 @@ static void virtio_fs_hiprio_done_work(s
>  		while ((req = virtqueue_get_buf(vq, &len)) != NULL)
>  			kfree(req);
>  	} while (!virtqueue_enable_cb(vq) && likely(!virtqueue_is_broken(vq)));
> -	spin_unlock(&fpq->lock);
> +	spin_unlock(&fsvq->lock);
>  }
>  
>  static void virtio_fs_dummy_dispatch_work(struct work_struct *work)
> @@ -207,7 +207,6 @@ static void virtio_fs_hiprio_dispatch_wo
>  	struct virtio_fs_forget *forget;
>  	struct virtio_fs_vq *fsvq = container_of(work, struct virtio_fs_vq,
>  						 dispatch_work.work);
> -	struct fuse_pqueue *fpq = &fsvq->fud->pq;
>  	struct virtqueue *vq = fsvq->vq;
>  	struct scatterlist sg;
>  	struct scatterlist *sgs[] = {&sg};
> @@ -216,11 +215,11 @@ static void virtio_fs_hiprio_dispatch_wo
>  
>  	pr_debug("worker virtio_fs_hiprio_dispatch_work() called.\n");
>  	while(1) {
> -		spin_lock(&fpq->lock);
> +		spin_lock(&fsvq->lock);
>  		forget = list_first_entry_or_null(&fsvq->queued_reqs,
>  					struct virtio_fs_forget, list);
>  		if (!forget) {
> -			spin_unlock(&fpq->lock);
> +			spin_unlock(&fsvq->lock);
>  			return;
>  		}
>  
> @@ -243,12 +242,12 @@ static void virtio_fs_hiprio_dispatch_wo
>  					 " err=%d. Dropping it.\n", ret);
>  				kfree(forget);
>  			}
> -			spin_unlock(&fpq->lock);
> +			spin_unlock(&fsvq->lock);
>  			return;
>  		}
>  
>  		notify = virtqueue_kick_prepare(vq);
> -		spin_unlock(&fpq->lock);
> +		spin_unlock(&fsvq->lock);
>  
>  		if (notify)
>  			virtqueue_notify(vq);
> @@ -335,7 +334,7 @@ static void virtio_fs_requests_done_work
>  	LIST_HEAD(reqs);
>  
>  	/* Collect completed requests off the virtqueue */
> -	spin_lock(&fpq->lock);
> +	spin_lock(&fsvq->lock);
>  	do {
>  		unsigned len;
>  
> @@ -344,7 +343,7 @@ static void virtio_fs_requests_done_work
>  		while ((req = virtqueue_get_buf(vq, &len)) != NULL)
>  			list_move_tail(&req->list, &reqs);
>  	} while (!virtqueue_enable_cb(vq) && likely(!virtqueue_is_broken(vq)));
> -	spin_unlock(&fpq->lock);
> +	spin_unlock(&fsvq->lock);
>  
>  	/* End requests */
>  	list_for_each_entry_safe(req, next, &reqs, list) {
> @@ -413,9 +412,11 @@ static int virtio_fs_setup_vqs(struct vi
>  	INIT_LIST_HEAD(&fs->vqs[VQ_HIPRIO].queued_reqs);
>  	INIT_DELAYED_WORK(&fs->vqs[VQ_HIPRIO].dispatch_work,
>  			virtio_fs_hiprio_dispatch_work);
> +	spin_lock_init(&fs->vqs[VQ_HIPRIO].lock);
>  
>  	/* Initialize the requests virtqueues */
>  	for (i = VQ_REQUEST; i < fs->nvqs; i++) {
> +		spin_lock_init(&fs->vqs[i].lock);
>  		INIT_WORK(&fs->vqs[i].done_work, virtio_fs_requests_done_work);
>  		INIT_DELAYED_WORK(&fs->vqs[i].dispatch_work,
>  					virtio_fs_dummy_dispatch_work);
> @@ -744,7 +745,6 @@ __releases(fiq->waitq.lock)
>  {
>  	struct fuse_forget_link *link;
>  	struct virtio_fs_forget *forget;
> -	struct fuse_pqueue *fpq;
>  	struct scatterlist sg;
>  	struct scatterlist *sgs[] = {&sg};
>  	struct virtio_fs *fs;
> @@ -788,8 +788,7 @@ __releases(fiq->waitq.lock)
>  	/* Enqueue the request */
>  	vq = fsvq->vq;
>  	dev_dbg(&vq->vdev->dev, "%s\n", __func__);
> -	fpq = vq_to_fpq(vq);
> -	spin_lock(&fpq->lock);
> +	spin_lock(&fsvq->lock);
>  
>  	ret = virtqueue_add_sgs(vq, sgs, 1, 0, forget, GFP_ATOMIC);
>  	if (ret < 0) {
> @@ -804,13 +803,13 @@ __releases(fiq->waitq.lock)
>  				 " Dropping it.\n", ret);
>  			kfree(forget);
>  		}
> -		spin_unlock(&fpq->lock);
> +		spin_unlock(&fsvq->lock);
>  		goto out;
>  	}
>  
>  	notify = virtqueue_kick_prepare(vq);
>  
> -	spin_unlock(&fpq->lock);
> +	spin_unlock(&fsvq->lock);
>  
>  	if (notify)
>  		virtqueue_notify(vq);
> @@ -903,7 +902,7 @@ static int virtio_fs_enqueue_req(struct
>  	struct scatterlist stack_sg[ARRAY_SIZE(stack_sgs)];
>  	struct scatterlist **sgs = stack_sgs;
>  	struct scatterlist *sg = stack_sg;
> -	struct fuse_pqueue *fpq;
> +	struct virtio_fs_vq *fsvq;
>  	unsigned argbuf_used = 0;
>  	unsigned out_sgs = 0;
>  	unsigned in_sgs = 0;
> @@ -950,19 +949,19 @@ static int virtio_fs_enqueue_req(struct
>  	for (i = 0; i < total_sgs; i++)
>  		sgs[i] = &sg[i];
>  
> -	fpq = vq_to_fpq(vq);
> -	spin_lock(&fpq->lock);
> +	fsvq = vq_to_fsvq(vq);
> +	spin_lock(&fsvq->lock);
>  
>  	ret = virtqueue_add_sgs(vq, sgs, out_sgs, in_sgs, req, GFP_ATOMIC);
>  	if (ret < 0) {
>  		/* TODO handle full virtqueue */
> -		spin_unlock(&fpq->lock);
> +		spin_unlock(&fsvq->lock);
>  		goto out;
>  	}
>  
>  	notify = virtqueue_kick_prepare(vq);
>  
> -	spin_unlock(&fpq->lock);
> +	spin_unlock(&fsvq->lock);
>  
>  	if (notify)
>  		virtqueue_notify(vq);

