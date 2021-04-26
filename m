Date: Mon, 26 Apr 2021 18:40:28 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YIb7DCBfUi0ybTYM@work-vm>
References: <20210423211130.GA1668472@redhat.com>
	<CAFQAk7i_u_xmBRVuDvWoN_dZDjGgHpRtZ_niCV5r86ezdYsKMQ@mail.gmail.com>
	<20210426151150.GB1724699@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426151150.GB1724699@redhat.com>
Subject: Re: [Virtio-fs] [External] [RFC] [PATCH] virtiofsd: Auto switch
 between inline and thread-pool processing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Michey Mehta <mimehta@redhat.com>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Sun, Apr 25, 2021 at 10:29:14AM +0800, Jiachen Zhang wrote:
> > On Sat, Apr 24, 2021 at 5:11 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > This is just an RFC patch for now. I am still running performance numbers
> > > and see if this method of switching is good enough or not. I did one run
> > > and seemed to get higher performance on deeper queue depths. There were
> > > few tests where I did not match lower queue depth performance with
> > > no thread pool. May be run to run variation.
> > >
> > >
> > I think this is interesting. I guess the switch number between thread-pool
> > and the inline method may change as the hardware or OS kernel changes.
> > Looking forward to the results.
> 
> Hi Jiachen,
> 
> Agreed that threshold to switch between inline and thread-pool will vary
> based on hardware and so many other factors. Having said that, there is
> no good way to determine what's the most optimized threshold for a
> particular setup. 

I can imagine something based on the % of time a thread is utilised as
being an indication you might need more/less; but that's an even more
complicated heuristic.

> Maybe we will have to just go with a default which works reasonably
> well and also provide a knob to user to alter that threshold. Atleast
> it can be useful to experiment with different thresholds.

Dave

> Vivek
> 
> > 
> > Jiachen
> > 
> > 
> > > For low queue depth workloads, inline processing works well. But for
> > > high queue depth (and multiple process/thread) workloads, parallel
> > > processing of thread pool can benefit.
> > >
> > > This patch is an experiment which tries to switch to between inline and
> > > thread-pool processing. If number of requests received on queue is
> > > 1, inline processing is done. Otherwise requests are handed over to
> > > a thread pool for processing.
> > >
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  tools/virtiofsd/fuse_virtio.c |   27 +++++++++++++++++++--------
> > >  1 file changed, 19 insertions(+), 8 deletions(-)
> > >
> > > Index: rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c
> > > ===================================================================
> > > --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_virtio.c    2021-04-23
> > > 10:03:46.175920039 -0400
> > > +++ rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c 2021-04-23
> > > 10:56:37.793722634 -0400
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
> > >  static void fv_queue_worker(gpointer data, gpointer user_data)
> > >  {
> > >      struct fv_QueueInfo *qi = user_data;
> > > @@ -605,6 +614,7 @@ static void *fv_queue_thread(void *opaqu
> > >      struct fuse_session *se = qi->virtio_dev->se;
> > >      GThreadPool *pool = NULL;
> > >      GList *req_list = NULL;
> > > +    int nr_req = 0;
> > >
> > >      if (se->thread_pool_size) {
> > >          fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue
> > > %d\n",
> > > @@ -686,22 +696,23 @@ static void *fv_queue_thread(void *opaqu
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
> > > +            if (!se->thread_pool_size || nr_req <= 2) {
> > > +                g_list_foreach(req_list, fv_queue_worker, qi);
> > > +            } else  {
> > > +                g_list_foreach(req_list, fv_queue_push_to_pool, pool);
> > > +            }
> > >              g_list_free(req_list);
> > >              req_list = NULL;
> > > +            nr_req = 0;
> > >          }
> > >      }
> > >
> > >
> > > _______________________________________________
> > > Virtio-fs mailing list
> > > Virtio-fs@redhat.com
> > > https://listman.redhat.com/mailman/listinfo/virtio-fs
> > >
> > >
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

