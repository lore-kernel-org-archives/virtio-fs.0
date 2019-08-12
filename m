DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=IkrbhFPcSnPtvS5/vf2c0eVumWCFB+tfToMfYL0Dg2E=;
	b=mq6fq5QknTVFJf/KljuIiU6zL00IJZyr/JRZy6CWy5b7YyeY4pLaKQc2UFrBbO6OmR
	mJdubkU0zFiY6sRllYieympJi4uxdZL+4FyLPuhmgoIHAy0Z+XWnNfPUj+ReRvXH7ceg
	HKhOn/cPt6JW3P2WqHmOzxjWYipEARO8/Iz//bPYnmqbWUN4/VghhIMrVJAuKrltzQ6n
	NpQb5CK9Oug9bSkSUqFkx7RWR5NOYSotkUfNWDnePXDOS1/VI5xXQKOIxugzt/W71Z7q
	sNXcHoHbFRmKb84lZK5wNwQ3lD5t8iTrbhEzlX/RkNXDYE6t40Ys3oeHx1xWpMqXQLw1
	r61Q==
Date: Mon, 12 Aug 2019 14:50:41 -0400
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20190812185040.dggjt3ou4524yn7z@gabell>
References: <20190729213431.10821-1-msys.mizuma@gmail.com>
	<20190807132836.GD32432@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807132836.GD32432@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 0/2][RFC] virtio-fs: Add some tracepoints
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>

Hi Stefan,

On Wed, Aug 07, 2019 at 02:28:36PM +0100, Stefan Hajnoczi wrote:
> On Mon, Jul 29, 2019 at 05:34:29PM -0400, Masayoshi Mizuma wrote:
> > From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > 
> > This patch series introduce some tracepoints. It will be
> > useful to debug the I/O request flow.
> > 
> > New trace events:
> > 
> >   - virtiofs_request_dispatched
> >   - virtiofs_request_done
> >   - virtiofs_hiprio_request_dispatched
> >   - virtiofs_hiprio_request_done
> > 
> > Above trace events is added to the following functions as
> > the tracepoints:
> > 
> >   - virtio_fs_enqueue_req
> >   - virtio_fs_requests_done_work
> >   - virtio_fs_hiprio_dispatch_work
> >   - virtio_fs_hiprio_done_work
> > 
> > Example of the trace record:
> > 
> >   cat-1420       [002] .... 34.687462: virtiofs_request_dispatched: opcode
> >       FUSE_READ unique 0x1a nodeid 0x2 in.len 80 flags ISREPLY|WAITING|SENT
> >       notify 1
> >   kworker/4:1-67 [004] .... 34.687531: virtiofs_request_done: opcode FUSE_READ
> >       unique 0x1a nodeid 0x2 in.len 80 flags ISREPLY|WAITING
> > 
> > Masayoshi Mizuma (2):
> >   add ftrace events
> >   add tracepoints
> > 
> >  fs/fuse/virtio_fs.c             |  21 ++++
> >  include/trace/events/virtiofs.h | 195 ++++++++++++++++++++++++++++++++
> >  2 files changed, 216 insertions(+)
> >  create mode 100644 include/trace/events/virtiofs.h
> 
> Looks good.  Two suggestions although I don't have a strong opinion:
> 
> 1. Please use "virtio_fs" instead of "virtiofs" for consistency with the
>    existing kernel code.

OK, I use virtio_fs.

> 
> 2. Please consider adding generic fuse.ko trace events for the request
>    lifecycle so both traditional FUSE and virtio-fs can benefit.  The
>    argument against this is that your patches correspond more closely to
>    virtqueue activity than tracepoints in the shared FUSE code, but I
>    wanted to mention the idea.

Yeah, it's a good idea to add generic fuse.ko trace events.

Thanks!
Masa

