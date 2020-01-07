From: Eryu Guan <eguan@linux.alibaba.com>
Date: Tue,  7 Jan 2020 12:15:21 +0800
Message-Id: <20200107041521.75833-1-eguan@linux.alibaba.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3] virtiofsd: stop all queue threads on exit in
	virtio_loop()
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

Fix it by stopping fv_queue_thread()s before virtio_loop() returns,
to make sure there's no-one could access fuse session and virtio dev.

Reported-by: Qingming Su <qingming.su@linux.alibaba.com>
Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
---
v3:
- stopping fv_queue_thread by writing to qi->kill_fd instead of
  cancelling thread, as suggested by Stefan Hajnoczi

v2:
- cancelling fv_queue_thread before exit

v1: virtiofsd: sync FUSE_DESTROY with session destroy
https://www.redhat.com/archives/virtio-fs/2019-December/msg00051.html

 tools/virtiofsd/fuse_virtio.c | 56 +++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index b6edd88b00fd..b93faa963fa2 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -775,6 +775,31 @@ static void *fv_queue_thread(void *opaque)
     return NULL;
 }
 
+static void fv_queue_cleanup_thread(struct fv_VuDev *vud, int qidx)
+{
+    int ret;
+    struct fv_QueueInfo *ourqi;
+
+    assert(qidx < vud->nqueues);
+    ourqi = vud->qi[qidx];
+
+    /* Kill the thread */
+    if (eventfd_write(ourqi->kill_fd, 1)) {
+        fuse_log(FUSE_LOG_ERR, "Eventfd_write for queue %d: %s\n",
+	         qidx, strerror(errno));
+    }
+    ret = pthread_join(ourqi->thread, NULL);
+    if (ret) {
+        fuse_log(FUSE_LOG_ERR, "%s: Failed to join thread idx %d err %d\n",
+	         __func__, qidx, ret);
+    }
+    pthread_mutex_destroy(&ourqi->vq_lock);
+    close(ourqi->kill_fd);
+    ourqi->kick_fd = -1;
+    free(vud->qi[qidx]);
+    vud->qi[qidx] = NULL;
+}
+
 /* Callback from libvhost-user on start or stop of a queue */
 static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
 {
@@ -830,24 +855,7 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
             assert(0);
         }
     } else {
-        int ret;
-        assert(qidx < vud->nqueues);
-        ourqi = vud->qi[qidx];
-
-        /* Kill the thread */
-        if (eventfd_write(ourqi->kill_fd, 1)) {
-            fuse_log(FUSE_LOG_ERR, "Eventfd_write for queue: %m\n");
-        }
-        ret = pthread_join(ourqi->thread, NULL);
-        if (ret) {
-            fuse_log(FUSE_LOG_ERR, "%s: Failed to join thread idx %d err %d\n",
-                     __func__, qidx, ret);
-        }
-        pthread_mutex_destroy(&ourqi->vq_lock);
-        close(ourqi->kill_fd);
-        ourqi->kick_fd = -1;
-        free(vud->qi[qidx]);
-        vud->qi[qidx] = NULL;
+        fv_queue_cleanup_thread(vud, qidx);
     }
 }
 
@@ -916,6 +924,18 @@ int virtio_loop(struct fuse_session *se)
         }
     }
 
+    /*
+     * Make sure all fv_queue_thread()s quit on exit, as we're about to
+     * free virtio dev and fuse session, no one should access them anymore.
+     */
+    for (int i = 0; i < se->virtio_dev->nqueues; i++) {
+        if (!se->virtio_dev->qi[i])
+            continue;
+
+        fuse_log(FUSE_LOG_INFO, "%s: Stopping queue %d thread\n", __func__, i);
+        fv_queue_cleanup_thread(se->virtio_dev, i);
+    }
+
     fuse_log(FUSE_LOG_INFO, "%s: Exit\n", __func__);
 
     return 0;
-- 
2.14.4.44.g2045bb6


