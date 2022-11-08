Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=+Mtx8odvHwCV0bf17EfBgIaZ7U3IJZv+eeZfeBwc4UQ=;
 b=pylU059h9atBQP2HUJ1P2PS5gPhC528RXgxry6KwVPVJPUphbcC7U9294RnSW+1vxy
 7G52xLzTQMlkaXzX8tE1ojTe6NDZN91xdDS+96gOQgKvL9qkfRNq/acxVJsmmONzuiwT
 0RoBbKFiG2X4WS/ZU2y8NolvEpt/JT4l2Sp2Ny+9LrTDIJsWPk0jUj0hnoCZgUYX/AS+
 /6OG5xIZXCclbNAfUrIsRvXAzJhVHgJDTKu9LV0dh8F7RNuHbNeVAKvUjDrsnn9OyINP
 WmKfY4roK69ctfmrPmJipUJocf67Kb9y0GX5kTY3VSM8s/hXHg+EKy1GjV2qJbG1Q3yQ
 VBLA==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue,  8 Nov 2022 09:23:04 +0000
Message-Id: <20221108092308.1717426-6-alex.bennee@linaro.org>
In-Reply-To: <20221108092308.1717426-1-alex.bennee@linaro.org>
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v1 5/9] hw/virtio: introduce
 virtio_device_should_start
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>

The previous fix to virtio_device_started revealed a problem in its
use by both the core and the device code. The core code should be able
to handle the device "starting" while the VM isn't running to handle
the restoration of migration state. To solve this dual use introduce a
new helper for use by the vhost-user backends who all use it to feed a
should_start variable.

We can also pick up a change vhost_user_blk_set_status while we are at
it which follows the same pattern.

Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_device_started)
Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-user-gpio device)
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
---
 include/hw/virtio/virtio.h   | 18 ++++++++++++++++++
 hw/block/vhost-user-blk.c    |  6 +-----
 hw/virtio/vhost-user-fs.c    |  2 +-
 hw/virtio/vhost-user-gpio.c  |  2 +-
 hw/virtio/vhost-user-i2c.c   |  2 +-
 hw/virtio/vhost-user-rng.c   |  2 +-
 hw/virtio/vhost-user-vsock.c |  2 +-
 hw/virtio/vhost-vsock.c      |  2 +-
 8 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index f41b4a7e64..3191c618f3 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -389,6 +389,24 @@ static inline bool virtio_device_started(VirtIODevice *vdev, uint8_t status)
         return vdev->started;
     }
 
+    return status & VIRTIO_CONFIG_S_DRIVER_OK;
+}
+
+/**
+ * virtio_device_should_start() - check if device startable
+ * @vdev - the VirtIO device
+ * @status - the devices status bits
+ *
+ * This is similar to virtio_device_started() but also encapsulates a
+ * check on the VM status which would prevent a device starting
+ * anyway.
+ */
+static inline bool virtio_device_should_start(VirtIODevice *vdev, uint8_t status)
+{
+    if (vdev->use_started) {
+        return vdev->started;
+    }
+
     if (!vdev->vm_running) {
         return false;
     }
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 13bf5cc47a..8feaf12e4e 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -222,14 +222,10 @@ static void vhost_user_blk_stop(VirtIODevice *vdev)
 static void vhost_user_blk_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserBlk *s = VHOST_USER_BLK(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_should_start(vdev, status);
     Error *local_err = NULL;
     int ret;
 
-    if (!vdev->vm_running) {
-        should_start = false;
-    }
-
     if (!s->connected) {
         return;
     }
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index ad0f91c607..1c40f42045 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -123,7 +123,7 @@ static void vuf_stop(VirtIODevice *vdev)
 static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_should_start(vdev, status);
 
     if (vhost_dev_is_started(&fs->vhost_dev) == should_start) {
         return;
diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
index 8b40fe450c..677d1c7730 100644
--- a/hw/virtio/vhost-user-gpio.c
+++ b/hw/virtio/vhost-user-gpio.c
@@ -152,7 +152,7 @@ static void vu_gpio_stop(VirtIODevice *vdev)
 static void vu_gpio_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserGPIO *gpio = VHOST_USER_GPIO(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_should_start(vdev, status);
 
     trace_virtio_gpio_set_status(status);
 
diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
index bc58b6c0d1..864eba695e 100644
--- a/hw/virtio/vhost-user-i2c.c
+++ b/hw/virtio/vhost-user-i2c.c
@@ -93,7 +93,7 @@ static void vu_i2c_stop(VirtIODevice *vdev)
 static void vu_i2c_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_should_start(vdev, status);
 
     if (vhost_dev_is_started(&i2c->vhost_dev) == should_start) {
         return;
diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
index bc1f36c5ac..8b47287875 100644
--- a/hw/virtio/vhost-user-rng.c
+++ b/hw/virtio/vhost-user-rng.c
@@ -90,7 +90,7 @@ static void vu_rng_stop(VirtIODevice *vdev)
 static void vu_rng_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_should_start(vdev, status);
 
     if (vhost_dev_is_started(&rng->vhost_dev) == should_start) {
         return;
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 7b67e29d83..9431b9792c 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -55,7 +55,7 @@ const VhostDevConfigOps vsock_ops = {
 static void vuv_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_should_start(vdev, status);
 
     if (vhost_dev_is_started(&vvc->vhost_dev) == should_start) {
         return;
diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
index 7dc3c73931..aa16d584ee 100644
--- a/hw/virtio/vhost-vsock.c
+++ b/hw/virtio/vhost-vsock.c
@@ -70,7 +70,7 @@ static int vhost_vsock_set_running(VirtIODevice *vdev, int start)
 static void vhost_vsock_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_should_start(vdev, status);
     int ret;
 
     if (vhost_dev_is_started(&vvc->vhost_dev) == should_start) {
-- 
2.34.1

