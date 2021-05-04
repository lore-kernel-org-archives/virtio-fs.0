Date: Tue, 4 May 2021 17:54:38 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210504175438.52468a40@bahia.lan>
In-Reply-To: <20210504151841.GC135914@redhat.com>
References: <20210504151841.GC135914@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [RFC][PATCH][v3] virtiofsd: virtiofsd: Use thread
 pool only after certain queue depth
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Tue, 4 May 2021 11:18:41 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> For low queue depth workloads, inline processing works well. But for 
> high queue depth (and multiple process/thread) workloads, parallel
> processing of thread pool can benefit.
> 
> This patch provides a knob --thread-pool-threshold=<nr-requests>, which
> uses a thread pool only if number of requests on virtqueue are more
> than nr-requests. IOW, upto nr-requests, requests are processed inline
> and anything more than nr-requests is sent for processing in thread
> pool.
> 
> I have got good results with "--thread-pool-size=16 --thread-pool-threshold=3" 
> on my system.
>  
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
> 
> Test results with this patch are available here.
> 
> https://github.com/rhvgoyal/virtiofs-tests/tree/master/performance-results/thread-pool-threshold/4-may-2021
> 
> Changes since v2:
> - Renamed knob name to "--thread-pool-threshold"
> - Started using GQueue instead of GList to keep a list of requests
>   received on virtqueue (Greg)
> - When threshold is crossed only requests above threshold are sent to
>   thread pool. Rest are still processed inline. (Greg)
> ---
>  tools/virtiofsd/fuse_i.h        |    1 +
>  tools/virtiofsd/fuse_lowlevel.c |    8 +++++++-
>  tools/virtiofsd/fuse_virtio.c   |   27 +++++++++++++--------------
>  3 files changed, 21 insertions(+), 15 deletions(-)
> 
> Index: rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c
> ===================================================================
> --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_virtio.c	2021-05-04 09:55:30.467514740 -0400
> +++ rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c	2021-05-04 10:06:32.453801299 -0400
> @@ -445,7 +445,6 @@ err:
>  
>  static __thread bool clone_fs_called;
>  
> -/* Process one FVRequest in a thread pool */
>  static void fv_queue_worker(gpointer data, gpointer user_data)
>  {
>      struct fv_QueueInfo *qi = user_data;
> @@ -604,11 +603,12 @@ static void *fv_queue_thread(void *opaqu
>      struct VuVirtq *q = vu_get_queue(dev, qi->qidx);
>      struct fuse_session *se = qi->virtio_dev->se;
>      GThreadPool *pool = NULL;
> -    GList *req_list = NULL;
> +    GQueue req_queue = G_QUEUE_INIT;
>  
>      if (se->thread_pool_size) {
> -        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d\n",
> -                 __func__, qi->qidx);
> +        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d."
> +                 " thread_pool_threshold=%u\n", __func__, qi->qidx,
> +                 se->thread_pool_threshold);
>          pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size,
>                                   FALSE, NULL);
>          if (!pool) {
> @@ -686,22 +686,21 @@ static void *fv_queue_thread(void *opaqu
>              }
>  
>              req->reply_sent = false;
> -
> -            if (!se->thread_pool_size) {
> -                req_list = g_list_prepend(req_list, req);
> -            } else {
> -                g_thread_pool_push(pool, req, NULL);
> -            }
> +            g_queue_push_tail(&req_queue, req);

So here you replace prepend() with push_tail() but...

>          }
>  
>          pthread_mutex_unlock(&qi->vq_lock);
>          vu_dispatch_unlock(qi->virtio_dev);
>  
>          /* Process all the requests. */
> -        if (!se->thread_pool_size && req_list != NULL) {
> -            g_list_foreach(req_list, fv_queue_worker, qi);
> -            g_list_free(req_list);
> -            req_list = NULL;
> +        for (int i = g_queue_get_length(&req_queue); i > 0; i--) {
> +                FVRequest *req = g_queue_pop_head(&req_queue);

... this pops from the head. Isn't this reversing the order in which
requests are processed ? Not very harmful I guess.

> +
> +                if (se->thread_pool_size && i > se->thread_pool_threshold) {

requests are pushed to the thread pool first, good. :)

> +                    g_thread_pool_push(pool, req, NULL);
> +                } else {
> +                    fv_queue_worker(req, qi);
> +                }
>          }
>      }
>  
> Index: rhvgoyal-qemu/tools/virtiofsd/fuse_i.h
> ===================================================================
> --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_i.h	2021-05-04 09:55:30.467514740 -0400
> +++ rhvgoyal-qemu/tools/virtiofsd/fuse_i.h	2021-05-04 10:04:58.737938382 -0400
> @@ -73,6 +73,7 @@ struct fuse_session {
>      int   vu_socketfd;
>      struct fv_VuDev *virtio_dev;
>      int thread_pool_size;
> +    unsigned thread_pool_threshold;
>  };
>  
>  struct fuse_chan {
> Index: rhvgoyal-qemu/tools/virtiofsd/fuse_lowlevel.c
> ===================================================================
> --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_lowlevel.c	2021-05-04 09:55:30.467514740 -0400
> +++ rhvgoyal-qemu/tools/virtiofsd/fuse_lowlevel.c	2021-05-04 10:17:27.674809167 -0400
> @@ -2432,6 +2432,7 @@ static const struct fuse_opt fuse_ll_opt
>      LL_OPTION("--socket-group=%s", vu_socket_group, 0),
>      LL_OPTION("--fd=%d", vu_listen_fd, 0),
>      LL_OPTION("--thread-pool-size=%d", thread_pool_size, 0),
> +    LL_OPTION("--thread-pool-threshold=%u", thread_pool_threshold, 0),
>      FUSE_OPT_END
>  };
>  
> @@ -2452,7 +2453,11 @@ void fuse_lowlevel_help(void)
>          "    --socket-path=PATH         path for the vhost-user socket\n"
>          "    --socket-group=GRNAME      name of group for the vhost-user socket\n"
>          "    --fd=FDNUM                 fd number of vhost-user socket\n"
> -        "    --thread-pool-size=NUM     thread pool size limit (default %d)\n",
> +        "    --thread-pool-size=NUM     thread pool size limit (default %d)\n"
> +        "    --thread-pool-threshold=NUM\n"
> +        "                               number of request threshold to\n"
> +        "                               switch between inline and thread pool\n"
> +        "                               processing of request\n",

The number of requests the queue thread pops out from the virtqueue
looks a bit cryptic from a user point of view IMHO. Is this really
something we want to expose in the API ? Shouldn't this be something
we want to only change internally depending one some heuristics in
the future ?

>          THREAD_POOL_SIZE);
>  }
>  
> @@ -2508,6 +2513,7 @@ struct fuse_session *fuse_session_new(st
>      se->fd = -1;
>      se->vu_listen_fd = -1;
>      se->thread_pool_size = THREAD_POOL_SIZE;
> +    se->thread_pool_threshold = 0;
>      se->conn.max_write = UINT_MAX;
>      se->conn.max_readahead = UINT_MAX;
>  
> 

