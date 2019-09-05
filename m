From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:49 -0400
Message-Id: <20190905194859.16219-9-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 08/18] virtiofs: Drain all pending requests
	during ->remove time
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

When device is going away, drain all pending requests.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 83 ++++++++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 32 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 90e7b2f345e5..d5730a50b303 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -63,6 +63,55 @@ static inline struct fuse_pqueue *vq_to_fpq(struct virtqueue *vq)
 	return &vq_to_fsvq(vq)->fud->pq;
 }
 
+static void virtio_fs_drain_queue(struct virtio_fs_vq *fsvq)
+{
+	WARN_ON(fsvq->in_flight < 0);
+
+	/* Wait for in flight requests to finish.*/
+	while (1) {
+		spin_lock(&fsvq->lock);
+		if (!fsvq->in_flight) {
+			spin_unlock(&fsvq->lock);
+			break;
+		}
+		spin_unlock(&fsvq->lock);
+		usleep_range(1000, 2000);
+	}
+
+	flush_work(&fsvq->done_work);
+	flush_delayed_work(&fsvq->dispatch_work);
+}
+
+static inline void drain_hiprio_queued_reqs(struct virtio_fs_vq *fsvq)
+{
+	struct virtio_fs_forget *forget;
+
+	spin_lock(&fsvq->lock);
+	while (1) {
+		forget = list_first_entry_or_null(&fsvq->queued_reqs,
+						struct virtio_fs_forget, list);
+		if (!forget)
+			break;
+		list_del(&forget->list);
+		kfree(forget);
+	}
+	spin_unlock(&fsvq->lock);
+}
+
+static void virtio_fs_drain_all_queues(struct virtio_fs *fs)
+{
+	struct virtio_fs_vq *fsvq;
+	int i;
+
+	for (i = 0; i < fs->nvqs; i++) {
+		fsvq = &fs->vqs[i];
+		if (i == VQ_HIPRIO)
+			drain_hiprio_queued_reqs(fsvq);
+
+		virtio_fs_drain_queue(fsvq);
+	}
+}
+
 /* Add a new instance to the list or return -EEXIST if tag name exists*/
 static int virtio_fs_add_instance(struct virtio_fs *fs)
 {
@@ -511,6 +560,7 @@ static void virtio_fs_remove(struct virtio_device *vdev)
 	struct virtio_fs *fs = vdev->priv;
 
 	virtio_fs_stop_all_queues(fs);
+	virtio_fs_drain_all_queues(fs);
 	vdev->config->reset(vdev);
 	virtio_fs_cleanup_vqs(vdev, fs);
 
@@ -865,37 +915,6 @@ __releases(fiq->waitq.lock)
 	}
 }
 
-static void virtio_fs_flush_hiprio_queue(struct virtio_fs_vq *fsvq)
-{
-	struct virtio_fs_forget *forget;
-
-	WARN_ON(fsvq->in_flight < 0);
-
-	/* Go through pending forget requests and free them */
-	spin_lock(&fsvq->lock);
-	while (1) {
-		forget = list_first_entry_or_null(&fsvq->queued_reqs,
-					struct virtio_fs_forget, list);
-		if (!forget)
-			break;
-		list_del(&forget->list);
-		kfree(forget);
-	}
-
-	spin_unlock(&fsvq->lock);
-
-	/* Wait for in flight requests to finish.*/
-	while (1) {
-		spin_lock(&fsvq->lock);
-		if (!fsvq->in_flight) {
-			spin_unlock(&fsvq->lock);
-			break;
-		}
-		spin_unlock(&fsvq->lock);
-		usleep_range(1000, 2000);
-	}
-}
-
 const static struct fuse_iqueue_ops virtio_fs_fiq_ops = {
 	.wake_forget_and_unlock		= virtio_fs_wake_forget_and_unlock,
 	.wake_interrupt_and_unlock	= virtio_fs_wake_interrupt_and_unlock,
@@ -988,7 +1007,7 @@ static void virtio_kill_sb(struct super_block *sb)
 	spin_lock(&fsvq->lock);
 	fsvq->connected = false;
 	spin_unlock(&fsvq->lock);
-	virtio_fs_flush_hiprio_queue(fsvq);
+	virtio_fs_drain_all_queues(vfs);
 
 	fuse_kill_sb_anon(sb);
 	virtio_fs_free_devs(vfs);
-- 
2.20.1

