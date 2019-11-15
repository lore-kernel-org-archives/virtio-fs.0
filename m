From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 15 Nov 2019 15:57:04 -0500
Message-Id: <20191115205705.2046-4-vgoyal@redhat.com>
In-Reply-To: <20191115205705.2046-1-vgoyal@redhat.com>
References: <20191115205705.2046-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/4] virtiofs: Add a virtqueue for notifications
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, vgoyal@redhat.com

Add a new virtqueue for notifications. This will allow device to send
notifications to guest. This queue is created only if device supports
it. This is negotiated using feature bit VIRTIO_FS_F_NOTIFICATION.

Given the architecture of virtqueue, one needs to queue up pre-allocated
elements in notication queue and device can pop these elements and fill
the notification info and send it back. Size of notication buffer is
negotiable and is specified by device through config space. This will
allow us to add and support more notification types without having to
change the spec.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c            | 199 +++++++++++++++++++++++++++++++--
 include/uapi/linux/virtio_fs.h |   5 +
 2 files changed, 193 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 1ab4b7b83707..21d8d9d7d317 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -21,10 +21,12 @@ static LIST_HEAD(virtio_fs_instances);
 
 enum {
 	VQ_HIPRIO,
+	VQ_NOTIFY,
 	VQ_REQUEST
 };
 
 #define VQ_NAME_LEN	24
+#define VQ_NOTIFY_ELEMS		16 /* Number of notification elements */
 
 /* Per-virtqueue state */
 struct virtio_fs_vq {
@@ -33,6 +35,8 @@ struct virtio_fs_vq {
 	struct work_struct done_work;
 	struct list_head queued_reqs;
 	struct list_head end_reqs;	/* End these requests */
+	struct virtio_fs_notify_node *notify_nodes;
+	struct list_head notify_reqs;	/* List for queuing notify requests */
 	struct delayed_work dispatch_work;
 	struct fuse_dev *fud;
 	bool connected;
@@ -50,6 +54,8 @@ struct virtio_fs {
 	unsigned int nvqs;               /* number of virtqueues */
 	unsigned int num_request_queues; /* number of request queues */
 	unsigned int first_reqq_idx;	/* First request queue idx */
+	bool notify_enabled;
+	unsigned int notify_buf_size;	/* Size of notification buffer */
 };
 
 struct virtio_fs_forget_req {
@@ -66,6 +72,20 @@ struct virtio_fs_forget {
 static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 				 struct fuse_req *req, bool in_flight);
 
+struct virtio_fs_notify {
+	struct fuse_out_header	out_hdr;
+	/* Size of notify data specified by fs->notify_buf_size */
+	char outarg[];
+};
+
+struct virtio_fs_notify_node {
+	struct list_head list;
+	struct virtio_fs_notify notify;
+};
+
+static int virtio_fs_enqueue_all_notify(struct virtio_fs_vq *fsvq);
+
+
 static inline struct virtio_fs_vq *vq_to_fsvq(struct virtqueue *vq)
 {
 	struct virtio_fs *fs = vq->vdev->priv;
@@ -78,6 +98,11 @@ static inline struct fuse_pqueue *vq_to_fpq(struct virtqueue *vq)
 	return &vq_to_fsvq(vq)->fud->pq;
 }
 
+static inline struct virtio_fs *fsvq_to_fs(struct virtio_fs_vq *fsvq)
+{
+	return (struct virtio_fs *)fsvq->vq->vdev->priv;
+}
+
 /* Should be called with fsvq->lock held. */
 static inline void inc_in_flight_req(struct virtio_fs_vq *fsvq)
 {
@@ -93,10 +118,17 @@ static inline void dec_in_flight_req(struct virtio_fs_vq *fsvq)
 		complete(&fsvq->in_flight_zero);
 }
 
+static void virtio_fs_free_notify_nodes(struct virtio_fs *fs)
+{
+	if (fs->notify_enabled && fs->vqs)
+		kfree(fs->vqs[VQ_NOTIFY].notify_nodes);
+}
+
 static void release_virtio_fs_obj(struct kref *ref)
 {
 	struct virtio_fs *vfs = container_of(ref, struct virtio_fs, refcount);
 
+	virtio_fs_free_notify_nodes(vfs);
 	kfree(vfs->vqs);
 	kfree(vfs);
 }
@@ -143,6 +175,13 @@ static void virtio_fs_drain_all_queues_locked(struct virtio_fs *fs)
 	int i;
 
 	for (i = 0; i < fs->nvqs; i++) {
+		/*
+		 * Can't wait to drain notification queue as it always
+		 * has pending requests so that server can use those
+		 * to send notifications.
+		 */
+		if (fs->notify_enabled && (i == VQ_NOTIFY))
+			continue;
 		fsvq = &fs->vqs[i];
 		virtio_fs_drain_queue(fsvq);
 	}
@@ -171,6 +210,8 @@ static void virtio_fs_start_all_queues(struct virtio_fs *fs)
 		spin_lock(&fsvq->lock);
 		fsvq->connected = true;
 		spin_unlock(&fsvq->lock);
+		if (fs->notify_enabled && (i == VQ_NOTIFY))
+			virtio_fs_enqueue_all_notify(fsvq);
 	}
 }
 
@@ -420,6 +461,99 @@ static void virtio_fs_hiprio_dispatch_work(struct work_struct *work)
 	}
 }
 
+/* Allocate memory for event requests in notify queue */
+static int virtio_fs_init_notify_vq(struct virtio_fs *fs,
+				    struct virtio_fs_vq *fsvq)
+{
+	struct virtio_fs_notify_node *notify;
+	unsigned notify_node_sz = sizeof(struct virtio_fs_notify_node) +
+				  fs->notify_buf_size;
+	int i;
+
+	fsvq->notify_nodes = kcalloc(VQ_NOTIFY_ELEMS, notify_node_sz,
+				     GFP_KERNEL);
+	if (!fsvq->notify_nodes)
+		return -ENOMEM;
+
+	for (i = 0; i < VQ_NOTIFY_ELEMS; i++) {
+		notify = (void *)fsvq->notify_nodes + (i * notify_node_sz);
+		list_add_tail(&notify->list, &fsvq->notify_reqs);
+	}
+
+	return 0;
+}
+
+static int virtio_fs_enqueue_all_notify(struct virtio_fs_vq *fsvq)
+{
+	struct scatterlist sg[1];
+	int ret;
+	bool kick;
+	struct virtio_fs *fs = fsvq_to_fs(fsvq);
+	struct virtio_fs_notify_node *notify, *next;
+	unsigned notify_sz;
+
+	notify_sz = sizeof(struct fuse_out_header) + fs->notify_buf_size;
+	spin_lock(&fsvq->lock);
+	list_for_each_entry_safe(notify, next, &fsvq->notify_reqs, list) {
+		list_del_init(&notify->list);
+		sg_init_one(sg, &notify->notify, notify_sz);
+		ret = virtqueue_add_inbuf(fsvq->vq, sg, 1, notify, GFP_ATOMIC);
+		if (ret) {
+			list_add_tail(&notify->list, &fsvq->notify_reqs);
+			spin_unlock(&fsvq->lock);
+			return ret;
+		}
+		inc_in_flight_req(fsvq);
+	}
+
+	kick = virtqueue_kick_prepare(fsvq->vq);
+	spin_unlock(&fsvq->lock);
+	if (kick)
+		virtqueue_notify(fsvq->vq);
+	return 0;
+}
+
+static void virtio_fs_notify_done_work(struct work_struct *work)
+{
+	struct virtio_fs_vq *fsvq = container_of(work, struct virtio_fs_vq,
+						 done_work);
+	struct virtqueue *vq = fsvq->vq;
+	LIST_HEAD(reqs);
+	struct virtio_fs_notify_node *notify, *next;
+
+	spin_lock(&fsvq->lock);
+	do {
+		unsigned int len;
+
+		virtqueue_disable_cb(vq);
+
+		while ((notify = virtqueue_get_buf(vq, &len)) != NULL) {
+			list_add_tail(&notify->list, &reqs);
+		}
+	} while (!virtqueue_enable_cb(vq) && likely(!virtqueue_is_broken(vq)));
+	spin_unlock(&fsvq->lock);
+
+	/* Process notify */
+	list_for_each_entry_safe(notify, next, &reqs, list) {
+		spin_lock(&fsvq->lock);
+		dec_in_flight_req(fsvq);
+		list_del_init(&notify->list);
+		list_add_tail(&notify->list, &fsvq->notify_reqs);
+		spin_unlock(&fsvq->lock);
+	}
+
+	/*
+	 * If queue is connected, queue notifications again. If not,
+	 * these will be queued again when virtuqueue is restarted.
+	 */
+	if (fsvq->connected)
+		virtio_fs_enqueue_all_notify(fsvq);
+}
+
+static void virtio_fs_notify_dispatch_work(struct work_struct *work)
+{
+}
+
 /* Allocate and copy args into req->argbuf */
 static int copy_args_to_argbuf(struct fuse_req *req)
 {
@@ -563,24 +697,34 @@ static void virtio_fs_vq_done(struct virtqueue *vq)
 	schedule_work(&fsvq->done_work);
 }
 
-static void virtio_fs_init_vq(struct virtio_fs_vq *fsvq, char *name,
-			      int vq_type)
+static int virtio_fs_init_vq(struct virtio_fs *fs, struct virtio_fs_vq *fsvq,
+			     char *name, int vq_type)
 {
+	int ret = 0;
+
 	strncpy(fsvq->name, name, VQ_NAME_LEN);
 	spin_lock_init(&fsvq->lock);
 	INIT_LIST_HEAD(&fsvq->queued_reqs);
 	INIT_LIST_HEAD(&fsvq->end_reqs);
+	INIT_LIST_HEAD(&fsvq->notify_reqs);
 	init_completion(&fsvq->in_flight_zero);
 
 	if (vq_type == VQ_REQUEST) {
 		INIT_WORK(&fsvq->done_work, virtio_fs_requests_done_work);
 		INIT_DELAYED_WORK(&fsvq->dispatch_work,
 				  virtio_fs_request_dispatch_work);
+	} else if (vq_type == VQ_NOTIFY) {
+		INIT_WORK(&fsvq->done_work, virtio_fs_notify_done_work);
+		INIT_DELAYED_WORK(&fsvq->dispatch_work,
+				  virtio_fs_notify_dispatch_work);
+		ret = virtio_fs_init_notify_vq(fs, fsvq);
 	} else {
 		INIT_WORK(&fsvq->done_work, virtio_fs_hiprio_done_work);
 		INIT_DELAYED_WORK(&fsvq->dispatch_work,
 				  virtio_fs_hiprio_dispatch_work);
 	}
+
+	return ret;
 }
 
 /* Initialize virtqueues */
@@ -598,9 +742,27 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 	if (fs->num_request_queues == 0)
 		return -EINVAL;
 
-	/* One hiprio queue and rest are request queues */
-	fs->nvqs = 1 + fs->num_request_queues;
-	fs->first_reqq_idx = 1;
+	if (virtio_has_feature(vdev, VIRTIO_FS_F_NOTIFICATION)) {
+		pr_debug("virtio_fs: device supports notification.\n");
+		fs->notify_enabled = true;
+		virtio_cread(vdev, struct virtio_fs_config, notify_buf_size,
+			     &fs->notify_buf_size);
+		if (fs->notify_buf_size == 0) {
+			printk("virtio-fs: Invalid value %d of notification"
+			       " buffer size\n", fs->notify_buf_size);
+			return -EINVAL;
+		}
+	}
+
+	if (fs->notify_enabled) {
+		/* One additional queue for hiprio and one for notifications */
+		fs->nvqs = 2 + fs->num_request_queues;
+		fs->first_reqq_idx = 2;
+	} else {
+		fs->nvqs = 1 + fs->num_request_queues;
+		fs->first_reqq_idx = 1;
+	}
+
 	fs->vqs = kcalloc(fs->nvqs, sizeof(fs->vqs[VQ_HIPRIO]), GFP_KERNEL);
 	if (!fs->vqs)
 		return -ENOMEM;
@@ -616,16 +778,30 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 
 	/* Initialize the hiprio/forget request virtqueue */
 	callbacks[VQ_HIPRIO] = virtio_fs_vq_done;
-	virtio_fs_init_vq(&fs->vqs[VQ_HIPRIO], "hiprio", VQ_HIPRIO);
+	ret = virtio_fs_init_vq(fs, &fs->vqs[VQ_HIPRIO], "hiprio", VQ_HIPRIO);
+	if (ret < 0)
+		goto out;
 	names[VQ_HIPRIO] = fs->vqs[VQ_HIPRIO].name;
 
+	/* Initialize notification queue */
+	if (fs->notify_enabled) {
+		callbacks[VQ_NOTIFY] = virtio_fs_vq_done;
+		ret = virtio_fs_init_vq(fs, &fs->vqs[VQ_NOTIFY], "notification",
+					VQ_NOTIFY);
+		if (ret < 0)
+			goto out;
+		names[VQ_NOTIFY] = fs->vqs[VQ_NOTIFY].name;
+	}
+
 	/* Initialize the requests virtqueues */
 	for (i = fs->first_reqq_idx; i < fs->nvqs; i++) {
 		char vq_name[VQ_NAME_LEN];
 
 		snprintf(vq_name, VQ_NAME_LEN, "requests.%u",
 			 i - fs->first_reqq_idx);
-		virtio_fs_init_vq(&fs->vqs[i], vq_name, VQ_REQUEST);
+		ret = virtio_fs_init_vq(fs, &fs->vqs[i], vq_name, VQ_REQUEST);
+		if (ret < 0)
+			goto out;
 		callbacks[i] = virtio_fs_vq_done;
 		names[i] = fs->vqs[i].name;
 	}
@@ -636,14 +812,14 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 
 	for (i = 0; i < fs->nvqs; i++)
 		fs->vqs[i].vq = vqs[i];
-
-	virtio_fs_start_all_queues(fs);
 out:
 	kfree(names);
 	kfree(callbacks);
 	kfree(vqs);
-	if (ret)
+	if (ret) {
+		virtio_fs_free_notify_nodes(fs);
 		kfree(fs->vqs);
+	}
 	return ret;
 }
 
@@ -679,6 +855,7 @@ static int virtio_fs_probe(struct virtio_device *vdev)
 	 * requests need to be sent before we return.
 	 */
 	virtio_device_ready(vdev);
+	virtio_fs_start_all_queues(fs);
 
 	ret = virtio_fs_add_instance(fs);
 	if (ret < 0)
@@ -747,7 +924,7 @@ const static struct virtio_device_id id_table[] = {
 	{},
 };
 
-const static unsigned int feature_table[] = {};
+const static unsigned int feature_table[] = {VIRTIO_FS_F_NOTIFICATION};
 
 static struct virtio_driver virtio_fs_driver = {
 	.driver.name		= KBUILD_MODNAME,
diff --git a/include/uapi/linux/virtio_fs.h b/include/uapi/linux/virtio_fs.h
index b02eb2ac3d99..f3f2ba3399a4 100644
--- a/include/uapi/linux/virtio_fs.h
+++ b/include/uapi/linux/virtio_fs.h
@@ -8,12 +8,17 @@
 #include <linux/virtio_config.h>
 #include <linux/virtio_types.h>
 
+/* Feature bits */
+#define VIRTIO_FS_F_NOTIFICATION	0	/* Notification queue supported */
+
 struct virtio_fs_config {
 	/* Filesystem name (UTF-8, not NUL-terminated, padded with NULs) */
 	__u8 tag[36];
 
 	/* Number of request queues */
 	__u32 num_request_queues;
+	/* Size of notification buffer */
+	__u32 notify_buf_size;
 } __attribute__((packed));
 
 #endif /* _UAPI_LINUX_VIRTIO_FS_H */
-- 
2.20.1

