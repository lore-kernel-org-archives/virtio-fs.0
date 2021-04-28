Date: Wed, 28 Apr 2021 09:40:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210428134025.GA1840673@redhat.com>
References: <20210423211130.GA1668472@redhat.com>
	<CAFQAk7i_u_xmBRVuDvWoN_dZDjGgHpRtZ_niCV5r86ezdYsKMQ@mail.gmail.com>
	<20210426151150.GB1724699@redhat.com> <YIb7DCBfUi0ybTYM@work-vm>
	<20210426175100.GC1741690@redhat.com> <YIb/lcwtZWZOL1/k@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIb/lcwtZWZOL1/k@work-vm>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Michey Mehta <mimehta@redhat.com>

On Mon, Apr 26, 2021 at 06:59:49PM +0100, Dr. David Alan Gilbert wrote:

[..]
> > > I can imagine something based on the % of time a thread is utilised as
> > > being an indication you might need more/less; but that's an even more
> > > complicated heuristic.
> > 
> > Yes, that's even more complicated heuristic.
> > 
> > Also not sure how to account for when thread blocks in kernel waiting for
> > I/O to finish. Thread is not keeping cpu busy but at the same time
> > can't make progress.
> 
> Does it matter if the thread is blocked due to CPU or IO?  If you can
> just look at the time the thread is non-free then that gives you a
> utilisation.

Hmm.., i guess you are right. So one way of doing this will be take
time snapshots.

t1 = gettimeofday()
thread-goes-to-sleep
thread-wakes-up
t2= gettimeofday()
thread-pops-requests
thread-processes-requests-inline
t3=gettimeofday()

So effectively t2-t1 is free time and t3-t2 is busy time. So % utilization
should be.

%util=(t3-t2) * 100/(t3-t1)

Once we swtich to thread pool, then we will also need something to go
back to inline processing. Some notion of how busy thread pool is. If
thread pool's %utilization is less then switch back to inline processing.
This bit might be more tricky because we use glib thread pool and glib
API might not provide us any of this data.

https://developer.gnome.org/glib/2.68/glib-Thread-Pools.html

I feel that heuristics based on number of requests are very simple to
implement. So may be we can implement that for now.

Thanks
Vivek

