From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 15 Nov 2019 15:55:43 -0500
Message-Id: <20191115205543.1816-5-vgoyal@redhat.com>
In-Reply-To: <20191115205543.1816-1-vgoyal@redhat.com>
References: <20191115205543.1816-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/4] virtiofsd: Implement blocking posix locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org
Cc: miklos@szeredi.hu, vgoyal@redhat.com

As of now we don't support fcntl(F_SETLKW) and if we see one, we return
-EOPNOTSUPP.

Change that by accepting these requests and returning a reply immediately
asking caller to wait. Once lock is available, send a notification to
the waiter indicating lock is available.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/fuse_kernel.h    |  7 +++
 contrib/virtiofsd/fuse_lowlevel.c  | 23 +++++++-
 contrib/virtiofsd/fuse_lowlevel.h  | 25 ++++++++
 contrib/virtiofsd/fuse_virtio.c    | 94 ++++++++++++++++++++++++++++--
 contrib/virtiofsd/passthrough_ll.c | 49 +++++++++++++---
 5 files changed, 182 insertions(+), 16 deletions(-)

diff --git a/contrib/virtiofsd/fuse_kernel.h b/contrib/virtiofsd/fuse_kernel.h
index 2bdc8b1c88..d4d65c5414 100644
--- a/contrib/virtiofsd/fuse_kernel.h
+++ b/contrib/virtiofsd/fuse_kernel.h
@@ -444,6 +444,7 @@ enum fuse_notify_code {
 	FUSE_NOTIFY_STORE = 4,
 	FUSE_NOTIFY_RETRIEVE = 5,
 	FUSE_NOTIFY_DELETE = 6,
+	FUSE_NOTIFY_LOCK = 7,
 	FUSE_NOTIFY_CODE_MAX,
 };
 
@@ -836,6 +837,12 @@ struct fuse_notify_retrieve_in {
 	uint64_t	dummy4;
 };
 
+struct fuse_notify_lock_out {
+	uint64_t	id;
+	int32_t		error;
+	int32_t		padding;
+};
+
 /* Device ioctls: */
 #define FUSE_DEV_IOC_CLONE	_IOR(229, 0, uint32_t)
 
diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index d4a42d9804..f706e440bf 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -183,7 +183,8 @@ int fuse_send_reply_iov_nofree(fuse_req_t req, int error, struct iovec *iov,
 {
 	struct fuse_out_header out;
 
-	if (error <= -1000 || error > 0) {
+	/* error = 1 has been used to signal client to wait for notificaiton */
+	if (error <= -1000 || error > 1) {
 		fuse_log(FUSE_LOG_ERR, "fuse: bad error value: %i\n",	error);
 		error = -ERANGE;
 	}
@@ -291,6 +292,12 @@ int fuse_reply_err(fuse_req_t req, int err)
 	return send_reply(req, -err, NULL, 0);
 }
 
+int fuse_reply_wait(fuse_req_t req)
+{
+	/* TODO: This is a hack. Fix it */
+	return send_reply(req, 1, NULL, 0);
+}
+
 void fuse_reply_none(fuse_req_t req)
 {
 	fuse_free_req(req);
@@ -2207,6 +2214,20 @@ static int send_notify_iov(struct fuse_session *se, int notify_code,
 	return fuse_send_msg(se, NULL, iov, count);
 }
 
+int fuse_lowlevel_notify_lock(struct fuse_session *se, uint64_t req_id,
+			      int32_t error)
+{
+	struct fuse_notify_lock_out outarg;
+	struct iovec iov[2];
+
+	outarg.id = req_id;
+	outarg.error = -error;
+
+	iov[1].iov_base = &outarg;
+	iov[1].iov_len = sizeof(outarg);
+	return send_notify_iov(se, FUSE_NOTIFY_LOCK, iov, 2);
+}
+
 int fuse_lowlevel_notify_poll(struct fuse_pollhandle *ph)
 {
 	if (ph != NULL) {
diff --git a/contrib/virtiofsd/fuse_lowlevel.h b/contrib/virtiofsd/fuse_lowlevel.h
index e664d2d12d..f0a94683b5 100644
--- a/contrib/virtiofsd/fuse_lowlevel.h
+++ b/contrib/virtiofsd/fuse_lowlevel.h
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
@@ -1704,6 +1720,15 @@ int fuse_lowlevel_notify_delete(struct fuse_session *se,
 int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
 			       off_t offset, struct fuse_bufvec *bufv,
 			       enum fuse_buf_copy_flags flags);
+/**
+ * Notify event related to previous lock request
+ *
+ * @param se the session object
+ * @param req_id the id of the request which requested setlkw
+ * @param error zero for success, -errno for the failure
+ */
+int fuse_lowlevel_notify_lock(struct fuse_session *se, uint64_t req_id,
+			      int32_t error);
 
 /* ----------------------------------------------------------- *
  * Utility functions					       *
diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index 982b6ad0bd..98d27e7642 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -215,6 +215,81 @@ static void copy_iov(struct iovec *src_iov, int src_count,
     }
 }
 
+static int virtio_send_notify_msg(struct fuse_session *se, struct iovec *iov,
+				  int count)
+{
+    struct fv_QueueInfo *qi;
+    VuDev *dev = &se->virtio_dev->dev;
+    VuVirtq *q;
+    FVRequest *req;
+    VuVirtqElement *elem;
+    unsigned int in_num, bad_in_num = 0, bad_out_num = 0;
+    struct fuse_out_header *out = iov[0].iov_base;
+    size_t in_len, tosend_len = iov_size(iov, count);
+    struct iovec *in_sg;
+    int ret = 0;
+
+    /* Notifications have unique == 0 */
+    assert (!out->unique);
+
+    if (!se->notify_enabled)
+        return -EOPNOTSUPP;
+
+    /* If notifications are enabled, queue index 1 is notification queue */
+    qi = se->virtio_dev->qi[1];
+    q = vu_get_queue(dev, qi->qidx);
+
+    pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
+    pthread_mutex_lock(&qi->vq_lock);
+    /* Pop an element from queue */
+    req = vu_queue_pop(dev, q, sizeof(FVRequest), &bad_in_num, &bad_out_num);
+    if (!req) {
+        /* TODO: Implement some sort of ring buffer and queue notifications
+	 * on that and send these later when notification queue has space
+	 * available.
+	 */
+        return -ENOSPC;
+    }
+    pthread_mutex_unlock(&qi->vq_lock);
+    pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
+
+    out->len = tosend_len;
+    elem = &req->elem;
+    in_num = elem->in_num;
+    in_sg = elem->in_sg;
+    in_len = iov_size(in_sg, in_num);
+    fuse_log(FUSE_LOG_DEBUG, "%s: elem %d: with %d in desc of length %zd\n",
+             __func__, elem->index, in_num,  in_len);
+
+    if (in_len < sizeof(struct fuse_out_header)) {
+        fuse_log(FUSE_LOG_ERR, "%s: elem %d too short for out_header\n",
+                 __func__, elem->index);
+        ret = -E2BIG;
+        goto out;
+    }
+
+    if (in_len < tosend_len) {
+        fuse_log(FUSE_LOG_ERR, "%s: elem %d too small for data len"
+                 " %zd\n", __func__, elem->index, tosend_len);
+        ret = -E2BIG;
+        goto out;
+    }
+
+    /* First copy the header data from iov->in_sg */
+    copy_iov(iov, count, in_sg, in_num, tosend_len);
+
+    /* TODO: Add bad_innum handling */
+    pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
+    pthread_mutex_lock(&qi->vq_lock);
+    vu_queue_push(dev, q, elem, tosend_len);
+    vu_queue_notify(dev, q);
+    pthread_mutex_unlock(&qi->vq_lock);
+    pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
+out:
+    free(req);
+    return ret;
+}
+
 /*
  * Called back by ll whenever it wants to send a reply/message back
  * The 1st element of the iov starts with the fuse_out_header
@@ -223,11 +298,11 @@ static void copy_iov(struct iovec *src_iov, int src_count,
 int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
                     struct iovec *iov, int count)
 {
-    FVRequest *req = container_of(ch, FVRequest, ch);
-    struct fv_QueueInfo *qi = ch->qi;
+    FVRequest *req;
+    struct fv_QueueInfo *qi;
     VuDev *dev = &se->virtio_dev->dev;
-    VuVirtq *q = vu_get_queue(dev, qi->qidx);
-    VuVirtqElement *elem = &req->elem;
+    VuVirtq *q;
+    VuVirtqElement *elem;
     int ret = 0;
 
     assert(count >= 1);
@@ -238,8 +313,15 @@ int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
 
     size_t tosend_len = iov_size(iov, count);
 
-    /* unique == 0 is notification, which we don't support */
-    assert(out->unique);
+    /* unique == 0 is notification */
+    if (!out->unique)
+        return virtio_send_notify_msg(se, iov, count);
+
+    assert(ch);
+    req = container_of(ch, FVRequest, ch);
+    elem = &req->elem;
+    qi = ch->qi;
+    q = vu_get_queue(dev, qi->qidx);
     assert(!req->reply_sent);
 
     /* The 'in' part of the elem is to qemu */
diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 028e7da273..ed52953565 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1925,7 +1925,10 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
 	struct lo_data *lo = lo_data(req);
 	struct lo_inode *inode;
 	struct lo_inode_plock *plock;
-	int ret, saverr = 0;
+	int ret, saverr = 0, ofd;
+	uint64_t unique;
+	struct fuse_session *se = req->se;
+	bool async_lock = false;
 
 	fuse_log(FUSE_LOG_DEBUG, "lo_setlk(ino=%" PRIu64 ", flags=%d)"
 		 " cmd=%d pid=%d owner=0x%lx sleep=%d l_whence=%d"
@@ -1933,11 +1936,6 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
 		 lock->l_type, lock->l_pid, fi->lock_owner, sleep,
 		 lock->l_whence, lock->l_start, lock->l_len);
 
-	if (sleep) {
-		fuse_reply_err(req, EOPNOTSUPP);
-		return;
-	}
-
 	inode = lo_inode(req, ino);
 	if (!inode) {
 		fuse_reply_err(req, EBADF);
@@ -1950,21 +1948,54 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
 
 	if (!plock) {
 		saverr = ret;
+		pthread_mutex_unlock(&inode->plock_mutex);
 		goto out;
 	}
 
+	/*
+	 * plock is now released when inode is going away. We already have
+	 * a reference on inode, so it is guaranteed that plock->fd is
+	 * still around even after dropping inode->plock_mutex lock
+	 */
+	ofd = plock->fd;
+	pthread_mutex_unlock(&inode->plock_mutex);
+
+	/*
+	 * If this lock request can block, request caller to wait for
+	 * notification. Do not access req after this. Once lock is
+	 * available, send a notification instead.
+	 */
+	if (sleep && lock->l_type != F_UNLCK) {
+		/*
+		 * If notification queue is not enabled, can't support async
+		 * locks.
+		 */
+		if (!se->notify_enabled) {
+			saverr = EOPNOTSUPP;
+			goto out;
+		}
+		async_lock = true;
+		unique = req->unique;
+		fuse_reply_wait(req);
+	}
 	/* TODO: Is it alright to modify flock? */
 	lock->l_pid = 0;
-	ret = fcntl(plock->fd, F_OFD_SETLK, lock);
+	if (async_lock)
+		ret = fcntl(ofd, F_OFD_SETLKW, lock);
+	else
+		ret = fcntl(ofd, F_OFD_SETLK, lock);
 	if (ret == -1) {
 		saverr = errno;
 	}
 
 out:
-	pthread_mutex_unlock(&inode->plock_mutex);
 	lo_inode_put(lo, &inode);
 
-	fuse_reply_err(req, saverr);
+	if (!async_lock)
+		fuse_reply_err(req, saverr);
+	else {
+		fuse_lowlevel_notify_lock(se, unique, saverr);
+	}
 }
 
 static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
-- 
2.20.1

