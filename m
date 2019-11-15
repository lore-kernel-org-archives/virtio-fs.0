From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 15 Nov 2019 15:57:02 -0500
Message-Id: <20191115205705.2046-2-vgoyal@redhat.com>
In-Reply-To: <20191115205705.2046-1-vgoyal@redhat.com>
References: <20191115205705.2046-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/4] virtiofs: Provide a helper function for
	virtqueue initialization
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

This reduces code duplication and make it little easier to read code.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 50 +++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index b5ba83ef1914..a0fb0a93980c 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -24,6 +24,8 @@ enum {
 	VQ_REQUEST
 };
 
+#define VQ_NAME_LEN	24
+
 /* Per-virtqueue state */
 struct virtio_fs_vq {
 	spinlock_t lock;
@@ -36,7 +38,7 @@ struct virtio_fs_vq {
 	bool connected;
 	long in_flight;
 	struct completion in_flight_zero; /* No inflight requests */
-	char name[24];
+	char name[VQ_NAME_LEN];
 } ____cacheline_aligned_in_smp;
 
 /* A virtio-fs device instance */
@@ -560,6 +562,26 @@ static void virtio_fs_vq_done(struct virtqueue *vq)
 	schedule_work(&fsvq->done_work);
 }
 
+static void virtio_fs_init_vq(struct virtio_fs_vq *fsvq, char *name,
+			      int vq_type)
+{
+	strncpy(fsvq->name, name, VQ_NAME_LEN);
+	spin_lock_init(&fsvq->lock);
+	INIT_LIST_HEAD(&fsvq->queued_reqs);
+	INIT_LIST_HEAD(&fsvq->end_reqs);
+	init_completion(&fsvq->in_flight_zero);
+
+	if (vq_type == VQ_REQUEST) {
+		INIT_WORK(&fsvq->done_work, virtio_fs_requests_done_work);
+		INIT_DELAYED_WORK(&fsvq->dispatch_work,
+				  virtio_fs_request_dispatch_work);
+	} else {
+		INIT_WORK(&fsvq->done_work, virtio_fs_hiprio_done_work);
+		INIT_DELAYED_WORK(&fsvq->dispatch_work,
+				  virtio_fs_hiprio_dispatch_work);
+	}
+}
+
 /* Initialize virtqueues */
 static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 			       struct virtio_fs *fs)
@@ -575,7 +597,7 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 	if (fs->num_request_queues == 0)
 		return -EINVAL;
 
-	fs->nvqs = 1 + fs->num_request_queues;
+	fs->nvqs = VQ_REQUEST + fs->num_request_queues;
 	fs->vqs = kcalloc(fs->nvqs, sizeof(fs->vqs[VQ_HIPRIO]), GFP_KERNEL);
 	if (!fs->vqs)
 		return -ENOMEM;
@@ -589,29 +611,17 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 		goto out;
 	}
 
+	/* Initialize the hiprio/forget request virtqueue */
 	callbacks[VQ_HIPRIO] = virtio_fs_vq_done;
-	snprintf(fs->vqs[VQ_HIPRIO].name, sizeof(fs->vqs[VQ_HIPRIO].name),
-			"hiprio");
+	virtio_fs_init_vq(&fs->vqs[VQ_HIPRIO], "hiprio", VQ_HIPRIO);
 	names[VQ_HIPRIO] = fs->vqs[VQ_HIPRIO].name;
-	INIT_WORK(&fs->vqs[VQ_HIPRIO].done_work, virtio_fs_hiprio_done_work);
-	INIT_LIST_HEAD(&fs->vqs[VQ_HIPRIO].queued_reqs);
-	INIT_LIST_HEAD(&fs->vqs[VQ_HIPRIO].end_reqs);
-	INIT_DELAYED_WORK(&fs->vqs[VQ_HIPRIO].dispatch_work,
-			virtio_fs_hiprio_dispatch_work);
-	init_completion(&fs->vqs[VQ_HIPRIO].in_flight_zero);
-	spin_lock_init(&fs->vqs[VQ_HIPRIO].lock);
 
 	/* Initialize the requests virtqueues */
 	for (i = VQ_REQUEST; i < fs->nvqs; i++) {
-		spin_lock_init(&fs->vqs[i].lock);
-		INIT_WORK(&fs->vqs[i].done_work, virtio_fs_requests_done_work);
-		INIT_DELAYED_WORK(&fs->vqs[i].dispatch_work,
-				  virtio_fs_request_dispatch_work);
-		INIT_LIST_HEAD(&fs->vqs[i].queued_reqs);
-		INIT_LIST_HEAD(&fs->vqs[i].end_reqs);
-		init_completion(&fs->vqs[i].in_flight_zero);
-		snprintf(fs->vqs[i].name, sizeof(fs->vqs[i].name),
-			 "requests.%u", i - VQ_REQUEST);
+		char vq_name[VQ_NAME_LEN];
+
+		snprintf(vq_name, VQ_NAME_LEN, "requests.%u", i - VQ_REQUEST);
+		virtio_fs_init_vq(&fs->vqs[i], vq_name, VQ_REQUEST);
 		callbacks[i] = virtio_fs_vq_done;
 		names[i] = fs->vqs[i].name;
 	}
-- 
2.20.1

