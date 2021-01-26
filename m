Date: Tue, 26 Jan 2021 13:33:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210126183336.GB3239@redhat.com>
References: <20210125180115.22936-1-vgoyal@redhat.com>
	<20210125180115.22936-2-vgoyal@redhat.com>
	<20210126165600.7bbe369d@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126165600.7bbe369d@bahia.lan>
Subject: Re: [Virtio-fs] [PATCH 1/6] virtiofsd: Drop ->vu_dispatch_rwlock
 while waiting for thread to exit
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: mst@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com, marcandre.lureau@redhat.com

On Tue, Jan 26, 2021 at 04:56:00PM +0100, Greg Kurz wrote:
> On Mon, 25 Jan 2021 13:01:10 -0500
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > When we are shutting down virtqueues, virtio_loop() receives a message
> > VHOST_USER_GET_VRING_BASE from master. We acquire ->vu_dispatch_rwlock
> > and get into the process of shutting down virtqueue. In one of the
> > final steps, we are waiting for fv_queue_thread() to exit/finish and
> > wait with ->vu_dispatch_rwlock held.
> > 
> > But it is possible that fv_queue_thread() itself is waiting to get
> > ->vu_dispatch_rwlock (With --thread-pool=0 option). If requests
> > are being processed by fv_queue_worker(), then fv_queue_worker()
> > can wait for the ->vu_dispatch_rwlock, and fv_queue_thread() will
> > wait for fv_queue_worker() before thread pool can be stopped.
> > 
> > IOW, if guest is shutdown uncleanly (some sort of emergency reboot),
> > it is possible that virtiofsd is processing a fs request and
> > qemu initiates device shutdown sequence. In that case there seem
> > to be two options. Either abort the existing request completely or
> > let existing request finish.
> > 
> > This patch is taking second approach. That is drop the ->vu_dispatch_rwlock
> > temporarily so that fv_queue_thread() can finish and deadlock does not
> > happen.
> > 
> > ->vu_dispatch_rwlock provides mutual exclusion between virtio_loop()
> > (handling vhost-user protocol messages) and fv_queue_thread() (handling
> > fuse filesystem requests). Rational seems to be that protocol message
> > might change queue memory mappings, so we don't want both to proceed
> > at the same time.
> > 
> > In this case queue is shutting down, so I hope it is fine for fv_queue_thread() to send response back while virtio_loop() is still waiting (and not handling
> 
> It looks this lacks a \n after "fine for"

Hi Greg,

Will fix.

> 
> > any further vho-user protocol messages).
> > 
> > IOW, assumption here is that while virto_loop is blocked processing
> > VHOST_USER_GET_VRING_BASE message, it is still ok to send back the
> > response on vq by fv_queue_thread().
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  tools/virtiofsd/fuse_virtio.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> > index 9577eaa68d..6805d8ba01 100644
> > --- a/tools/virtiofsd/fuse_virtio.c
> > +++ b/tools/virtiofsd/fuse_virtio.c
> > @@ -813,11 +813,20 @@ static void fv_queue_cleanup_thread(struct fv_VuDev *vud, int qidx)
> >          fuse_log(FUSE_LOG_ERR, "Eventfd_write for queue %d: %s\n",
> >                   qidx, strerror(errno));
> >      }
> > +
> > +    /*
> > +     * Drop ->vu_dispath_rwlock and reacquire. We are about to wait for
> > +     * for fv_queue_thread() and that might require ->vu_dispatch_rwlock
> > +     * to finish.
> > +     */
> > +    pthread_rwlock_unlock(&vud->vu_dispatch_rwlock);
> >      ret = pthread_join(ourqi->thread, NULL);
> >      if (ret) {
> >          fuse_log(FUSE_LOG_ERR, "%s: Failed to join thread idx %d err %d\n",
> >                   __func__, qidx, ret);
> >      }
> > +    pthread_rwlock_wrlock(&vud->vu_dispatch_rwlock);
> > +
> 
> So this is assuming that fv_queue_cleanup_thread() is called with
> vu_dispatch_rwlock already taken for writing, but there are no
> clear evidence in the code why it should care for the locking at
> all in the first place.
> 
> On the contrary, one of its two callers is a vhost-user callback,
> in which we can reasonably have this assumption, while we can
> have the opposite assumption for the other one in virtio_loop().
> 
> This makes me think that the drop/reacquire trick should only
> be done in fv_queue_set_started(), instead of...

I think this sounds reasonable. I will drop lock/re-acquire in
fv_queue_set_started() around the call to fv_queue_cleanup_thread().

> 
> >      pthread_mutex_destroy(&ourqi->vq_lock);
> >      close(ourqi->kill_fd);
> >      ourqi->kick_fd = -1;
> > @@ -952,7 +961,11 @@ int virtio_loop(struct fuse_session *se)
> >      /*
> >       * Make sure all fv_queue_thread()s quit on exit, as we're about to
> >       * free virtio dev and fuse session, no one should access them anymore.
> > +     * Hold ->vu_dispatch_rwlock in write mode as fv_queue_cleanup_thread()
> > +     * assumes mutex is locked and unlocks/re-locks it.
> >       */
> > +
> > +    pthread_rwlock_wrlock(&se->virtio_dev->vu_dispatch_rwlock);
> 
> 
> ... artificially introducing another critical section here.
> 
> The issue isn't even specific to vu_dispatch_rwlock actually :
> fv_queue_cleanup_thread() shouldn't be called with any lock
> held because it might sleep in pthread_join() and cause a
> deadlock all the same. So I'd rather document that instead :
> drop all locks before calling fv_queue_cleanup_thread().

Sounds good. Will do.

> 
> Also, since pthread_rwlock_wrlock() can fail, I think we should
> always check it's return value, at least with an assert() like
> already done elsewhere.

Will check return code of pthread_rwlock_wrlock() and probably use
assert().

Vivek

> 
> >      for (int i = 0; i < se->virtio_dev->nqueues; i++) {
> >          if (!se->virtio_dev->qi[i]) {
> >              continue;
> > @@ -961,6 +974,7 @@ int virtio_loop(struct fuse_session *se)
> >          fuse_log(FUSE_LOG_INFO, "%s: Stopping queue %d thread\n", __func__, i);
> >          fv_queue_cleanup_thread(se->virtio_dev, i);
> >      }
> > +    pthread_rwlock_unlock(&se->virtio_dev->vu_dispatch_rwlock);
> >  
> >      fuse_log(FUSE_LOG_INFO, "%s: Exit\n", __func__);
> >  
> 

