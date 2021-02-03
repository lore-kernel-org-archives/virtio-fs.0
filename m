Date: Wed, 3 Feb 2021 15:23:44 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210203202344.GF3307@redhat.com>
References: <20210203182434.93870-1-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203182434.93870-1-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: vu_dispatch locking should
	never fail
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Feb 03, 2021 at 07:24:34PM +0100, Greg Kurz wrote:
> pthread_rwlock_rdlock() and pthread_rwlock_wrlock() can fail if a
> deadlock condition is detected or the current thread already owns
> the lock. They can also fail, like pthread_rwlock_unlock(), if the
> mutex wasn't properly initialized. None of these are ever expected
> to happen with fv_VuDev::vu_dispatch_rwlock.
> 
> Some users already check the return value and assert, some others
> don't. Introduce rdlock/wrlock/unlock wrappers that just do the
> former and use them everywhere for improved consistency and
> robustness.
> 
> This is just cleanup. It doesn't fix any actual issue.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> 
> v2: - open-code helpers instead of defining them with a macro (Vivek, Stefan)
>     - fixed rd/wr typo in fv_queue_thread() (Stefan)
>     - make it clear in the changelog this is just cleanup (Stefan)
> 
>  tools/virtiofsd/fuse_virtio.c | 49 +++++++++++++++++++++++++----------
>  1 file changed, 35 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index ddcefee4272f..523ee64fb7ae 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -187,6 +187,31 @@ static void copy_iov(struct iovec *src_iov, int src_count,
>      }
>  }
>  
> +/*
> + * pthread_rwlock_rdlock() and pthread_rwlock_wrlock can fail if
> + * a deadlock condition is detected or the current thread already
> + * owns the lock. They can also fail, like pthread_rwlock_unlock(),
> + * if the mutex wasn't properly initialized. None of these are ever
> + * expected to happen.
> + */
> +static void vu_dispatch_rdlock(struct fv_VuDev *vud)
> +{
> +    int ret = pthread_rwlock_rdlock(&vud->vu_dispatch_rwlock);
> +    assert(ret == 0);
> +}
> +
> +static void vu_dispatch_wrlock(struct fv_VuDev *vud)
> +{
> +    int ret = pthread_rwlock_wrlock(&vud->vu_dispatch_rwlock);
> +    assert(ret == 0);
> +}
> +
> +static void vu_dispatch_unlock(struct fv_VuDev *vud)
> +{
> +    int ret = pthread_rwlock_unlock(&vud->vu_dispatch_rwlock);
> +    assert(ret == 0);
> +}
> +
>  /*
>   * Called back by ll whenever it wants to send a reply/message back
>   * The 1st element of the iov starts with the fuse_out_header
> @@ -240,12 +265,12 @@ int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
>  
>      copy_iov(iov, count, in_sg, in_num, tosend_len);
>  
> -    pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
> +    vu_dispatch_rdlock(qi->virtio_dev);
>      pthread_mutex_lock(&qi->vq_lock);
>      vu_queue_push(dev, q, elem, tosend_len);
>      vu_queue_notify(dev, q);
>      pthread_mutex_unlock(&qi->vq_lock);
> -    pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
> +    vu_dispatch_unlock(qi->virtio_dev);
>  
>      req->reply_sent = true;
>  
> @@ -403,12 +428,12 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>  
>      ret = 0;
>  
> -    pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
> +    vu_dispatch_rdlock(qi->virtio_dev);
>      pthread_mutex_lock(&qi->vq_lock);
>      vu_queue_push(dev, q, elem, tosend_len);
>      vu_queue_notify(dev, q);
>      pthread_mutex_unlock(&qi->vq_lock);
> -    pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
> +    vu_dispatch_unlock(qi->virtio_dev);
>  
>  err:
>      if (ret == 0) {
> @@ -558,12 +583,12 @@ out:
>          fuse_log(FUSE_LOG_DEBUG, "%s: elem %d no reply sent\n", __func__,
>                   elem->index);
>  
> -        pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
> +        vu_dispatch_rdlock(qi->virtio_dev);
>          pthread_mutex_lock(&qi->vq_lock);
>          vu_queue_push(dev, q, elem, 0);
>          vu_queue_notify(dev, q);
>          pthread_mutex_unlock(&qi->vq_lock);
> -        pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
> +        vu_dispatch_unlock(qi->virtio_dev);
>      }
>  
>      pthread_mutex_destroy(&req->ch.lock);
> @@ -596,7 +621,6 @@ static void *fv_queue_thread(void *opaque)
>               qi->qidx, qi->kick_fd);
>      while (1) {
>          struct pollfd pf[2];
> -        int ret;
>  
>          pf[0].fd = qi->kick_fd;
>          pf[0].events = POLLIN;
> @@ -645,8 +669,7 @@ static void *fv_queue_thread(void *opaque)
>              break;
>          }
>          /* Mutual exclusion with virtio_loop() */
> -        ret = pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
> -        assert(ret == 0); /* there is no possible error case */
> +        vu_dispatch_rdlock(qi->virtio_dev);
>          pthread_mutex_lock(&qi->vq_lock);
>          /* out is from guest, in is too guest */
>          unsigned int in_bytes, out_bytes;
> @@ -672,7 +695,7 @@ static void *fv_queue_thread(void *opaque)
>          }
>  
>          pthread_mutex_unlock(&qi->vq_lock);
> -        pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
> +        vu_dispatch_unlock(qi->virtio_dev);
>  
>          /* Process all the requests. */
>          if (!se->thread_pool_size && req_list != NULL) {
> @@ -799,7 +822,6 @@ int virtio_loop(struct fuse_session *se)
>      while (!fuse_session_exited(se)) {
>          struct pollfd pf[1];
>          bool ok;
> -        int ret;
>          pf[0].fd = se->vu_socketfd;
>          pf[0].events = POLLIN;
>          pf[0].revents = 0;
> @@ -825,12 +847,11 @@ int virtio_loop(struct fuse_session *se)
>          assert(pf[0].revents & POLLIN);
>          fuse_log(FUSE_LOG_DEBUG, "%s: Got VU event\n", __func__);
>          /* Mutual exclusion with fv_queue_thread() */
> -        ret = pthread_rwlock_wrlock(&se->virtio_dev->vu_dispatch_rwlock);
> -        assert(ret == 0); /* there is no possible error case */
> +        vu_dispatch_wrlock(se->virtio_dev);
>  
>          ok = vu_dispatch(&se->virtio_dev->dev);
>  
> -        pthread_rwlock_unlock(&se->virtio_dev->vu_dispatch_rwlock);
> +        vu_dispatch_unlock(se->virtio_dev);
>  
>          if (!ok) {
>              fuse_log(FUSE_LOG_ERR, "%s: vu_dispatch failed\n", __func__);
> -- 
> 2.26.2
> 

