From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:56 -0400
Message-Id: <20190905194859.16219-16-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 15/18] virtiofs: Make virtio_fs object refcounted
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, miklos@szeredi.hu
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, vgoyal@redhat.com

This object is used both by fuse_connection as well virt device. So make
this object reference counted and that makes it easy to define life cycle
of the object.

Now deivce can be removed while filesystem is still mounted. This will
cleanup all the virtqueues but virtio_fs object will still be around and
will be cleaned when filesystem is unmounted and sb/fc drops its reference.

Removing a device also stops all virt queues and any new reuqest gets
error -ENOTCONN. All existing in flight requests are drained before
->remove returns.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 52 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 01bbf2c0e144..29ec2f5bbbe2 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -37,6 +37,7 @@ struct virtio_fs_vq {
 
 /* A virtio-fs device instance */
 struct virtio_fs {
+	struct kref refcount;
 	struct list_head list;    /* on virtio_fs_instances */
 	char *tag;
 	struct virtio_fs_vq *vqs;
@@ -63,6 +64,27 @@ static inline struct fuse_pqueue *vq_to_fpq(struct virtqueue *vq)
 	return &vq_to_fsvq(vq)->fud->pq;
 }
 
+static void release_virtiofs_obj(struct kref *ref)
+{
+	struct virtio_fs *vfs = container_of(ref, struct virtio_fs, refcount);
+
+	kfree(vfs->vqs);
+	kfree(vfs);
+}
+
+static void virtiofs_put(struct virtio_fs *fs)
+{
+	mutex_lock(&virtio_fs_mutex);
+	kref_put(&fs->refcount, release_virtiofs_obj);
+	mutex_unlock(&virtio_fs_mutex);
+}
+
+static void virtio_fs_put(struct fuse_iqueue *fiq)
+{
+	struct virtio_fs *vfs = fiq->priv;
+	virtiofs_put(vfs);
+}
+
 static void virtio_fs_drain_queue(struct virtio_fs_vq *fsvq)
 {
 	WARN_ON(fsvq->in_flight < 0);
@@ -156,8 +178,10 @@ static struct virtio_fs *virtio_fs_find_instance(const char *tag)
 	mutex_lock(&virtio_fs_mutex);
 
 	list_for_each_entry(fs, &virtio_fs_instances, list) {
-		if (strcmp(fs->tag, tag) == 0)
+		if (strcmp(fs->tag, tag) == 0) {
+			kref_get(&fs->refcount);
 			goto found;
+		}
 	}
 
 	fs = NULL; /* not found */
@@ -519,6 +543,7 @@ static int virtio_fs_probe(struct virtio_device *vdev)
 	fs = kzalloc(sizeof(*fs), GFP_KERNEL);
 	if (!fs)
 		return -ENOMEM;
+	kref_init(&fs->refcount);
 	vdev->priv = fs;
 
 	ret = virtio_fs_read_tag(vdev, fs);
@@ -570,18 +595,18 @@ static void virtio_fs_remove(struct virtio_device *vdev)
 {
 	struct virtio_fs *fs = vdev->priv;
 
+	mutex_lock(&virtio_fs_mutex);
+	list_del_init(&fs->list);
+	mutex_unlock(&virtio_fs_mutex);
+
 	virtio_fs_stop_all_queues(fs);
 	virtio_fs_drain_all_queues(fs);
 	vdev->config->reset(vdev);
 	virtio_fs_cleanup_vqs(vdev, fs);
 
-	mutex_lock(&virtio_fs_mutex);
-	list_del(&fs->list);
-	mutex_unlock(&virtio_fs_mutex);
-
 	vdev->priv = NULL;
-	kfree(fs->vqs);
-	kfree(fs);
+	/* Put device reference on virtio_fs object */
+	virtiofs_put(fs);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -932,6 +957,7 @@ const static struct fuse_iqueue_ops virtio_fs_fiq_ops = {
 	.wake_forget_and_unlock		= virtio_fs_wake_forget_and_unlock,
 	.wake_interrupt_and_unlock	= virtio_fs_wake_interrupt_and_unlock,
 	.wake_pending_and_unlock	= virtio_fs_wake_pending_and_unlock,
+	.put				= virtio_fs_put,
 };
 
 static int virtio_fs_fill_super(struct super_block *sb)
@@ -1026,7 +1052,9 @@ static void virtio_kill_sb(struct super_block *sb)
 	fuse_kill_sb_anon(sb);
 
 	/* fuse_kill_sb_anon() must have sent destroy. Stop all queues
-	 * and drain one more time and free fuse devices.
+	 * and drain one more time and free fuse devices. Freeing fuse
+	 * devices will drop their reference on fuse_conn and that in
+	 * turn will drop its reference on virtio_fs object.
 	 */
 	virtio_fs_stop_all_queues(vfs);
 	virtio_fs_drain_all_queues(vfs);
@@ -1060,6 +1088,10 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	struct fuse_conn *fc;
 	int err;
 
+	/* This gets a reference on virtio_fs object. This ptr gets installed
+	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
+	 * to drop the reference to this object.
+	 */
 	fs = virtio_fs_find_instance(fsc->source);
 	if (!fs) {
 		pr_info("virtio-fs: tag <%s> not found\n", fsc->source);
@@ -1067,8 +1099,10 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	}
 
 	fc = kzalloc(sizeof(struct fuse_conn), GFP_KERNEL);
-	if (!fc)
+	if (!fc) {
+		virtiofs_put(fs);
 		return -ENOMEM;
+	}
 
 	fuse_conn_init(fc, get_user_ns(current_user_ns()), &virtio_fs_fiq_ops,
 		       fs);
-- 
2.20.1

