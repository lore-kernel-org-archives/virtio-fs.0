Date: Tue, 7 Jan 2020 12:09:39 +0800
From: Eryu Guan <eguan@linux.alibaba.com>
Message-ID: <20200107040939.GG41863@e18g06458.et15sqa>
References: <20191220031213.119553-1-eguan@linux.alibaba.com>
	<20200106154710.GA350142@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <20200106154710.GA350142@stefanha-x1.localdomain>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: cancel all queue threads on
 exit in virtio_loop()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qingming.su@linux.alibaba.com

On Mon, Jan 06, 2020 at 03:47:10PM +0000, Stefan Hajnoczi wrote:
> On Fri, Dec 20, 2019 at 11:12:13AM +0800, Eryu Guan wrote:
> > On guest graceful shutdown, virtiofsd receives VHOST_USER_GET_VRING_BASE
> > request from VMM and shuts down virtqueues by calling fv_set_started(),
> > which joins fv_queue_thread() threads. So when virtio_loop() returns,
> > there should be no thread is still accessing data in fuse session and/or
> > virtio dev.
> > 
> > But on abnormal exit, e.g. guest got killed for whatever reason,
> > vhost-user socket is closed and virtio_loop() breaks out the main loop
> > and returns to main(). But it's possible fv_queue_worker()s are still
> > working and accessing fuse session and virtio dev, which results in
> > crash or use-after-free.
> > 
> > Fix it by cancelling fv_queue_thread()s before virtio_loop() returns,
> > to make sure there's no-one could access fuse session and virtio dev.
> 
> Why use pthread_cancel(3) instead of writing 1 to the thread's kill_fd?
> 
> I'm concerned about pthread_cancel(3) because the threads access
> rwlocks, which may be leaked when pthread_cancel(3) terminates the
> thread.
> 
> It would be safer to reuse the following code to get full thread
> cleanup:

Makes sense, fixed in v3.

Thanks,
Eryu

> 
>   static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
>   {
>         ...
>         int ret;
>         assert(qidx < vud->nqueues);
>         ourqi = vud->qi[qidx];
> 
>         /* Kill the thread */
>         if (eventfd_write(ourqi->kill_fd, 1)) {
>             fuse_log(FUSE_LOG_ERR, "Eventfd_read for queue: %m\n");
>         }
>         ret = pthread_join(ourqi->thread, NULL);
>         if (ret) {
>             fuse_log(FUSE_LOG_ERR, "%s: Failed to join thread idx %d err %d\n",
>                      __func__, qidx, ret);
>         }
>         pthread_mutex_destroy(&ourqi->vq_lock);
>         close(ourqi->kill_fd);
>         ourqi->kick_fd = -1;
>         free(vud->qi[qidx]);
>         vud->qi[qidx] = NULL;
> 	...
>   }



