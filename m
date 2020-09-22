Date: Tue, 22 Sep 2020 18:46:18 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20200922174618.GV1989025@redhat.com>
References: <20200921213216.GE13362@redhat.com>
	<20200922125957.GN1989025@redhat.com>
	<20200922174255.GC57620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200922174255.GC57620@redhat.com>
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

On Tue, Sep 22, 2020 at 01:42:55PM -0400, Vivek Goyal wrote:
> On Tue, Sep 22, 2020 at 01:59:57PM +0100, Daniel P. Berrangé wrote:
> > On Mon, Sep 21, 2020 at 05:32:16PM -0400, Vivek Goyal wrote:
> > > glib offers thread pools and it seems to support "exclusive" and "shared"
> > > thread pools.
> > > 
> > > https://developer.gnome.org/glib/stable/glib-Thread-Pools.html#g-thread-pool-new
> > > 
> > > Currently we use "exlusive" thread pools but its performance seems to be
> > > poor. I tried using "shared" thread pools and performance seems much
> > > better. I posted performance results here.
> > > 
> > > https://www.redhat.com/archives/virtio-fs/2020-September/msg00080.html
> > > 
> > > So lets switch to shared thread pools. We can think of making it optional
> > > once somebody can show in what cases exclusive thread pools offer better
> > > results. For now, my simple performance tests across the board see
> > > better results with shared thread pools.
> > 
> > I'm really curious why  there's any perf difference between shared and
> > exclusive thread pools in the GLib impl.
> > 
> > Looking at the code the main difference between the two is appears to
> > be around the way threads are spawned, specifically around the scheduler
> > attributes assigned.
> > 
> > In the shared case, the threads in the pool will have their scheduler
> > attributes copied from the very first thread that calls g_thread_pool_new.
> > 
> > In the exclusive case, the threads in the pool will inherit their
> > scheduler attributes from the thread which pushs the job that
> > causes the worker thread to be created.
> > 
> > By schedular attributes, I mean all the items in the 'struct schedattr'
> > filled by sched_getattr()
> > 
> > IOW, if threads in virtiofsd have varying schedular attributes this
> > could possibly explain the difference in performance you see between
> > the two setups.
> 
> Hi Daniel,
> 
> Few things.
> 
> - I think scheduler attributes are same for the thread creating
>   pool as well as for thread pushing the job for virtiofsd.
> 
> - My glib2 is old (2.58.3) and I think that did not have sched_getattr()
>   stuff.
> 
> - One difference I noticed is that in case of shared pool, it does not
>   create extra threads if client is doing one request at a time. While
>   exclusive pool seemed to push every request to a new thread in pool
>   in sort of round robin fashion. It feels keeping requests being served
>   from same thread helps in this particilar workload case.

Yeah, that does sound like a candidate for the cause. I wonder if that
was intentional in the GLib design or just an accidental impl they didn't
realize had performance implications. Might be worth filing a bug against
GLib if someone has free time & motivation to figure out a standalone
reproducer to demonstrate the performance difference in the GLib APIs.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

