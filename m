From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:01 +0000
Message-Id: <20210209190224.62827-2-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 01/24] DAX: vhost-user: Rework slave return
	values
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

All the current slave handlers on the qemu side generate an 'int'
return value that's squashed down to a bool (!!ret) and stuffed into
a uint64_t (field of a union) to be returned.

Move the uint64_t type back up through the individual handlers so
that we can mkae one actually return a full uint64_t.

Note that the definition in the interop spec says most of these
cases are defined as returning 0 on success and non-0 for failure,
so it's OK to change from a bool to another non-0.

Vivek:
This is needed because upcoming patches in series will add new functions
which want to return full error code. Existing functions continue to
return true/false so, it should not lead to change of behavior for
existing users.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 hw/virtio/vhost-backend.c         |  4 ++--
 hw/virtio/vhost-user.c            | 32 ++++++++++++++++---------------
 include/hw/virtio/vhost-backend.h |  2 +-
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
index 31b33bde37..21082084ea 100644
--- a/hw/virtio/vhost-backend.c
+++ b/hw/virtio/vhost-backend.c
@@ -401,7 +401,7 @@ int vhost_backend_invalidate_device_iotlb(struct vhost_dev *dev,
     return -ENODEV;
 }
 
-int vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
+uint64_t vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
                                           struct vhost_iotlb_msg *imsg)
 {
     int ret = 0;
@@ -429,5 +429,5 @@ int vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
         break;
     }
 
-    return ret;
+    return !!ret;
 }
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 2fdd5daf74..13789cc55e 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -1317,24 +1317,25 @@ static int vhost_user_reset_device(struct vhost_dev *dev)
     return 0;
 }
 
-static int vhost_user_slave_handle_config_change(struct vhost_dev *dev)
+static uint64_t vhost_user_slave_handle_config_change(struct vhost_dev *dev)
 {
     int ret = -1;
 
     if (!dev->config_ops) {
-        return -1;
+        return true;
     }
 
     if (dev->config_ops->vhost_dev_config_notifier) {
         ret = dev->config_ops->vhost_dev_config_notifier(dev);
     }
 
-    return ret;
+    return !!ret;
 }
 
-static int vhost_user_slave_handle_vring_host_notifier(struct vhost_dev *dev,
-                                                       VhostUserVringArea *area,
-                                                       int fd)
+static uint64_t vhost_user_slave_handle_vring_host_notifier(
+                struct vhost_dev *dev,
+               VhostUserVringArea *area,
+               int fd)
 {
     int queue_idx = area->u64 & VHOST_USER_VRING_IDX_MASK;
     size_t page_size = qemu_real_host_page_size;
@@ -1348,7 +1349,7 @@ static int vhost_user_slave_handle_vring_host_notifier(struct vhost_dev *dev,
     if (!virtio_has_feature(dev->protocol_features,
                             VHOST_USER_PROTOCOL_F_HOST_NOTIFIER) ||
         vdev == NULL || queue_idx >= virtio_get_num_queues(vdev)) {
-        return -1;
+        return true;
     }
 
     n = &user->notifier[queue_idx];
@@ -1361,18 +1362,18 @@ static int vhost_user_slave_handle_vring_host_notifier(struct vhost_dev *dev,
     }
 
     if (area->u64 & VHOST_USER_VRING_NOFD_MASK) {
-        return 0;
+        return false;
     }
 
     /* Sanity check. */
     if (area->size != page_size) {
-        return -1;
+        return true;
     }
 
     addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED,
                 fd, area->offset);
     if (addr == MAP_FAILED) {
-        return -1;
+        return true;
     }
 
     name = g_strdup_printf("vhost-user/host-notifier@%p mmaps[%d]",
@@ -1383,13 +1384,13 @@ static int vhost_user_slave_handle_vring_host_notifier(struct vhost_dev *dev,
 
     if (virtio_queue_set_host_notifier_mr(vdev, queue_idx, &n->mr, true)) {
         munmap(addr, page_size);
-        return -1;
+        return true;
     }
 
     n->addr = addr;
     n->set = true;
 
-    return 0;
+    return false;
 }
 
 static void slave_read(void *opaque)
@@ -1398,7 +1399,8 @@ static void slave_read(void *opaque)
     struct vhost_user *u = dev->opaque;
     VhostUserHeader hdr = { 0, };
     VhostUserPayload payload = { 0, };
-    int size, ret = 0;
+    int size;
+    uint64_t ret = 0;
     struct iovec iov;
     struct msghdr msgh;
     int fd[VHOST_USER_SLAVE_MAX_FDS];
@@ -1472,7 +1474,7 @@ static void slave_read(void *opaque)
         break;
     default:
         error_report("Received unexpected msg type: %d.", hdr.request);
-        ret = -EINVAL;
+        ret = (uint64_t)-EINVAL;
     }
 
     /* Close the remaining file descriptors. */
@@ -1493,7 +1495,7 @@ static void slave_read(void *opaque)
         hdr.flags &= ~VHOST_USER_NEED_REPLY_MASK;
         hdr.flags |= VHOST_USER_REPLY_MASK;
 
-        payload.u64 = !!ret;
+        payload.u64 = ret;
         hdr.size = sizeof(payload.u64);
 
         iovec[0].iov_base = &hdr;
diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
index 8a6f8e2a7a..64ac6b6444 100644
--- a/include/hw/virtio/vhost-backend.h
+++ b/include/hw/virtio/vhost-backend.h
@@ -186,7 +186,7 @@ int vhost_backend_update_device_iotlb(struct vhost_dev *dev,
 int vhost_backend_invalidate_device_iotlb(struct vhost_dev *dev,
                                                  uint64_t iova, uint64_t len);
 
-int vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
+uint64_t vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
                                           struct vhost_iotlb_msg *imsg);
 
 int vhost_user_gpu_set_socket(struct vhost_dev *dev, int fd);
-- 
2.29.2

