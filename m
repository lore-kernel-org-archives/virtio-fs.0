Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681834907; x=1684426907;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=RHdGm7j8I+C9yYQqKwhoXKBTWIBzPYm6rSCDYdpEQFY=;
 b=deuGwp5rAZYC5syALPZhWioCmWGRvpOYvx58ZCYZ7WjLW70hU8BaMdUoPk3XWoGQeG
 A6EDNB9tLeYj2TPgVYAilqzopjWPzRvzX7LWho4R+0QEayd8YwLf5hh72gxHI7S8E+I7
 mOHK2IIZRHZnOW7l7VteuVBMRl8c850wahOQhPZF/OF2hlGepIQQNJLV6uwuTKOOFVIi
 GMcgApm9FJNX+dHqzEHLPZ4CU02mO5i2qc8dyFaB3wFIpN+kRub7s41uG9ghK9bjPuev
 y6Yr36GzV+UTjHbPxUOHBD2nq84ACoQ+7L0ruxwSOIHjTn7OGM5gCgBO7UCXvRepD6bk
 U+vg==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 18 Apr 2023 17:21:36 +0100
Message-Id: <20230418162140.373219-10-alex.bennee@linaro.org>
In-Reply-To: <20230418162140.373219-1-alex.bennee@linaro.org>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 09/13] hw/virtio: derive vhost-user-rng from
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

Now we can take advantage of our new base class and make
vhost-user-rng a much simpler boilerplate wrapper. Also as this
doesn't require any target specific hacks we only need to build the
stubs once.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v2
  - new derivation layout
  - move directly to softmmu_virtio_ss
---
 include/hw/virtio/vhost-user-rng.h |  11 +-
 hw/virtio/vhost-user-rng.c         | 277 +++--------------------------
 hw/virtio/meson.build              |   7 +-
 3 files changed, 28 insertions(+), 267 deletions(-)

diff --git a/include/hw/virtio/vhost-user-rng.h b/include/hw/virtio/vhost-user-rng.h
index ddd9f01eea..13139c0d9d 100644
--- a/include/hw/virtio/vhost-user-rng.h
+++ b/include/hw/virtio/vhost-user-rng.h
@@ -12,21 +12,14 @@
 #include "hw/virtio/virtio.h"
 #include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-user.h"
-#include "chardev/char-fe.h"
+#include "hw/virtio/vhost-user-device.h"
 
 #define TYPE_VHOST_USER_RNG "vhost-user-rng"
 OBJECT_DECLARE_SIMPLE_TYPE(VHostUserRNG, VHOST_USER_RNG)
 
 struct VHostUserRNG {
     /*< private >*/
-    VirtIODevice parent;
-    CharBackend chardev;
-    struct vhost_virtqueue *vhost_vq;
-    struct vhost_dev vhost_dev;
-    VhostUserState vhost_user;
-    VirtQueue *req_vq;
-    bool connected;
-
+    VHostUserBase parent;
     /*< public >*/
 };
 
diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
index efc54cd3fb..71d3991f93 100644
--- a/hw/virtio/vhost-user-rng.c
+++ b/hw/virtio/vhost-user-rng.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2021 Mathieu Poirier <mathieu.poirier@linaro.org>
  *
- * Implementation seriously tailored on vhost-user-i2c.c
+ * Simple wrapper of the generic vhost-user-device.
  *
  * SPDX-License-Identifier: GPL-2.0-or-later
  */
@@ -13,281 +13,46 @@
 #include "hw/qdev-properties.h"
 #include "hw/virtio/virtio-bus.h"
 #include "hw/virtio/vhost-user-rng.h"
-#include "qemu/error-report.h"
 #include "standard-headers/linux/virtio_ids.h"
 
-static const int feature_bits[] = {
-    VIRTIO_F_RING_RESET,
-    VHOST_INVALID_FEATURE_BIT
-};
-
-static void vu_rng_start(VirtIODevice *vdev)
-{
-    VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-    BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
-    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    int ret;
-    int i;
-
-    if (!k->set_guest_notifiers) {
-        error_report("binding does not support guest notifiers");
-        return;
-    }
-
-    ret = vhost_dev_enable_notifiers(&rng->vhost_dev, vdev);
-    if (ret < 0) {
-        error_report("Error enabling host notifiers: %d", -ret);
-        return;
-    }
-
-    ret = k->set_guest_notifiers(qbus->parent, rng->vhost_dev.nvqs, true);
-    if (ret < 0) {
-        error_report("Error binding guest notifier: %d", -ret);
-        goto err_host_notifiers;
-    }
-
-    rng->vhost_dev.acked_features = vdev->guest_features;
-    ret = vhost_dev_start(&rng->vhost_dev, vdev, true);
-    if (ret < 0) {
-        error_report("Error starting vhost-user-rng: %d", -ret);
-        goto err_guest_notifiers;
-    }
-
-    /*
-     * guest_notifier_mask/pending not used yet, so just unmask
-     * everything here. virtio-pci will do the right thing by
-     * enabling/disabling irqfd.
-     */
-    for (i = 0; i < rng->vhost_dev.nvqs; i++) {
-        vhost_virtqueue_mask(&rng->vhost_dev, vdev, i, false);
-    }
-
-    return;
-
-err_guest_notifiers:
-    k->set_guest_notifiers(qbus->parent, rng->vhost_dev.nvqs, false);
-err_host_notifiers:
-    vhost_dev_disable_notifiers(&rng->vhost_dev, vdev);
-}
-
-static void vu_rng_stop(VirtIODevice *vdev)
-{
-    VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-    BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
-    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    int ret;
-
-    if (!k->set_guest_notifiers) {
-        return;
-    }
-
-    vhost_dev_stop(&rng->vhost_dev, vdev, true);
-
-    ret = k->set_guest_notifiers(qbus->parent, rng->vhost_dev.nvqs, false);
-    if (ret < 0) {
-        error_report("vhost guest notifier cleanup failed: %d", ret);
-        return;
-    }
-
-    vhost_dev_disable_notifiers(&rng->vhost_dev, vdev);
-}
-
-static void vu_rng_set_status(VirtIODevice *vdev, uint8_t status)
-{
-    VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-    bool should_start = virtio_device_should_start(vdev, status);
-
-    if (vhost_dev_is_started(&rng->vhost_dev) == should_start) {
-        return;
-    }
-
-    if (should_start) {
-        vu_rng_start(vdev);
-    } else {
-        vu_rng_stop(vdev);
-    }
-}
-
-static uint64_t vu_rng_get_features(VirtIODevice *vdev,
-                                    uint64_t requested_features, Error **errp)
-{
-    VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-
-    return vhost_get_features(&rng->vhost_dev, feature_bits,
-                              requested_features);
-}
-
-static void vu_rng_handle_output(VirtIODevice *vdev, VirtQueue *vq)
-{
-    /*
-     * Not normally called; it's the daemon that handles the queue;
-     * however virtio's cleanup path can call this.
-     */
-}
-
-static void vu_rng_guest_notifier_mask(VirtIODevice *vdev, int idx, bool mask)
-{
-    VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-
-    vhost_virtqueue_mask(&rng->vhost_dev, vdev, idx, mask);
-}
-
-static bool vu_rng_guest_notifier_pending(VirtIODevice *vdev, int idx)
-{
-    VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-
-    return vhost_virtqueue_pending(&rng->vhost_dev, idx);
-}
-
-static void vu_rng_connect(DeviceState *dev)
-{
-    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
-    VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-
-    if (rng->connected) {
-        return;
-    }
-
-    rng->connected = true;
-
-    /* restore vhost state */
-    if (virtio_device_started(vdev, vdev->status)) {
-        vu_rng_start(vdev);
-    }
-}
-
-static void vu_rng_disconnect(DeviceState *dev)
-{
-    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
-    VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-
-    if (!rng->connected) {
-        return;
-    }
-
-    rng->connected = false;
-
-    if (vhost_dev_is_started(&rng->vhost_dev)) {
-        vu_rng_stop(vdev);
-    }
-}
-
-static void vu_rng_event(void *opaque, QEMUChrEvent event)
-{
-    DeviceState *dev = opaque;
-
-    switch (event) {
-    case CHR_EVENT_OPENED:
-        vu_rng_connect(dev);
-        break;
-    case CHR_EVENT_CLOSED:
-        vu_rng_disconnect(dev);
-        break;
-    case CHR_EVENT_BREAK:
-    case CHR_EVENT_MUX_IN:
-    case CHR_EVENT_MUX_OUT:
-        /* Ignore */
-        break;
-    }
-}
-
-static void vu_rng_device_realize(DeviceState *dev, Error **errp)
-{
-    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
-    VHostUserRNG *rng = VHOST_USER_RNG(dev);
-    int ret;
-
-    if (!rng->chardev.chr) {
-        error_setg(errp, "missing chardev");
-        return;
-    }
-
-    if (!vhost_user_init(&rng->vhost_user, &rng->chardev, errp)) {
-        return;
-    }
-
-    virtio_init(vdev, VIRTIO_ID_RNG, 0);
-
-    rng->req_vq = virtio_add_queue(vdev, 4, vu_rng_handle_output);
-    if (!rng->req_vq) {
-        error_setg_errno(errp, -1, "virtio_add_queue() failed");
-        goto virtio_add_queue_failed;
-    }
-
-    rng->vhost_dev.nvqs = 1;
-    rng->vhost_dev.vqs = g_new0(struct vhost_virtqueue, rng->vhost_dev.nvqs);
-    ret = vhost_dev_init(&rng->vhost_dev, &rng->vhost_user,
-                         VHOST_BACKEND_TYPE_USER, 0, errp);
-    if (ret < 0) {
-        error_setg_errno(errp, -ret, "vhost_dev_init() failed");
-        goto vhost_dev_init_failed;
-    }
-
-    qemu_chr_fe_set_handlers(&rng->chardev, NULL, NULL, vu_rng_event, NULL,
-                             dev, NULL, true);
-
-    return;
-
-vhost_dev_init_failed:
-    g_free(rng->vhost_dev.vqs);
-    virtio_delete_queue(rng->req_vq);
-virtio_add_queue_failed:
-    virtio_cleanup(vdev);
-    vhost_user_cleanup(&rng->vhost_user);
-}
-
-static void vu_rng_device_unrealize(DeviceState *dev)
-{
-    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
-    VHostUserRNG *rng = VHOST_USER_RNG(dev);
-    struct vhost_virtqueue *vhost_vqs = rng->vhost_dev.vqs;
-
-    vu_rng_set_status(vdev, 0);
-
-    vhost_dev_cleanup(&rng->vhost_dev);
-    g_free(vhost_vqs);
-    virtio_delete_queue(rng->req_vq);
-    virtio_cleanup(vdev);
-    vhost_user_cleanup(&rng->vhost_user);
-}
-
-static struct vhost_dev *vu_rng_get_vhost(VirtIODevice *vdev)
-{
-    VHostUserRNG *rng = VHOST_USER_RNG(vdev);
-    return &rng->vhost_dev;
-}
-
 static const VMStateDescription vu_rng_vmstate = {
     .name = "vhost-user-rng",
     .unmigratable = 1,
 };
 
-static Property vu_rng_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserRNG, chardev),
+static Property vrng_properties[] = {
+    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
     DEFINE_PROP_END_OF_LIST(),
 };
 
+static void vu_rng_base_realize(DeviceState *dev, Error **errp)
+{
+    VHostUserBase *vub = VHOST_USER_BASE(dev);
+    VHostUserBaseClass *vubs = VHOST_USER_BASE_GET_CLASS(dev);
+
+    /* Fixed for RNG */
+    vub->virtio_id = VIRTIO_ID_RNG;
+    vub->num_vqs = 1;
+
+    vubs->parent_realize(dev, errp);
+}
+
 static void vu_rng_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
-    VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
+    VHostUserBaseClass *vubc = VHOST_USER_BASE_CLASS(klass);
 
-    device_class_set_props(dc, vu_rng_properties);
     dc->vmsd = &vu_rng_vmstate;
-    set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
+    device_class_set_props(dc, vrng_properties);
+    device_class_set_parent_realize(dc, vu_rng_base_realize,
+                                    &vubc->parent_realize);
 
-    vdc->realize = vu_rng_device_realize;
-    vdc->unrealize = vu_rng_device_unrealize;
-    vdc->get_features = vu_rng_get_features;
-    vdc->set_status = vu_rng_set_status;
-    vdc->guest_notifier_mask = vu_rng_guest_notifier_mask;
-    vdc->guest_notifier_pending = vu_rng_guest_notifier_pending;
-    vdc->get_vhost = vu_rng_get_vhost;
+    set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
 }
 
 static const TypeInfo vu_rng_info = {
     .name = TYPE_VHOST_USER_RNG,
-    .parent = TYPE_VIRTIO_DEVICE,
+    .parent = TYPE_VHOST_USER_BASE,
     .instance_size = sizeof(VHostUserRNG),
     .class_init = vu_rng_class_init,
 };
diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
index c0a86b94ae..de442dcb96 100644
--- a/hw/virtio/meson.build
+++ b/hw/virtio/meson.build
@@ -3,6 +3,11 @@ softmmu_virtio_ss.add(files('virtio-bus.c'))
 softmmu_virtio_ss.add(when: 'CONFIG_VIRTIO_PCI', if_true: files('virtio-pci.c'))
 softmmu_virtio_ss.add(when: 'CONFIG_VIRTIO_MMIO', if_true: files('virtio-mmio.c'))
 
+# VirtIO stubs which don't need building per-guest
+softmmu_virtio_ss.add(when: 'CONFIG_VHOST_USER_RNG', if_true: files('vhost-user-rng.c'))
+softmmu_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_RNG'],
+                      if_true: files('vhost-user-rng-pci.c'))
+
 specific_virtio_ss = ss.source_set()
 specific_virtio_ss.add(files('virtio.c'))
 specific_virtio_ss.add(files('virtio-config-io.c', 'virtio-qmp.c'))
@@ -32,7 +37,6 @@ specific_virtio_ss.add(when: 'CONFIG_VIRTIO_RNG', if_true: files('virtio-rng.c')
 specific_virtio_ss.add(when: 'CONFIG_VIRTIO_IOMMU', if_true: files('virtio-iommu.c'))
 specific_virtio_ss.add(when: 'CONFIG_VIRTIO_MEM', if_true: files('virtio-mem.c'))
 specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_I2C', if_true: files('vhost-user-i2c.c'))
-specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_RNG', if_true: files('vhost-user-rng.c'))
 specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_GPIO', if_true: files('vhost-user-gpio.c'))
 specific_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_GPIO'], if_true: files('vhost-user-gpio-pci.c'))
 specific_virtio_ss.add(when: 'CONFIG_VHOST_VDPA_DEV', if_true: files('vdpa-dev.c'))
@@ -43,7 +47,6 @@ virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_VSOCK', if_true: files('vhost-user-vs
 virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_BLK', if_true: files('vhost-user-blk-pci.c'))
 virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_I2C', if_true: files('vhost-user-i2c-pci.c'))
 virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_INPUT', if_true: files('vhost-user-input-pci.c'))
-virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_RNG', if_true: files('vhost-user-rng-pci.c'))
 virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_SCSI', if_true: files('vhost-user-scsi-pci.c'))
 virtio_pci_ss.add(when: 'CONFIG_VHOST_SCSI', if_true: files('vhost-scsi-pci.c'))
 virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_FS', if_true: files('vhost-user-fs-pci.c'))
-- 
2.39.2

