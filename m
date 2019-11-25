Date: Mon, 25 Nov 2019 10:38:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191125153845.GB13247@redhat.com>
References: <20191115205543.1816-1-vgoyal@redhat.com>
	<20191115205543.1816-5-vgoyal@redhat.com>
	<20191122105324.GE464656@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122105324.GE464656@stefanha-x1.localdomain>
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, miklos@szeredi.hu

On Fri, Nov 22, 2019 at 10:53:24AM +0000, Stefan Hajnoczi wrote:
> On Fri, Nov 15, 2019 at 03:55:43PM -0500, Vivek Goyal wrote:
> > diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> > index d4a42d9804..f706e440bf 100644
> > --- a/contrib/virtiofsd/fuse_lowlevel.c
> > +++ b/contrib/virtiofsd/fuse_lowlevel.c
> > @@ -183,7 +183,8 @@ int fuse_send_reply_iov_nofree(fuse_req_t req, int error, struct iovec *iov,
> >  {
> >  	struct fuse_out_header out;
> >  
> > -	if (error <= -1000 || error > 0) {
> > +	/* error = 1 has been used to signal client to wait for notificaiton */
> > +	if (error <= -1000 || error > 1) {
> >  		fuse_log(FUSE_LOG_ERR, "fuse: bad error value: %i\n",	error);
> >  		error = -ERANGE;
> >  	}
> 
> What is this?

When a waiting lock request comes in, we need a way to reply back saying
wait for the notification. So I used value "1" for the
fuse_out_header->error field for this purpose. As of now, 0 is returned
for success and negative values for error code. So positive values seem
to be unused.

> 
> > +int fuse_lowlevel_notify_lock(struct fuse_session *se, uint64_t req_id,
> > +			      int32_t error)
> > +{
> > +	struct fuse_notify_lock_out outarg;
> 
> Missing = {} initialization to avoid information leaks to the guest.

Will do.

> 
> > @@ -1704,6 +1720,15 @@ int fuse_lowlevel_notify_delete(struct fuse_session *se,
> >  int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
> >  			       off_t offset, struct fuse_bufvec *bufv,
> >  			       enum fuse_buf_copy_flags flags);
> > +/**
> > + * Notify event related to previous lock request
> > + *
> > + * @param se the session object
> > + * @param req_id the id of the request which requested setlkw
> 
> The rest of the code calls this id "unique":

Will change it.

> 
>   + * @param req_unique the unique id of the setlkw request
> 
> > +    /* Pop an element from queue */
> > +    req = vu_queue_pop(dev, q, sizeof(FVRequest), &bad_in_num, &bad_out_num);
> > +    if (!req) {
> > +        /* TODO: Implement some sort of ring buffer and queue notifications
> > +	 * on that and send these later when notification queue has space
> > +	 * available.
> > +	 */
> > +        return -ENOSPC;
> 
> Ah, I thought the point of the notifications processing thread was
> exactly this case.  It could wake any threads waiting for buffers.
> 
> This wakeup could be implemented with a condvar - no ring buffer
> necessary.

I was thinking that thread sending notification should not block. It can
just queue the notification reuqest and some other thread (including
notification thread could send it later). Number of pre-allocated buffers
could be of fixed and we will drop notifications if guest is not
responding. This will also take care of concerns w.r.t rogue guest
blocking filesystem code in daemon.

Anyway, this is a TODO item and not implemented yet. 

Thanks
Vivek

