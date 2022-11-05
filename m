Return-Path: <mst@redhat.com>
Date: Sat, 5 Nov 2022 14:16:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221105172453.445049-2-mst@redhat.com>
References: <20221105172453.445049-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221105172453.445049-1-mst@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH RFC 1/3] virtio: distinguish between started and
 running
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, virtio-fs@redhat.com

virtio core often needs to know whether device is started, this is what
virtio_device_started already did. However, backends want to know
whether virtio is actually running which also depends on whether vm is
running. To address this we moved the check to virtio_device_started,
but this changes virtio core behavior which wasn't intentional.  Let's
add a new API virtio_device_running just for the backends.
Follow up patch will revert the change to virtio_device_started.

Further, the old API was actually ignoring vm running state
most of the time (when use_started property is set),
The new API takes vm running state into account properly.

Fixes: 9f6bcfd99f ("hw/virtio: move vm_running check to virtio_device_started")
Cc: "Alex Bennée" <alex.bennee@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/hw/virtio/virtio.h   | 9 +++++++++
 hw/virtio/vhost-user-fs.c    | 2 +-
 hw/virtio/vhost-user-i2c.c   | 4 ++--
 hw/virtio/vhost-user-rng.c   | 4 ++--
 hw/virtio/vhost-user-vsock.c | 2 +-
 hw/virtio/vhost-vsock.c      | 2 +-
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 1423dba379..634c24513f 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -402,6 +402,15 @@ static inline bool virtio_device_started(VirtIODevice *vdev, uint8_t status)
     return status & VIRTIO_CONFIG_S_DRIVER_OK;
 }
 
+static inline bool virtio_device_running(VirtIODevice *vdev, uint8_t status)
+{
+    if (!vdev->vm_running) {
+        return false;
+    }
+
+    return virtio_device_started(vdev, status);
+}
+
 static inline void virtio_set_started(VirtIODevice *vdev, bool started)
 {
     if (started) {
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index ad0f91c607..174c968179 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -123,7 +123,7 @@ static void vuf_stop(VirtIODevice *vdev)
 static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_running(vdev, status);
 
     if (vhost_dev_is_started(&fs->vhost_dev) == should_start) {
         return;
diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
index bc58b6c0d1..cf4fd26cf4 100644
--- a/hw/virtio/vhost-user-i2c.c
+++ b/hw/virtio/vhost-user-i2c.c
@@ -93,7 +93,7 @@ static void vu_i2c_stop(VirtIODevice *vdev)
 static void vu_i2c_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_running(vdev, status);
 
     if (vhost_dev_is_started(&i2c->vhost_dev) == should_start) {
         return;
@@ -157,7 +157,7 @@ static int vu_i2c_connect(DeviceState *dev)
     i2c->connected = true;
 
     /* restore vhost state */
-    if (virtio_device_started(vdev, vdev->status)) {
+    if (virtio_device_running(vdev, vdev->status)) {
         vu_i2c_start(vdev);
     }
 
diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
index bc1f36c5ac..ba548dc83c 100644
--- a/hw/virtio/vhost-user-rng.c
+++ b/hw/virtio/vhost-user-rng.c
@@ -90,7 +90,7 @@ static void vu_rng_stop(VirtIODevice *vdev)
 static void vu_rng_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_running(vdev, status);
 
     if (vhost_dev_is_started(&rng->vhost_dev) == should_start) {
         return;
@@ -144,7 +144,7 @@ static void vu_rng_connect(DeviceState *dev)
     rng->connected = true;
 
     /* restore vhost state */
-    if (virtio_device_started(vdev, vdev->status)) {
+    if (virtio_device_running(vdev, vdev->status)) {
         vu_rng_start(vdev);
     }
 }
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 7b67e29d83..30228eaa21 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -55,7 +55,7 @@ const VhostDevConfigOps vsock_ops = {
 static void vuv_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_running(vdev, status);
 
     if (vhost_dev_is_started(&vvc->vhost_dev) == should_start) {
         return;
diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
index 7dc3c73931..1c768ee196 100644
--- a/hw/virtio/vhost-vsock.c
+++ b/hw/virtio/vhost-vsock.c
@@ -70,7 +70,7 @@ static int vhost_vsock_set_running(VirtIODevice *vdev, int start)
 static void vhost_vsock_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_running(vdev, status);
     int ret;
 
     if (vhost_dev_is_started(&vvc->vhost_dev) == should_start) {
-- 
MST

