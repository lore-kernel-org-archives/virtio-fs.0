Date: Mon, 10 Jan 2022 02:16:30 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20220110071547.195669-11-mst@redhat.com>
References: <20220110071547.195669-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220110071547.195669-1-mst@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PULL 10/10] Revert "virtio: introduce macro
	IRTIO_CONFIG_IRQ_IDX"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Jason Wang <jasowang@redhat.com>, virtio-fs@redhat.com, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>

This reverts commit bf1d85c166c19af95dbd27b1faba1d2909732323.
---
 include/hw/virtio/virtio.h     |  3 ---
 hw/display/vhost-user-gpu.c    |  6 ------
 hw/net/virtio-net.c            | 10 ++--------
 hw/virtio/vhost-user-fs.c      |  6 ------
 hw/virtio/vhost-vsock-common.c |  6 ------
 hw/virtio/virtio-crypto.c      |  6 ------
 6 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 605ea79c90..8bab9cfb75 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -67,9 +67,6 @@ typedef struct VirtQueueElement
 
 #define VIRTIO_NO_VECTOR 0xffff
 
-/* special index value used internally for config irqs */
-#define VIRTIO_CONFIG_IRQ_IDX -1
-
 #define TYPE_VIRTIO_DEVICE "virtio-device"
 OBJECT_DECLARE_TYPE(VirtIODevice, VirtioDeviceClass, VIRTIO_DEVICE)
 
diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
index d4a440e815..09818231bd 100644
--- a/hw/display/vhost-user-gpu.c
+++ b/hw/display/vhost-user-gpu.c
@@ -485,9 +485,6 @@ vhost_user_gpu_guest_notifier_pending(VirtIODevice *vdev, int idx)
 {
     VhostUserGPU *g = VHOST_USER_GPU(vdev);
 
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return false;
-    }
     return vhost_virtqueue_pending(&g->vhost->dev, idx);
 }
 
@@ -496,9 +493,6 @@ vhost_user_gpu_guest_notifier_mask(VirtIODevice *vdev, int idx, bool mask)
 {
     VhostUserGPU *g = VHOST_USER_GPU(vdev);
 
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return;
-    }
     vhost_virtqueue_mask(&g->vhost->dev, vdev, idx, mask);
 }
 
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index 5e03c0dd14..cf8ab0f8af 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -3168,9 +3168,6 @@ static bool virtio_net_guest_notifier_pending(VirtIODevice *vdev, int idx)
     VirtIONet *n = VIRTIO_NET(vdev);
     NetClientState *nc = qemu_get_subqueue(n->nic, vq2q(idx));
     assert(n->vhost_started);
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return false;
-    }
     return vhost_net_virtqueue_pending(get_vhost_net(nc->peer), idx);
 }
 
@@ -3180,11 +3177,8 @@ static void virtio_net_guest_notifier_mask(VirtIODevice *vdev, int idx,
     VirtIONet *n = VIRTIO_NET(vdev);
     NetClientState *nc = qemu_get_subqueue(n->nic, vq2q(idx));
     assert(n->vhost_started);
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return;
-    }
-
-    vhost_net_virtqueue_mask(get_vhost_net(nc->peer), vdev, idx, mask);
+    vhost_net_virtqueue_mask(get_vhost_net(nc->peer),
+                             vdev, idx, mask);
 }
 
 static void virtio_net_set_config_size(VirtIONet *n, uint64_t host_features)
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 9b0349922e..c595957983 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -161,9 +161,6 @@ static void vuf_guest_notifier_mask(VirtIODevice *vdev, int idx,
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
 
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return;
-    }
     vhost_virtqueue_mask(&fs->vhost_dev, vdev, idx, mask);
 }
 
@@ -171,9 +168,6 @@ static bool vuf_guest_notifier_pending(VirtIODevice *vdev, int idx)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
 
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return false;
-    }
     return vhost_virtqueue_pending(&fs->vhost_dev, idx);
 }
 
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index d1b9c027b6..3f3771274e 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -125,9 +125,6 @@ static void vhost_vsock_common_guest_notifier_mask(VirtIODevice *vdev, int idx,
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
 
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return;
-    }
     vhost_virtqueue_mask(&vvc->vhost_dev, vdev, idx, mask);
 }
 
@@ -136,9 +133,6 @@ static bool vhost_vsock_common_guest_notifier_pending(VirtIODevice *vdev,
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
 
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return false;
-    }
     return vhost_virtqueue_pending(&vvc->vhost_dev, idx);
 }
 
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index 1d5192f8b4..54f9bbb789 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -948,9 +948,6 @@ static void virtio_crypto_guest_notifier_mask(VirtIODevice *vdev, int idx,
 
     assert(vcrypto->vhost_started);
 
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return;
-    }
     cryptodev_vhost_virtqueue_mask(vdev, queue, idx, mask);
 }
 
@@ -961,9 +958,6 @@ static bool virtio_crypto_guest_notifier_pending(VirtIODevice *vdev, int idx)
 
     assert(vcrypto->vhost_started);
 
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return false;
-    }
     return cryptodev_vhost_virtqueue_pending(vdev, queue, idx);
 }
 
-- 
MST

