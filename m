Date: Tue, 22 Sep 2020 13:59:57 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20200922125957.GN1989025@redhat.com>
References: <20200921213216.GE13362@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200921213216.GE13362@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Used glib "shared" thread pool
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, qemu-devel@nongnu.org

On Mon, Sep 21, 2020 at 05:32:16PM -0400, Vivek Goyal wrote:
> glib offers thread pools and it seems to support "exclusive" and "shared"
> thread pools.
> 
> https://developer.gnome.org/glib/stable/glib-Thread-Pools.html#g-thread-pool-new
> 
> Currently we use "exlusive" thread pools but its performance seems to be
> poor. I tried using "shared" thread pools and performance seems much
> better. I posted performance results here.
> 
> https://www.redhat.com/archives/virtio-fs/2020-September/msg00080.html
> 
> So lets switch to shared thread pools. We can think of making it optional
> once somebody can show in what cases exclusive thread pools offer better
> results. For now, my simple performance tests across the board see
> better results with shared thread pools.

I'm really curious why  there's any perf difference between shared and
exclusive thread pools in the GLib impl.

Looking at the code the main difference between the two is appears to
be around the way threads are spawned, specifically around the scheduler
attributes assigned.

In the shared case, the threads in the pool will have their scheduler
attributes copied from the very first thread that calls g_thread_pool_new.

In the exclusive case, the threads in the pool will inherit their
scheduler attributes from the thread which pushs the job that
causes the worker thread to be created.

By schedular attributes, I mean all the items in the 'struct schedattr'
filled by sched_getattr()

IOW, if threads in virtiofsd have varying schedular attributes this
could possibly explain the difference in performance you see between
the two setups.

> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: qemu/tools/virtiofsd/fuse_virtio.c
> ===================================================================
> --- qemu.orig/tools/virtiofsd/fuse_virtio.c	2020-09-21 17:28:27.444438015 -0400
> +++ qemu/tools/virtiofsd/fuse_virtio.c	2020-09-21 17:28:30.584568910 -0400
> @@ -695,7 +695,7 @@ static void *fv_queue_thread(void *opaqu
>      struct fuse_session *se = qi->virtio_dev->se;
>      GThreadPool *pool;
>  
> -    pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size, TRUE,
> +    pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size, FALSE,
>                               NULL);
>      if (!pool) {
>          fuse_log(FUSE_LOG_ERR, "%s: g_thread_pool_new failed\n", __func__);
> 
> 

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

