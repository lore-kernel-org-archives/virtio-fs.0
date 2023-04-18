Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681834905; x=1684426905;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=eC5A3sVizk95geXn4I1Vdcti4PHMTBsSCbklkuaCJpg=;
 b=xX9KuWORBVoBfQaDp//Zj0pCE5vi9R8pcHOLPKEJQIUMXddEwHNwZq084NqimIeyhB
 HuFcJaY/AtdyL1kOOyxH198nMH9K/P/HP+qmddQwx85LZzJujl3jUeF9M2i01toKnPT8
 paS0v4aJQ/co9mcaY2FT4MJPfGtPthzwnL17/d/BXS1xRsDrnexwQ0n48m4ZZWKatO63
 AduMP3Hpmv2mrlGVvfagKIKaM995d/8qGx7v4PeV9l5dgCktjjW0W78lYWdCS+kcRWPu
 cqJ/synPvQ2RAMUPgUELdkVLjjoM+T3VuKmdANkLxsUcqdV7e2cASOlr47p1Tu5O0oXd
 110w==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 18 Apr 2023 17:21:35 +0100
Message-Id: <20230418162140.373219-9-alex.bennee@linaro.org>
In-Reply-To: <20230418162140.373219-1-alex.bennee@linaro.org>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 08/13] virtio: add PCI stub for
 vhost-user-device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Jason Wang <jasowang@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Gerd Hoffmann <kraxel@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>

This is all pretty much boilerplate.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Tested-by: Erik Schilling <erik.schilling@linaro.org>
---
 hw/virtio/vhost-user-device-pci.c | 71 +++++++++++++++++++++++++++++++
 hw/virtio/meson.build             |  1 +
 2 files changed, 72 insertions(+)
 create mode 100644 hw/virtio/vhost-user-device-pci.c

diff --git a/hw/virtio/vhost-user-device-pci.c b/hw/virtio/vhost-user-device-pci.c
new file mode 100644
index 0000000000..41f9b7905b
--- /dev/null
+++ b/hw/virtio/vhost-user-device-pci.c
@@ -0,0 +1,71 @@
+/*
+ * Vhost-user generic virtio device PCI glue
+ *
+ * Copyright (c) 2023 Linaro Ltd
+ * Author: Alex Bennée <alex.bennee@linaro.org>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "hw/qdev-properties.h"
+#include "hw/virtio/vhost-user-device.h"
+#include "hw/virtio/virtio-pci.h"
+
+struct VHostUserDevicePCI {
+    VirtIOPCIProxy parent_obj;
+    VHostUserBase vub;
+};
+
+typedef struct VHostUserDevicePCI VHostUserDevicePCI;
+
+#define TYPE_VHOST_USER_DEVICE_PCI "vhost-user-device-pci-base"
+
+DECLARE_INSTANCE_CHECKER(VHostUserDevicePCI,
+                         VHOST_USER_DEVICE_PCI,
+                         TYPE_VHOST_USER_DEVICE_PCI)
+
+static void vhost_user_device_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
+{
+    VHostUserDevicePCI *dev = VHOST_USER_DEVICE_PCI(vpci_dev);
+    DeviceState *vdev = DEVICE(&dev->vub);
+
+    vpci_dev->nvectors = 1;
+    qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
+}
+
+static void vhost_user_device_pci_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    VirtioPCIClass *k = VIRTIO_PCI_CLASS(klass);
+    PCIDeviceClass *pcidev_k = PCI_DEVICE_CLASS(klass);
+    k->realize = vhost_user_device_pci_realize;
+    set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
+    pcidev_k->vendor_id = PCI_VENDOR_ID_REDHAT_QUMRANET;
+    pcidev_k->device_id = 0; /* Set by virtio-pci based on virtio id */
+    pcidev_k->revision = 0x00;
+    pcidev_k->class_id = PCI_CLASS_COMMUNICATION_OTHER;
+}
+
+static void vhost_user_device_pci_instance_init(Object *obj)
+{
+    VHostUserDevicePCI *dev = VHOST_USER_DEVICE_PCI(obj);
+
+    virtio_instance_init_common(obj, &dev->vub, sizeof(dev->vub),
+                                TYPE_VHOST_USER_DEVICE);
+}
+
+static const VirtioPCIDeviceTypeInfo vhost_user_device_pci_info = {
+    .base_name = TYPE_VHOST_USER_DEVICE_PCI,
+    .non_transitional_name = "vhost-user-device-pci",
+    .instance_size = sizeof(VHostUserDevicePCI),
+    .instance_init = vhost_user_device_pci_instance_init,
+    .class_init = vhost_user_device_pci_class_init,
+};
+
+static void vhost_user_device_pci_register(void)
+{
+    virtio_pci_types_register(&vhost_user_device_pci_info);
+}
+
+type_init(vhost_user_device_pci_register);
diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
index 43e5fa3f7d..c0a86b94ae 100644
--- a/hw/virtio/meson.build
+++ b/hw/virtio/meson.build
@@ -13,6 +13,7 @@ if have_vhost
     # fixme - this really should be generic
     specific_virtio_ss.add(files('vhost-user.c'))
     softmmu_virtio_ss.add(files('vhost-user-device.c'))
+    softmmu_virtio_ss.add(when: 'CONFIG_VIRTIO_PCI', if_true: files('vhost-user-device-pci.c'))
   endif
   if have_vhost_vdpa
     specific_virtio_ss.add(files('vhost-vdpa.c', 'vhost-shadow-virtqueue.c'))
-- 
2.39.2

