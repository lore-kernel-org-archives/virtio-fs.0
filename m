Date: Wed, 7 Aug 2019 09:23:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190807132320.GB18557@redhat.com>
References: <20190729213431.10821-1-msys.mizuma@gmail.com>
	<20190729213431.10821-2-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729213431.10821-2-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH 1/2][RFC] virtio-fs: add ftrace events
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

On Mon, Jul 29, 2019 at 05:34:30PM -0400, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> Introduce the following ftrace events. 
> 
>   - virtiofs_request_dispatched
>   - virtiofs_request_done
>   - virtiofs_hiprio_request_dispatched
>   - virtiofs_hiprio_request_done
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  include/trace/events/virtiofs.h | 195 ++++++++++++++++++++++++++++++++
>  1 file changed, 195 insertions(+)
>  create mode 100644 include/trace/events/virtiofs.h

Hi Masayoshi,


How about naming this file vitio_fs.h (instead of virtiofs.h). We name
it fs/fuse/virtio_fs.c in fuse code as well.

Can we easily change trace points later? Or there is resistance to 
changing static trace points upstream once introdced.

I can carry tracepoints in devel branch so that its easy to debug
issues. When it comes to sending tracepoints upstream, may be it
is a good idea to first upstream core code and then send tracepoints
in a separate patch series later.

Thanks
Vivek

> 
> diff --git a/include/trace/events/virtiofs.h b/include/trace/events/virtiofs.h
> new file mode 100644
> index 000000000..50269d7de
> --- /dev/null
> +++ b/include/trace/events/virtiofs.h
> @@ -0,0 +1,195 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM virtiofs
> +
> +#if !defined(_TRACE_VIRTIOFS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_VIRTIOFS_H
> +
> +#include <linux/tracepoint.h>
> +#include <uapi/linux/fuse.h>
> +
> +#define fuse_opcode_name(opcode)	{ opcode, #opcode }
> +#define show_opcode_name(val)				\
> +	__print_symbolic(val,				\
> +		fuse_opcode_name(FUSE_LOOKUP),		\
> +		fuse_opcode_name(FUSE_FORGET),		\
> +		fuse_opcode_name(FUSE_GETATTR),		\
> +		fuse_opcode_name(FUSE_SETATTR),		\
> +		fuse_opcode_name(FUSE_READLINK),	\
> +		fuse_opcode_name(FUSE_SYMLINK),		\
> +		fuse_opcode_name(FUSE_MKNOD),		\
> +		fuse_opcode_name(FUSE_MKDIR),		\
> +		fuse_opcode_name(FUSE_UNLINK),		\
> +		fuse_opcode_name(FUSE_RMDIR),		\
> +		fuse_opcode_name(FUSE_RENAME),		\
> +		fuse_opcode_name(FUSE_LINK),		\
> +		fuse_opcode_name(FUSE_OPEN),		\
> +		fuse_opcode_name(FUSE_READ),		\
> +		fuse_opcode_name(FUSE_WRITE),		\
> +		fuse_opcode_name(FUSE_STATFS),		\
> +		fuse_opcode_name(FUSE_RELEASE),		\
> +		fuse_opcode_name(FUSE_FSYNC),		\
> +		fuse_opcode_name(FUSE_SETXATTR),	\
> +		fuse_opcode_name(FUSE_GETXATTR),	\
> +		fuse_opcode_name(FUSE_LISTXATTR),	\
> +		fuse_opcode_name(FUSE_REMOVEXATTR),	\
> +		fuse_opcode_name(FUSE_FLUSH),		\
> +		fuse_opcode_name(FUSE_INIT),		\
> +		fuse_opcode_name(FUSE_OPENDIR),		\
> +		fuse_opcode_name(FUSE_READDIR),		\
> +		fuse_opcode_name(FUSE_RELEASEDIR),	\
> +		fuse_opcode_name(FUSE_FSYNCDIR),	\
> +		fuse_opcode_name(FUSE_GETLK),		\
> +		fuse_opcode_name(FUSE_SETLK),		\
> +		fuse_opcode_name(FUSE_SETLKW),		\
> +		fuse_opcode_name(FUSE_ACCESS),		\
> +		fuse_opcode_name(FUSE_CREATE),		\
> +		fuse_opcode_name(FUSE_INTERRUPT),	\
> +		fuse_opcode_name(FUSE_BMAP),		\
> +		fuse_opcode_name(FUSE_DESTROY),		\
> +		fuse_opcode_name(FUSE_IOCTL),		\
> +		fuse_opcode_name(FUSE_POLL),		\
> +		fuse_opcode_name(FUSE_NOTIFY_REPLY),	\
> +		fuse_opcode_name(FUSE_BATCH_FORGET),	\
> +		fuse_opcode_name(FUSE_FALLOCATE),	\
> +		fuse_opcode_name(FUSE_READDIRPLUS),	\
> +		fuse_opcode_name(FUSE_RENAME2),		\
> +		fuse_opcode_name(FUSE_LSEEK),		\
> +		fuse_opcode_name(FUSE_COPY_FILE_RANGE),	\
> +		fuse_opcode_name(FUSE_SETUPMAPPING),	\
> +		fuse_opcode_name(FUSE_REMOVEMAPPING))
> +
> +#define show_req_flag(flags) __print_flags(flags, "|",	\
> +	{ (1UL << FR_ISREPLY),		"ISREPLY"},	\
> +	{ (1UL << FR_FORCE),		"FORCE"},	\
> +	{ (1UL << FR_BACKGROUND),	"BACKGROUND"},	\
> +	{ (1UL << FR_WAITING),		"WAITING"},	\
> +	{ (1UL << FR_ABORTED),		"ABORTED"},	\
> +	{ (1UL << FR_INTERRUPTED),	"INTERRUPTED"},	\
> +	{ (1UL << FR_LOCKED),		"LOCKED"},	\
> +	{ (1UL << FR_PENDING),		"PENDING"},	\
> +	{ (1UL << FR_SENT),		"SENT"},	\
> +	{ (1UL << FR_FINISHED),		"FINISHED"},	\
> +	{ (1UL << FR_PRIVATE),		"PRIVATE"})
> +
> +TRACE_EVENT(virtiofs_request_dispatched,
> +
> +	TP_PROTO(uint32_t opcode, uint64_t unique, uint64_t nodeid,
> +		uint32_t inlen, unsigned long flags, bool notify),
> +
> +	TP_ARGS(opcode, unique, nodeid, inlen, flags, notify),
> +
> +	TP_STRUCT__entry(
> +		__field(uint32_t,	opcode)
> +		__field(uint64_t,	unique)
> +		__field(uint64_t,	nodeid)
> +		__field(uint32_t,	inlen)
> +		__field(unsigned long,	flags)
> +		__field(bool,		notify)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->opcode	=	opcode;
> +		__entry->unique	=	unique;
> +		__entry->nodeid	=	nodeid;
> +		__entry->inlen	=	inlen;
> +		__entry->flags	=	flags;
> +		__entry->notify	=	notify;
> +	),
> +
> +	TP_printk("opcode %s unique %#llx nodeid %#llx in.len %u flags %s notify %d\n",
> +			show_opcode_name(__entry->opcode),
> +			__entry->unique, __entry->nodeid,
> +			__entry->inlen, show_req_flag(__entry->flags),
> +			__entry->notify)
> +);
> +
> +TRACE_EVENT(virtiofs_request_done,
> +
> +	TP_PROTO(uint32_t opcode, uint64_t unique, uint64_t nodeid,
> +		uint32_t inlen, unsigned long flags),
> +
> +	TP_ARGS(opcode, unique, nodeid, inlen, flags),
> +
> +	TP_STRUCT__entry(
> +		__field(uint32_t,	opcode)
> +		__field(uint64_t,	unique)
> +		__field(uint64_t,	nodeid)
> +		__field(uint32_t,	inlen)
> +		__field(unsigned long,	flags)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->opcode	=	opcode;
> +		__entry->unique	=	unique;
> +		__entry->nodeid	=	nodeid;
> +		__entry->inlen	=	inlen;
> +		__entry->flags	=	flags;
> +	),
> +
> +	TP_printk("opcode %s unique %#llx nodeid %#llx in.len %u flags %s\n",
> +			show_opcode_name(__entry->opcode),
> +			__entry->unique, __entry->nodeid,
> +			__entry->inlen, show_req_flag(__entry->flags))
> +);
> +
> +TRACE_EVENT(virtiofs_hiprio_request_dispatched,
> +
> +	TP_PROTO(uint32_t opcode, uint64_t unique, uint64_t nodeid,
> +		uint32_t inlen, bool notify),
> +
> +	TP_ARGS(opcode, unique, nodeid, inlen, notify),
> +
> +	TP_STRUCT__entry(
> +		__field(uint32_t,	opcode)
> +		__field(uint64_t,	unique)
> +		__field(uint64_t,	nodeid)
> +		__field(uint32_t,	inlen)
> +		__field(bool,		notify)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->opcode	=	opcode;
> +		__entry->unique	=	unique;
> +		__entry->nodeid	=	nodeid;
> +		__entry->inlen	=	inlen;
> +		__entry->notify	=	notify;
> +	),
> +
> +	TP_printk("opcode %s unique %#llx nodeid %#llx in.len %u notify %d\n",
> +			show_opcode_name(__entry->opcode),
> +			__entry->unique, __entry->nodeid,
> +			__entry->inlen,  __entry->notify)
> +);
> +
> +TRACE_EVENT(virtiofs_hiprio_request_done,
> +
> +	TP_PROTO(uint32_t opcode, uint64_t unique, uint64_t nodeid,
> +		uint32_t inlen),
> +
> +	TP_ARGS(opcode, unique, nodeid, inlen),
> +
> +	TP_STRUCT__entry(
> +		__field(uint32_t,	opcode)
> +		__field(uint64_t,	unique)
> +		__field(uint64_t,	nodeid)
> +		__field(uint32_t,	inlen)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->opcode	=	opcode;
> +		__entry->unique	=	unique;
> +		__entry->nodeid	=	nodeid;
> +		__entry->inlen	=	inlen;
> +	),
> +
> +	TP_printk("opcode %s unique %#llx nodeid %#llx in.len %u\n",
> +			show_opcode_name(__entry->opcode),
> +			__entry->unique, __entry->nodeid,
> +			__entry->inlen)
> +);
> +
> +#endif /* _TRACE_VIRTIOFS_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> -- 
> 2.18.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

