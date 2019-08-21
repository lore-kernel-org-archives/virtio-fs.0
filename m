DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references;
	bh=IUWeGub1/eD07NC3el/NuPWrCbEc7ymBNNKQAxobRKk=;
	b=ZUtut8jlYeN/0D9MozDEmR0eh38M2dyukZ+v5Eoc6jqkVPxhkHznL1CLQQrARWQuHv
	Co5zarQZBMyldJJgpYOd2y8JHeQMCCFCtYcwiTb53Ho1FITQIw+AV/P5qpq8CjAks+ON
	dDw3ubLqnFEmPsrjiVsb4mPBuCjzJBesezPF8kFRB+bX5EAiLL3UC6AS6IqTSzTGLl/f
	4yQ+QGaDfxLePNewqXZc49LrGiwznz8VKSUNIx7dHeNfIUWa063TxGNbZtgXqgJrudsq
	mRrG2e0MqjPOD8wM9YtFwGt0ZuJ58/5nk+ZWmfPmKOgGk3lgBOI7vxZIdqjCca73kRld
	wu2A==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Wed, 21 Aug 2019 00:40:14 -0400
Message-Id: <20190821044014.26369-4-msys.mizuma@gmail.com>
In-Reply-To: <20190821044014.26369-1-msys.mizuma@gmail.com>
References: <20190821044014.26369-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH v2 3/3] virtio-fs: add tracepoints
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

Add tracepoint to the following function. It will be useful
to debug the I/O request flow.

  - virtio_fs_enqueue_req
  - virtio_fs_requests_done_work
  - virtio_fs_hiprio_dispatch_work
  - virtio_fs_hiprio_done_work

Example of the trace record:

  cat-4491         [006] .... 72.414799: virtio_fs_request_dispatched:
      opcode FUSE_READ unique 0x13b30 nodeid 0x2 in.len 80 flags
      ISREPLY|WAITING|SENT notify 1
  kworker/0:12-448 [000] .... 72.414807: virtio_fs_request_done:
      opcode FUSE_READ unique 0x13b30 nodeid 0x2 in.len 80 flags
      ISREPLY|WAITING

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 fs/fuse/virtio_fs.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 558d090af..83055d22a 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -14,6 +14,9 @@
 #include <linux/delay.h>
 #include "fuse_i.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/virtio_fs.h>
+
 /* List of virtio-fs device instances and a lock for the list */
 static DEFINE_MUTEX(virtio_fs_mutex);
 static LIST_HEAD(virtio_fs_instances);
@@ -175,6 +178,7 @@ static void virtio_fs_hiprio_done_work(struct work_struct *work)
 	struct virtio_fs_vq *fsvq = container_of(work, struct virtio_fs_vq,
 						 done_work);
 	struct virtqueue *vq = fsvq->vq;
+	struct virtio_fs_forget *forget;
 
 	/* Free completed FUSE_FORGET requests */
 	spin_lock(&fsvq->lock);
@@ -185,6 +189,10 @@ static void virtio_fs_hiprio_done_work(struct work_struct *work)
 		virtqueue_disable_cb(vq);
 
 		while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
+			forget = (struct virtio_fs_forget *)req;
+			trace_virtio_fs_hiprio_request_done(
+				forget->ih.opcode, forget->ih.unique,
+				forget->ih.nodeid, forget->ih.len);
 			kfree(req);
 			fsvq->in_flight--;
 		}
@@ -249,6 +257,12 @@ static void virtio_fs_hiprio_dispatch_work(struct work_struct *work)
 
 		fsvq->in_flight++;
 		notify = virtqueue_kick_prepare(vq);
+
+		trace_virtio_fs_hiprio_request_dispatched(
+			forget->ih.opcode, forget->ih.unique,
+			forget->ih.nodeid, forget->ih.len,
+			notify);
+
 		spin_unlock(&fsvq->lock);
 
 		if (notify)
@@ -362,6 +376,11 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
 		spin_lock(&fpq->lock);
 		clear_bit(FR_SENT, &req->flags);
 		list_del_init(&req->list);
+
+		trace_virtio_fs_request_done(
+			req->in.h.opcode, req->in.h.unique,
+			req->in.h.nodeid, req->in.h.len, req->flags);
+
 		spin_unlock(&fpq->lock);
 
 		fuse_request_end(fc, req);
@@ -912,6 +931,10 @@ static int virtio_fs_enqueue_req(struct virtqueue *vq, struct fuse_req *req)
 
 	notify = virtqueue_kick_prepare(vq);
 
+	trace_virtio_fs_request_dispatched(
+		req->in.h.opcode, req->in.h.unique,
+		req->in.h.nodeid, req->in.h.len, req->flags, notify);
+
 	spin_unlock(&fsvq->lock);
 
 	if (notify)
-- 
2.18.1

