From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Fri, 23 Aug 2019 18:56:57 +0100
Message-Id: <20190823175657.12085-3-dgilbert@redhat.com>
In-Reply-To: <20190823175657.12085-1-dgilbert@redhat.com>
References: <20190823175657.12085-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 2/2] virtio: add vhost-user-fs-pci device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com
Cc: virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Add the PCI version of vhost-user-fs.

Launch QEMU like this:

  qemu -chardev socket,path=/tmp/vhost-fs.sock,id=chr0
       -device x-vhost-user-fs-pci,tag=myfs,chardev=chr0

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 hw/virtio/Makefile.objs       |  1 +
 hw/virtio/vhost-user-fs-pci.c | 85 +++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)
 create mode 100644 hw/virtio/vhost-user-fs-pci.c

diff --git a/hw/virtio/Makefile.objs b/hw/virtio/Makefile.objs
index 47ffbf22c4..e2f70fbb89 100644
--- a/hw/virtio/Makefile.objs
+++ b/hw/virtio/Makefile.objs
@@ -15,6 +15,7 @@ obj-$(CONFIG_VHOST_USER_FS) += vhost-user-fs.o
 obj-$(call land,$(CONFIG_VIRTIO_CRYPTO),$(CONFIG_VIRTIO_PCI)) += virtio-crypto-pci.o
 obj-$(CONFIG_VIRTIO_PMEM) += virtio-pmem.o
 common-obj-$(call land,$(CONFIG_VIRTIO_PMEM),$(CONFIG_VIRTIO_PCI)) += virtio-pmem-pci.o
+obj-$(call land,$(CONFIG_VHOST_USER_FS),$(CONFIG_VIRTIO_PCI)) += vhost-user-fs-pci.o
 obj-$(CONFIG_VHOST_VSOCK) += vhost-vsock.o
 
 ifeq ($(CONFIG_VIRTIO_PCI),y)
diff --git a/hw/virtio/vhost-user-fs-pci.c b/hw/virtio/vhost-user-fs-pci.c
new file mode 100644
index 0000000000..0e70985094
--- /dev/null
+++ b/hw/virtio/vhost-user-fs-pci.c
@@ -0,0 +1,85 @@
+/*
+ * Vhost-user filesystem virtio device PCI glue
+ *
+ * Copyright 2018-2019 Red Hat, Inc.
+ *
+ * Authors:
+ *  Dr. David Alan Gilbert <dgilbert@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * (at your option) any later version.  See the COPYING file in the
+ * top-level directory.
+ */
+
+#include "qemu/osdep.h"
+#include "hw/qdev-properties.h"
+#include "hw/virtio/vhost-user-fs.h"
+#include "virtio-pci.h"
+
+struct VHostUserFSPCI {
+    VirtIOPCIProxy parent_obj;
+    VHostUserFS vdev;
+};
+
+typedef struct VHostUserFSPCI VHostUserFSPCI;
+
+#define TYPE_VHOST_USER_FS_PCI "vhost-user-fs-pci-base"
+
+#define VHOST_USER_FS_PCI(obj) \
+        OBJECT_CHECK(VHostUserFSPCI, (obj), TYPE_VHOST_USER_FS_PCI)
+
+static Property vhost_user_fs_pci_properties[] = {
+    DEFINE_PROP_UINT32("vectors", VirtIOPCIProxy, nvectors,
+                       DEV_NVECTORS_UNSPECIFIED),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void vhost_user_fs_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
+{
+    VHostUserFSPCI *dev = VHOST_USER_FS_PCI(vpci_dev);
+    DeviceState *vdev = DEVICE(&dev->vdev);
+
+    if (vpci_dev->nvectors == DEV_NVECTORS_UNSPECIFIED) {
+        vpci_dev->nvectors = dev->vdev.conf.num_request_queues + 1;
+    }
+
+    qdev_set_parent_bus(vdev, BUS(&vpci_dev->bus));
+    object_property_set_bool(OBJECT(vdev), true, "realized", errp);
+}
+
+static void vhost_user_fs_pci_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    VirtioPCIClass *k = VIRTIO_PCI_CLASS(klass);
+    PCIDeviceClass *pcidev_k = PCI_DEVICE_CLASS(klass);
+    k->realize = vhost_user_fs_pci_realize;
+    set_bit(DEVICE_CATEGORY_STORAGE, dc->categories);
+    dc->props = vhost_user_fs_pci_properties;
+    pcidev_k->vendor_id = PCI_VENDOR_ID_REDHAT_QUMRANET;
+    pcidev_k->device_id = 0; /* Set by virtio-pci based on virtio id */
+    pcidev_k->revision = 0x00;
+    pcidev_k->class_id = PCI_CLASS_STORAGE_OTHER;
+}
+
+static void vhost_user_fs_pci_instance_init(Object *obj)
+{
+    VHostUserFSPCI *dev = VHOST_USER_FS_PCI(obj);
+
+    virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
+                                TYPE_VHOST_USER_FS);
+}
+
+static const VirtioPCIDeviceTypeInfo vhost_user_fs_pci_info = {
+    .base_name             = TYPE_VHOST_USER_FS_PCI,
+    .non_transitional_name = "x-vhost-user-fs-pci",
+    .instance_size = sizeof(VHostUserFSPCI),
+    .instance_init = vhost_user_fs_pci_instance_init,
+    .class_init    = vhost_user_fs_pci_class_init,
+};
+
+static void vhost_user_fs_pci_register(void)
+{
+    virtio_pci_types_register(&vhost_user_fs_pci_info);
+}
+
+type_init(vhost_user_fs_pci_register);
-- 
2.21.0

