Date: Tue, 4 May 2021 18:34:44 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210504183444.70f41199@bahia.lan>
In-Reply-To: <20210504160909.GE135914@redhat.com>
References: <20210504151841.GC135914@redhat.com>
	<20210504175438.52468a40@bahia.lan>
	<20210504160909.GE135914@redhat.com>
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

On Tue, 4 May 2021 12:09:09 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, May 04, 2021 at 05:54:38PM +0200, Greg Kurz wrote:
> > On Tue, 4 May 2021 11:18:41 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > For low queue depth workloads, inline processing works well. But for 
> > > high queue depth (and multiple process/thread) workloads, parallel
> > > processing of thread pool can benefit.
> > > 
> > > This patch provides a knob --thread-pool-threshold=<nr-requests>, which
> > > uses a thread pool only if number of requests on virtqueue are more
> > > than nr-requests. IOW, upto nr-requests, requests are processed inline
> > > and anything more than nr-requests is sent for processing in thread
> > > pool.
> > > 
> > > I have got good results with "--thread-pool-size=16 --thread-pool-threshold=3" 
> > > on my system.
> > >  
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > > 
> > > Test results with this patch are available here.
> > > 
> > > https://github.com/rhvgoyal/virtiofs-tests/tree/master/performance-results/thread-pool-threshold/4-may-2021
> > > 
> > > Changes since v2:
> > > - Renamed knob name to "--thread-pool-threshold"
> > > - Started using GQueue instead of GList to keep a list of requests
> > >   received on virtqueue (Greg)
> > > - When threshold is crossed only requests above threshold are sent to
> > >   thread pool. Rest are still processed inline. (Greg)
> > > ---
> > >  tools/virtiofsd/fuse_i.h        |    1 +
> > >  tools/virtiofsd/fuse_lowlevel.c |    8 +++++++-
> > >  tools/virtiofsd/fuse_virtio.c   |   27 +++++++++++++--------------
> > >  3 files changed, 21 insertions(+), 15 deletions(-)
> > > 
> > > Index: rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c
> > > ===================================================================
> > > --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_virtio.c	2021-05-04 09:55:30.467514740 -0400
> > > +++ rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c	2021-05-04 10:06:32.453801299 -0400
> > > @@ -445,7 +445,6 @@ err:
> > >  
> > >  static __thread bool clone_fs_called;
> > >  
> > > -/* Process one FVRequest in a thread pool */
> > >  static void fv_queue_worker(gpointer data, gpointer user_data)
> > >  {
> > >      struct fv_QueueInfo *qi = user_data;
> > > @@ -604,11 +603,12 @@ static void *fv_queue_thread(void *opaqu
> > >      struct VuVirtq *q = vu_get_queue(dev, qi->qidx);
> > >      struct fuse_session *se = qi->virtio_dev->se;
> > >      GThreadPool *pool = NULL;
> > > -    GList *req_list = NULL;
> > > +    GQueue req_queue = G_QUEUE_INIT;
> > >  
> > >      if (se->thread_pool_size) {
> > > -        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d\n",
> > > -                 __func__, qi->qidx);
> > > +        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d."
> > > +                 " thread_pool_threshold=%u\n", __func__, qi->qidx,
> > > +                 se->thread_pool_threshold);
> > >          pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size,
> > >                                   FALSE, NULL);
> > >          if (!pool) {
> > > @@ -686,22 +686,21 @@ static void *fv_queue_thread(void *opaqu
> > >              }
> > >  
> > >              req->reply_sent = false;
> > > -
> > > -            if (!se->thread_pool_size) {
> > > -                req_list = g_list_prepend(req_list, req);
> > > -            } else {
> > > -                g_thread_pool_push(pool, req, NULL);
> > > -            }
> > > +            g_queue_push_tail(&req_queue, req);
> > 
> > So here you replace prepend() with push_tail() but...
> > 
> > >          }
> > >  
> > >          pthread_mutex_unlock(&qi->vq_lock);
> > >          vu_dispatch_unlock(qi->virtio_dev);
> > >  
> > >          /* Process all the requests. */
> > > -        if (!se->thread_pool_size && req_list != NULL) {
> > > -            g_list_foreach(req_list, fv_queue_worker, qi);
> > > -            g_list_free(req_list);
> > > -            req_list = NULL;
> > > +        for (int i = g_queue_get_length(&req_queue); i > 0; i--) {
> > > +                FVRequest *req = g_queue_pop_head(&req_queue);
> > 
> > ... this pops from the head. Isn't this reversing the order in which
> > requests are processed ? Not very harmful I guess.
> 
> IIUC, g_queue_push_tail() will add each new request to tail of the queue.
> So when I pop from head, I will first pop the element which came first.
> That will be FIFO order. Am I misunderstanding it?
> 

This isn't what the current code is doing in the no-thread pool case
AFAICT. It pushes requests to the head and then does foreach(), i.e.
LIFO.

> > 
> > > +
> > > +                if (se->thread_pool_size && i > se->thread_pool_threshold) {
> > 
> > requests are pushed to the thread pool first, good. :)
> > 
> > > +                    g_thread_pool_push(pool, req, NULL);
> > > +                } else {
> > > +                    fv_queue_worker(req, qi);
> > > +                }
> > >          }
> > >      }
> > >  
> > > Index: rhvgoyal-qemu/tools/virtiofsd/fuse_i.h
> > > ===================================================================
> > > --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_i.h	2021-05-04 09:55:30.467514740 -0400
> > > +++ rhvgoyal-qemu/tools/virtiofsd/fuse_i.h	2021-05-04 10:04:58.737938382 -0400
> > > @@ -73,6 +73,7 @@ struct fuse_session {
> > >      int   vu_socketfd;
> > >      struct fv_VuDev *virtio_dev;
> > >      int thread_pool_size;
> > > +    unsigned thread_pool_threshold;
> > >  };
> > >  
> > >  struct fuse_chan {
> > > Index: rhvgoyal-qemu/tools/virtiofsd/fuse_lowlevel.c
> > > ===================================================================
> > > --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_lowlevel.c	2021-05-04 09:55:30.467514740 -0400
> > > +++ rhvgoyal-qemu/tools/virtiofsd/fuse_lowlevel.c	2021-05-04 10:17:27.674809167 -0400
> > > @@ -2432,6 +2432,7 @@ static const struct fuse_opt fuse_ll_opt
> > >      LL_OPTION("--socket-group=%s", vu_socket_group, 0),
> > >      LL_OPTION("--fd=%d", vu_listen_fd, 0),
> > >      LL_OPTION("--thread-pool-size=%d", thread_pool_size, 0),
> > > +    LL_OPTION("--thread-pool-threshold=%u", thread_pool_threshold, 0),
> > >      FUSE_OPT_END
> > >  };
> > >  
> > > @@ -2452,7 +2453,11 @@ void fuse_lowlevel_help(void)
> > >          "    --socket-path=PATH         path for the vhost-user socket\n"
> > >          "    --socket-group=GRNAME      name of group for the vhost-user socket\n"
> > >          "    --fd=FDNUM                 fd number of vhost-user socket\n"
> > > -        "    --thread-pool-size=NUM     thread pool size limit (default %d)\n",
> > > +        "    --thread-pool-size=NUM     thread pool size limit (default %d)\n"
> > > +        "    --thread-pool-threshold=NUM\n"
> > > +        "                               number of request threshold to\n"
> > > +        "                               switch between inline and thread pool\n"
> > > +        "                               processing of request\n",
> > 
> > The number of requests the queue thread pops out from the virtqueue
> > looks a bit cryptic from a user point of view IMHO. Is this really
> > something we want to expose in the API ? Shouldn't this be something
> > we want to only change internally depending one some heuristics in
> > the future ?
> 
> I think there are few things to consider.
> 
> - We will always have capability to modify defaults internally until
>   and unless user overrides that with options. So even if user does
>   not specify --thread-pool-threshold, we can always use it internally
>   if we can get good results across broad range of systems.
> 
> - Anohter option could be that we just give user a knob to enable
>   this switching behavior but number of requests are determined
>   internally. We can add that knob later as well. Right now I don't
>   feel like hardcoding this value "3" internally because it will

You're right but until we come up with a heuristic, if you had
good results with "3", I guess it's ok to hardcode that for now.

>   vary from systems to systems and from workload to worklaod 
>   probably. That's why I explicitly provided this interface
>   so that users can speicify this value.
> 
>   Having said that, this looks ugly. How a user is supposed to know
>   what value they should configure by default. That makes it more
>   of an interface usable in specific scenarios and not a generic
>   interface.
> 

That's my point. Ugly interfaces can prove to be burden in the
long term.... At least it should have x- prefix so that people
know they should probably not rely on it too much.

> So question is how to arrive at better heuristics so that virtiofsd
> itself determines right threhosld and user should not have to specify
> the threshold. Users should probably choose between whether to
> opt-in/opt-out of that new behavior.
> 

I'm not even sure the user needs to know that we internally
decide to process a few requests inline when a thread pool is
available.

> That makes me think that this is a good experimental patch to show
> that we can improve performance across spectrum if we wisely choose
> between inline process and when to take help of thread pool. But we
> need to develop a method for some sort of smart heuristic to determine
> that and not leave it to user.
> 

Yeah definitely.


> Thanks
> Vivek
> 
> > 
> > >          THREAD_POOL_SIZE);
> > >  }
> > >  
> > > @@ -2508,6 +2513,7 @@ struct fuse_session *fuse_session_new(st
> > >      se->fd = -1;
> > >      se->vu_listen_fd = -1;
> > >      se->thread_pool_size = THREAD_POOL_SIZE;
> > > +    se->thread_pool_threshold = 0;
> > >      se->conn.max_write = UINT_MAX;
> > >      se->conn.max_readahead = UINT_MAX;
> > >  
> > > 
> > 
> 

