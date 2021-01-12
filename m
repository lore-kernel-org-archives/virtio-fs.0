From: Laszlo Ersek <lersek@redhat.com>
Date: Tue, 12 Jan 2021 14:16:03 +0100
Message-Id: <20210112131603.12686-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2] vhost-user-fs: add the "bootindex" property
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu devel list <qemu-devel@nongnu.org>
Cc: virtio-fs@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>

virtio-fs qualifies as a bootable device minimally under OVMF, but
currently the necessary "bootindex" property is missing. Add the property.

Expose the property only in the PCI device, for now. There is no boot
support for virtiofs on s390x (ccw) for the time being [1] [2], so leave
the CCW device unchanged. Add the property to the base device still,
because adding the alias to the CCW device later will be easier this way
[3].

[1] https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg01745.html
[2] https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg01870.html
[3] https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg01751.html

Example OpenFirmware device path for the "vhost-user-fs-pci" device in the
"bootorder" fw_cfg file:

  /pci@i0cf8/pci-bridge@1,6/pci1af4,105a@0/filesystem@0

Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Ján Tomko <jtomko@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
Acked-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---

Notes:
    v2:
    - drop "hw/s390x/vhost-user-fs-ccw.c" hunk [Christian, Cornelia]
    
    - document the same in the commit message
    
    - remove fw_cfg kernel boot reference from the commit message (somewhat
      similar use case, but a comparison or even a hint doesn't necessarily
      belong in the commit message)
    
    - pick up Dave's ACK

 include/hw/virtio/vhost-user-fs.h |  1 +
 hw/virtio/vhost-user-fs-pci.c     |  2 ++
 hw/virtio/vhost-user-fs.c         | 10 ++++++++++
 3 files changed, 13 insertions(+)

diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 698575277101..0d62834c2510 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -39,6 +39,7 @@ struct VHostUserFS {
     VhostUserState vhost_user;
     VirtQueue **req_vqs;
     VirtQueue *hiprio_vq;
+    int32_t bootindex;
 
     /*< public >*/
 };
diff --git a/hw/virtio/vhost-user-fs-pci.c b/hw/virtio/vhost-user-fs-pci.c
index 8bb389bd282a..2ed8492b3fa3 100644
--- a/hw/virtio/vhost-user-fs-pci.c
+++ b/hw/virtio/vhost-user-fs-pci.c
@@ -68,6 +68,8 @@ static void vhost_user_fs_pci_instance_init(Object *obj)
 
     virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
                                 TYPE_VHOST_USER_FS);
+    object_property_add_alias(obj, "bootindex", OBJECT(&dev->vdev),
+                              "bootindex");
 }
 
 static const VirtioPCIDeviceTypeInfo vhost_user_fs_pci_info = {
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index ed036ad9c13f..ac4fc34b36a2 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -22,6 +22,7 @@
 #include "qemu/error-report.h"
 #include "hw/virtio/vhost-user-fs.h"
 #include "monitor/monitor.h"
+#include "sysemu/sysemu.h"
 
 static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
 {
@@ -279,6 +280,14 @@ static Property vuf_properties[] = {
     DEFINE_PROP_END_OF_LIST(),
 };
 
+static void vuf_instance_init(Object *obj)
+{
+    VHostUserFS *fs = VHOST_USER_FS(obj);
+
+    device_add_bootindex_property(obj, &fs->bootindex, "bootindex",
+                                  "/filesystem@0", DEVICE(obj));
+}
+
 static void vuf_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
@@ -300,6 +309,7 @@ static const TypeInfo vuf_info = {
     .name = TYPE_VHOST_USER_FS,
     .parent = TYPE_VIRTIO_DEVICE,
     .instance_size = sizeof(VHostUserFS),
+    .instance_init = vuf_instance_init,
     .class_init = vuf_class_init,
 };
 
-- 
2.19.1.3.g30247aa5d201


