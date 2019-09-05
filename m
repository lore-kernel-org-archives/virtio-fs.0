From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:44 -0400
Message-Id: <20190905194859.16219-4-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 03/18] virtiofs: Pass fsvq instead of vq as
	parameter to virtio_fs_enqueue_req
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

Pass fsvq instead of vq as parameter to virtio_fs_enqueue_req(). We will
retrieve vq from fsvq under spin lock.

Later in the patch series we will retrieve vq only if fsvq is still connected
other vq might have been cleaned up by device ->remove code and we will
return error.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index e9497b565dd8..9d30530e3ca9 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -698,14 +698,15 @@ static unsigned int sg_init_fuse_args(struct scatterlist *sg,
 }
 
 /* Add a request to a virtqueue and kick the device */
-static int virtio_fs_enqueue_req(struct virtqueue *vq, struct fuse_req *req)
+static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
+				 struct fuse_req *req)
 {
 	/* requests need at least 4 elements */
 	struct scatterlist *stack_sgs[6];
 	struct scatterlist stack_sg[ARRAY_SIZE(stack_sgs)];
 	struct scatterlist **sgs = stack_sgs;
 	struct scatterlist *sg = stack_sg;
-	struct virtio_fs_vq *fsvq;
+	struct virtqueue *vq;
 	unsigned int argbuf_used = 0;
 	unsigned int out_sgs = 0;
 	unsigned int in_sgs = 0;
@@ -752,9 +753,9 @@ static int virtio_fs_enqueue_req(struct virtqueue *vq, struct fuse_req *req)
 	for (i = 0; i < total_sgs; i++)
 		sgs[i] = &sg[i];
 
-	fsvq = vq_to_fsvq(vq);
 	spin_lock(&fsvq->lock);
 
+	vq = fsvq->vq;
 	ret = virtqueue_add_sgs(vq, sgs, out_sgs, in_sgs, req, GFP_ATOMIC);
 	if (ret < 0) {
 		/* TODO handle full virtqueue */
@@ -824,7 +825,7 @@ __releases(fiq->waitq.lock)
 	/* TODO check for FR_INTERRUPTED? */
 
 retry:
-	ret = virtio_fs_enqueue_req(fs->vqs[queue_id].vq, req);
+	ret = virtio_fs_enqueue_req(&fs->vqs[queue_id], req);
 	if (ret < 0) {
 		if (ret == -ENOMEM || ret == -ENOSPC) {
 			/* Virtqueue full. Retry submission */
-- 
2.20.1

