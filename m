Date: Mon, 5 Aug 2019 13:02:31 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190805120231.GL13734@work-vm>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190801165409.20121-2-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801165409.20121-2-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/4] virtiofsd: process requests in a thread
	pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> Introduce a thread pool so that fv_queue_thread() just pops
> VuVirtqElements and hands them to the thread pool.  For the time being
> only one worker thread is allowed since passthrough_ll.c is not
> thread-safe yet.  Future patches will lift this restriction so that
> multiple FUSE requests can be processed in parallel.
> 
> The main new concept is struct FVRequest, which contains both
> VuVirtqElement and struct fuse_chan.  We now have fv_VuDev for a device,
> fv_QueueInfo for a virtqueue, and FVRequest for a request.  Some of
> fv_QueueInfo's fields are moved into FVRequest because they are
> per-request.  The name FVRequest conforms to QEMU coding style and I
> expect the struct fv_* types will be renamed in a future refactoring.
> 
> This patch series is not optimal.  fbuf reuse is dropped so each request
> does malloc(se->bufsize), but there is no clean and cheap way to keep
> this with a thread pool.  The vq_lock mutex is held for longer than
> necessary, especially during the eventfd_write() syscall.  Performance
> can be improved in the future.
> 
> prctl(2) had to be added to the seccomp whitelist because glib invokes
> it.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks, applied; some comments below.

> +
> +        pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
> +        pthread_mutex_lock(&qi->vq_lock);
> +        vu_queue_push(dev, q, elem, tosend_len);
> +        vu_queue_notify(dev, q);
> +        pthread_mutex_unlock(&qi->vq_lock);
> +        pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);

It surprises me that these paired locks are so common.
>  
>  err:
>  
> @@ -249,9 +268,12 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>                           struct iovec *iov, int count,
>                           struct fuse_bufvec *buf, size_t len)
>  {
> +        FVRequest *req = container_of(ch, FVRequest, ch);

I can't think of a better answer than the container_of but it does make
me a bit nervous; I guess we need it because 'ch' comes from the generic
fs code so can't be FVRequest*
> +        struct VuDev *dev = &qi->virtio_dev->dev;
> +        FVRequest *req = data;
> +        VuVirtqElement *elem = &req->elem;
> +        struct fuse_buf fbuf = {};
> +        bool allocated_bufv = false;
> +        struct fuse_bufvec bufv;
> +        struct fuse_bufvec *pbufv;
> +
> +        assert(se->bufsize > sizeof(struct fuse_in_header));
> +
> +        /* An element contains one request and the space to send our response
> +         * They're spread over multiple descriptors in a scatter/gather set
> +         * and we can't trust the guest to keep them still; so copy in/out.
> +         */
> +        fbuf.mem = malloc(se->bufsize);
> +        assert(fbuf.mem);

Now we're using thread pools etc, maybe it's time to switch to glib's
g_new/g_malloc etc that never return NULL?

> +        if (se->debug)
> +                fuse_debug("%s: elem %d: with %d out desc of length %zd"
> +                           " bad_in_num=%u bad_out_num=%u\n",
> +                           __func__, elem->index, out_num,
> +                           out_len, req->bad_in_num, req->bad_out_num);

Are the debug/logging calls thread safe?


> diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
> index cea4cc5f60..5f1c873b82 100644
> --- a/contrib/virtiofsd/seccomp.c
> +++ b/contrib/virtiofsd/seccomp.c
> @@ -58,6 +58,7 @@ static const int syscall_whitelist[] = {
>  	SCMP_SYS(open),
>  	SCMP_SYS(openat),
>  	SCMP_SYS(ppoll),
> +	SCMP_SYS(prctl), /* TODO restrict to just PR_SET_NAME? */

Would seem a good idea because prctl can do lots of crazy things.

Dave

>  	SCMP_SYS(preadv),
>  	SCMP_SYS(pwrite64),
>  	SCMP_SYS(read),
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

