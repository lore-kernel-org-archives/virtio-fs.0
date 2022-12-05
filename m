Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:53 +0100
Message-Id: <20221205095228.1314-17-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 16/51] include/hw: VM state takes precedence
 in virtio_device_should_start
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>

From: Alex Bennée <alex.bennee@linaro.org>

The VM status should always preempt the device status for these
checks. This ensures the device is in the correct state when we
suspend the VM prior to migrations. This restores the checks to the
order they where in before the refactoring moved things around.

While we are at it lets improve our documentation of the various
fields involved and document the two functions.

Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_device_started)
Fixes: 259d69c00b (hw/virtio: introduce virtio_device_should_start)
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20221130112439.2527228-6-alex.bennee@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/hw/virtio/virtio.h | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index a973811cbf..acfd4df125 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -116,6 +116,13 @@ struct VirtIODevice
     bool broken; /* device in invalid state, needs reset */
     bool use_disabled_flag; /* allow use of 'disable' flag when needed */
     bool disabled; /* device in temporarily disabled state */
+    /**
+     * @use_started: true if the @started flag should be used to check the
+     * current state of the VirtIO device. Otherwise status bits
+     * should be checked for a current status of the device.
+     * @use_started is only set via QMP and defaults to true for all
+     * modern machines (since 4.1).
+     */
     bool use_started;
     bool started;
     bool start_on_kick; /* when virtio 1.0 feature has not been negotiated */
@@ -391,6 +398,16 @@ static inline bool virtio_is_big_endian(VirtIODevice *vdev)
     return false;
 }
 
+/**
+ * virtio_device_started() - check if device started
+ * @vdev - the VirtIO device
+ * @status - the devices status bits
+ *
+ * Check if the device is started. For most modern machines this is
+ * tracked via the @vdev->started field (to support migration),
+ * otherwise we check for the final negotiated status bit that
+ * indicates everything is ready.
+ */
 static inline bool virtio_device_started(VirtIODevice *vdev, uint8_t status)
 {
     if (vdev->use_started) {
@@ -411,15 +428,11 @@ static inline bool virtio_device_started(VirtIODevice *vdev, uint8_t status)
  */
 static inline bool virtio_device_should_start(VirtIODevice *vdev, uint8_t status)
 {
-    if (vdev->use_started) {
-        return vdev->started;
-    }
-
     if (!vdev->vm_running) {
         return false;
     }
 
-    return status & VIRTIO_CONFIG_S_DRIVER_OK;
+    return virtio_device_started(vdev, status);
 }
 
 static inline void virtio_set_started(VirtIODevice *vdev, bool started)
-- 
2.38.1

