Date: Thu, 24 Sep 2020 10:29:35 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200924092935.GC2792@work-vm>
References: <20200921213216.GE13362@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921213216.GE13362@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Used glib "shared" thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, Miklos Szeredi <miklos@szeredi.hu>

* Vivek Goyal (vgoyal@redhat.com) wrote:
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
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Queued (with Miklos's seccomp fix); although my gut feeling is we'll be
coming back to this again to understand how the threading should work.

Dave

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
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

