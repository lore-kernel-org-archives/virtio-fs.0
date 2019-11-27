Date: Wed, 27 Nov 2019 14:08:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191127190808.GA18507@redhat.com>
References: <20191115205543.1816-1-vgoyal@redhat.com>
	<20191115205543.1816-5-vgoyal@redhat.com>
	<20191122174732.GL2785@work-vm> <20191125154414.GC13247@redhat.com>
	<20191126130229.GG2928@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126130229.GG2928@work-vm>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, miklos@szeredi.hu

On Tue, Nov 26, 2019 at 01:02:29PM +0000, Dr. David Alan Gilbert wrote:

[..]
> > > > @@ -1950,21 +1948,54 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
> > > >  
> > > >  	if (!plock) {
> > > >  		saverr = ret;
> > > > +		pthread_mutex_unlock(&inode->plock_mutex);
> > > >  		goto out;
> > > >  	}
> > > >  
> > > > +	/*
> > > > +	 * plock is now released when inode is going away. We already have
> > > > +	 * a reference on inode, so it is guaranteed that plock->fd is
> > > > +	 * still around even after dropping inode->plock_mutex lock
> > > > +	 */
> > > > +	ofd = plock->fd;
> > > > +	pthread_mutex_unlock(&inode->plock_mutex);
> > > > +
> > > > +	/*
> > > > +	 * If this lock request can block, request caller to wait for
> > > > +	 * notification. Do not access req after this. Once lock is
> > > > +	 * available, send a notification instead.
> > > > +	 */
> > > > +	if (sleep && lock->l_type != F_UNLCK) {
> > > > +		/*
> > > > +		 * If notification queue is not enabled, can't support async
> > > > +		 * locks.
> > > > +		 */
> > > > +		if (!se->notify_enabled) {
> > > > +			saverr = EOPNOTSUPP;
> > > > +			goto out;
> > > > +		}
> > > > +		async_lock = true;
> > > > +		unique = req->unique;
> > > > +		fuse_reply_wait(req);
> > > > +	}
> > > >  	/* TODO: Is it alright to modify flock? */
> > > >  	lock->l_pid = 0;
> > > > -	ret = fcntl(plock->fd, F_OFD_SETLK, lock);
> > > > +	if (async_lock)
> > > > +		ret = fcntl(ofd, F_OFD_SETLKW, lock);
> > > > +	else
> > > > +		ret = fcntl(ofd, F_OFD_SETLK, lock);
> > > 
> > > What happens if the guest is rebooted after it's asked
> > > for, but not been granted a lock?
> > 
> > I think a regular reboot can't be done till a request is pending, because
> > virtio-fs can't be unmounted and unmount will wait for all pending
> > requests to finish.
> > 
> > Destroying qemu will destroy deamon too.
> > 
> > Are there any other reboot paths I have missed.
> 
> Yes, there are a few other ways the guest can reboot:
>   a) A echo b > /proc/sysrq-trigger

I tried it. Both qemu and virtiofsd hang. virtiofsd wants to stop a 
queue. And that tries to stop thrad pool. But one of the threads in
thread pool is blocked on setlkw. So g_thread_pool_free() hangs.

I am not seeing any option in glib thread pool API to stop or send
signal to threads which are blocked.

Thanks
Vivek

