Date: Tue, 26 Nov 2019 13:02:29 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191126130229.GG2928@work-vm>
References: <20191115205543.1816-1-vgoyal@redhat.com>
	<20191115205543.1816-5-vgoyal@redhat.com>
	<20191122174732.GL2785@work-vm> <20191125154414.GC13247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125154414.GC13247@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 4/4] virtiofsd: Implement blocking posix
	locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, miklos@szeredi.hu

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Fri, Nov 22, 2019 at 05:47:32PM +0000, Dr. David Alan Gilbert wrote:
> 
> [..]
> > > +static int virtio_send_notify_msg(struct fuse_session *se, struct iovec *iov,
> > > +				  int count)
> > > +{
> > > +    struct fv_QueueInfo *qi;
> > > +    VuDev *dev = &se->virtio_dev->dev;
> > > +    VuVirtq *q;
> > > +    FVRequest *req;
> > > +    VuVirtqElement *elem;
> > > +    unsigned int in_num, bad_in_num = 0, bad_out_num = 0;
> > > +    struct fuse_out_header *out = iov[0].iov_base;
> > > +    size_t in_len, tosend_len = iov_size(iov, count);
> > > +    struct iovec *in_sg;
> > > +    int ret = 0;
> > > +
> > > +    /* Notifications have unique == 0 */
> > > +    assert (!out->unique);
> > > +
> > > +    if (!se->notify_enabled)
> > > +        return -EOPNOTSUPP;
> > > +
> > > +    /* If notifications are enabled, queue index 1 is notification queue */
> > > +    qi = se->virtio_dev->qi[1];
> > > +    q = vu_get_queue(dev, qi->qidx);
> > > +
> > > +    pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
> > > +    pthread_mutex_lock(&qi->vq_lock);
> > > +    /* Pop an element from queue */
> > > +    req = vu_queue_pop(dev, q, sizeof(FVRequest), &bad_in_num, &bad_out_num);
> > 
> > You don't need bad_in_num/bad_out_num - just pass NULL for both; they're
> > only needed if you expect to read/write data that's not mappable (i.e.
> > in our direct write case).
> 
> Will do.
> 
> [..]
> > > @@ -1950,21 +1948,54 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
> > >  
> > >  	if (!plock) {
> > >  		saverr = ret;
> > > +		pthread_mutex_unlock(&inode->plock_mutex);
> > >  		goto out;
> > >  	}
> > >  
> > > +	/*
> > > +	 * plock is now released when inode is going away. We already have
> > > +	 * a reference on inode, so it is guaranteed that plock->fd is
> > > +	 * still around even after dropping inode->plock_mutex lock
> > > +	 */
> > > +	ofd = plock->fd;
> > > +	pthread_mutex_unlock(&inode->plock_mutex);
> > > +
> > > +	/*
> > > +	 * If this lock request can block, request caller to wait for
> > > +	 * notification. Do not access req after this. Once lock is
> > > +	 * available, send a notification instead.
> > > +	 */
> > > +	if (sleep && lock->l_type != F_UNLCK) {
> > > +		/*
> > > +		 * If notification queue is not enabled, can't support async
> > > +		 * locks.
> > > +		 */
> > > +		if (!se->notify_enabled) {
> > > +			saverr = EOPNOTSUPP;
> > > +			goto out;
> > > +		}
> > > +		async_lock = true;
> > > +		unique = req->unique;
> > > +		fuse_reply_wait(req);
> > > +	}
> > >  	/* TODO: Is it alright to modify flock? */
> > >  	lock->l_pid = 0;
> > > -	ret = fcntl(plock->fd, F_OFD_SETLK, lock);
> > > +	if (async_lock)
> > > +		ret = fcntl(ofd, F_OFD_SETLKW, lock);
> > > +	else
> > > +		ret = fcntl(ofd, F_OFD_SETLK, lock);
> > 
> > What happens if the guest is rebooted after it's asked
> > for, but not been granted a lock?
> 
> I think a regular reboot can't be done till a request is pending, because
> virtio-fs can't be unmounted and unmount will wait for all pending
> requests to finish.
> 
> Destroying qemu will destroy deamon too.
> 
> Are there any other reboot paths I have missed.

Yes, there are a few other ways the guest can reboot:
  a) A echo b > /proc/sysrq-trigger
  b) Telling qemu to do a reset

probably a few more as well; but they all end up with the daemon
still running over the same connection.   See
'virtiofsd: Handle hard reboot' where I handle that case where
a FUSE_INIT turns up unexpectedly.

Dave


> Thanks
> Vivek
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

