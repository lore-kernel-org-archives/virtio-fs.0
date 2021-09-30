From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 11:30:28 -0400
Message-Id: <20210930153037.1194279-5-vgoyal@redhat.com>
In-Reply-To: <20210930153037.1194279-1-vgoyal@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 04/13] virtiofsd: Add a helper to send element
	on virtqueue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu

We have open coded logic to take locks and push element on virtqueue at
three places. Add a helper and use it everywhere. Code is easier to read and
less number of lines of code.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 45 ++++++++++++++---------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index da7b6a76bf..fcf12db9cd 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -243,6 +243,21 @@ static void vu_dispatch_unlock(struct fv_VuDev *vud)
     assert(ret == 0);
 }
 
+static void vq_send_element(struct fv_QueueInfo *qi, VuVirtqElement *elem,
+                            ssize_t len)
+{
+    struct fuse_session *se = qi->virtio_dev->se;
+    VuDev *dev = &se->virtio_dev->dev;
+    VuVirtq *q = vu_get_queue(dev, qi->qidx);
+
+    vu_dispatch_rdlock(qi->virtio_dev);
+    pthread_mutex_lock(&qi->vq_lock);
+    vu_queue_push(dev, q, elem, len);
+    vu_queue_notify(dev, q);
+    pthread_mutex_unlock(&qi->vq_lock);
+    vu_dispatch_unlock(qi->virtio_dev);
+}
+
 /*
  * Called back by ll whenever it wants to send a reply/message back
  * The 1st element of the iov starts with the fuse_out_header
@@ -253,8 +268,6 @@ int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
 {
     FVRequest *req = container_of(ch, FVRequest, ch);
     struct fv_QueueInfo *qi = ch->qi;
-    VuDev *dev = &se->virtio_dev->dev;
-    VuVirtq *q = vu_get_queue(dev, qi->qidx);
     VuVirtqElement *elem = &req->elem;
     int ret = 0;
 
@@ -296,13 +309,7 @@ int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
 
     copy_iov(iov, count, in_sg, in_num, tosend_len);
 
-    vu_dispatch_rdlock(qi->virtio_dev);
-    pthread_mutex_lock(&qi->vq_lock);
-    vu_queue_push(dev, q, elem, tosend_len);
-    vu_queue_notify(dev, q);
-    pthread_mutex_unlock(&qi->vq_lock);
-    vu_dispatch_unlock(qi->virtio_dev);
-
+    vq_send_element(qi, elem, tosend_len);
     req->reply_sent = true;
 
 err:
@@ -321,8 +328,6 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
 {
     FVRequest *req = container_of(ch, FVRequest, ch);
     struct fv_QueueInfo *qi = ch->qi;
-    VuDev *dev = &se->virtio_dev->dev;
-    VuVirtq *q = vu_get_queue(dev, qi->qidx);
     VuVirtqElement *elem = &req->elem;
     int ret = 0;
     g_autofree struct iovec *in_sg_cpy = NULL;
@@ -430,12 +435,7 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
         out_sg->len = tosend_len;
     }
 
-    vu_dispatch_rdlock(qi->virtio_dev);
-    pthread_mutex_lock(&qi->vq_lock);
-    vu_queue_push(dev, q, elem, tosend_len);
-    vu_queue_notify(dev, q);
-    pthread_mutex_unlock(&qi->vq_lock);
-    vu_dispatch_unlock(qi->virtio_dev);
+    vq_send_element(qi, elem, tosend_len);
     req->reply_sent = true;
     return 0;
 }
@@ -447,7 +447,6 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
 {
     struct fv_QueueInfo *qi = user_data;
     struct fuse_session *se = qi->virtio_dev->se;
-    struct VuDev *dev = &qi->virtio_dev->dev;
     FVRequest *req = data;
     VuVirtqElement *elem = &req->elem;
     struct fuse_buf fbuf = {};
@@ -589,17 +588,9 @@ out:
 
     /* If the request has no reply, still recycle the virtqueue element */
     if (!req->reply_sent) {
-        struct VuVirtq *q = vu_get_queue(dev, qi->qidx);
-
         fuse_log(FUSE_LOG_DEBUG, "%s: elem %d no reply sent\n", __func__,
                  elem->index);
-
-        vu_dispatch_rdlock(qi->virtio_dev);
-        pthread_mutex_lock(&qi->vq_lock);
-        vu_queue_push(dev, q, elem, 0);
-        vu_queue_notify(dev, q);
-        pthread_mutex_unlock(&qi->vq_lock);
-        vu_dispatch_unlock(qi->virtio_dev);
+        vq_send_element(qi, elem, 0);
     }
 
     pthread_mutex_destroy(&req->ch.lock);
-- 
2.31.1

