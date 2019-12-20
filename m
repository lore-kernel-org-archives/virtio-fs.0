From: Eryu Guan <eguan@linux.alibaba.com>
Date: Fri, 20 Dec 2019 11:12:13 +0800
Message-Id: <20191220031213.119553-1-eguan@linux.alibaba.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2] virtiofsd: cancel all queue threads on exit
	in virtio_loop()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qingming.su@linux.alibaba.com

On guest graceful shutdown, virtiofsd receives VHOST_USER_GET_VRING_BASE
request from VMM and shuts down virtqueues by calling fv_set_started(),
which joins fv_queue_thread() threads. So when virtio_loop() returns,
there should be no thread is still accessing data in fuse session and/or
virtio dev.

But on abnormal exit, e.g. guest got killed for whatever reason,
vhost-user socket is closed and virtio_loop() breaks out the main loop
and returns to main(). But it's possible fv_queue_worker()s are still
working and accessing fuse session and virtio dev, which results in
crash or use-after-free.

Fix it by cancelling fv_queue_thread()s before virtio_loop() returns,
to make sure there's no-one could access fuse session and virtio dev.

Reported-by: Qingming Su <qingming.su@linux.alibaba.com>
Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
---
v1: virtiofsd: sync FUSE_DESTROY with session destroy
https://www.redhat.com/archives/virtio-fs/2019-December/msg00051.html

 tools/virtiofsd/fuse_virtio.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 254b0a71cd0b..2ae38758567e 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -671,6 +671,11 @@ out:
     free(req);
 }
 
+static void worker_cleanup(void *data)
+{
+    g_thread_pool_free((GThreadPool *)data, FALSE, TRUE);
+}
+
 /* Thread function for individual queues, created when a queue is 'started' */
 static void *fv_queue_thread(void *opaque)
 {
@@ -687,6 +692,8 @@ static void *fv_queue_thread(void *opaque)
         return NULL;
     }
 
+    pthread_cleanup_push(worker_cleanup, pool);
+
     fuse_log(FUSE_LOG_INFO, "%s: Start for queue %d kick_fd %d\n", __func__,
              qi->qidx, qi->kick_fd);
     while (1) {
@@ -770,7 +777,7 @@ static void *fv_queue_thread(void *opaque)
         pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
     }
 
-    g_thread_pool_free(pool, FALSE, TRUE);
+    pthread_cleanup_pop(1);
 
     return NULL;
 }
@@ -916,6 +923,33 @@ int virtio_loop(struct fuse_session *se)
         }
     }
 
+    /*
+     * Make sure all fv_queue_thread()s quit on exit, as we're about to
+     * free virtio dev and fuse session, no one should access them anymore.
+     */
+    for (int i = 0; i < se->virtio_dev->nqueues; i++) {
+        int ret;
+        pthread_t tid;
+
+        if (!se->virtio_dev->qi[i])
+            continue;
+
+        tid = se->virtio_dev->qi[i]->thread;
+        fuse_log(FUSE_LOG_INFO, "%s: Canceling queue %d thread (%lu)\n",
+		 __func__, i, tid);
+        ret = pthread_cancel(tid);
+        if (ret) {
+            fuse_log(FUSE_LOG_WARNING, "%s: Cancel queue %d thread: %s\n",
+                     __func__, i, strerror(ret));
+        } else {
+            ret = pthread_join(tid, NULL);
+            if (ret) {
+                fuse_log(FUSE_LOG_WARNING, "%s: Join queue %d thread: %s\n",
+                         __func__, i, strerror(ret));
+            }
+        }
+    }
+
     fuse_log(FUSE_LOG_INFO, "%s: Exit\n", __func__);
 
     return 0;
-- 
2.14.4.44.g2045bb6


