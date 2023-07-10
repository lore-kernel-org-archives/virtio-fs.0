Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003802; x=1691595802;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=BNSYY0aQSTUHXzFTnzMxA99hIZ3LEiMZlUH/7FQpKls=;
 b=YH15xvhobY8NKTSC57QZAz6v9BkK2sney38Tz5C1DwmvpAH9ZuHGtEZHtG0sdzIOnz
 ChjGwrmQskZnDfU4iAE7CmtmW/aCdNc3/yFW+NMcPENbRVxwIRs2oxszMXenA6Koa7q8
 ONCPss2T5r0ROt9ewnCsbNXpOxHnQeEzaWxXIl70mvvhxet0GJHWwOYyiAXJ5eE+4wk+
 euB8K/msMSgqhWm4SBcPlyqdfl+VSQYsBw2+C0lLPsqj63Na8vZ9HAOm9iu+oVIBXW/t
 ZWhBvhNdq0FDfmnVYy2dPuyobWtRgj5ovMndveTNrvTNAhn+t60IsHYk2I1RG8kOJOYa
 60Kg==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:14 +0100
Message-Id: <20230710153522.3469097-13-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-1-alex.bennee@linaro.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 12/20] hw/virtio: derive vhost-user-i2c from
 vhost-user-base
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

Now we can take advantage of the new base class and make
vhost-user-i2c a much simpler boilerplate wrapper. Also as this
doesn't require any target specific hacks we only need to build the
stubs once.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v2
  - update to new inheritance scheme
  - move build to common code
v3
  - fix merge conflict in meson
---
 include/hw/virtio/vhost-user-i2c.h |  18 +-
 hw/virtio/vhost-user-i2c.c         | 271 ++---------------------------
 hw/virtio/meson.build              |   5 +-
 3 files changed, 26 insertions(+), 268 deletions(-)

diff --git a/include/hw/virtio/vhost-user-i2c.h b/include/hw/virtio/vhost-user-i2c.h
index 0f7acd40e3..47153782d1 100644
--- a/include/hw/virtio/vhost-user-i2c.h
+++ b/include/hw/virtio/vhost-user-i2c.h
@@ -12,20 +12,18 @@
 #include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-user.h"
 
+#include "hw/virtio/virtio.h"
+#include "hw/virtio/vhost.h"
+#include "hw/virtio/vhost-user.h"
+#include "hw/virtio/vhost-user-device.h"
+
 #define TYPE_VHOST_USER_I2C "vhost-user-i2c-device"
 OBJECT_DECLARE_SIMPLE_TYPE(VHostUserI2C, VHOST_USER_I2C)
 
 struct VHostUserI2C {
-    VirtIODevice parent;
-    CharBackend chardev;
-    struct vhost_virtqueue *vhost_vq;
-    struct vhost_dev vhost_dev;
-    VhostUserState vhost_user;
-    VirtQueue *vq;
-    bool connected;
+    /*< private >*/
+    VHostUserBase parent;
+    /*< public >*/
 };
 
-/* Virtio Feature bits */
-#define VIRTIO_I2C_F_ZERO_LENGTH_REQUEST		0
-
 #endif /* QEMU_VHOST_USER_I2C_H */
diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
index 4eef3f0633..4a1f644a87 100644
--- a/hw/virtio/vhost-user-i2c.c
+++ b/hw/virtio/vhost-user-i2c.c
@@ -14,253 +14,21 @@
 #include "qemu/error-report.h"
 #include "standard-headers/linux/virtio_ids.h"
 
-static const int feature_bits[] = {
-    VIRTIO_I2C_F_ZERO_LENGTH_REQUEST,
-    VIRTIO_F_RING_RESET,
-    VHOST_INVALID_FEATURE_BIT
+static Property vi2c_properties[] = {
+    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
+    DEFINE_PROP_END_OF_LIST(),
 };
 
-static void vu_i2c_start(VirtIODevice *vdev)
-{
-    BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
-    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-    int ret, i;
-
-    if (!k->set_guest_notifiers) {
-        error_report("binding does not support guest notifiers");
-        return;
-    }
-
-    ret = vhost_dev_enable_notifiers(&i2c->vhost_dev, vdev);
-    if (ret < 0) {
-        error_report("Error enabling host notifiers: %d", -ret);
-        return;
-    }
-
-    ret = k->set_guest_notifiers(qbus->parent, i2c->vhost_dev.nvqs, true);
-    if (ret < 0) {
-        error_report("Error binding guest notifier: %d", -ret);
-        goto err_host_notifiers;
-    }
-
-    i2c->vhost_dev.acked_features = vdev->guest_features;
-
-    ret = vhost_dev_start(&i2c->vhost_dev, vdev, true);
-    if (ret < 0) {
-        error_report("Error starting vhost-user-i2c: %d", -ret);
-        goto err_guest_notifiers;
-    }
-
-    /*
-     * guest_notifier_mask/pending not used yet, so just unmask
-     * everything here. virtio-pci will do the right thing by
-     * enabling/disabling irqfd.
-     */
-    for (i = 0; i < i2c->vhost_dev.nvqs; i++) {
-        vhost_virtqueue_mask(&i2c->vhost_dev, vdev, i, false);
-    }
-
-    return;
-
-err_guest_notifiers:
-    k->set_guest_notifiers(qbus->parent, i2c->vhost_dev.nvqs, false);
-err_host_notifiers:
-    vhost_dev_disable_notifiers(&i2c->vhost_dev, vdev);
-}
-
-static void vu_i2c_stop(VirtIODevice *vdev)
-{
-    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-    BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
-    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    int ret;
-
-    if (!k->set_guest_notifiers) {
-        return;
-    }
-
-    vhost_dev_stop(&i2c->vhost_dev, vdev, true);
-
-    ret = k->set_guest_notifiers(qbus->parent, i2c->vhost_dev.nvqs, false);
-    if (ret < 0) {
-        error_report("vhost guest notifier cleanup failed: %d", ret);
-        return;
-    }
-
-    vhost_dev_disable_notifiers(&i2c->vhost_dev, vdev);
-}
-
-static void vu_i2c_set_status(VirtIODevice *vdev, uint8_t status)
-{
-    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-    bool should_start = virtio_device_should_start(vdev, status);
-
-    if (vhost_dev_is_started(&i2c->vhost_dev) == should_start) {
-        return;
-    }
-
-    if (should_start) {
-        vu_i2c_start(vdev);
-    } else {
-        vu_i2c_stop(vdev);
-    }
-}
-
-static uint64_t vu_i2c_get_features(VirtIODevice *vdev,
-                                    uint64_t requested_features, Error **errp)
-{
-    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-
-    virtio_add_feature(&requested_features, VIRTIO_I2C_F_ZERO_LENGTH_REQUEST);
-    return vhost_get_features(&i2c->vhost_dev, feature_bits, requested_features);
-}
-
-static void vu_i2c_handle_output(VirtIODevice *vdev, VirtQueue *vq)
-{
-    /*
-     * Not normally called; it's the daemon that handles the queue;
-     * however virtio's cleanup path can call this.
-     */
-}
-
-static void vu_i2c_guest_notifier_mask(VirtIODevice *vdev, int idx, bool mask)
-{
-    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-
-    /*
-     * We don't support interrupts, return early if index is set to
-     * VIRTIO_CONFIG_IRQ_IDX.
-     */
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return;
-    }
-
-    vhost_virtqueue_mask(&i2c->vhost_dev, vdev, idx, mask);
-}
-
-static bool vu_i2c_guest_notifier_pending(VirtIODevice *vdev, int idx)
-{
-    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-
-    /*
-     * We don't support interrupts, return early if index is set to
-     * VIRTIO_CONFIG_IRQ_IDX.
-     */
-    if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return false;
-    }
-
-    return vhost_virtqueue_pending(&i2c->vhost_dev, idx);
-}
-
-static void do_vhost_user_cleanup(VirtIODevice *vdev, VHostUserI2C *i2c)
-{
-    vhost_user_cleanup(&i2c->vhost_user);
-    virtio_delete_queue(i2c->vq);
-    virtio_cleanup(vdev);
-}
-
-static int vu_i2c_connect(DeviceState *dev)
+static void vi2c_realize(DeviceState *dev, Error **errp)
 {
-    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
-    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
+    VHostUserBase *vub = VHOST_USER_BASE(dev);
+    VHostUserBaseClass *vubc = VHOST_USER_BASE_GET_CLASS(dev);
 
-    if (i2c->connected) {
-        return 0;
-    }
-    i2c->connected = true;
+    /* Fixed for I2C */
+    vub->virtio_id = VIRTIO_ID_I2C_ADAPTER;
+    vub->num_vqs = 1;
 
-    /* restore vhost state */
-    if (virtio_device_started(vdev, vdev->status)) {
-        vu_i2c_start(vdev);
-    }
-
-    return 0;
-}
-
-static void vu_i2c_disconnect(DeviceState *dev)
-{
-    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
-    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-
-    if (!i2c->connected) {
-        return;
-    }
-    i2c->connected = false;
-
-    if (vhost_dev_is_started(&i2c->vhost_dev)) {
-        vu_i2c_stop(vdev);
-    }
-}
-
-static void vu_i2c_event(void *opaque, QEMUChrEvent event)
-{
-    DeviceState *dev = opaque;
-    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
-    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
-
-    switch (event) {
-    case CHR_EVENT_OPENED:
-        if (vu_i2c_connect(dev) < 0) {
-            qemu_chr_fe_disconnect(&i2c->chardev);
-            return;
-        }
-        break;
-    case CHR_EVENT_CLOSED:
-        vu_i2c_disconnect(dev);
-        break;
-    case CHR_EVENT_BREAK:
-    case CHR_EVENT_MUX_IN:
-    case CHR_EVENT_MUX_OUT:
-        /* Ignore */
-        break;
-    }
-}
-
-static void vu_i2c_device_realize(DeviceState *dev, Error **errp)
-{
-    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
-    VHostUserI2C *i2c = VHOST_USER_I2C(dev);
-    int ret;
-
-    if (!i2c->chardev.chr) {
-        error_setg(errp, "vhost-user-i2c: missing chardev");
-        return;
-    }
-
-    if (!vhost_user_init(&i2c->vhost_user, &i2c->chardev, errp)) {
-        return;
-    }
-
-    virtio_init(vdev, VIRTIO_ID_I2C_ADAPTER, 0);
-
-    i2c->vhost_dev.nvqs = 1;
-    i2c->vq = virtio_add_queue(vdev, 4, vu_i2c_handle_output);
-    i2c->vhost_dev.vqs = g_new0(struct vhost_virtqueue, i2c->vhost_dev.nvqs);
-
-    ret = vhost_dev_init(&i2c->vhost_dev, &i2c->vhost_user,
-                         VHOST_BACKEND_TYPE_USER, 0, errp);
-    if (ret < 0) {
-        g_free(i2c->vhost_dev.vqs);
-        do_vhost_user_cleanup(vdev, i2c);
-    }
-
-    qemu_chr_fe_set_handlers(&i2c->chardev, NULL, NULL, vu_i2c_event, NULL,
-                             dev, NULL, true);
-}
-
-static void vu_i2c_device_unrealize(DeviceState *dev)
-{
-    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
-    VHostUserI2C *i2c = VHOST_USER_I2C(dev);
-    struct vhost_virtqueue *vhost_vqs = i2c->vhost_dev.vqs;
-
-    /* This will stop vhost backend if appropriate. */
-    vu_i2c_set_status(vdev, 0);
-    vhost_dev_cleanup(&i2c->vhost_dev);
-    g_free(vhost_vqs);
-    do_vhost_user_cleanup(vdev, i2c);
+    vubc->parent_realize(dev, errp);
 }
 
 static const VMStateDescription vu_i2c_vmstate = {
@@ -268,30 +36,21 @@ static const VMStateDescription vu_i2c_vmstate = {
     .unmigratable = 1,
 };
 
-static Property vu_i2c_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserI2C, chardev),
-    DEFINE_PROP_END_OF_LIST(),
-};
-
 static void vu_i2c_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
-    VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
+    VHostUserBaseClass *vubc = VHOST_USER_BASE_CLASS(klass);
 
-    device_class_set_props(dc, vu_i2c_properties);
     dc->vmsd = &vu_i2c_vmstate;
+    device_class_set_props(dc, vi2c_properties);
+    device_class_set_parent_realize(dc, vi2c_realize,
+                                    &vubc->parent_realize);
     set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
-    vdc->realize = vu_i2c_device_realize;
-    vdc->unrealize = vu_i2c_device_unrealize;
-    vdc->get_features = vu_i2c_get_features;
-    vdc->set_status = vu_i2c_set_status;
-    vdc->guest_notifier_mask = vu_i2c_guest_notifier_mask;
-    vdc->guest_notifier_pending = vu_i2c_guest_notifier_pending;
 }
 
 static const TypeInfo vu_i2c_info = {
     .name = TYPE_VHOST_USER_I2C,
-    .parent = TYPE_VIRTIO_DEVICE,
+    .parent = TYPE_VHOST_USER_BASE,
     .instance_size = sizeof(VHostUserI2C),
     .class_init = vu_i2c_class_init,
 };
diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
index 62ab2d82e0..d1d6892068 100644
--- a/hw/virtio/meson.build
+++ b/hw/virtio/meson.build
@@ -14,6 +14,9 @@ softmmu_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_RNG'],
 softmmu_virtio_ss.add(when: 'CONFIG_VHOST_USER_GPIO', if_true: files('vhost-user-gpio.c'))
 softmmu_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_GPIO'],
                       if_true: files('vhost-user-gpio-pci.c'))
+softmmu_virtio_ss.add(when: 'CONFIG_VHOST_USER_I2C', if_true: files('vhost-user-i2c.c'))
+softmmu_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_I2C'],
+                       if_true: files('vhost-user-i2c-pci.c'))
 
 specific_virtio_ss = ss.source_set()
 specific_virtio_ss.add(files('virtio.c'))
@@ -42,13 +45,11 @@ specific_virtio_ss.add(when: 'CONFIG_VHOST_VSOCK', if_true: files('vhost-vsock.c
 specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_VSOCK', if_true: files('vhost-user-vsock.c'))
 specific_virtio_ss.add(when: 'CONFIG_VIRTIO_RNG', if_true: files('virtio-rng.c'))
 specific_virtio_ss.add(when: 'CONFIG_VIRTIO_MEM', if_true: files('virtio-mem.c'))
-specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_I2C', if_true: files('vhost-user-i2c.c'))
 
 virtio_pci_ss = ss.source_set()
 virtio_pci_ss.add(when: 'CONFIG_VHOST_VSOCK', if_true: files('vhost-vsock-pci.c'))
 virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_VSOCK', if_true: files('vhost-user-vsock-pci.c'))
 virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_BLK', if_true: files('vhost-user-blk-pci.c'))
-virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_I2C', if_true: files('vhost-user-i2c-pci.c'))
 virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_INPUT', if_true: files('vhost-user-input-pci.c'))
 virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_SCSI', if_true: files('vhost-user-scsi-pci.c'))
 virtio_pci_ss.add(when: 'CONFIG_VHOST_SCSI', if_true: files('vhost-scsi-pci.c'))
-- 
2.39.2

