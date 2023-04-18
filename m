Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681834906; x=1684426906;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=uTkEU0oqDGeWEiEFn49DE5kPkeQF20sGslhQri+i2Js=;
 b=Qx4KdgdPZjW3qENTPMJcMl8Ulf9v7o9rH1J8gU/pwRgUKgk7FciB6j07A4w9Y4PmeP
 eSx8DfuLJc262S8OMkXsepujdQ8PVmihiXGn15NkgfJPxKWJKjvto91EBAzWQ8TUSf6C
 7piiG2N2DugFTjQx+FykbO5SaBYW5NF7FoqsWPRNSdwmsYM/dIleNZrGqNUrDXlyB4fl
 k7MHLz4Sy0SiCgqS3rYa1p7sGh0MLaIOxO1jYjPr7CeFO1e8bFbxTgyteR2J6jOPfNlX
 cfPUGK++kx3ZVxJexecLX/54ut58loJbBsBqibRW2YaEIZfirKgnfmdrHMYAYNjnels6
 pxCA==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 18 Apr 2023 17:21:37 +0100
Message-Id: <20230418162140.373219-11-alex.bennee@linaro.org>
In-Reply-To: <20230418162140.373219-1-alex.bennee@linaro.org>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 10/13] hw/virtio: add config support to
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

To use the generic device the user will need to provide the config
region size via the command line. We also add a notifier so the guest
can be pinged if the remote daemon updates the config.

With these changes:

  -device vhost-user-device-pci,virtio-id=41,num_vqs=2,config_size=8

is equivalent to:

  -device vhost-user-gpio-pci

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/virtio/vhost-user-device.h |  1 +
 hw/virtio/vhost-user-device.c         | 58 ++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/hw/virtio/vhost-user-device.h b/include/hw/virtio/vhost-user-device.h
index 9105011e25..3ddf88a146 100644
--- a/include/hw/virtio/vhost-user-device.h
+++ b/include/hw/virtio/vhost-user-device.h
@@ -22,6 +22,7 @@ struct VHostUserBase {
     CharBackend chardev;
     uint16_t virtio_id;
     uint32_t num_vqs;
+    uint32_t config_size;
     /* State tracking */
     VhostUserState vhost_user;
     struct vhost_virtqueue *vhost_vq;
diff --git a/hw/virtio/vhost-user-device.c b/hw/virtio/vhost-user-device.c
index b0239fa033..2b028cae08 100644
--- a/hw/virtio/vhost-user-device.c
+++ b/hw/virtio/vhost-user-device.c
@@ -117,6 +117,42 @@ static uint64_t vub_get_features(VirtIODevice *vdev,
     return vub->vhost_dev.features & ~(1ULL << VHOST_USER_F_PROTOCOL_FEATURES);
 }
 
+/*
+ * To handle VirtIO config we need to know the size of the config
+ * space. We don't cache the config but re-fetch it from the guest
+ * every time in case something has changed.
+ */
+static void vub_get_config(VirtIODevice *vdev, uint8_t *config)
+{
+    VHostUserBase *vub = VHOST_USER_BASE(vdev);
+    Error *local_err = NULL;
+
+    /*
+     * There will have been a warning during vhost_dev_init, but lets
+     * assert here as nothing will go right now.
+     */
+    g_assert(vub->config_size && vub->vhost_user.supports_config == true);
+
+    if (vhost_dev_get_config(&vub->vhost_dev, config,
+                             vub->config_size, &local_err)) {
+        error_report_err(local_err);
+    }
+}
+
+/*
+ * When the daemon signals an update to the config we just need to
+ * signal the guest as we re-read the config on demand above.
+ */
+static int vub_config_notifier(struct vhost_dev *dev)
+{
+    virtio_notify_config(dev->vdev);
+    return 0;
+}
+
+const VhostDevConfigOps vub_config_ops = {
+    .vhost_dev_config_notifier = vub_config_notifier,
+};
+
 static void vub_handle_output(VirtIODevice *vdev, VirtQueue *vq)
 {
     /*
@@ -141,12 +177,21 @@ static int vub_connect(DeviceState *dev)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VHostUserBase *vub = VHOST_USER_BASE(vdev);
+    struct vhost_dev *vhost_dev = &vub->vhost_dev;
 
     if (vub->connected) {
         return 0;
     }
     vub->connected = true;
 
+    /*
+     * If we support VHOST_USER_GET_CONFIG we must enable the notifier
+     * so we can ping the guest when it updates.
+     */
+    if (vub->vhost_user.supports_config) {
+        vhost_dev_set_config_notifier(vhost_dev, &vub_config_ops);
+    }
+
     /* restore vhost state */
     if (virtio_device_started(vdev, vdev->status)) {
         vub_start(vdev);
@@ -214,11 +259,20 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
         vub->num_vqs = 1; /* reasonable default? */
     }
 
+    /*
+     * We can't handle config requests unless we know the size of the
+     * config region, specialisations of the vhost-user-device will be
+     * able to set this.
+     */
+    if (vub->config_size) {
+        vub->vhost_user.supports_config = true;
+    }
+
     if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
         return;
     }
 
-    virtio_init(vdev, vub->virtio_id, 0);
+    virtio_init(vdev, vub->virtio_id, vub->config_size);
 
     /*
      * Disable guest notifiers, by default all notifications will be via the
@@ -268,6 +322,7 @@ static void vub_class_init(ObjectClass *klass, void *data)
     vdc->realize = vub_device_realize;
     vdc->unrealize = vub_device_unrealize;
     vdc->get_features = vub_get_features;
+    vdc->get_config = vub_get_config;
     vdc->set_status = vub_set_status;
 }
 
@@ -295,6 +350,7 @@ static Property vud_properties[] = {
     DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
     DEFINE_PROP_UINT16("virtio-id", VHostUserBase, virtio_id, 0),
     DEFINE_PROP_UINT32("num_vqs", VHostUserBase, num_vqs, 1),
+    DEFINE_PROP_UINT32("config_size", VHostUserBase, config_size, 0),
     DEFINE_PROP_END_OF_LIST(),
 };
 
-- 
2.39.2

