DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references;
	bh=6ZDbgt0aiufZ2ucol2DP084JcZRJU08Z8gN0UKFjfjU=;
	b=PMOgsKWM2H8jvLgzMSDBerdm8NDpRFe3FGvQJQJK+IjSUFPqpeCIPwiDn2B1jP2e89
	tfuZilSpmG4RKM8n2bUroi/qSOa+R5C5SVMZbpWdwmoCf0G+S/7LTthfP1XgWA7XpV/4
	dKWPhHIBSTDuLbUeu2DuoOhhmjPEd2b5w4WrxzgbGt94XV1QJrkTLuo/oeHD+U3SgFUp
	A65+huNi28d1imqFPWYv5itThvGQCOxsiyUZLK9co0O+jNdGjhqDIY1sbelLAn9pQqxP
	K3k5Ml3rUMk3fQ8Zt/JxI/CP4z11RWj6esmUyHVf0BBiGq3L7N8dsa7xtTFLsWc+e+rA
	b/gQ==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Mon, 12 Aug 2019 17:04:54 -0400
Message-Id: <20190812210455.12540-3-msys.mizuma@gmail.com>
In-Reply-To: <20190812210455.12540-1-msys.mizuma@gmail.com>
References: <20190812210455.12540-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH 2/3] virtio-fs: add ftrace events
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Introduce the following ftrace events.

  - virtio_fs_request_dispatched
  - virtio_fs_request_done
  - virtio_fs_hiprio_request_dispatched
  - virtio_fs_hiprio_request_done

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 include/trace/events/virtio_fs.h | 131 +++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100644 include/trace/events/virtio_fs.h

diff --git a/include/trace/events/virtio_fs.h b/include/trace/events/virtio_fs.h
new file mode 100644
index 000000000..84ccfa7eb
--- /dev/null
+++ b/include/trace/events/virtio_fs.h
@@ -0,0 +1,131 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM virtio_fs
+
+#if !defined(_TRACE_VIRTIO_FS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VIRTIO_FS_H
+
+#include <linux/tracepoint.h>
+#include <trace/events/fuse_common.h>
+
+TRACE_EVENT(virtio_fs_request_dispatched,
+
+	TP_PROTO(uint32_t opcode, uint64_t unique, uint64_t nodeid,
+		uint32_t inlen, unsigned long flags, bool notify),
+
+	TP_ARGS(opcode, unique, nodeid, inlen, flags, notify),
+
+	TP_STRUCT__entry(
+		__field(uint32_t,	opcode)
+		__field(uint64_t,	unique)
+		__field(uint64_t,	nodeid)
+		__field(uint32_t,	inlen)
+		__field(unsigned long,	flags)
+		__field(bool,		notify)
+	),
+
+	TP_fast_assign(
+		__entry->opcode	=	opcode;
+		__entry->unique	=	unique;
+		__entry->nodeid	=	nodeid;
+		__entry->inlen	=	inlen;
+		__entry->flags	=	flags;
+		__entry->notify	=	notify;
+	),
+
+	TP_printk("opcode %s unique %#llx nodeid %#llx in.len %u flags %s notify %d\n",
+			show_opcode_name(__entry->opcode),
+			__entry->unique, __entry->nodeid,
+			__entry->inlen, show_req_flag(__entry->flags),
+			__entry->notify)
+);
+
+TRACE_EVENT(virtio_fs_request_done,
+
+	TP_PROTO(uint32_t opcode, uint64_t unique, uint64_t nodeid,
+		uint32_t inlen, unsigned long flags),
+
+	TP_ARGS(opcode, unique, nodeid, inlen, flags),
+
+	TP_STRUCT__entry(
+		__field(uint32_t,	opcode)
+		__field(uint64_t,	unique)
+		__field(uint64_t,	nodeid)
+		__field(uint32_t,	inlen)
+		__field(unsigned long,	flags)
+	),
+
+	TP_fast_assign(
+		__entry->opcode	=	opcode;
+		__entry->unique	=	unique;
+		__entry->nodeid	=	nodeid;
+		__entry->inlen	=	inlen;
+		__entry->flags	=	flags;
+	),
+
+	TP_printk("opcode %s unique %#llx nodeid %#llx in.len %u flags %s\n",
+			show_opcode_name(__entry->opcode),
+			__entry->unique, __entry->nodeid,
+			__entry->inlen, show_req_flag(__entry->flags))
+);
+
+TRACE_EVENT(virtio_fs_hiprio_request_dispatched,
+
+	TP_PROTO(uint32_t opcode, uint64_t unique, uint64_t nodeid,
+		uint32_t inlen, bool notify),
+
+	TP_ARGS(opcode, unique, nodeid, inlen, notify),
+
+	TP_STRUCT__entry(
+		__field(uint32_t,	opcode)
+		__field(uint64_t,	unique)
+		__field(uint64_t,	nodeid)
+		__field(uint32_t,	inlen)
+		__field(bool,		notify)
+	),
+
+	TP_fast_assign(
+		__entry->opcode	=	opcode;
+		__entry->unique	=	unique;
+		__entry->nodeid	=	nodeid;
+		__entry->inlen	=	inlen;
+		__entry->notify	=	notify;
+	),
+
+	TP_printk("opcode %s unique %#llx nodeid %#llx in.len %u notify %d\n",
+			show_opcode_name(__entry->opcode),
+			__entry->unique, __entry->nodeid,
+			__entry->inlen,  __entry->notify)
+);
+
+TRACE_EVENT(virtio_fs_hiprio_request_done,
+
+	TP_PROTO(uint32_t opcode, uint64_t unique, uint64_t nodeid,
+		uint32_t inlen),
+
+	TP_ARGS(opcode, unique, nodeid, inlen),
+
+	TP_STRUCT__entry(
+		__field(uint32_t,	opcode)
+		__field(uint64_t,	unique)
+		__field(uint64_t,	nodeid)
+		__field(uint32_t,	inlen)
+	),
+
+	TP_fast_assign(
+		__entry->opcode	=	opcode;
+		__entry->unique	=	unique;
+		__entry->nodeid	=	nodeid;
+		__entry->inlen	=	inlen;
+	),
+
+	TP_printk("opcode %s unique %#llx nodeid %#llx in.len %u\n",
+			show_opcode_name(__entry->opcode),
+			__entry->unique, __entry->nodeid,
+			__entry->inlen)
+);
+
+#endif /* _TRACE_VIRTIO_FS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.18.1

