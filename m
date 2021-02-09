From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:03 +0000
Message-Id: <20210209190224.62827-4-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 03/24] DAX: libvhost-user: Allow popping a queue
	element with bad pointers
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Allow a daemon implemented with libvhost-user to accept an
element with pointers to memory that aren't in the mapping table.
The daemon might have some special way to deal with some special
cases of this.

The default behaviour doesn't change.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 block/export/vhost-user-blk-server.c      |  2 +-
 contrib/vhost-user-blk/vhost-user-blk.c   |  3 +-
 contrib/vhost-user-gpu/vhost-user-gpu.c   |  5 ++-
 contrib/vhost-user-input/main.c           |  4 +-
 contrib/vhost-user-scsi/vhost-user-scsi.c |  2 +-
 subprojects/libvhost-user/libvhost-user.c | 51 ++++++++++++++++++-----
 subprojects/libvhost-user/libvhost-user.h |  8 +++-
 tests/vhost-user-bridge.c                 |  4 +-
 tools/virtiofsd/fuse_virtio.c             |  3 +-
 9 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/block/export/vhost-user-blk-server.c b/block/export/vhost-user-blk-server.c
index ab2c4d44c4..ea2d302e33 100644
--- a/block/export/vhost-user-blk-server.c
+++ b/block/export/vhost-user-blk-server.c
@@ -205,7 +205,7 @@ static void vu_blk_process_vq(VuDev *vu_dev, int idx)
     while (1) {
         VuBlkReq *req;
 
-        req = vu_queue_pop(vu_dev, vq, sizeof(VuBlkReq));
+        req = vu_queue_pop(vu_dev, vq, sizeof(VuBlkReq), NULL, NULL);
         if (!req) {
             break;
         }
diff --git a/contrib/vhost-user-blk/vhost-user-blk.c b/contrib/vhost-user-blk/vhost-user-blk.c
index d14b2896bf..01193552e9 100644
--- a/contrib/vhost-user-blk/vhost-user-blk.c
+++ b/contrib/vhost-user-blk/vhost-user-blk.c
@@ -235,7 +235,8 @@ static int vub_virtio_process_req(VubDev *vdev_blk,
     unsigned out_num;
     VubReq *req;
 
-    elem = vu_queue_pop(vu_dev, vq, sizeof(VuVirtqElement) + sizeof(VubReq));
+    elem = vu_queue_pop(vu_dev, vq, sizeof(VuVirtqElement) + sizeof(VubReq),
+                        NULL, NULL);
     if (!elem) {
         return -1;
     }
diff --git a/contrib/vhost-user-gpu/vhost-user-gpu.c b/contrib/vhost-user-gpu/vhost-user-gpu.c
index b27990ffdb..58f50ae83f 100644
--- a/contrib/vhost-user-gpu/vhost-user-gpu.c
+++ b/contrib/vhost-user-gpu/vhost-user-gpu.c
@@ -840,7 +840,8 @@ vg_handle_ctrl(VuDev *dev, int qidx)
             return;
         }
 
-        cmd = vu_queue_pop(dev, vq, sizeof(struct virtio_gpu_ctrl_command));
+        cmd = vu_queue_pop(dev, vq, sizeof(struct virtio_gpu_ctrl_command),
+                           NULL, NULL);
         if (!cmd) {
             break;
         }
@@ -943,7 +944,7 @@ vg_handle_cursor(VuDev *dev, int qidx)
     struct virtio_gpu_update_cursor cursor;
 
     for (;;) {
-        elem = vu_queue_pop(dev, vq, sizeof(VuVirtqElement));
+        elem = vu_queue_pop(dev, vq, sizeof(VuVirtqElement), NULL, NULL);
         if (!elem) {
             break;
         }
diff --git a/contrib/vhost-user-input/main.c b/contrib/vhost-user-input/main.c
index c15d18c33f..d5c435605c 100644
--- a/contrib/vhost-user-input/main.c
+++ b/contrib/vhost-user-input/main.c
@@ -57,7 +57,7 @@ static void vi_input_send(VuInput *vi, struct virtio_input_event *event)
 
     /* ... then check available space ... */
     for (i = 0; i < vi->qindex; i++) {
-        elem = vu_queue_pop(dev, vq, sizeof(VuVirtqElement));
+        elem = vu_queue_pop(dev, vq, sizeof(VuVirtqElement), NULL, NULL);
         if (!elem) {
             while (--i >= 0) {
                 vu_queue_unpop(dev, vq, vi->queue[i].elem, 0);
@@ -141,7 +141,7 @@ static void vi_handle_sts(VuDev *dev, int qidx)
     g_debug("%s", G_STRFUNC);
 
     for (;;) {
-        elem = vu_queue_pop(dev, vq, sizeof(VuVirtqElement));
+        elem = vu_queue_pop(dev, vq, sizeof(VuVirtqElement), NULL, NULL);
         if (!elem) {
             break;
         }
diff --git a/contrib/vhost-user-scsi/vhost-user-scsi.c b/contrib/vhost-user-scsi/vhost-user-scsi.c
index 4f6e3e2a24..7564d6ab2d 100644
--- a/contrib/vhost-user-scsi/vhost-user-scsi.c
+++ b/contrib/vhost-user-scsi/vhost-user-scsi.c
@@ -252,7 +252,7 @@ static void vus_proc_req(VuDev *vu_dev, int idx)
         VirtIOSCSICmdReq *req;
         VirtIOSCSICmdResp *rsp;
 
-        elem = vu_queue_pop(vu_dev, vq, sizeof(VuVirtqElement));
+        elem = vu_queue_pop(vu_dev, vq, sizeof(VuVirtqElement), NULL, NULL);
         if (!elem) {
             g_debug("No more elements pending on vq[%d]@%p", idx, vq);
             break;
diff --git a/subprojects/libvhost-user/libvhost-user.c b/subprojects/libvhost-user/libvhost-user.c
index 937f64480d..68eb165755 100644
--- a/subprojects/libvhost-user/libvhost-user.c
+++ b/subprojects/libvhost-user/libvhost-user.c
@@ -2469,7 +2469,8 @@ vu_queue_set_notification(VuDev *dev, VuVirtq *vq, int enable)
 
 static bool
 virtqueue_map_desc(VuDev *dev,
-                   unsigned int *p_num_sg, struct iovec *iov,
+                   unsigned int *p_num_sg, unsigned int *p_bad_sg,
+                   struct iovec *iov,
                    unsigned int max_num_sg, bool is_write,
                    uint64_t pa, size_t sz)
 {
@@ -2490,10 +2491,35 @@ virtqueue_map_desc(VuDev *dev,
             return false;
         }
 
-        iov[num_sg].iov_base = vu_gpa_to_va(dev, &len, pa);
-        if (iov[num_sg].iov_base == NULL) {
-            vu_panic(dev, "virtio: invalid address for buffers");
-            return false;
+        if (p_bad_sg && *p_bad_sg) {
+            /* A previous mapping was bad, we won't try and map this either */
+            *p_bad_sg = *p_bad_sg + 1;
+        }
+        if (!p_bad_sg || !*p_bad_sg) {
+            /* No bad mappings so far, lets try mapping this one */
+            iov[num_sg].iov_base = vu_gpa_to_va(dev, &len, pa);
+            if (iov[num_sg].iov_base == NULL) {
+                /*
+                 * OK, it won't map, either panic or if the caller can handle
+                 * it, then count it.
+                 */
+                if (!p_bad_sg) {
+                    vu_panic(dev, "virtio: invalid address for buffers");
+                    return false;
+                } else {
+                    *p_bad_sg = *p_bad_sg + 1;
+                }
+            }
+        }
+        if (p_bad_sg && *p_bad_sg) {
+            /*
+             * There was a bad mapping, either now or previously, since
+             * the caller set p_bad_sg it means it's prepared to deal with
+             * it, so give it the pa in the iov
+             * Note: In this case len will be the whole sz, so we won't
+             * go around again for this descriptor
+             */
+            iov[num_sg].iov_base = (void *)(uintptr_t)pa;
         }
         iov[num_sg].iov_len = len;
         num_sg++;
@@ -2524,7 +2550,8 @@ virtqueue_alloc_element(size_t sz,
 }
 
 static void *
-vu_queue_map_desc(VuDev *dev, VuVirtq *vq, unsigned int idx, size_t sz)
+vu_queue_map_desc(VuDev *dev, VuVirtq *vq, unsigned int idx, size_t sz,
+                  unsigned int *p_bad_in, unsigned int *p_bad_out)
 {
     struct vring_desc *desc = vq->vring.desc;
     uint64_t desc_addr, read_len;
@@ -2568,7 +2595,7 @@ vu_queue_map_desc(VuDev *dev, VuVirtq *vq, unsigned int idx, size_t sz)
     /* Collect all the descriptors */
     do {
         if (le16toh(desc[i].flags) & VRING_DESC_F_WRITE) {
-            if (!virtqueue_map_desc(dev, &in_num, iov + out_num,
+            if (!virtqueue_map_desc(dev, &in_num, p_bad_in, iov + out_num,
                                VIRTQUEUE_MAX_SIZE - out_num, true,
                                le64toh(desc[i].addr),
                                le32toh(desc[i].len))) {
@@ -2579,7 +2606,7 @@ vu_queue_map_desc(VuDev *dev, VuVirtq *vq, unsigned int idx, size_t sz)
                 vu_panic(dev, "Incorrect order for descriptors");
                 return NULL;
             }
-            if (!virtqueue_map_desc(dev, &out_num, iov,
+            if (!virtqueue_map_desc(dev, &out_num, p_bad_out, iov,
                                VIRTQUEUE_MAX_SIZE, false,
                                le64toh(desc[i].addr),
                                le32toh(desc[i].len))) {
@@ -2669,7 +2696,8 @@ vu_queue_inflight_post_put(VuDev *dev, VuVirtq *vq, int desc_idx)
 }
 
 void *
-vu_queue_pop(VuDev *dev, VuVirtq *vq, size_t sz)
+vu_queue_pop(VuDev *dev, VuVirtq *vq, size_t sz,
+             unsigned int *p_bad_in, unsigned int *p_bad_out)
 {
     int i;
     unsigned int head;
@@ -2682,7 +2710,8 @@ vu_queue_pop(VuDev *dev, VuVirtq *vq, size_t sz)
 
     if (unlikely(vq->resubmit_list && vq->resubmit_num > 0)) {
         i = (--vq->resubmit_num);
-        elem = vu_queue_map_desc(dev, vq, vq->resubmit_list[i].index, sz);
+        elem = vu_queue_map_desc(dev, vq, vq->resubmit_list[i].index, sz,
+                                 p_bad_in, p_bad_out);
 
         if (!vq->resubmit_num) {
             free(vq->resubmit_list);
@@ -2714,7 +2743,7 @@ vu_queue_pop(VuDev *dev, VuVirtq *vq, size_t sz)
         vring_set_avail_event(vq, vq->last_avail_idx);
     }
 
-    elem = vu_queue_map_desc(dev, vq, head, sz);
+    elem = vu_queue_map_desc(dev, vq, head, sz, p_bad_in, p_bad_out);
 
     if (!elem) {
         return NULL;
diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
index 3d13dfadde..330b61c005 100644
--- a/subprojects/libvhost-user/libvhost-user.h
+++ b/subprojects/libvhost-user/libvhost-user.h
@@ -589,11 +589,17 @@ void vu_queue_notify_sync(VuDev *dev, VuVirtq *vq);
  * @dev: a VuDev context
  * @vq: a VuVirtq queue
  * @sz: the size of struct to return (must be >= VuVirtqElement)
+ * @p_bad_in: If none NULL, a pointer to an integer count of
+ *            unmappable regions in input descriptors
+ * @p_bad_out: If none NULL, a pointer to an integer count of
+ *            unmappable regions in output descriptors
+ *
  *
  * Returns: a VuVirtqElement filled from the queue or NULL. The
  * returned element must be free()-d by the caller.
  */
-void *vu_queue_pop(VuDev *dev, VuVirtq *vq, size_t sz);
+void *vu_queue_pop(VuDev *dev, VuVirtq *vq, size_t sz,
+                   unsigned int *p_bad_in, unsigned int *p_bad_out);
 
 
 /**
diff --git a/tests/vhost-user-bridge.c b/tests/vhost-user-bridge.c
index 24815920b2..4f6829e6c3 100644
--- a/tests/vhost-user-bridge.c
+++ b/tests/vhost-user-bridge.c
@@ -184,7 +184,7 @@ vubr_handle_tx(VuDev *dev, int qidx)
         unsigned int out_num;
         struct iovec sg[VIRTQUEUE_MAX_SIZE], *out_sg;
 
-        elem = vu_queue_pop(dev, vq, sizeof(VuVirtqElement));
+        elem = vu_queue_pop(dev, vq, sizeof(VuVirtqElement), NULL, NULL);
         if (!elem) {
             break;
         }
@@ -299,7 +299,7 @@ vubr_backend_recv_cb(int sock, void *ctx)
         ssize_t ret, total = 0;
         unsigned int num;
 
-        elem = vu_queue_pop(dev, vq, sizeof(VuVirtqElement));
+        elem = vu_queue_pop(dev, vq, sizeof(VuVirtqElement), NULL, NULL);
         if (!elem) {
             break;
         }
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index ddcefee427..bd19358437 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -657,7 +657,8 @@ static void *fv_queue_thread(void *opaque)
                  __func__, qi->qidx, (size_t)evalue, in_bytes, out_bytes);
 
         while (1) {
-            FVRequest *req = vu_queue_pop(dev, q, sizeof(FVRequest));
+            FVRequest *req = vu_queue_pop(dev, q, sizeof(FVRequest),
+                                          NULL, NULL);
             if (!req) {
                 break;
             }
-- 
2.29.2

