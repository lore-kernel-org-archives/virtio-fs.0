Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1697709374; x=1698314174; darn=redhat.com;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Q4GXVCT0h3aOuJrUKXks6Wem9BLFnGtf8W3Df6B2wjU=;
 b=eQUG/RSxBUSWFtwvHd8xAoKxw3scAlH1M6etpWy+pwEyTtzALhDIN9M2uA1rpsz9iP
 sT3Fv1BPCOGEXs5bTunM3S5MmKqUzb7b5jI5iI5ajniMuQT3GT9wMFq8r/JwhOmqt61+
 8HqxLq24wkoIJ8K+D3+mgpc8XYAAryrj042k3ZG3A9suznvVi91s9hm4m89HFIeveVjS
 q57RXGErMvBcCFuJnYgcJcAUXpPKEhaUkPUPSgc74mOw0o3MKnsi0N54pxRF2mheJcvI
 F1iKin2ZCZL6MFYVqkEmNib64TL5R8BQHLMmKAQ+YNTaa1W/I6IwV0o23ybcc0EtgjyN
 TMCg==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Thu, 19 Oct 2023 10:56:09 +0100
Message-Id: <20231019095610.2818087-6-alex.bennee@linaro.org>
In-Reply-To: <20231019095610.2818087-1-alex.bennee@linaro.org>
References: <20231019095610.2818087-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 5/6] hw/virtio: add vhost-user-snd and
 virtio-snd-pci devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Markus Armbruster <armbru@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Manos Pitsidianakis <manos.pitsidianakis@linaro.org>

From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>

Tested with rust-vmm vhost-user-sound daemon:

    RUST_LOG=trace cargo run --bin vhost-user-sound -- --socket /tmp/snd.sock --backend null

Invocation:

    qemu-system-x86_64  \
            -qmp unix:./qmp-sock,server,wait=off  \
            -m 4096 \
            -numa node,memdev=mem \
            -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on \
            -D qemu.log \
            -d guest_errors,trace:\*snd\*,trace:\*sound\*,trace:\*vhost\* \
            -chardev socket,id=vsnd,path=/tmp/snd.sock \
            -device vhost-user-snd-pci,chardev=vsnd,id=snd \
            /path/to/disk

[AJB: imported from https://github.com/epilys/qemu-virtio-snd/commit/54ae1cdd15fef2d88e9e387a175f099a38c636f4.patch]

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20231009095937.195728-6-alex.bennee@linaro.org>
---
 include/hw/virtio/vhost-user-snd.h | 26 +++++++++++
 hw/virtio/vhost-user-snd-pci.c     | 75 ++++++++++++++++++++++++++++++
 hw/virtio/vhost-user-snd.c         | 67 ++++++++++++++++++++++++++
 hw/virtio/Kconfig                  |  5 ++
 hw/virtio/meson.build              |  3 ++
 5 files changed, 176 insertions(+)
 create mode 100644 include/hw/virtio/vhost-user-snd.h
 create mode 100644 hw/virtio/vhost-user-snd-pci.c
 create mode 100644 hw/virtio/vhost-user-snd.c

diff --git a/include/hw/virtio/vhost-user-snd.h b/include/hw/virtio/vhost-user-snd.h
new file mode 100644
index 0000000000..a1627003a0
--- /dev/null
+++ b/include/hw/virtio/vhost-user-snd.h
@@ -0,0 +1,26 @@
+/*
+ * Vhost-user Sound virtio device
+ *
+ * Copyright (c) 2021 Mathieu Poirier <mathieu.poirier@linaro.org>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef QEMU_VHOST_USER_SND_H
+#define QEMU_VHOST_USER_SND_H
+
+#include "hw/virtio/virtio.h"
+#include "hw/virtio/vhost.h"
+#include "hw/virtio/vhost-user.h"
+#include "hw/virtio/vhost-user-base.h"
+
+#define TYPE_VHOST_USER_SND "vhost-user-snd"
+OBJECT_DECLARE_SIMPLE_TYPE(VHostUserSound, VHOST_USER_SND)
+
+struct VHostUserSound {
+    /*< private >*/
+    VHostUserBase parent;
+    /*< public >*/
+};
+
+#endif /* QEMU_VHOST_USER_SND_H */
diff --git a/hw/virtio/vhost-user-snd-pci.c b/hw/virtio/vhost-user-snd-pci.c
new file mode 100644
index 0000000000..d61cfdae63
--- /dev/null
+++ b/hw/virtio/vhost-user-snd-pci.c
@@ -0,0 +1,75 @@
+/*
+ * Vhost-user Sound virtio device PCI glue
+ *
+ * Copyright (c) 2023 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "hw/qdev-properties.h"
+#include "hw/virtio/vhost-user-snd.h"
+#include "hw/virtio/virtio-pci.h"
+
+struct VHostUserSoundPCI {
+    VirtIOPCIProxy parent_obj;
+    VHostUserSound vdev;
+};
+
+typedef struct VHostUserSoundPCI VHostUserSoundPCI;
+
+#define TYPE_VHOST_USER_SND_PCI "vhost-user-snd-pci-base"
+
+DECLARE_INSTANCE_CHECKER(VHostUserSoundPCI, VHOST_USER_SND_PCI,
+                         TYPE_VHOST_USER_SND_PCI)
+
+static Property vhost_user_snd_pci_properties[] = {
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void vhost_user_snd_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
+{
+    VHostUserSoundPCI *dev = VHOST_USER_SND_PCI(vpci_dev);
+    DeviceState *vdev = DEVICE(&dev->vdev);
+
+    vpci_dev->nvectors = 1;
+
+    qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
+}
+
+static void vhost_user_snd_pci_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    VirtioPCIClass *k = VIRTIO_PCI_CLASS(klass);
+    PCIDeviceClass *pcidev_k = PCI_DEVICE_CLASS(klass);
+    k->realize = vhost_user_snd_pci_realize;
+    set_bit(DEVICE_CATEGORY_SOUND, dc->categories);
+    device_class_set_props(dc, vhost_user_snd_pci_properties);
+    pcidev_k->vendor_id = PCI_VENDOR_ID_REDHAT_QUMRANET;
+    pcidev_k->device_id = 0; /* Set by virtio-pci based on virtio id */
+    pcidev_k->revision = 0x00;
+    pcidev_k->class_id = PCI_CLASS_MULTIMEDIA_AUDIO;
+}
+
+static void vhost_user_snd_pci_instance_init(Object *obj)
+{
+    VHostUserSoundPCI *dev = VHOST_USER_SND_PCI(obj);
+
+    virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
+                                TYPE_VHOST_USER_SND);
+}
+
+static const VirtioPCIDeviceTypeInfo vhost_user_snd_pci_info = {
+    .base_name = TYPE_VHOST_USER_SND_PCI,
+    .non_transitional_name = "vhost-user-snd-pci",
+    .instance_size = sizeof(VHostUserSoundPCI),
+    .instance_init = vhost_user_snd_pci_instance_init,
+    .class_init = vhost_user_snd_pci_class_init,
+};
+
+static void vhost_user_snd_pci_register(void)
+{
+    virtio_pci_types_register(&vhost_user_snd_pci_info);
+}
+
+type_init(vhost_user_snd_pci_register);
diff --git a/hw/virtio/vhost-user-snd.c b/hw/virtio/vhost-user-snd.c
new file mode 100644
index 0000000000..9a217543f8
--- /dev/null
+++ b/hw/virtio/vhost-user-snd.c
@@ -0,0 +1,67 @@
+/*
+ * Vhost-user snd virtio device
+ *
+ * Copyright (c) 2023 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
+ *
+ * Simple wrapper of the generic vhost-user-device.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "hw/qdev-properties.h"
+#include "hw/virtio/virtio-bus.h"
+#include "hw/virtio/vhost-user-snd.h"
+#include "standard-headers/linux/virtio_ids.h"
+#include "standard-headers/linux/virtio_snd.h"
+
+static const VMStateDescription vu_snd_vmstate = {
+    .name = "vhost-user-snd",
+    .unmigratable = 1,
+};
+
+static Property vsnd_properties[] = {
+    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void vu_snd_base_realize(DeviceState *dev, Error **errp)
+{
+    VHostUserBase *vub = VHOST_USER_BASE(dev);
+    VHostUserBaseClass *vubs = VHOST_USER_BASE_GET_CLASS(dev);
+
+    vub->virtio_id = VIRTIO_ID_SOUND;
+    vub->num_vqs = 4;
+    vub->config_size = sizeof(struct virtio_snd_config);
+    vub->vq_size = 64;
+
+    vubs->parent_realize(dev, errp);
+}
+
+static void vu_snd_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    VHostUserBaseClass *vubc = VHOST_USER_BASE_CLASS(klass);
+
+    dc->vmsd = &vu_snd_vmstate;
+    device_class_set_props(dc, vsnd_properties);
+    device_class_set_parent_realize(dc, vu_snd_base_realize,
+                                    &vubc->parent_realize);
+
+    set_bit(DEVICE_CATEGORY_SOUND, dc->categories);
+}
+
+static const TypeInfo vu_snd_info = {
+    .name = TYPE_VHOST_USER_SND,
+    .parent = TYPE_VHOST_USER_BASE,
+    .instance_size = sizeof(VHostUserSound),
+    .class_init = vu_snd_class_init,
+};
+
+static void vu_snd_register_types(void)
+{
+    type_register_static(&vu_snd_info);
+}
+
+type_init(vu_snd_register_types)
diff --git a/hw/virtio/Kconfig b/hw/virtio/Kconfig
index 92c9cf6c96..aa63ff7fd4 100644
--- a/hw/virtio/Kconfig
+++ b/hw/virtio/Kconfig
@@ -101,6 +101,11 @@ config VHOST_VDPA_DEV
     default y
     depends on VIRTIO && VHOST_VDPA && LINUX
 
+config VHOST_USER_SND
+    bool
+    default y
+    depends on VIRTIO && VHOST_USER
+
 config VHOST_USER_SCMI
     bool
     default y
diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
index 0a4d29ace6..118d4d4da7 100644
--- a/hw/virtio/meson.build
+++ b/hw/virtio/meson.build
@@ -24,6 +24,7 @@ if have_vhost
     system_virtio_ss.add(when: 'CONFIG_VHOST_USER_GPIO', if_true: files('vhost-user-gpio.c'))
     system_virtio_ss.add(when: 'CONFIG_VHOST_USER_I2C', if_true: files('vhost-user-i2c.c'))
     system_virtio_ss.add(when: 'CONFIG_VHOST_USER_RNG', if_true: files('vhost-user-rng.c'))
+    system_virtio_ss.add(when: 'CONFIG_VHOST_USER_SND', if_true: files('vhost-user-snd.c'))
 
     # PCI Stubs
     system_virtio_ss.add(when: 'CONFIG_VIRTIO_PCI', if_true: files('vhost-user-device-pci.c'))
@@ -33,6 +34,8 @@ if have_vhost
                          if_true: files('vhost-user-i2c-pci.c'))
     system_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_RNG'],
                          if_true: files('vhost-user-rng-pci.c'))
+    system_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_SND'],
+                         if_true: files('vhost-user-snd-pci.c'))
   endif
   if have_vhost_vdpa
     system_virtio_ss.add(files('vhost-vdpa.c'))
-- 
2.39.2

