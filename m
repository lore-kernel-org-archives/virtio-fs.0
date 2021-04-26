Date: Mon, 26 Apr 2021 07:39:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210426113954.GA1724699@redhat.com>
References: <20210423211130.GA1668472@redhat.com>
	<20210424061243.GA36532@rsjd01523.et2sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210424061243.GA36532@rsjd01523.et2sqa>
Subject: Re: [Virtio-fs] [RFC] [PATCH] virtiofsd: Auto switch between inline
 and thread-pool processing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Michey Mehta <mimehta@redhat.com>

On Sat, Apr 24, 2021 at 02:12:44PM +0800, Liu Bo wrote:
> On Fri, Apr 23, 2021 at 05:11:30PM -0400, Vivek Goyal wrote:
> > This is just an RFC patch for now. I am still running performance numbers
> > and see if this method of switching is good enough or not. I did one run
> > and seemed to get higher performance on deeper queue depths. There were
> > few tests where I did not match lower queue depth performance with 
> > no thread pool. May be run to run variation.
> > 
> > For low queue depth workloads, inline processing works well. But for 
> > high queue depth (and multiple process/thread) workloads, parallel
> > processing of thread pool can benefit.
> > 
> > This patch is an experiment which tries to switch to between inline and
> > thread-pool processing. If number of requests received on queue is
> > 1, inline processing is done. Otherwise requests are handed over to
> > a thread pool for processing.
> >
> 
> I'm looking forward to the results showing how many requests would it
> beats the overhead of using thread pools.
> 
> This is a good idea indeed, and the switch mechanism also applies to
> async IO framework like iouring.

Hi Liubo,

I have been thinking of using io_uring. Have you managed to make it work.
Do we get better performance with io_uring.

Thanks
Vivek

> 
> thanks,
> liubo
> 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  tools/virtiofsd/fuse_virtio.c |   27 +++++++++++++++++++--------
> >  1 file changed, 19 insertions(+), 8 deletions(-)
> > 
> > Index: rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c
> > ===================================================================
> > --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_virtio.c	2021-04-23 10:03:46.175920039 -0400
> > +++ rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c	2021-04-23 10:56:37.793722634 -0400
> > @@ -446,6 +446,15 @@ err:
> >  static __thread bool clone_fs_called;
> >  
> >  /* Process one FVRequest in a thread pool */
> > +static void fv_queue_push_to_pool(gpointer data, gpointer user_data)
> > +{
> > +    FVRequest *req = data;
> > +    GThreadPool *pool = user_data;
> > +
> > +    g_thread_pool_push(pool, req, NULL);
> > +}
> > +
> > +/* Process one FVRequest in a thread pool */
> >  static void fv_queue_worker(gpointer data, gpointer user_data)
> >  {
> >      struct fv_QueueInfo *qi = user_data;
> > @@ -605,6 +614,7 @@ static void *fv_queue_thread(void *opaqu
> >      struct fuse_session *se = qi->virtio_dev->se;
> >      GThreadPool *pool = NULL;
> >      GList *req_list = NULL;
> > +    int nr_req = 0;
> >  
> >      if (se->thread_pool_size) {
> >          fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d\n",
> > @@ -686,22 +696,23 @@ static void *fv_queue_thread(void *opaqu
> >              }
> >  
> >              req->reply_sent = false;
> > -
> > -            if (!se->thread_pool_size) {
> > -                req_list = g_list_prepend(req_list, req);
> > -            } else {
> > -                g_thread_pool_push(pool, req, NULL);
> > -            }
> > +            req_list = g_list_prepend(req_list, req);
> > +            nr_req++;
> >          }
> >  
> >          pthread_mutex_unlock(&qi->vq_lock);
> >          vu_dispatch_unlock(qi->virtio_dev);
> >  
> >          /* Process all the requests. */
> > -        if (!se->thread_pool_size && req_list != NULL) {
> > -            g_list_foreach(req_list, fv_queue_worker, qi);
> > +        if (req_list != NULL) {
> > +            if (!se->thread_pool_size || nr_req <= 2) {
> > +                g_list_foreach(req_list, fv_queue_worker, qi);
> > +            } else  {
> > +                g_list_foreach(req_list, fv_queue_push_to_pool, pool);
> > +            }
> >              g_list_free(req_list);
> >              req_list = NULL;
> > +            nr_req = 0;
> >          }
> >      }
> >  
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

