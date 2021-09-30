From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 10:38:46 -0400
Message-Id: <20210930143850.1188628-5-vgoyal@redhat.com>
In-Reply-To: <20210930143850.1188628-1-vgoyal@redhat.com>
References: <20210930143850.1188628-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/8] virtiofs: Decouple queue index and queue
	type
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

Right now we use a single enum {VQ_HIPRIO, VQ_REQUEST} and this seems to be
being used to communicate both virtqueue index as well as virtqueue type.

For example, virtio_fs_init_vq(..,..,..,vq_type) expects queue type in
vq_type parameter. In rest of the code we are also using this enum as
queue index.

This is little confusing. At the same time, queue index situation is about
to become little complicated and dynamic with the introduction of
notification queue. Request queue index is not going to be determined at
compile time. It will be dynamic based on whether notification queue is
offered by device or not.

So do not use this enum for both the purposes. Instead use it only to
denote virtqueue type. For queue index, use macros where queue index is
fixed and use a variable where queue index is not fixed.

In the previous patch we are already using a variable ->first_reqq_idx for
request queue index. This patch defines VQ_HIPRIO_IDX to keep track of
hiprio virtqueue index.

This patch also renames the enum elements to make it explicit that these
representing virtqueue type (and not index).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index cb3c7bf8cce4..eef9591de640 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -24,6 +24,8 @@
  */
 #define FUSE_HEADER_OVERHEAD    4
 
+#define VQ_HIPRIO_IDX	0
+
 /* List of virtio-fs device instances and a lock for the list. Also provides
  * mutual exclusion in device removal and mounting path
  */
@@ -31,8 +33,8 @@ static DEFINE_MUTEX(virtio_fs_mutex);
 static LIST_HEAD(virtio_fs_instances);
 
 enum {
-	VQ_HIPRIO,
-	VQ_REQUEST
+	VQ_TYPE_HIPRIO,
+	VQ_TYPE_REQUEST
 };
 
 #define VQ_NAME_LEN	24
@@ -651,7 +653,7 @@ static void virtio_fs_init_vq(struct virtio_fs_vq *fsvq, char *name,
 	INIT_LIST_HEAD(&fsvq->end_reqs);
 	init_completion(&fsvq->in_flight_zero);
 
-	if (vq_type == VQ_REQUEST) {
+	if (vq_type == VQ_TYPE_REQUEST) {
 		INIT_WORK(&fsvq->done_work, virtio_fs_requests_done_work);
 		INIT_DELAYED_WORK(&fsvq->dispatch_work,
 				  virtio_fs_request_dispatch_work);
@@ -680,23 +682,24 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 	/* One hiprio queue and rest are request queues */
 	fs->nvqs = 1 + fs->num_request_queues;
 	fs->first_reqq_idx = 1;
-	fs->vqs = kcalloc(fs->nvqs, sizeof(fs->vqs[VQ_HIPRIO]), GFP_KERNEL);
+	fs->vqs = kcalloc(fs->nvqs, sizeof(fs->vqs[VQ_HIPRIO_IDX]), GFP_KERNEL);
 	if (!fs->vqs)
 		return -ENOMEM;
 
-	vqs = kmalloc_array(fs->nvqs, sizeof(vqs[VQ_HIPRIO]), GFP_KERNEL);
-	callbacks = kmalloc_array(fs->nvqs, sizeof(callbacks[VQ_HIPRIO]),
+	vqs = kmalloc_array(fs->nvqs, sizeof(vqs[VQ_HIPRIO_IDX]), GFP_KERNEL);
+	callbacks = kmalloc_array(fs->nvqs, sizeof(callbacks[VQ_HIPRIO_IDX]),
 					GFP_KERNEL);
-	names = kmalloc_array(fs->nvqs, sizeof(names[VQ_HIPRIO]), GFP_KERNEL);
+	names = kmalloc_array(fs->nvqs, sizeof(names[VQ_HIPRIO_IDX]),
+			      GFP_KERNEL);
 	if (!vqs || !callbacks || !names) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	/* Initialize the hiprio/forget request virtqueue */
-	callbacks[VQ_HIPRIO] = virtio_fs_vq_done;
-	virtio_fs_init_vq(&fs->vqs[VQ_HIPRIO], "hiprio", VQ_HIPRIO);
-	names[VQ_HIPRIO] = fs->vqs[VQ_HIPRIO].name;
+	callbacks[VQ_HIPRIO_IDX] = virtio_fs_vq_done;
+	virtio_fs_init_vq(&fs->vqs[VQ_HIPRIO_IDX], "hiprio", VQ_TYPE_HIPRIO);
+	names[VQ_HIPRIO_IDX] = fs->vqs[VQ_HIPRIO_IDX].name;
 
 	/* Initialize the requests virtqueues */
 	for (i = fs->first_reqq_idx; i < fs->nvqs; i++) {
@@ -704,7 +707,7 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 
 		snprintf(vq_name, VQ_NAME_LEN, "requests.%u",
 			 i - fs->first_reqq_idx);
-		virtio_fs_init_vq(&fs->vqs[i], vq_name, VQ_REQUEST);
+		virtio_fs_init_vq(&fs->vqs[i], vq_name, VQ_TYPE_REQUEST);
 		callbacks[i] = virtio_fs_vq_done;
 		names[i] = fs->vqs[i].name;
 	}
@@ -985,7 +988,7 @@ __releases(fiq->lock)
 	unique = fuse_get_unique(fiq);
 
 	fs = fiq->priv;
-	fsvq = &fs->vqs[VQ_HIPRIO];
+	fsvq = &fs->vqs[VQ_HIPRIO_IDX];
 	spin_unlock(&fiq->lock);
 
 	/* Allocate a buffer for the request */
@@ -1359,7 +1362,7 @@ static void virtio_fs_conn_destroy(struct fuse_mount *fm)
 {
 	struct fuse_conn *fc = fm->fc;
 	struct virtio_fs *vfs = fc->iq.priv;
-	struct virtio_fs_vq *fsvq = &vfs->vqs[VQ_HIPRIO];
+	struct virtio_fs_vq *fsvq = &vfs->vqs[VQ_HIPRIO_IDX];
 
 	/* Stop dax worker. Soon evict_inodes() will be called which
 	 * will free all memory ranges belonging to all inodes.
-- 
2.31.1

