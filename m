Return-Path: <lulu@redhat.com>
From: Cindy Lu <lulu@redhat.com>
Date: Wed, 20 Jul 2022 21:12:03 +0800
Message-Id: <20220720131204.591104-10-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v13 09/10] virtio-mmio: add support for
 configure interrupt
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

Add configure interrupt support in virtio-mmio bus.
add function to set configure guest notifier.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 hw/virtio/virtio-mmio.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
index 688eccda94..5c613a96d9 100644
--- a/hw/virtio/virtio-mmio.c
+++ b/hw/virtio/virtio-mmio.c
@@ -672,7 +672,30 @@ static int virtio_mmio_set_guest_notifier(DeviceState *d, int n, bool assign,
 
     return 0;
 }
+static int virtio_mmio_set_config_guest_notifier(DeviceState *d, bool assign,
+                                                 bool with_irqfd)
+{
+    VirtIOMMIOProxy *proxy = VIRTIO_MMIO(d);
+    VirtIODevice *vdev = virtio_bus_get_device(&proxy->bus);
+    VirtioDeviceClass *vdc = VIRTIO_DEVICE_GET_CLASS(vdev);
+    EventNotifier *notifier = virtio_config_get_guest_notifier(vdev);
+    int r = 0;
 
+    if (assign) {
+        r = event_notifier_init(notifier, 0);
+        if (r < 0) {
+            return r;
+        }
+        virtio_config_set_guest_notifier_fd_handler(vdev, assign, with_irqfd);
+    } else {
+        virtio_config_set_guest_notifier_fd_handler(vdev, assign, with_irqfd);
+        event_notifier_cleanup(notifier);
+    }
+    if (vdc->guest_notifier_mask && vdev->use_guest_notifier_mask) {
+        vdc->guest_notifier_mask(vdev, VIRTIO_CONFIG_IRQ_IDX, !assign);
+    }
+    return r;
+}
 static int virtio_mmio_set_guest_notifiers(DeviceState *d, int nvqs,
                                            bool assign)
 {
@@ -694,6 +717,10 @@ static int virtio_mmio_set_guest_notifiers(DeviceState *d, int nvqs,
             goto assign_error;
         }
     }
+    r = virtio_mmio_set_config_guest_notifier(d, assign, with_irqfd);
+    if (r < 0) {
+        goto assign_error;
+    }
 
     return 0;
 
-- 
2.34.3

