Date: Wed, 7 Aug 2019 14:28:36 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190807132836.GD32432@stefanha-x1.localdomain>
References: <20190729213431.10821-1-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729213431.10821-1-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/2][RFC] virtio-fs: Add some tracepoints
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>

On Mon, Jul 29, 2019 at 05:34:29PM -0400, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> This patch series introduce some tracepoints. It will be
> useful to debug the I/O request flow.
> 
> New trace events:
> 
>   - virtiofs_request_dispatched
>   - virtiofs_request_done
>   - virtiofs_hiprio_request_dispatched
>   - virtiofs_hiprio_request_done
> 
> Above trace events is added to the following functions as
> the tracepoints:
> 
>   - virtio_fs_enqueue_req
>   - virtio_fs_requests_done_work
>   - virtio_fs_hiprio_dispatch_work
>   - virtio_fs_hiprio_done_work
> 
> Example of the trace record:
> 
>   cat-1420       [002] .... 34.687462: virtiofs_request_dispatched: opcode
>       FUSE_READ unique 0x1a nodeid 0x2 in.len 80 flags ISREPLY|WAITING|SENT
>       notify 1
>   kworker/4:1-67 [004] .... 34.687531: virtiofs_request_done: opcode FUSE_READ
>       unique 0x1a nodeid 0x2 in.len 80 flags ISREPLY|WAITING
> 
> Masayoshi Mizuma (2):
>   add ftrace events
>   add tracepoints
> 
>  fs/fuse/virtio_fs.c             |  21 ++++
>  include/trace/events/virtiofs.h | 195 ++++++++++++++++++++++++++++++++
>  2 files changed, 216 insertions(+)
>  create mode 100644 include/trace/events/virtiofs.h

Looks good.  Two suggestions although I don't have a strong opinion:

1. Please use "virtio_fs" instead of "virtiofs" for consistency with the
   existing kernel code.

2. Please consider adding generic fuse.ko trace events for the request
   lifecycle so both traditional FUSE and virtio-fs can benefit.  The
   argument against this is that your patches correspond more closely to
   virtqueue activity than tracepoints in the shared FUSE code, but I
   wanted to mention the idea.

