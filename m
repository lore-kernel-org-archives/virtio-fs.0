From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 10:38:49 -0400
Message-Id: <20210930143850.1188628-8-vgoyal@redhat.com>
In-Reply-To: <20210930143850.1188628-1-vgoyal@redhat.com>
References: <20210930143850.1188628-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 7/8] virtiofs: Add new notification type
	FUSE_NOTIFY_LOCK
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com
Cc: vgoyal@redhat.com

Add a new notification type FUSE_NOTIFY_LOCK. This notification can be
sent by file server to signifiy that a previous locking request has
completed and actual caller should be woken up.

As of now we don't support blocking variant of posix locks and daemon
returns -EOPNOTSUPP. Reason being that it can lead to deadlocks.
Virtqueue size is limited and it is possible we fill virtqueue with
all the requests of fcntl(F_SETLKW) and wait for reply. And later a
subsequent unlock request can't make progress because virtqueue is full.
And that means F_SETLKW can't make progress and we are deadlocked.

This problem is not limited to posix locks only. I think blocking remote
flock and open file description locks should face the same issue. Right
now fuse does not support open file description locks, so its not
a problem. But fuse/virtiofs does support remote flock and they can use
same mechanism too.

Use notification queue to solve this problem. After submitting lock
request device will send a reply asking requester to wait. Once lock is
available, requester will get a notification saying lock is available.
That way we don't keep the request virtueue busy while we are waiting for
lock and further unlock requests can make progress.

When we get a reply in response to lock request, we need a way to know
if we need to wait for notification or not. I have overloaded the
fuse_out_header->error field. If value is ->error is 1, that's a signal
to caller to wait for lock notification. Overloading ->error in this way
is not the best way to do it. But I am running out of ideas.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 fs/fuse/virtio_fs.c       | 73 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fuse.h | 11 +++++-
 2 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 8d33879d62fb..1634ea2d0555 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -48,6 +48,7 @@ struct virtio_fs_vq {
 	struct virtqueue *vq;     /* protected by ->lock */
 	struct work_struct done_work;
 	struct list_head queued_reqs;
+	struct list_head wait_reqs;     /* Requests waiting for notification  */
 	struct list_head end_reqs;	/* End these requests */
 	struct virtio_fs_notify_node *notify_nodes;
 	struct list_head notify_reqs;	/* List for queuing notify requests */
@@ -575,13 +576,72 @@ static int virtio_fs_enqueue_all_notify(struct virtio_fs_vq *fsvq)
 	return 0;
 }
 
+static int notify_complete_waiting_req(struct virtio_fs *vfs,
+				       struct fuse_notify_lock_out *out_args)
+{
+	/* TODO: Handle multiqueue */
+	struct virtio_fs_vq *fsvq = &vfs->vqs[vfs->first_reqq_idx];
+	struct fuse_req *req, *next;
+	bool found = false;
+
+	/* Find waiting request with the unique number and end it */
+	spin_lock(&fsvq->lock);
+	list_for_each_entry_safe(req, next, &fsvq->wait_reqs, list) {
+		if (req->in.h.unique == out_args->unique) {
+			list_del_init(&req->list);
+			clear_bit(FR_SENT, &req->flags);
+			/* Transfer error code from notify */
+			req->out.h.error = out_args->error;
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&fsvq->lock);
+
+	/*
+	 * TODO: It is possible that some re-ordering happens in notify
+	 * comes before request is complete. Deal with it.
+	 */
+	if (found) {
+		end_req_dec_in_flight(req, fsvq);
+	} else
+		pr_debug("virtio-fs: Did not find waiting request with unique=0x%llx\n",
+			 out_args->unique);
+
+	return 0;
+}
+
+static int virtio_fs_handle_notify(struct virtio_fs *vfs,
+				   struct virtio_fs_notify *notify)
+{
+	int ret = 0;
+	struct fuse_out_header *oh = &notify->out_hdr;
+	struct fuse_notify_lock_out *lo;
+
+	/*
+	 * For notifications, oh.unique is 0 and oh->error contains code
+	 * for which notification as arrived.
+	 */
+	switch (oh->error) {
+	case FUSE_NOTIFY_LOCK:
+		lo = (struct fuse_notify_lock_out *) &notify->outarg;
+		notify_complete_waiting_req(vfs, lo);
+		break;
+	default:
+		pr_err("virtio-fs: Unexpected notification %d\n", oh->error);
+	}
+	return ret;
+}
+
 static void virtio_fs_notify_done_work(struct work_struct *work)
 {
 	struct virtio_fs_vq *fsvq = container_of(work, struct virtio_fs_vq,
 						 done_work);
 	struct virtqueue *vq = fsvq->vq;
+	struct virtio_fs *vfs = vq->vdev->priv;
 	LIST_HEAD(reqs);
 	struct virtio_fs_notify_node *notifyn, *next;
+	struct fuse_out_header *oh;
 
 	spin_lock(&fsvq->lock);
 	do {
@@ -597,6 +657,10 @@ static void virtio_fs_notify_done_work(struct work_struct *work)
 
 	/* Process notify */
 	list_for_each_entry_safe(notifyn, next, &reqs, list) {
+		oh = &notifyn->notify.out_hdr;
+		WARN_ON(oh->unique);
+		/* Handle notification */
+		virtio_fs_handle_notify(vfs, &notifyn->notify);
 		spin_lock(&fsvq->lock);
 		dec_in_flight_req(fsvq);
 		list_del_init(&notifyn->list);
@@ -696,6 +760,14 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 	 * TODO verify that server properly follows FUSE protocol
 	 * (oh.uniq, oh.len)
 	 */
+	if (req->out.h.error == 1) {
+		/* Wait for notification to complete request */
+		spin_lock(&fsvq->lock);
+		list_add_tail(&req->list, &fsvq->wait_reqs);
+		spin_unlock(&fsvq->lock);
+		return;
+	}
+
 	args = req->args;
 	copy_args_from_argbuf(args, req);
 
@@ -788,6 +860,7 @@ static int virtio_fs_init_vq(struct virtio_fs *fs, struct virtio_fs_vq *fsvq,
 	strncpy(fsvq->name, name, VQ_NAME_LEN);
 	spin_lock_init(&fsvq->lock);
 	INIT_LIST_HEAD(&fsvq->queued_reqs);
+	INIT_LIST_HEAD(&fsvq->wait_reqs);
 	INIT_LIST_HEAD(&fsvq->end_reqs);
 	INIT_LIST_HEAD(&fsvq->notify_reqs);
 	init_completion(&fsvq->in_flight_zero);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 36ed092227fa..46838551ea84 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -184,6 +184,8 @@
  *
  *  7.34
  *  - add FUSE_SYNCFS
+ *  7.35
+ *  - add FUSE_NOTIFY_LOCK
  */
 
 #ifndef _LINUX_FUSE_H
@@ -219,7 +221,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 34
+#define FUSE_KERNEL_MINOR_VERSION 35
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -529,6 +531,7 @@ enum fuse_notify_code {
 	FUSE_NOTIFY_STORE = 4,
 	FUSE_NOTIFY_RETRIEVE = 5,
 	FUSE_NOTIFY_DELETE = 6,
+	FUSE_NOTIFY_LOCK = 7,
 	FUSE_NOTIFY_CODE_MAX,
 };
 
@@ -920,6 +923,12 @@ struct fuse_notify_retrieve_in {
 	uint64_t	dummy4;
 };
 
+struct fuse_notify_lock_out {
+	uint64_t	unique;
+	int32_t		error;
+	int32_t		padding;
+};
+
 /* Device ioctls: */
 #define FUSE_DEV_IOC_MAGIC		229
 #define FUSE_DEV_IOC_CLONE		_IOR(FUSE_DEV_IOC_MAGIC, 0, uint32_t)
-- 
2.31.1

