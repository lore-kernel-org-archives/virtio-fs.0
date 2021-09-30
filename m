From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 11:30:36 -0400
Message-Id: <20210930153037.1194279-13-vgoyal@redhat.com>
In-Reply-To: <20210930153037.1194279-1-vgoyal@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 12/13] virtiofsd: Implement blocking posix locks
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

As of now we don't support fcntl(F_SETLKW) and if we see one, we return
-EOPNOTSUPP.

Change that by accepting these requests and returning a reply
immediately asking caller to wait. Once lock is available, send a
notification to the waiter indicating lock is available.

In response to lock request, we are returning error value as "1", which
signals to client to queue the lock request internally and later client
will get a notification which will signal lock is taken (or error). And
then fuse client should wake up the guest process.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c  | 37 ++++++++++++++++-
 tools/virtiofsd/fuse_lowlevel.h  | 26 ++++++++++++
 tools/virtiofsd/fuse_virtio.c    | 50 ++++++++++++++++++++---
 tools/virtiofsd/passthrough_ll.c | 70 ++++++++++++++++++++++++++++----
 4 files changed, 167 insertions(+), 16 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index e4679c73ab..2e7f4b786d 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -179,8 +179,8 @@ int fuse_send_reply_iov_nofree(fuse_req_t req, int error, struct iovec *iov,
         .unique = req->unique,
         .error = error,
     };
-
-    if (error <= -1000 || error > 0) {
+    /* error = 1 has been used to signal client to wait for notificaiton */
+    if (error <= -1000 || error > 1) {
         fuse_log(FUSE_LOG_ERR, "fuse: bad error value: %i\n", error);
         out.error = -ERANGE;
     }
@@ -290,6 +290,11 @@ int fuse_reply_err(fuse_req_t req, int err)
     return send_reply(req, -err, NULL, 0);
 }
 
+int fuse_reply_wait(fuse_req_t req)
+{
+    return send_reply(req, 1, NULL, 0);
+}
+
 void fuse_reply_none(fuse_req_t req)
 {
     fuse_free_req(req);
@@ -2165,6 +2170,34 @@ static void do_destroy(fuse_req_t req, fuse_ino_t nodeid,
     send_reply_ok(req, NULL, 0);
 }
 
+static int send_notify_iov(struct fuse_session *se, int notify_code,
+                           struct iovec *iov, int count)
+{
+    struct fuse_out_header out;
+    if (!se->got_init) {
+        return -ENOTCONN;
+    }
+    out.unique = 0;
+    out.error = notify_code;
+    iov[0].iov_base = &out;
+    iov[0].iov_len = sizeof(struct fuse_out_header);
+    return fuse_send_msg(se, NULL, iov, count);
+}
+
+int fuse_lowlevel_notify_lock(struct fuse_session *se, uint64_t unique,
+                  int32_t error)
+{
+    struct fuse_notify_lock_out outarg = {0};
+    struct iovec iov[2];
+
+    outarg.unique = unique;
+    outarg.error = -error;
+
+    iov[1].iov_base = &outarg;
+    iov[1].iov_len = sizeof(outarg);
+    return send_notify_iov(se, FUSE_NOTIFY_LOCK, iov, 2);
+}
+
 int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
                                off_t offset, struct fuse_bufvec *bufv)
 {
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index c55c0ca2fc..64624b48dc 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -1251,6 +1251,22 @@ struct fuse_lowlevel_ops {
  */
 int fuse_reply_err(fuse_req_t req, int err);
 
+/**
+ * Ask caller to wait for lock.
+ *
+ * Possible requests:
+ *   setlkw
+ *
+ * If caller sends a blocking lock request (setlkw), then reply to caller
+ * that wait for lock to be available. Once lock is available caller will
+ * receive a notification with request's unique id. Notification will
+ * carry info whether lock was successfully obtained or not.
+ *
+ * @param req request handle
+ * @return zero for success, -errno for failure to send reply
+ */
+int fuse_reply_wait(fuse_req_t req);
+
 /**
  * Don't send reply
  *
@@ -1685,6 +1701,16 @@ int fuse_lowlevel_notify_delete(struct fuse_session *se, fuse_ino_t parent,
 int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
                                off_t offset, struct fuse_bufvec *bufv);
 
+/**
+ * Notify event related to previous lock request
+ *
+ * @param se the session object
+ * @param unique the unique id of the request which requested setlkw
+ * @param error zero for success, -errno for the failure
+ */
+int fuse_lowlevel_notify_lock(struct fuse_session *se, uint64_t unique,
+                              int32_t error);
+
 /*
  * Utility functions
  */
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index a87e88e286..bb2d4456fc 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -273,6 +273,23 @@ static void vq_send_element(struct fv_QueueInfo *qi, VuVirtqElement *elem,
     vu_dispatch_unlock(qi->virtio_dev);
 }
 
+/* Returns NULL if queue is empty */
+static FVRequest *vq_pop_notify_elem(struct fv_QueueInfo *qi)
+{
+    struct fuse_session *se = qi->virtio_dev->se;
+    VuDev *dev = &se->virtio_dev->dev;
+    VuVirtq *q = vu_get_queue(dev, qi->qidx);
+    FVRequest *req;
+
+    vu_dispatch_rdlock(qi->virtio_dev);
+    pthread_mutex_lock(&qi->vq_lock);
+    /* Pop an element from queue */
+    req = vu_queue_pop(dev, q, sizeof(FVRequest));
+    pthread_mutex_unlock(&qi->vq_lock);
+    vu_dispatch_unlock(qi->virtio_dev);
+    return req;
+}
+
 /*
  * Called back by ll whenever it wants to send a reply/message back
  * The 1st element of the iov starts with the fuse_out_header
@@ -281,9 +298,9 @@ static void vq_send_element(struct fv_QueueInfo *qi, VuVirtqElement *elem,
 int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
                     struct iovec *iov, int count)
 {
-    FVRequest *req = container_of(ch, FVRequest, ch);
-    struct fv_QueueInfo *qi = ch->qi;
-    VuVirtqElement *elem = &req->elem;
+    FVRequest *req;
+    struct fv_QueueInfo *qi;
+    VuVirtqElement *elem;
     int ret = 0;
 
     assert(count >= 1);
@@ -294,8 +311,30 @@ int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
 
     size_t tosend_len = iov_size(iov, count);
 
-    /* unique == 0 is notification, which we don't support */
-    assert(out->unique);
+    /* unique == 0 is notification */
+    if (!out->unique) {
+        if (!se->notify_enabled) {
+            return -EOPNOTSUPP;
+        }
+        /* If notifications are enabled, queue index 1 is notification queue */
+        qi = se->virtio_dev->qi[1];
+        req = vq_pop_notify_elem(qi);
+        if (!req) {
+            /*
+             * TODO: Implement some sort of ring buffer and queue notifications
+             * on that and send these later when notification queue has space
+             * available.
+             */
+            return -ENOSPC;
+        }
+        req->reply_sent = false;
+    } else {
+        assert(ch);
+        req = container_of(ch, FVRequest, ch);
+        qi = ch->qi;
+    }
+
+    elem = &req->elem;
     assert(!req->reply_sent);
 
     /* The 'in' part of the elem is to qemu */
@@ -985,6 +1024,7 @@ static int fv_get_config(VuDev *dev, uint8_t *config, uint32_t len)
         struct fuse_notify_delete_out       delete_out;
         struct fuse_notify_store_out        store_out;
         struct fuse_notify_retrieve_out     retrieve_out;
+        struct fuse_notify_lock_out         lock_out;
     };
 
     notify_size = sizeof(struct fuse_out_header) +
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 6928662e22..277f74762b 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2131,13 +2131,35 @@ out:
     }
 }
 
+static void setlk_send_notification(struct fuse_session *se, uint64_t unique,
+                                    int saverr)
+{
+    int ret;
+
+    do {
+        ret = fuse_lowlevel_notify_lock(se, unique, saverr);
+        /*
+         * Retry sending notification if notification queue does not have
+         * free descriptor yet, otherwise break out of loop. Either we
+         * successfully sent notifiation or some other error occurred.
+         */
+        if (ret != -ENOSPC) {
+            break;
+        }
+        usleep(10000);
+    } while (1);
+}
+
 static void lo_setlk(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
                      struct flock *lock, int sleep)
 {
     struct lo_data *lo = lo_data(req);
     struct lo_inode *inode;
     struct lo_inode_plock *plock;
-    int ret, saverr = 0;
+    int ret, saverr = 0, ofd;
+    uint64_t unique;
+    struct fuse_session *se = req->se;
+    bool blocking_lock = false;
 
     fuse_log(FUSE_LOG_DEBUG,
              "lo_setlk(ino=%" PRIu64 ", flags=%d)"
@@ -2151,11 +2173,6 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
         return;
     }
 
-    if (sleep) {
-        fuse_reply_err(req, EOPNOTSUPP);
-        return;
-    }
-
     inode = lo_inode(req, ino);
     if (!inode) {
         fuse_reply_err(req, EBADF);
@@ -2168,21 +2185,56 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
 
     if (!plock) {
         saverr = ret;
+        pthread_mutex_unlock(&inode->plock_mutex);
         goto out;
     }
 
+    /*
+     * plock is now released when inode is going away. We already have
+     * a reference on inode, so it is guaranteed that plock->fd is
+     * still around even after dropping inode->plock_mutex lock
+     */
+    ofd = plock->fd;
+    pthread_mutex_unlock(&inode->plock_mutex);
+
+    /*
+     * If this lock request can block, request caller to wait for
+     * notification. Do not access req after this. Once lock is
+     * available, send a notification instead.
+     */
+    if (sleep && lock->l_type != F_UNLCK) {
+        /*
+         * If notification queue is not enabled, can't support async
+         * locks.
+         */
+        if (!se->notify_enabled) {
+            saverr = EOPNOTSUPP;
+            goto out;
+        }
+        blocking_lock = true;
+        unique = req->unique;
+        fuse_reply_wait(req);
+    }
+
     /* TODO: Is it alright to modify flock? */
     lock->l_pid = 0;
-    ret = fcntl(plock->fd, F_OFD_SETLK, lock);
+    if (blocking_lock) {
+        ret = fcntl(ofd, F_OFD_SETLKW, lock);
+    } else {
+        ret = fcntl(ofd, F_OFD_SETLK, lock);
+    }
     if (ret == -1) {
         saverr = errno;
     }
 
 out:
-    pthread_mutex_unlock(&inode->plock_mutex);
     lo_inode_put(lo, &inode);
 
-    fuse_reply_err(req, saverr);
+    if (!blocking_lock) {
+        fuse_reply_err(req, saverr);
+    } else {
+        setlk_send_notification(se, unique, saverr);
+    }
 }
 
 static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
-- 
2.31.1

