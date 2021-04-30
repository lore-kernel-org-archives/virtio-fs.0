Date: Fri, 30 Apr 2021 12:28:50 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210430122850.0af11cd1@bahia.lan>
In-Reply-To: <20210428180639.GC1840673@redhat.com>
References: <20210428180639.GC1840673@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [RFC] [PATCH][v2]: Auto switch between inline and
 thread pool processing
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

Hi Vivek,

On Wed, 28 Apr 2021 14:06:39 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> For low queue depth workloads, inline processing works well. But for 
> high queue depth (and multiple process/thread) workloads, parallel
> processing of thread pool can benefit.
> 
> This patch is an experiment which tries to switch to between inline and
> thread-pool processing.
> 
> If number of requests received on queue is less than or equal to user
> specified threshold, inline processing is done. Otherwise requests are
> handed over to a thread pool for processing.
> 
> A user can specify the threshold using option
> "--auto-switch-threshold=<threshold>".
> 
> I have got good results with "--thread-pool-size=16 --auto-switch-threshold=3" 
> on my system.
>  
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
> Changes since v1:
> 
> Added a knob to specify auto switch threshold. This will also enable
> auto switching. By default it is turned off.
> 
> ---
>  tools/virtiofsd/fuse_i.h        |    1 +
>  tools/virtiofsd/fuse_lowlevel.c |    5 ++++-
>  tools/virtiofsd/fuse_virtio.c   |   32 ++++++++++++++++++++++----------
>  3 files changed, 27 insertions(+), 11 deletions(-)
> 
> Index: rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c
> ===================================================================
> --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_virtio.c	2021-04-28 13:42:34.855145073 -0400
> +++ rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c	2021-04-28 13:48:21.980538754 -0400
> @@ -446,6 +446,15 @@ err:
>  static __thread bool clone_fs_called;
>  
>  /* Process one FVRequest in a thread pool */
> +static void fv_queue_push_to_pool(gpointer data, gpointer user_data)
> +{
> +    FVRequest *req = data;
> +    GThreadPool *pool = user_data;
> +
> +    g_thread_pool_push(pool, req, NULL);
> +}
> +
> +/* Process one FVRequest in a thread pool */

This comment should be dropped actually since fv_queue_worker() can
be called by the queue thread as well.

>  static void fv_queue_worker(gpointer data, gpointer user_data)
>  {
>      struct fv_QueueInfo *qi = user_data;
> @@ -605,10 +614,12 @@ static void *fv_queue_thread(void *opaqu
>      struct fuse_session *se = qi->virtio_dev->se;
>      GThreadPool *pool = NULL;
>      GList *req_list = NULL;
> +    int nr_req = 0;
>  

nr_req isn't strictly needed : it is used in one place and we won't have
that many requests to handle that calling g_list_length() could be an issue
IMHO.

>      if (se->thread_pool_size) {
> -        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d\n",
> -                 __func__, qi->qidx);
> +        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d."
> +                 " auto_switch_threshold=%u\n", __func__, qi->qidx,
> +                 se->auto_switch_threshold);
>          pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size,
>                                   FALSE, NULL);
>          if (!pool) {
> @@ -686,22 +697,23 @@ static void *fv_queue_thread(void *opaqu
>              }
>  
>              req->reply_sent = false;
> -
> -            if (!se->thread_pool_size) {
> -                req_list = g_list_prepend(req_list, req);
> -            } else {
> -                g_thread_pool_push(pool, req, NULL);
> -            }
> +            req_list = g_list_prepend(req_list, req);

Actually this change looks like an improvement...

> +            nr_req++;
>          }
>  
>          pthread_mutex_unlock(&qi->vq_lock);
>          vu_dispatch_unlock(qi->virtio_dev);
>  
>          /* Process all the requests. */
> -        if (!se->thread_pool_size && req_list != NULL) {
> -            g_list_foreach(req_list, fv_queue_worker, qi);
> +        if (req_list != NULL) {
> +            if (!se->thread_pool_size || nr_req <= se->auto_switch_threshold) {
> +                g_list_foreach(req_list, fv_queue_worker, qi);
> +            } else  {
> +                g_list_foreach(req_list, fv_queue_push_to_pool, pool);
> +            }

... even without the introduction of the auto switch feature. Code paths
for thread pool and inline are clearer IMHO, and this would provide a
good base to experiment various strategies with the thread pool.

Also, what I understand is that the queue thread either handle up
to auto_switch_threshold requests synchronously or offloads the
full list of requests to the thread pool, i.e. when using the thread
pool, the queue thread would basically have around 0% utilization.

What I had in mind is that the queue thread would always handle
some requests inline and only offload the rest to the thread pool.
The utilization of the queue thread as you described in some other
mail could be used to decide on the amount of requests to offload.

Makes sense ?

Cheers,

--
Greg

>              g_list_free(req_list);
>              req_list = NULL;
> +            nr_req = 0;
>          }
>      }
>  
> Index: rhvgoyal-qemu/tools/virtiofsd/fuse_i.h
> ===================================================================
> --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_i.h	2021-04-28 13:42:34.855145073 -0400
> +++ rhvgoyal-qemu/tools/virtiofsd/fuse_i.h	2021-04-28 13:42:35.903188526 -0400
> @@ -73,6 +73,7 @@ struct fuse_session {
>      int   vu_socketfd;
>      struct fv_VuDev *virtio_dev;
>      int thread_pool_size;
> +    unsigned auto_switch_threshold;
>  };
>  
>  struct fuse_chan {
> Index: rhvgoyal-qemu/tools/virtiofsd/fuse_lowlevel.c
> ===================================================================
> --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_lowlevel.c	2021-04-28 13:42:34.855145073 -0400
> +++ rhvgoyal-qemu/tools/virtiofsd/fuse_lowlevel.c	2021-04-28 13:42:35.904188567 -0400
> @@ -2432,6 +2432,7 @@ static const struct fuse_opt fuse_ll_opt
>      LL_OPTION("--socket-group=%s", vu_socket_group, 0),
>      LL_OPTION("--fd=%d", vu_listen_fd, 0),
>      LL_OPTION("--thread-pool-size=%d", thread_pool_size, 0),
> +    LL_OPTION("--auto-switch-threshold=%u", auto_switch_threshold, 0),
>      FUSE_OPT_END
>  };
>  
> @@ -2452,7 +2453,8 @@ void fuse_lowlevel_help(void)
>          "    --socket-path=PATH         path for the vhost-user socket\n"
>          "    --socket-group=GRNAME      name of group for the vhost-user socket\n"
>          "    --fd=FDNUM                 fd number of vhost-user socket\n"
> -        "    --thread-pool-size=NUM     thread pool size limit (default %d)\n",
> +        "    --thread-pool-size=NUM     thread pool size limit (default %d)\n"
> +        "    --auto-switch-threshold=NUM     number of request threshold to switch between inline and thread pool processing of request\n",
>          THREAD_POOL_SIZE);
>  }
>  
> @@ -2508,6 +2510,7 @@ struct fuse_session *fuse_session_new(st
>      se->fd = -1;
>      se->vu_listen_fd = -1;
>      se->thread_pool_size = THREAD_POOL_SIZE;
> +    se->auto_switch_threshold = 0;
>      se->conn.max_write = UINT_MAX;
>      se->conn.max_readahead = UINT_MAX;
>  
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

