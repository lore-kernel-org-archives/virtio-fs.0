From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 15 Nov 2019 15:57:03 -0500
Message-Id: <20191115205705.2046-3-vgoyal@redhat.com>
In-Reply-To: <20191115205705.2046-1-vgoyal@redhat.com>
References: <20191115205705.2046-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/4] virtiofs: Add an index to keep track of
	first request queue
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

We have many virtqueues and first queue which carries fuse normal requests
(except forget requests) has index pointed to by enum VQ_REQUEST. This works
fine as long as number of queues are not dynamic.

I am about to introduce one more virtqueue, called notification queue, which
will be present only if device on host supports it. That means index of
request queue will change depending on if notification queue is present
or not.

So, add a variable to keep track of that index and this will help when
notification queue is added in next patch.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index a0fb0a93980c..1ab4b7b83707 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -49,6 +49,7 @@ struct virtio_fs {
 	struct virtio_fs_vq *vqs;
 	unsigned int nvqs;               /* number of virtqueues */
 	unsigned int num_request_queues; /* number of request queues */
+	unsigned int first_reqq_idx;	/* First request queue idx */
 };
 
 struct virtio_fs_forget_req {
@@ -597,7 +598,9 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 	if (fs->num_request_queues == 0)
 		return -EINVAL;
 
-	fs->nvqs = VQ_REQUEST + fs->num_request_queues;
+	/* One hiprio queue and rest are request queues */
+	fs->nvqs = 1 + fs->num_request_queues;
+	fs->first_reqq_idx = 1;
 	fs->vqs = kcalloc(fs->nvqs, sizeof(fs->vqs[VQ_HIPRIO]), GFP_KERNEL);
 	if (!fs->vqs)
 		return -ENOMEM;
@@ -617,10 +620,11 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 	names[VQ_HIPRIO] = fs->vqs[VQ_HIPRIO].name;
 
 	/* Initialize the requests virtqueues */
-	for (i = VQ_REQUEST; i < fs->nvqs; i++) {
+	for (i = fs->first_reqq_idx; i < fs->nvqs; i++) {
 		char vq_name[VQ_NAME_LEN];
 
-		snprintf(vq_name, VQ_NAME_LEN, "requests.%u", i - VQ_REQUEST);
+		snprintf(vq_name, VQ_NAME_LEN, "requests.%u",
+			 i - fs->first_reqq_idx);
 		virtio_fs_init_vq(&fs->vqs[i], vq_name, VQ_REQUEST);
 		callbacks[i] = virtio_fs_vq_done;
 		names[i] = fs->vqs[i].name;
@@ -990,7 +994,7 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 static void virtio_fs_wake_pending_and_unlock(struct fuse_iqueue *fiq)
 __releases(fiq->lock)
 {
-	unsigned int queue_id = VQ_REQUEST; /* TODO multiqueue */
+	unsigned int queue_id;
 	struct virtio_fs *fs;
 	struct fuse_req *req;
 	struct virtio_fs_vq *fsvq;
@@ -1004,6 +1008,7 @@ __releases(fiq->lock)
 	spin_unlock(&fiq->lock);
 
 	fs = fiq->priv;
+	queue_id = fs->first_reqq_idx;
 
 	pr_debug("%s: opcode %u unique %#llx nodeid %#llx in.len %u out.len %u\n",
 		  __func__, req->in.h.opcode, req->in.h.unique,
@@ -1077,7 +1082,7 @@ static int virtio_fs_fill_super(struct super_block *sb)
 
 	err = -ENOMEM;
 	/* Allocate fuse_dev for hiprio and notification queues */
-	for (i = 0; i < VQ_REQUEST; i++) {
+	for (i = 0; i < fs->first_reqq_idx; i++) {
 		struct virtio_fs_vq *fsvq = &fs->vqs[i];
 
 		fsvq->fud = fuse_dev_alloc();
@@ -1085,17 +1090,17 @@ static int virtio_fs_fill_super(struct super_block *sb)
 			goto err_free_fuse_devs;
 	}
 
-	ctx.fudptr = (void **)&fs->vqs[VQ_REQUEST].fud;
+	ctx.fudptr = (void **)&fs->vqs[fs->first_reqq_idx].fud;
 	err = fuse_fill_super_common(sb, &ctx);
 	if (err < 0)
 		goto err_free_fuse_devs;
 
-	fc = fs->vqs[VQ_REQUEST].fud->fc;
+	fc = fs->vqs[fs->first_reqq_idx].fud->fc;
 
 	for (i = 0; i < fs->nvqs; i++) {
 		struct virtio_fs_vq *fsvq = &fs->vqs[i];
 
-		if (i == VQ_REQUEST)
+		if (i == fs->first_reqq_idx)
 			continue; /* already initialized */
 		fuse_dev_install(fsvq->fud, fc);
 	}
-- 
2.20.1

