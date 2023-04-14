Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681488279; x=1684080279;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=8LanDirQaSq5LBuEyiFieoGUbbdGI81Zqz66tepS9FQ=;
 b=U+LgH173VoEnClmk7N0zz0J0Rbd4X7uGJOV6cb1+Vm9EpXFm77MJQJOHdsXWn5tQa6
 RzHZyoSBqWlab3YUwF42OKbMZ/hcISl09QhqYXX8+OOT4TdzQ8y7lFnLeFfU3SXSG07S
 sqxYetcbQknkip75ZkqNrPqtOvFUuhBxn+4PxmAaUOw1nx53VG+QKQN6RfkqLzIHFXDN
 mlRm5NAOoa8fFcM9ttDD0kw2hI/W9+qpw7hNvTM+JCOVjw0iyawvPgAYTqATjS4LvGNB
 x2aJ0o20sJKrycdLO5aMw1PP2PgN+ypmh5D2RAdDudGPHMbBYtvnHBCk0pF3mL4Z0wwB
 8T+g==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Fri, 14 Apr 2023 17:04:31 +0100
Message-Id: <20230414160433.2096866-11-alex.bennee@linaro.org>
In-Reply-To: <20230414160433.2096866-1-alex.bennee@linaro.org>
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 10/12] hw/virtio: add config support to
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
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>

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
index 8d77f06721..cb98e0dcaa 100644
--- a/include/hw/virtio/vhost-user-device.h
+++ b/include/hw/virtio/vhost-user-device.h
@@ -21,6 +21,7 @@ struct VHostUserDevice {
     CharBackend chardev;
     uint16_t virtio_id;
     uint32_t num_vqs;
+    uint32_t config_size;
     /* State tracking */
     VhostUserState vhost_user;
     struct vhost_virtqueue *vhost_vq;
diff --git a/hw/virtio/vhost-user-device.c b/hw/virtio/vhost-user-device.c
index bfbf3b29cb..977cfed247 100644
--- a/hw/virtio/vhost-user-device.c
+++ b/hw/virtio/vhost-user-device.c
@@ -117,6 +117,42 @@ static uint64_t vud_get_features(VirtIODevice *vdev,
     return vud->vhost_dev.features & ~(1ULL << VHOST_USER_F_PROTOCOL_FEATURES);
 }
 
+/*
+ * To handle VirtIO config we need to know the size of the config
+ * space. We don't cache the config but re-fetch it from the guest
+ * every time in case something has changed.
+ */
+static void vud_get_config(VirtIODevice *vdev, uint8_t *config)
+{
+    VHostUserDevice *vud = VHOST_USER_DEVICE(vdev);
+    Error *local_err = NULL;
+
+    /*
+     * There will have been a warning during vhost_dev_init, but lets
+     * assert here as nothing will go right now.
+     */
+    g_assert(vud->config_size && vud->vhost_user.supports_config == true);
+
+    if (vhost_dev_get_config(&vud->vhost_dev, config,
+                             vud->config_size, &local_err)) {
+        error_report_err(local_err);
+    }
+}
+
+/*
+ * When the daemon signals an update to the config we just need to
+ * signal the guest as we re-read the config on demand above.
+ */
+static int vud_config_notifier(struct vhost_dev *dev)
+{
+    virtio_notify_config(dev->vdev);
+    return 0;
+}
+
+const VhostDevConfigOps vud_config_ops = {
+    .vhost_dev_config_notifier = vud_config_notifier,
+};
+
 static void vud_handle_output(VirtIODevice *vdev, VirtQueue *vq)
 {
     /*
@@ -141,12 +177,21 @@ static int vud_connect(DeviceState *dev)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VHostUserDevice *vud = VHOST_USER_DEVICE(vdev);
+    struct vhost_dev *vhost_dev = &vud->vhost_dev;
 
     if (vud->connected) {
         return 0;
     }
     vud->connected = true;
 
+    /*
+     * If we support VHOST_USER_GET_CONFIG we must enable the notifier
+     * so we can ping the guest when it updates.
+     */
+    if (vud->vhost_user.supports_config) {
+        vhost_dev_set_config_notifier(vhost_dev, &vud_config_ops);
+    }
+
     /* restore vhost state */
     if (virtio_device_started(vdev, vdev->status)) {
         vud_start(vdev);
@@ -214,11 +259,20 @@ static void vud_device_realize(DeviceState *dev, Error **errp)
         vud->num_vqs = 1; /* reasonable default? */
     }
 
+    /*
+     * We can't handle config requests unless we know the size of the
+     * config region, specialisations of the vhost-user-device will be
+     * able to set this.
+     */
+    if (vud->config_size) {
+        vud->vhost_user.supports_config = true;
+    }
+
     if (!vhost_user_init(&vud->vhost_user, &vud->chardev, errp)) {
         return;
     }
 
-    virtio_init(vdev, vud->virtio_id, 0);
+    virtio_init(vdev, vud->virtio_id, vud->config_size);
 
     /*
      * Disable guest notifiers, by default all notifications will be via the
@@ -271,6 +325,7 @@ static Property vud_properties[] = {
     DEFINE_PROP_CHR("chardev", VHostUserDevice, chardev),
     DEFINE_PROP_UINT16("virtio-id", VHostUserDevice, virtio_id, 0),
     DEFINE_PROP_UINT32("num_vqs", VHostUserDevice, num_vqs, 1),
+    DEFINE_PROP_UINT32("config_size", VHostUserDevice, config_size, 0),
     DEFINE_PROP_END_OF_LIST(),
 };
 
@@ -285,6 +340,7 @@ static void vud_class_init(ObjectClass *klass, void *data)
     vdc->realize = vud_device_realize;
     vdc->unrealize = vud_device_unrealize;
     vdc->get_features = vud_get_features;
+    vdc->get_config = vud_get_config;
     vdc->set_status = vud_set_status;
 }
 
-- 
2.39.2

