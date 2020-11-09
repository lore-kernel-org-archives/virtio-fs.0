Date: Mon, 9 Nov 2020 18:47:06 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201109184706.GP3024@work-vm>
References: <20201109143548.GA1479853@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109143548.GA1479853@redhat.com>
Subject: Re: [Virtio-fs] [PATCH V2] virtiofsd: Use --thread-pool-size=0 to
 mean no thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, jose.carlos.venegas.munoz@intel.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Right now we create a thread pool and main thread hands over the request
> to thread in thread pool to process. Number of threads in thread pool
> can be managed by option --thread-pool-size.
> 
> In tests we have noted that many of the workloads are getting better
> performance if we don't use a thread pool at all and process all
> the requests in the context of a thread receiving the request.
> 
> Hence give user an option to be able to run virtiofsd without using
> a thread pool.
> 
> To implement this, I have used existing option --thread-pool-size. This
> option defines how many maximum threads can be in the thread pool.
> Thread pool size zero freezes thead pool. I can't see why will one
> start virtiofsd with a frozen thread pool (hence frozen file system).
> So I am redefining --thread-pool-size=0 to mean, don't use a thread pool.
> Instead process the request in the context of thread receiving request
> from the queue.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/fuse_virtio.c | 36 ++++++++++++++++++++++++++---------
>  1 file changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 83ba07c6cd..944b9a577c 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -588,13 +588,18 @@ static void *fv_queue_thread(void *opaque)
>      struct VuDev *dev = &qi->virtio_dev->dev;
>      struct VuVirtq *q = vu_get_queue(dev, qi->qidx);
>      struct fuse_session *se = qi->virtio_dev->se;
> -    GThreadPool *pool;
> -
> -    pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size, FALSE,
> -                             NULL);
> -    if (!pool) {
> -        fuse_log(FUSE_LOG_ERR, "%s: g_thread_pool_new failed\n", __func__);
> -        return NULL;
> +    GThreadPool *pool = NULL;
> +    GList *req_list = NULL;
> +
> +    if (se->thread_pool_size) {
> +        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d\n",
> +                 __func__, qi->qidx);
> +        pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size,
> +                                 FALSE, NULL);
> +        if (!pool) {
> +            fuse_log(FUSE_LOG_ERR, "%s: g_thread_pool_new failed\n", __func__);
> +            return NULL;
> +        }
>      }
>  
>      fuse_log(FUSE_LOG_INFO, "%s: Start for queue %d kick_fd %d\n", __func__,
> @@ -669,14 +674,27 @@ static void *fv_queue_thread(void *opaque)
>  
>              req->reply_sent = false;
>  
> -            g_thread_pool_push(pool, req, NULL);
> +            if (!se->thread_pool_size) {
> +                req_list = g_list_prepend(req_list, req);
> +            } else {
> +                g_thread_pool_push(pool, req, NULL);
> +            }
>          }
>  
>          pthread_mutex_unlock(&qi->vq_lock);
>          pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
> +
> +        /* Process all the requests. */
> +        if (!se->thread_pool_size && req_list != NULL) {
> +            g_list_foreach(req_list, fv_queue_worker, qi);
> +            g_list_free(req_list);
> +            req_list = NULL;
> +        }
>      }
>  
> -    g_thread_pool_free(pool, FALSE, TRUE);
> +    if (pool) {
> +        g_thread_pool_free(pool, FALSE, TRUE);
> +    }
>  
>      return NULL;
>  }
> -- 
> 2.25.4
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

