From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue, 16 Feb 2021 18:37:30 +0000
Message-Id: <20210216183734.57810-3-dgilbert@redhat.com>
In-Reply-To: <20210216183734.57810-1-dgilbert@redhat.com>
References: <20210216183734.57810-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 2/6] virtiofsd: vu_dispatch locking should never
	fail
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, wainersm@redhat.com, groug@kaod.org, philmd@redhat.com, vgoyal@redhat.com
Cc: virtio-fs@redhat.com

From: Greg Kurz <groug@kaod.org>

pthread_rwlock_rdlock() and pthread_rwlock_wrlock() can fail if a
deadlock condition is detected or the current thread already owns
the lock. They can also fail, like pthread_rwlock_unlock(), if the
mutex wasn't properly initialized. None of these are ever expected
to happen with fv_VuDev::vu_dispatch_rwlock.

Some users already check the return value and assert, some others
don't. Introduce rdlock/wrlock/unlock wrappers that just do the
former and use them everywhere for improved consistency and
robustness.

This is just cleanup. It doesn't fix any actual issue.

Signed-off-by: Greg Kurz <groug@kaod.org>
Message-Id: <20210203182434.93870-1-groug@kaod.org>
Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 49 +++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index ddcefee427..523ee64fb7 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -187,6 +187,31 @@ static void copy_iov(struct iovec *src_iov, int src_count,
     }
 }
 
+/*
+ * pthread_rwlock_rdlock() and pthread_rwlock_wrlock can fail if
+ * a deadlock condition is detected or the current thread already
+ * owns the lock. They can also fail, like pthread_rwlock_unlock(),
+ * if the mutex wasn't properly initialized. None of these are ever
+ * expected to happen.
+ */
+static void vu_dispatch_rdlock(struct fv_VuDev *vud)
+{
+    int ret = pthread_rwlock_rdlock(&vud->vu_dispatch_rwlock);
+    assert(ret == 0);
+}
+
+static void vu_dispatch_wrlock(struct fv_VuDev *vud)
+{
+    int ret = pthread_rwlock_wrlock(&vud->vu_dispatch_rwlock);
+    assert(ret == 0);
+}
+
+static void vu_dispatch_unlock(struct fv_VuDev *vud)
+{
+    int ret = pthread_rwlock_unlock(&vud->vu_dispatch_rwlock);
+    assert(ret == 0);
+}
+
 /*
  * Called back by ll whenever it wants to send a reply/message back
  * The 1st element of the iov starts with the fuse_out_header
@@ -240,12 +265,12 @@ int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
 
     copy_iov(iov, count, in_sg, in_num, tosend_len);
 
-    pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
+    vu_dispatch_rdlock(qi->virtio_dev);
     pthread_mutex_lock(&qi->vq_lock);
     vu_queue_push(dev, q, elem, tosend_len);
     vu_queue_notify(dev, q);
     pthread_mutex_unlock(&qi->vq_lock);
-    pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
+    vu_dispatch_unlock(qi->virtio_dev);
 
     req->reply_sent = true;
 
@@ -403,12 +428,12 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
 
     ret = 0;
 
-    pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
+    vu_dispatch_rdlock(qi->virtio_dev);
     pthread_mutex_lock(&qi->vq_lock);
     vu_queue_push(dev, q, elem, tosend_len);
     vu_queue_notify(dev, q);
     pthread_mutex_unlock(&qi->vq_lock);
-    pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
+    vu_dispatch_unlock(qi->virtio_dev);
 
 err:
     if (ret == 0) {
@@ -558,12 +583,12 @@ out:
         fuse_log(FUSE_LOG_DEBUG, "%s: elem %d no reply sent\n", __func__,
                  elem->index);
 
-        pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
+        vu_dispatch_rdlock(qi->virtio_dev);
         pthread_mutex_lock(&qi->vq_lock);
         vu_queue_push(dev, q, elem, 0);
         vu_queue_notify(dev, q);
         pthread_mutex_unlock(&qi->vq_lock);
-        pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
+        vu_dispatch_unlock(qi->virtio_dev);
     }
 
     pthread_mutex_destroy(&req->ch.lock);
@@ -596,7 +621,6 @@ static void *fv_queue_thread(void *opaque)
              qi->qidx, qi->kick_fd);
     while (1) {
         struct pollfd pf[2];
-        int ret;
 
         pf[0].fd = qi->kick_fd;
         pf[0].events = POLLIN;
@@ -645,8 +669,7 @@ static void *fv_queue_thread(void *opaque)
             break;
         }
         /* Mutual exclusion with virtio_loop() */
-        ret = pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
-        assert(ret == 0); /* there is no possible error case */
+        vu_dispatch_rdlock(qi->virtio_dev);
         pthread_mutex_lock(&qi->vq_lock);
         /* out is from guest, in is too guest */
         unsigned int in_bytes, out_bytes;
@@ -672,7 +695,7 @@ static void *fv_queue_thread(void *opaque)
         }
 
         pthread_mutex_unlock(&qi->vq_lock);
-        pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
+        vu_dispatch_unlock(qi->virtio_dev);
 
         /* Process all the requests. */
         if (!se->thread_pool_size && req_list != NULL) {
@@ -799,7 +822,6 @@ int virtio_loop(struct fuse_session *se)
     while (!fuse_session_exited(se)) {
         struct pollfd pf[1];
         bool ok;
-        int ret;
         pf[0].fd = se->vu_socketfd;
         pf[0].events = POLLIN;
         pf[0].revents = 0;
@@ -825,12 +847,11 @@ int virtio_loop(struct fuse_session *se)
         assert(pf[0].revents & POLLIN);
         fuse_log(FUSE_LOG_DEBUG, "%s: Got VU event\n", __func__);
         /* Mutual exclusion with fv_queue_thread() */
-        ret = pthread_rwlock_wrlock(&se->virtio_dev->vu_dispatch_rwlock);
-        assert(ret == 0); /* there is no possible error case */
+        vu_dispatch_wrlock(se->virtio_dev);
 
         ok = vu_dispatch(&se->virtio_dev->dev);
 
-        pthread_rwlock_unlock(&se->virtio_dev->vu_dispatch_rwlock);
+        vu_dispatch_unlock(se->virtio_dev);
 
         if (!ok) {
             fuse_log(FUSE_LOG_ERR, "%s: vu_dispatch failed\n", __func__);
-- 
2.29.2

