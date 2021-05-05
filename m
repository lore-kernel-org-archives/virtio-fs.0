Date: Wed, 5 May 2021 15:05:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210505190525.GD244258@redhat.com>
References: <20210504151841.GC135914@redhat.com>
	<20210504175438.52468a40@bahia.lan>
	<20210504160909.GE135914@redhat.com>
	<20210504183444.70f41199@bahia.lan>
	<20210504180729.GH135914@redhat.com>
	<20210505094919.25a21ae8@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505094919.25a21ae8@bahia.lan>
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
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Wed, May 05, 2021 at 09:49:19AM +0200, Greg Kurz wrote:

[..]
> > > > > > Index: rhvgoyal-qemu/tools/virtiofsd/fuse_lowlevel.c
> > > > > > ===================================================================
> > > > > > --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_lowlevel.c	2021-05-04 09:55:30.467514740 -0400
> > > > > > +++ rhvgoyal-qemu/tools/virtiofsd/fuse_lowlevel.c	2021-05-04 10:17:27.674809167 -0400
> > > > > > @@ -2432,6 +2432,7 @@ static const struct fuse_opt fuse_ll_opt
> > > > > >      LL_OPTION("--socket-group=%s", vu_socket_group, 0),
> > > > > >      LL_OPTION("--fd=%d", vu_listen_fd, 0),
> > > > > >      LL_OPTION("--thread-pool-size=%d", thread_pool_size, 0),
> > > > > > +    LL_OPTION("--thread-pool-threshold=%u", thread_pool_threshold, 0),
> > > > > >      FUSE_OPT_END
> > > > > >  };
> > > > > >  
> > > > > > @@ -2452,7 +2453,11 @@ void fuse_lowlevel_help(void)
> > > > > >          "    --socket-path=PATH         path for the vhost-user socket\n"
> > > > > >          "    --socket-group=GRNAME      name of group for the vhost-user socket\n"
> > > > > >          "    --fd=FDNUM                 fd number of vhost-user socket\n"
> > > > > > -        "    --thread-pool-size=NUM     thread pool size limit (default %d)\n",
> > > > > > +        "    --thread-pool-size=NUM     thread pool size limit (default %d)\n"
> > > > > > +        "    --thread-pool-threshold=NUM\n"
> > > > > > +        "                               number of request threshold to\n"
> > > > > > +        "                               switch between inline and thread pool\n"
> > > > > > +        "                               processing of request\n",
> > > > > 
> > > > > The number of requests the queue thread pops out from the virtqueue
> > > > > looks a bit cryptic from a user point of view IMHO. Is this really
> > > > > something we want to expose in the API ? Shouldn't this be something
> > > > > we want to only change internally depending one some heuristics in
> > > > > the future ?
> > > > 
> > > > I think there are few things to consider.
> > > > 
> > > > - We will always have capability to modify defaults internally until
> > > >   and unless user overrides that with options. So even if user does
> > > >   not specify --thread-pool-threshold, we can always use it internally
> > > >   if we can get good results across broad range of systems.
> > > > 
> > > > - Anohter option could be that we just give user a knob to enable
> > > >   this switching behavior but number of requests are determined
> > > >   internally. We can add that knob later as well. Right now I don't
> > > >   feel like hardcoding this value "3" internally because it will
> > > 
> > > You're right but until we come up with a heuristic, if you had
> > > good results with "3", I guess it's ok to hardcode that for now.
> > > 
> > > >   vary from systems to systems and from workload to worklaod 
> > > >   probably. That's why I explicitly provided this interface
> > > >   so that users can speicify this value.
> > > > 
> > > >   Having said that, this looks ugly. How a user is supposed to know
> > > >   what value they should configure by default. That makes it more
> > > >   of an interface usable in specific scenarios and not a generic
> > > >   interface.
> > > > 
> > > 
> > > That's my point. Ugly interfaces can prove to be burden in the
> > > long term.... At least it should have x- prefix so that people
> > > know they should probably not rely on it too much.
> > > 
> > > > So question is how to arrive at better heuristics so that virtiofsd
> > > > itself determines right threhosld and user should not have to specify
> > > > the threshold. Users should probably choose between whether to
> > > > opt-in/opt-out of that new behavior.
> > > > 
> > > 
> > > I'm not even sure the user needs to know that we internally
> > > decide to process a few requests inline when a thread pool is
> > > available.
> > 
> > Currently we offer --thread-pool-size=X option. It means a thread pool
> > is created and as of now all requests are sent to thread pool.
> > 
> 
> Indeed we're doing this now but this is just an implementation detail
> IMHO. I don't think that pushing all or only some requests to the
> thread pool is relevant. I see the ---thread-pool-size=X option more
> like a way to provision the maximum number of extra threads virtiofsd
> is permitted to start in order to benefit from parallelism.

Hi Greg,

This sounds reasonable. I think easiest is to hardcode threshold
internally and if number of requests are more than threshold then
send extra requests to a thread pool (if one exists).

> 
> > Is it ok, to change that behavior (without user opting in) where upto 3
> > requests are processed inline and anything more than 3 is sent to
> > thread pool.
> > 
> 
> I think it is ok.
> 
> > Or just leave it untouched and choose new behavior as default only
> > if user did not specify --thread-pool-size.
> > 
> 
> Not passing --thread-pool-size currently means no thread pool, i.e.
> all requests are serialized. I'd rather preserve this behavior
> because it clearly indicates that the user doesn't want parallelism.

User can specify --thread-pool-size=0 if they don't want any parallelism.

Right now default is no thread pool but we should be able to change
that anytime. 

In fact, with this patch I would like to change default to say
use thread-pool of 16 and a threshold of 3 requests. So upto 3
requests everything is processed internally and anything extra
is sent to thread pool.

Not specifying --thread-pool-size just means fallback to default and
its up to virtiofsd to decide what defaults does it see best.

> 
> Also if we use a thread pool anyway in this case, what would be its
> size ?

Previously it used to be 64 by default. I think that probably is too
big. May be 16 is good enough.

Vivek

