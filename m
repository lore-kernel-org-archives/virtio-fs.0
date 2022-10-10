Return-Path: <mst@redhat.com>
Date: Mon, 10 Oct 2022 13:29:05 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221010172813.204597-8-mst@redhat.com>
References: <20221010172813.204597-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221010172813.204597-1-mst@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 07/55] hw/virtio: move vm_running check to
 virtio_device_started
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, virtio-fs@redhat.com

From: Alex Bennée <alex.bennee@linaro.org>

All the boilerplate virtio code does the same thing (or should at
least) of checking to see if the VM is running before attempting to
start VirtIO. Push the logic up to the common function to avoid
getting a copy and paste wrong.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20220802095010.3330793-11-alex.bennee@linaro.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/hw/virtio/virtio.h   | 5 +++++
 hw/virtio/vhost-user-fs.c    | 6 +-----
 hw/virtio/vhost-user-i2c.c   | 6 +-----
 hw/virtio/vhost-user-rng.c   | 6 +-----
 hw/virtio/vhost-user-vsock.c | 6 +-----
 hw/virtio/vhost-vsock.c      | 6 +-----
 6 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 9bb2485415..74e7ad5a92 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -100,6 +100,7 @@ struct VirtIODevice
     VirtQueue *vq;
     MemoryListener listener;
     uint16_t device_id;
+    /* @vm_running: current VM running state via virtio_vmstate_change() */
     bool vm_running;
     bool broken; /* device in invalid state, needs reset */
     bool use_disabled_flag; /* allow use of 'disable' flag when needed */
@@ -376,6 +377,10 @@ static inline bool virtio_device_started(VirtIODevice *vdev, uint8_t status)
         return vdev->started;
     }
 
+    if (!vdev->vm_running) {
+        return false;
+    }
+
     return status & VIRTIO_CONFIG_S_DRIVER_OK;
 }
 
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index e513e4fdda..d2bebba785 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -122,11 +122,7 @@ static void vuf_stop(VirtIODevice *vdev)
 static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
-    bool should_start = status & VIRTIO_CONFIG_S_DRIVER_OK;
-
-    if (!vdev->vm_running) {
-        should_start = false;
-    }
+    bool should_start = virtio_device_started(vdev, status);
 
     if (fs->vhost_dev.started == should_start) {
         return;
diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
index 6020eee093..b930cf6d5e 100644
--- a/hw/virtio/vhost-user-i2c.c
+++ b/hw/virtio/vhost-user-i2c.c
@@ -93,11 +93,7 @@ static void vu_i2c_stop(VirtIODevice *vdev)
 static void vu_i2c_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-    bool should_start = status & VIRTIO_CONFIG_S_DRIVER_OK;
-
-    if (!vdev->vm_running) {
-        should_start = false;
-    }
+    bool should_start = virtio_device_started(vdev, status);
 
     if (i2c->vhost_dev.started == should_start) {
         return;
diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
index 3a7bf8e32d..a9c1c4bc79 100644
--- a/hw/virtio/vhost-user-rng.c
+++ b/hw/virtio/vhost-user-rng.c
@@ -90,11 +90,7 @@ static void vu_rng_stop(VirtIODevice *vdev)
 static void vu_rng_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-    bool should_start = status & VIRTIO_CONFIG_S_DRIVER_OK;
-
-    if (!vdev->vm_running) {
-        should_start = false;
-    }
+    bool should_start = virtio_device_started(vdev, status);
 
     if (rng->vhost_dev.started == should_start) {
         return;
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 0f8ff99f85..22c1616ebd 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -55,11 +55,7 @@ const VhostDevConfigOps vsock_ops = {
 static void vuv_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
-    bool should_start = status & VIRTIO_CONFIG_S_DRIVER_OK;
-
-    if (!vdev->vm_running) {
-        should_start = false;
-    }
+    bool should_start = virtio_device_started(vdev, status);
 
     if (vvc->vhost_dev.started == should_start) {
         return;
diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
index 0338de892f..8031c164a5 100644
--- a/hw/virtio/vhost-vsock.c
+++ b/hw/virtio/vhost-vsock.c
@@ -70,13 +70,9 @@ static int vhost_vsock_set_running(VirtIODevice *vdev, int start)
 static void vhost_vsock_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
-    bool should_start = status & VIRTIO_CONFIG_S_DRIVER_OK;
+    bool should_start = virtio_device_started(vdev, status);
     int ret;
 
-    if (!vdev->vm_running) {
-        should_start = false;
-    }
-
     if (vvc->vhost_dev.started == should_start) {
         return;
     }
-- 
MST

