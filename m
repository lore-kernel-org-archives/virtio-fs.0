From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 11:30:29 -0400
Message-Id: <20210930153037.1194279-6-vgoyal@redhat.com>
In-Reply-To: <20210930153037.1194279-1-vgoyal@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 05/13] virtiofsd: Add a helper to stop all queues
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

Use a helper to stop all the queues. Later in the patch series I am
planning to use this helper at one more place later in the patch series.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index fcf12db9cd..baead08b28 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -740,6 +740,18 @@ static void fv_queue_cleanup_thread(struct fv_VuDev *vud, int qidx)
     vud->qi[qidx] = NULL;
 }
 
+static void stop_all_queues(struct fv_VuDev *vud)
+{
+    for (int i = 0; i < vud->nqueues; i++) {
+        if (!vud->qi[i]) {
+            continue;
+        }
+
+        fuse_log(FUSE_LOG_INFO, "%s: Stopping queue %d thread\n", __func__, i);
+        fv_queue_cleanup_thread(vud, i);
+    }
+}
+
 /* Callback from libvhost-user on start or stop of a queue */
 static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
 {
@@ -870,15 +882,7 @@ int virtio_loop(struct fuse_session *se)
      * Make sure all fv_queue_thread()s quit on exit, as we're about to
      * free virtio dev and fuse session, no one should access them anymore.
      */
-    for (int i = 0; i < se->virtio_dev->nqueues; i++) {
-        if (!se->virtio_dev->qi[i]) {
-            continue;
-        }
-
-        fuse_log(FUSE_LOG_INFO, "%s: Stopping queue %d thread\n", __func__, i);
-        fv_queue_cleanup_thread(se->virtio_dev, i);
-    }
-
+    stop_all_queues(se->virtio_dev);
     fuse_log(FUSE_LOG_INFO, "%s: Exit\n", __func__);
 
     return 0;
-- 
2.31.1

