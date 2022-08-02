Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc;
 bh=x448FCGsB6jl4t/PEZTiuqAxlBX+i+OighRCNvx3IrY=;
 b=a2o70i6ozgrkoN+0syJ6dPIbzVBJa9qJmDlahBv+BChgsvfUIast9YimY1+nJjhzEc
 Rp4qxINM/eb26p2DShObyo0xHy8Z6Xjbf16z+cMYY0Jwzn+Jx3tgAXZR3wBxQ46mwmlu
 dkJW5rcJmxcRC218sQeh0E8GOlL/p740hcxz4qFWgUB22oCwxARhtBpcXRM17NZ+7bOA
 gcRP2QgKO4lbjWf9Vt5ohl/Nhbg2bg8VrU5/KiGdeK/9WX+EnRaUlVNZzx0ym1FM9FPB
 9MIdIqitVw3Hnxjih5SB5O0z4Io9GkYyAmpHXRLoJlLmioTXu4XmGwfRPohyVHqSZYWt
 E7pA==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue,  2 Aug 2022 10:49:58 +0100
Message-Id: <20220802095010.3330793-11-alex.bennee@linaro.org>
In-Reply-To: <20220802095010.3330793-1-alex.bennee@linaro.org>
References: <20220802095010.3330793-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 10/22] hw/virtio: move vm_running check to
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
Cc: slp@redhat.com, mst@redhat.com, marcandre.lureau@redhat.com, stefanha@redhat.com, mathieu.poirier@linaro.org, viresh.kumar@linaro.org, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>

All the boilerplate virtio code does the same thing (or should at
least) of checking to see if the VM is running before attempting to
start VirtIO. Push the logic up to the common function to avoid
getting a copy and paste wrong.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
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
2.30.2

