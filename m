Date: Mon, 8 Jul 2019 16:08:22 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190708150822.GK2746@work-vm>
References: <20190704104650.GF1609@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704104650.GF1609@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] Achieving parallelism in virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> Hi,
> Here are my plans for achieving parallelism in virtiofsd.  This will
> improve performance for workloads that keep more than one request in
> flight at a time.
> 
> Today virtiofsd performance is limited because it only processes 1
> request at a time.  This can be improved in two independent ways:
> parallel request processing and multiqueue.
> 
> Parallel request processing means working on more than one request at a
> time.  A request that blocks should not prevent the next request from
> executing.  The FUSE protocol is asynchronous so it's just a question of
> adjusting virtiofsd.

Are there any ordering constraints? Or barriers etc?

> Multiqueue means providing several request virtqueues instead of just
> one.  This can be used with CPU and NUMA pinning so that request
> processing takes place on a core and NUMA node.  Better locality can
> result in higher performance.
> 
> virtiofsd needs to offer both of these features.  The model I'm
> proposing is one thread per virtqueue which distributes requests to a
> thread pool for execution.  Each virtqueue thread and its thread pool
> can be bound to a subset of CPUs.
> 
> Separate optimizations such as virtqueue polling could be added later to
> reduce latency.
> 
> I plan to use the glib thread pool, which offers the basic functionality
> that virtiofsd requires.  In the process of this work I will also audit
> and fix passthrough_ll.c's thread-safety.
> 
> Feedback is appreciated!

I think that should work; it probably needs a bit more abstraction for
some concept of a current command; 

I think currently we have that:

  fuse_req_t req
has  fuse_chan *ch
has     fv_QueueInfo *qi
has       VuVirtqElement *qe

(There's also reply_sent and elem_bad_in that relate to the current
request)

and the filesystem code just passes 'req' in to calls where it wants
to return data; with multiple threads you could have multiple
fuse_chan's and thus multiple fv_QueueInfo's; but for a thread pool
you really need to tie the qe directly to the req.

It's a bit structurally differnt from normal fuse, since they just
write on an fd, there's no concept of having to use particularly
storage to return the result of a particular request.

Perhaps the easiest thing would be to keep a hash of virtqelement's
based on the unique id in each request?

Dave

> 
> Stefan


--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

