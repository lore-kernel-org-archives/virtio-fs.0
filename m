Return-Path: <mst@redhat.com>
Date: Mon, 10 Oct 2022 13:29:10 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221010172813.204597-9-mst@redhat.com>
References: <20221010172813.204597-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221010172813.204597-1-mst@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 08/55] hw/virtio: move vhd->started check into
 helper and add FIXME
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Raphael Norwitz <raphael.norwittz@nutanix.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, qemu-block@nongnu.org, virtio-fs@redhat.com

From: Alex Bennée <alex.bennee@linaro.org>

The `started` field is manipulated internally within the vhost code
except for one place, vhost-user-blk via f5b22d06fb (vhost: recheck
dev state in the vhost_migration_log routine). Mark that as a FIXME
because it introduces a potential race. I think the referenced fix
should be tracking its state locally.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20220802095010.3330793-12-alex.bennee@linaro.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Raphael Norwitz <raphael.norwittz@nutanix.com>
---
 include/hw/virtio/vhost.h      | 12 ++++++++++++
 hw/block/vhost-user-blk.c      | 10 ++++++++--
 hw/scsi/vhost-scsi.c           |  4 ++--
 hw/scsi/vhost-user-scsi.c      |  2 +-
 hw/virtio/vhost-user-fs.c      |  3 ++-
 hw/virtio/vhost-user-i2c.c     |  4 ++--
 hw/virtio/vhost-user-rng.c     |  4 ++--
 hw/virtio/vhost-user-vsock.c   |  2 +-
 hw/virtio/vhost-vsock-common.c |  3 ++-
 hw/virtio/vhost-vsock.c        |  2 +-
 10 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 586c5457e2..61b957e927 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -94,6 +94,7 @@ struct vhost_dev {
     uint64_t protocol_features;
     uint64_t max_queues;
     uint64_t backend_cap;
+    /* @started: is the vhost device started? */
     bool started;
     bool log_enabled;
     uint64_t log_size;
@@ -165,6 +166,17 @@ int vhost_dev_enable_notifiers(struct vhost_dev *hdev, VirtIODevice *vdev);
  */
 void vhost_dev_disable_notifiers(struct vhost_dev *hdev, VirtIODevice *vdev);
 
+/**
+ * vhost_dev_is_started() - report status of vhost device
+ * @hdev: common vhost_dev structure
+ *
+ * Return the started status of the vhost device
+ */
+static inline bool vhost_dev_is_started(struct vhost_dev *hdev)
+{
+    return hdev->started;
+}
+
 /**
  * vhost_dev_start() - start the vhost device
  * @hdev: common vhost_dev structure
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 9117222456..2bba42478d 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -229,7 +229,7 @@ static void vhost_user_blk_set_status(VirtIODevice *vdev, uint8_t status)
         return;
     }
 
-    if (s->dev.started == should_start) {
+    if (vhost_dev_is_started(&s->dev) == should_start) {
         return;
     }
 
@@ -286,7 +286,7 @@ static void vhost_user_blk_handle_output(VirtIODevice *vdev, VirtQueue *vq)
         return;
     }
 
-    if (s->dev.started) {
+    if (vhost_dev_is_started(&s->dev)) {
         return;
     }
 
@@ -415,6 +415,12 @@ static void vhost_user_blk_event(void *opaque, QEMUChrEvent event)
              * the vhost migration code. If disconnect was caught there is an
              * option for the general vhost code to get the dev state without
              * knowing its type (in this case vhost-user).
+             *
+             * FIXME: this is sketchy to be reaching into vhost_dev
+             * now because we are forcing something that implies we
+             * have executed vhost_dev_stop() but that won't happen
+             * until vhost_user_blk_stop() gets called from the bh.
+             * Really this state check should be tracked locally.
              */
             s->dev.started = false;
         }
diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index 3059068175..bdf337a7a2 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -120,7 +120,7 @@ static void vhost_scsi_set_status(VirtIODevice *vdev, uint8_t val)
         start = false;
     }
 
-    if (vsc->dev.started == start) {
+    if (vhost_dev_is_started(&vsc->dev) == start) {
         return;
     }
 
@@ -147,7 +147,7 @@ static int vhost_scsi_pre_save(void *opaque)
 
     /* At this point, backend must be stopped, otherwise
      * it might keep writing to memory. */
-    assert(!vsc->dev.started);
+    assert(!vhost_dev_is_started(&vsc->dev));
 
     return 0;
 }
diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
index 1b2f7eed98..bc37317d55 100644
--- a/hw/scsi/vhost-user-scsi.c
+++ b/hw/scsi/vhost-user-scsi.c
@@ -49,7 +49,7 @@ static void vhost_user_scsi_set_status(VirtIODevice *vdev, uint8_t status)
     VHostSCSICommon *vsc = VHOST_SCSI_COMMON(s);
     bool start = (status & VIRTIO_CONFIG_S_DRIVER_OK) && vdev->vm_running;
 
-    if (vsc->dev.started == start) {
+    if (vhost_dev_is_started(&vsc->dev) == start) {
         return;
     }
 
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index d2bebba785..ad0f91c607 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -20,6 +20,7 @@
 #include "hw/virtio/virtio-bus.h"
 #include "hw/virtio/virtio-access.h"
 #include "qemu/error-report.h"
+#include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-user-fs.h"
 #include "monitor/monitor.h"
 #include "sysemu/sysemu.h"
@@ -124,7 +125,7 @@ static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
     VHostUserFS *fs = VHOST_USER_FS(vdev);
     bool should_start = virtio_device_started(vdev, status);
 
-    if (fs->vhost_dev.started == should_start) {
+    if (vhost_dev_is_started(&fs->vhost_dev) == should_start) {
         return;
     }
 
diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
index b930cf6d5e..bc58b6c0d1 100644
--- a/hw/virtio/vhost-user-i2c.c
+++ b/hw/virtio/vhost-user-i2c.c
@@ -95,7 +95,7 @@ static void vu_i2c_set_status(VirtIODevice *vdev, uint8_t status)
     VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
     bool should_start = virtio_device_started(vdev, status);
 
-    if (i2c->vhost_dev.started == should_start) {
+    if (vhost_dev_is_started(&i2c->vhost_dev) == should_start) {
         return;
     }
 
@@ -174,7 +174,7 @@ static void vu_i2c_disconnect(DeviceState *dev)
     }
     i2c->connected = false;
 
-    if (i2c->vhost_dev.started) {
+    if (vhost_dev_is_started(&i2c->vhost_dev)) {
         vu_i2c_stop(vdev);
     }
 }
diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
index a9c1c4bc79..bc1f36c5ac 100644
--- a/hw/virtio/vhost-user-rng.c
+++ b/hw/virtio/vhost-user-rng.c
@@ -92,7 +92,7 @@ static void vu_rng_set_status(VirtIODevice *vdev, uint8_t status)
     VHostUserRNG *rng = VHOST_USER_RNG(vdev);
     bool should_start = virtio_device_started(vdev, status);
 
-    if (rng->vhost_dev.started == should_start) {
+    if (vhost_dev_is_started(&rng->vhost_dev) == should_start) {
         return;
     }
 
@@ -160,7 +160,7 @@ static void vu_rng_disconnect(DeviceState *dev)
 
     rng->connected = false;
 
-    if (rng->vhost_dev.started) {
+    if (vhost_dev_is_started(&rng->vhost_dev)) {
         vu_rng_stop(vdev);
     }
 }
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 22c1616ebd..7b67e29d83 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -57,7 +57,7 @@ static void vuv_set_status(VirtIODevice *vdev, uint8_t status)
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
     bool should_start = virtio_device_started(vdev, status);
 
-    if (vvc->vhost_dev.started == should_start) {
+    if (vhost_dev_is_started(&vvc->vhost_dev) == should_start) {
         return;
     }
 
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index 7394818e00..29b9ab4f72 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -14,6 +14,7 @@
 #include "hw/virtio/virtio-access.h"
 #include "qemu/error-report.h"
 #include "hw/qdev-properties.h"
+#include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-vsock.h"
 #include "qemu/iov.h"
 #include "monitor/monitor.h"
@@ -199,7 +200,7 @@ int vhost_vsock_common_pre_save(void *opaque)
      * At this point, backend must be stopped, otherwise
      * it might keep writing to memory.
      */
-    assert(!vvc->vhost_dev.started);
+    assert(!vhost_dev_is_started(&vvc->vhost_dev));
 
     return 0;
 }
diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
index 8031c164a5..7dc3c73931 100644
--- a/hw/virtio/vhost-vsock.c
+++ b/hw/virtio/vhost-vsock.c
@@ -73,7 +73,7 @@ static void vhost_vsock_set_status(VirtIODevice *vdev, uint8_t status)
     bool should_start = virtio_device_started(vdev, status);
     int ret;
 
-    if (vvc->vhost_dev.started == should_start) {
+    if (vhost_dev_is_started(&vvc->vhost_dev) == should_start) {
         return;
     }
 
-- 
MST

