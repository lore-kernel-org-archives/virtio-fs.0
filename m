References: <20190704104650.GF1609@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D1ED564.6040705@huawei.com>
Date: Fri, 5 Jul 2019 12:43:16 +0800
MIME-Version: 1.0
In-Reply-To: <20190704104650.GF1609@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] Achieving parallelism in virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com

Hi Stefan,

>From your description, virtiofsd does the same work as SPDK, and I
wonder if we could adapt it to SPDK-vhost-fs which is widely used.

Thanks,
Jun

On 2019/7/4 18:46, Stefan Hajnoczi wrote:
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
> 
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
> 
> Stefan
> 
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
> 

