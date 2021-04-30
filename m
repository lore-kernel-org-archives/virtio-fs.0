Date: Fri, 30 Apr 2021 17:23:12 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210430172312.4e50f604@bahia.lan>
In-Reply-To: <20210430134207.GB1936051@redhat.com>
References: <20210428180639.GC1840673@redhat.com>
	<20210430122850.0af11cd1@bahia.lan>
	<20210430134207.GB1936051@redhat.com>
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

On Fri, 30 Apr 2021 09:42:07 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Apr 30, 2021 at 12:28:50PM +0200, Greg Kurz wrote:
> > Hi Vivek,
> > 
> > On Wed, 28 Apr 2021 14:06:39 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > For low queue depth workloads, inline processing works well. But for 
> > > high queue depth (and multiple process/thread) workloads, parallel
> > > processing of thread pool can benefit.
> > > 
> > > This patch is an experiment which tries to switch to between inline and
> > > thread-pool processing.
> > > 
> > > If number of requests received on queue is less than or equal to user
> > > specified threshold, inline processing is done. Otherwise requests are
> > > handed over to a thread pool for processing.
> > > 
> > > A user can specify the threshold using option
> > > "--auto-switch-threshold=<threshold>".
> > > 
> > > I have got good results with "--thread-pool-size=16 --auto-switch-threshold=3" 
> > > on my system.
> > >  
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > > Changes since v1:
> > > 
> > > Added a knob to specify auto switch threshold. This will also enable
> > > auto switching. By default it is turned off.
> > > 
> > > ---
> > >  tools/virtiofsd/fuse_i.h        |    1 +
> > >  tools/virtiofsd/fuse_lowlevel.c |    5 ++++-
> > >  tools/virtiofsd/fuse_virtio.c   |   32 ++++++++++++++++++++++----------
> > >  3 files changed, 27 insertions(+), 11 deletions(-)
> > > 
> > > Index: rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c
> > > ===================================================================
> > > --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_virtio.c	2021-04-28 13:42:34.855145073 -0400
> > > +++ rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c	2021-04-28 13:48:21.980538754 -0400
> > > @@ -446,6 +446,15 @@ err:
> > >  static __thread bool clone_fs_called;
> > >  
> > >  /* Process one FVRequest in a thread pool */
> > > +static void fv_queue_push_to_pool(gpointer data, gpointer user_data)
> > > +{
> > > +    FVRequest *req = data;
> > > +    GThreadPool *pool = user_data;
> > > +
> > > +    g_thread_pool_push(pool, req, NULL);
> > > +}
> > > +
> > > +/* Process one FVRequest in a thread pool */
> > 
> > This comment should be dropped actually since fv_queue_worker() can
> > be called by the queue thread as well.
> 
> Yes. Will remove this.
> 
> > 
> > >  static void fv_queue_worker(gpointer data, gpointer user_data)
> > >  {
> > >      struct fv_QueueInfo *qi = user_data;
> > > @@ -605,10 +614,12 @@ static void *fv_queue_thread(void *opaqu
> > >      struct fuse_session *se = qi->virtio_dev->se;
> > >      GThreadPool *pool = NULL;
> > >      GList *req_list = NULL;
> > > +    int nr_req = 0;
> > >  
> > 
> > nr_req isn't strictly needed : it is used in one place and we won't have
> > that many requests to handle that calling g_list_length() could be an issue
> > IMHO.
> 
> I disagree a bit here. Say there are 8 requests in the list. I would
> rather prefer to keep a count of number of elements in the list instead
> of traversing all elements of the list to figure out how many are there.
> And cost is just maintaining one local variable.
> 

Alternatively, req_list could be converted to GQueue, which maintains
the element count internally. It would also offer more flexibility to
split req_list between inline and thread pool paths.

> > 
> > >      if (se->thread_pool_size) {
> > > -        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d\n",
> > > -                 __func__, qi->qidx);
> > > +        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d."
> > > +                 " auto_switch_threshold=%u\n", __func__, qi->qidx,
> > > +                 se->auto_switch_threshold);
> > >          pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size,
> > >                                   FALSE, NULL);
> > >          if (!pool) {
> > > @@ -686,22 +697,23 @@ static void *fv_queue_thread(void *opaqu
> > >              }
> > >  
> > >              req->reply_sent = false;
> > > -
> > > -            if (!se->thread_pool_size) {
> > > -                req_list = g_list_prepend(req_list, req);
> > > -            } else {
> > > -                g_thread_pool_push(pool, req, NULL);
> > > -            }
> > > +            req_list = g_list_prepend(req_list, req);
> > 
> > Actually this change looks like an improvement...
> 
> Agreed.
> 
> > 
> > > +            nr_req++;
> > >          }
> > >  
> > >          pthread_mutex_unlock(&qi->vq_lock);
> > >          vu_dispatch_unlock(qi->virtio_dev);
> > >  
> > >          /* Process all the requests. */
> > > -        if (!se->thread_pool_size && req_list != NULL) {
> > > -            g_list_foreach(req_list, fv_queue_worker, qi);
> > > +        if (req_list != NULL) {
> > > +            if (!se->thread_pool_size || nr_req <= se->auto_switch_threshold) {
> > > +                g_list_foreach(req_list, fv_queue_worker, qi);
> > > +            } else  {
> > > +                g_list_foreach(req_list, fv_queue_push_to_pool, pool);
> > > +            }
> > 
> > ... even without the introduction of the auto switch feature. Code paths
> > for thread pool and inline are clearer IMHO, and this would provide a
> > good base to experiment various strategies with the thread pool.
> > 
> > Also, what I understand is that the queue thread either handle up
> > to auto_switch_threshold requests synchronously or offloads the
> > full list of requests to the thread pool, i.e. when using the thread
> > pool, the queue thread would basically have around 0% utilization.
> > 
> > What I had in mind is that the queue thread would always handle
> > some requests inline and only offload the rest to the thread pool.
> 
> I also was thinking about that option. Then I thought, what if client
> is pushing requests too fast and most of the cycles of one thread are
> gone in just popping requests from the queue and handing it over to
> thread pool. In that case it might be better if this main thread does
> not process anything.
> 

Maybe rate limit the popping of requests ?

> But I don't know if reset of the code is optimized enough that it
> can push requests at such high rate that one thread can be kept
> busy.
> 
> > The utilization of the queue thread as you described in some other
> > mail could be used to decide on the amount of requests to offload.
> 
> Hmm.., I guess we could experiment with this. Keep track of current
> utilization of this main thread. And if utilization crosses a
> threshold say 75%, then start offloading some requests to thread pool.
> 
> And if thread utilization drops below say 50%, then do everything
> inline again. And this will not require knowing what's the utilization
> of thread pool because we are only relying on cpu utilization of this
> main thread.
> 

Yes, I'm thinking of something alike.

> > 
> > Makes sense ?
> 
> Yes. I am still trying to figure out what's the best way to determine
> % cpu utilization of main thread. This is the crude mechanism I had
> thought about.
> 
> t1 = gettimeofday()
> thread-goes-to-sleep
> thread-wakes-up
> t2= gettimeofday()
> thread-pops-requests
> thread-processes-requests-inline
> t3=gettimeofday()
> 
> So effectively t2-t1 is free time and t3-t2 is busy time. So % utilization
> should be.
> 
> %util=(t3-t2) * 100/(t3-t1)
> 
> But this has issues. A thread might not wake up because host is too
> busy and can't schedule a thread despite the fact it is ready to
> run. In that case (t2-t1) can be long and we will think that thread's
> % utilization is low and it is lot of free time.
> 
> So this method of determining % utilization of thread is not very good.
> We need a more accurate method.
> 

Nothing comes to mind right now. I need to think some more :)

> Thanks
> Vivek
> 

Cheers,

--
Greg

