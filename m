DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references;
	bh=BTUK/VLGXMWp1MCxbbn+ZqjsLnAXmWWgx9zkvLcCxpg=;
	b=UPyT0O+FYIKlt1RxJX7cBN3jzBn645Uw8D51kgjcA49eNkg2iG4YLJ8qz/nVj670Mc
	SLRWUMxZLyUi4sYZXNLGa9qqCTEtTDr7sMishQ4lF+IWgXoe06a6sb7vNjhpnNY5ttwq
	vJsNVKv50oQoxocr1zrpyahCsmhmmUeYD+ixoJxiR0K/UwQgg/MWSTSubXH0GM175aAH
	097D7BV6VjnsLskHHyTxJfg7Tknn2L77KhLyibzZssg+IyxLhKn96vnRpsyyP98ADqCA
	/LAxcUgb5ORDKs9EzBqyJCAZoeS82BLhE4ePBo74AbA7r9sQ3EWfU4ZG8UxtJde1EMOh
	6q9w==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Mon, 29 Jul 2019 17:34:31 -0400
Message-Id: <20190729213431.10821-3-msys.mizuma@gmail.com>
In-Reply-To: <20190729213431.10821-1-msys.mizuma@gmail.com>
References: <20190729213431.10821-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH 2/2][RFC] virtio-fs: add tracepoints
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Add tracepoint to the following function. It will be useful
to debug the I/O request flow.

  - virtio_fs_enqueue_req
  - virtio_fs_requests_done_work
  - virtio_fs_hiprio_dispatch_work
  - virtio_fs_hiprio_done_work

Example of the trace record:

  cat-1420        [002] .... 34.687462: virtiofs_request_dispatched: opcode
      FUSE_READ unique 0x1a nodeid 0x2 in.len 80 flags ISREPLY|WAITING|SENT
      notify 1
  kworker/4:1-67  [004] .... 34.687531: virtiofs_request_done: opcode FUSE_READ
      unique 0x1a nodeid 0x2 in.len 80 flags ISREPLY|WAITING

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 fs/fuse/virtio_fs.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 558d090af..611da2765 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -14,6 +14,9 @@
 #include <linux/delay.h>
 #include "fuse_i.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/virtiofs.h>
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
+			trace_virtiofs_hiprio_request_done(
+				forget->ih.opcode, forget->ih.unique,
+				forget->ih.nodeid, forget->ih.len);
 			kfree(req);
 			fsvq->in_flight--;
 		}
@@ -251,6 +259,11 @@ static void virtio_fs_hiprio_dispatch_work(struct work_struct *work)
 		notify = virtqueue_kick_prepare(vq);
 		spin_unlock(&fsvq->lock);
 
+		trace_virtiofs_hiprio_request_dispatched(
+			forget->ih.opcode, forget->ih.unique,
+			forget->ih.nodeid, forget->ih.len,
+			notify);
+
 		if (notify)
 			virtqueue_notify(vq);
 		pr_debug("worker virtio_fs_hiprio_dispatch_work() dispatched one forget request.\n");
@@ -364,6 +377,10 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
 		list_del_init(&req->list);
 		spin_unlock(&fpq->lock);
 
+		trace_virtiofs_request_done(
+			req->in.h.opcode, req->in.h.unique,
+			req->in.h.nodeid, req->in.h.len, req->flags);
+
 		fuse_request_end(fc, req);
 	}
 }
@@ -914,6 +931,10 @@ static int virtio_fs_enqueue_req(struct virtqueue *vq, struct fuse_req *req)
 
 	spin_unlock(&fsvq->lock);
 
+	trace_virtiofs_request_dispatched(
+		req->in.h.opcode, req->in.h.unique,
+		req->in.h.nodeid, req->in.h.len, req->flags, notify);
+
 	if (notify)
 		virtqueue_notify(vq);
 
-- 
2.18.1

