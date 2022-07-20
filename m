Return-Path: <lulu@redhat.com>
From: Cindy Lu <lulu@redhat.com>
Date: Wed, 20 Jul 2022 21:11:55 +0800
Message-Id: <20220720131204.591104-2-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v13 01/10] virtio: introduce macro
 VIRTIO_CONFIG_IRQ_IDX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: lulu@redhat.com, qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>

To support configure interrupt for vhost-vdpa
Introduce VIRTIO_CONFIG_IRQ_IDX -1 as configure interrupt's queue index,
Then we can reuse the functions guest_notifier_mask and guest_notifier_pending.
Add the check of queue index in these drivers, if the driver does not support
configure interrupt, the function will just return

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 hw/display/vhost-user-gpu.c    | 13 +++++++++++++
 hw/net/virtio-net.c            | 20 ++++++++++++++++++--
 hw/virtio/vhost-user-fs.c      | 14 ++++++++++++++
 hw/virtio/vhost-vsock-common.c | 14 ++++++++++++++
 hw/virtio/virtio-crypto.c      | 14 ++++++++++++++
 include/hw/virtio/virtio.h     |  3 +++
 6 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
index 09818231bd..e956f8c7a3 100644
--- a/hw/display/vhost-user-gpu.c
+++ b/hw/display/vhost-user-gpu.c
@@ -485,6 +485,12 @@ vhost_user_gpu_guest_notifier_pending(VirtIODevice *vdev, int idx)
 {
     VhostUserGPU *g = VHOST_USER_GPU(vdev);
 
+    /* Add the check for configure interrupt, we use VIRTIO_CONFIG_IRQ_IDX -1
+     * as the Marco of configure interrupt, If this driver does not
+     * support, the function will just return false */
+    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        return false;
+    }
     return vhost_virtqueue_pending(&g->vhost->dev, idx);
 }
 
@@ -493,6 +499,13 @@ vhost_user_gpu_guest_notifier_mask(VirtIODevice *vdev, int idx, bool mask)
 {
     VhostUserGPU *g = VHOST_USER_GPU(vdev);
 
+    /* Add the check for configure interrupt,Here use VIRTIO_CONFIG_IRQ_IDX -1
+     * as the Marco of configure interrupt, If this driver does not
+     * support, the function will return */
+
+    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        return;
+    }
     vhost_virtqueue_mask(&g->vhost->dev, vdev, idx, mask);
 }
 
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index 1067e72b39..a566936e5c 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -3172,6 +3172,14 @@ static bool virtio_net_guest_notifier_pending(VirtIODevice *vdev, int idx)
     VirtIONet *n = VIRTIO_NET(vdev);
     NetClientState *nc = qemu_get_subqueue(n->nic, vq2q(idx));
     assert(n->vhost_started);
+
+    /* Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
+     * as the Marco of configure interrupt's IDX, If this driver does not
+     * support, the function will return false */
+
+    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        return false;
+    }
     return vhost_net_virtqueue_pending(get_vhost_net(nc->peer), idx);
 }
 
@@ -3181,8 +3189,16 @@ static void virtio_net_guest_notifier_mask(VirtIODevice *vdev, int idx,
     VirtIONet *n = VIRTIO_NET(vdev);
     NetClientState *nc = qemu_get_subqueue(n->nic, vq2q(idx));
     assert(n->vhost_started);
-    vhost_net_virtqueue_mask(get_vhost_net(nc->peer),
-                             vdev, idx, mask);
+
+    /* Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
+     * as the Marco of configure interrupt's IDX, If this driver does not
+     * support, the function will return */
+
+    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        return;
+    }
+
+    vhost_net_virtqueue_mask(get_vhost_net(nc->peer), vdev, idx, mask);
 }
 
 static void virtio_net_set_config_size(VirtIONet *n, uint64_t host_features)
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index c595957983..f2e52b6446 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -161,6 +161,13 @@ static void vuf_guest_notifier_mask(VirtIODevice *vdev, int idx,
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
 
+    /* Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
+     * as the Marco of configure interrupt's IDX, If this driver does not
+     * support, the function will return */
+
+    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        return;
+    }
     vhost_virtqueue_mask(&fs->vhost_dev, vdev, idx, mask);
 }
 
@@ -168,6 +175,13 @@ static bool vuf_guest_notifier_pending(VirtIODevice *vdev, int idx)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
 
+    /* Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
+     * as the Marco of configure interrupt's IDX, If this driver does not
+     * support, the function will return */
+
+    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        return false;
+    }
     return vhost_virtqueue_pending(&fs->vhost_dev, idx);
 }
 
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index ed706681ac..1ceeaaf762 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -125,6 +125,13 @@ static void vhost_vsock_common_guest_notifier_mask(VirtIODevice *vdev, int idx,
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
 
+    /* Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
+     * as the Marco of configure interrupt's IDX, If this driver does not
+     * support, the function will return */
+
+    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        return;
+    }
     vhost_virtqueue_mask(&vvc->vhost_dev, vdev, idx, mask);
 }
 
@@ -133,6 +140,13 @@ static bool vhost_vsock_common_guest_notifier_pending(VirtIODevice *vdev,
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
 
+    /* Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
+     * as the Marco of configure interrupt's IDX, If this driver does not
+     * support, the function will return */
+
+    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        return false;
+    }
     return vhost_virtqueue_pending(&vvc->vhost_dev, idx);
 }
 
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index dcd80b904d..ec6e4a0a94 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -948,6 +948,13 @@ static void virtio_crypto_guest_notifier_mask(VirtIODevice *vdev, int idx,
 
     assert(vcrypto->vhost_started);
 
+    /* Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
+     * as the Marco of configure interrupt's IDX, If this driver does not
+     * support, the function will return */
+
+    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        return;
+    }
     cryptodev_vhost_virtqueue_mask(vdev, queue, idx, mask);
 }
 
@@ -958,6 +965,13 @@ static bool virtio_crypto_guest_notifier_pending(VirtIODevice *vdev, int idx)
 
     assert(vcrypto->vhost_started);
 
+    /* Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
+     * as the Marco of configure interrupt's IDX, If this driver does not
+     * support, the function will return */
+
+    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        return false;
+    }
     return cryptodev_vhost_virtqueue_pending(vdev, queue, idx);
 }
 
diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index b31c4507f5..4512205503 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -67,6 +67,9 @@ typedef struct VirtQueueElement
 
 #define VIRTIO_NO_VECTOR 0xffff
 
+/* special index value used internally for config irqs */
+#define VIRTIO_CONFIG_IRQ_IDX -1
+
 #define TYPE_VIRTIO_DEVICE "virtio-device"
 OBJECT_DECLARE_TYPE(VirtIODevice, VirtioDeviceClass, VIRTIO_DEVICE)
 
-- 
2.34.3

