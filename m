Date: Wed, 31 Jul 2019 10:48:22 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190731174821.huiokivwch3ffglo@US-160370MP2.local>
References: <1564465872-60404-1-git-send-email-bo.liu@linux.alibaba.com>
	<ceef880a-1b0d-c1a8-eb85-5c0bf4dfb023@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ceef880a-1b0d-c1a8-eb85-5c0bf4dfb023@huawei.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: reduce lock contention on
	fpq->lock
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com

Hi Jun,

On Wed, Jul 31, 2019 at 08:05:03PM +0800, piaojun wrote:
> Hi liubo,
> 
> This change has already committed in rhvgoyal's branch:
>
> https://github.com/rhvgoyal/linux/tree/virtio-fs-dev-5.1
>

Thanks for the link, the patch here does one more thing beyond Vivek's current
code, i.e. the lock protection around req is also removed as it's not necessary.

thanks,
-liubo

> Thanks,
> Jun
> 
> On 2019/7/30 13:51, Liu Bo wrote:
> > Right now within virtio_fs_requests_done_work(), virtqueue is protected by
> > both fsvq->lock and fpq->lock for processing both virtqueue and
> > fpq->processing_list, however, it is fine for them to be protected
> > separately.
> > 
> > Also since %req has been removed from fpq->processing_list, no one except
> > request_wait_answer() is looking at this %req and request_wait_answer()
> > waits only on FINISH flag, it's OK to remove fpq->lock after %req is
> > dropped from the list.
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >  fs/fuse/virtio_fs.c | 13 ++++++-------
> >  1 file changed, 6 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> > index 9b3f2e9..d88bb6c 100644
> > --- a/fs/fuse/virtio_fs.c
> > +++ b/fs/fuse/virtio_fs.c
> > @@ -347,21 +347,22 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
> >  
> >  	/* Collect completed requests off the virtqueue */
> >  	spin_lock(&fsvq->lock);
> > -	/* grab fpq->lock as req is on fpq->processing list */
> > -	spin_lock(&fpq->lock);
> >  	do {
> >  		unsigned len;
> >  
> >  		virtqueue_disable_cb(vq);
> >  
> >  		while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
> > +			/* grab fpq->lock as req is on fpq->processing list */
> > +			spin_lock(&fpq->lock);
> > +
> >  			/* If !connected, req is freed by fuse_abort_conn. */
> > -			if (fpq->connected) {
> > +			if (fpq->connected)
> >  				list_move_tail(&req->list, &reqs);
> > -			}
> > +
> > +			spin_unlock(&fpq->lock);
> >  		}
> >  	} while (!virtqueue_enable_cb(vq) && likely(!virtqueue_is_broken(vq)));
> > -	spin_unlock(&fpq->lock);
> >  	spin_unlock(&fsvq->lock);
> >  
> >  	/* End requests */
> > @@ -373,10 +374,8 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
> >  
> >  		/* TODO zeroing? */
> >  
> > -		spin_lock(&fpq->lock);
> >  		clear_bit(FR_SENT, &req->flags);
> >  		list_del_init(&req->list);
> > -		spin_unlock(&fpq->lock);
> >  
> >  		fuse_request_end(fc, req);
> >  	}
> > 

