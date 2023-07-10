Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003803; x=1691595803;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=IVoZ+61FKCrNdklMoUuKRwdzJcWCiwu+9oFevqFhgNQ=;
 b=Vr0iX5PBlhO1Adj/4b7VlrHQkVn7GTOo5wyPKAYyOoIZEHmtrmf2CnnHEjUWaj3r5E
 gN1/wrYb3QfFv9cJ7Q+onYHROjTQ7g4Zk2+NvhwEx5lQUiRVDTA3Vspem0wuleZKlBTw
 HxZ5kfqcc4mZ5OGvHc4DKl1bxmJcccfgaf1hFufn/FOtw3wsH314q4Bjfx9ltnd83Dbg
 RvbJfwf39Lt2h6ddlusjcgwbBsceZCUeizDw6Aj5TX5ZaGT/rwtKPWaPWC5SFUqnexVj
 cNOLUD3riwHeX40BdeiIYBWMhiTu09Cv6qL4s4sfSUpe+/RCFyr7dZl0XKiMfrbRFWG9
 2mtg==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:22 +0100
Message-Id: <20230710153522.3469097-21-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-1-alex.bennee@linaro.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH v3 20/20] hw/virtio: allow vhost-user-device
 to be driven by backend
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

Instead of requiring all the information up front allow the
vhost_dev_init to complete and then see what information we have from
the backend.

This does change the order around somewhat.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/virtio/vhost-user-device.c | 45 +++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/hw/virtio/vhost-user-device.c b/hw/virtio/vhost-user-device.c
index 0109d4829d..b30b6265fb 100644
--- a/hw/virtio/vhost-user-device.c
+++ b/hw/virtio/vhost-user-device.c
@@ -243,7 +243,6 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VHostUserBase *vub = VHOST_USER_BASE(dev);
-    int ret;
 
     if (!vub->chardev.chr) {
         error_setg(errp, "vhost-user-device: missing chardev");
@@ -254,13 +253,43 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
+    if (vhost_dev_init(&vub->vhost_dev, &vub->vhost_user,
+                       VHOST_BACKEND_TYPE_USER, 0, errp)!=0) {
+        error_setg(errp, "vhost-user-device: unable to start connection");
+        return;
+    }
+
+    if (vub->vhost_dev.specs.device_id) {
+        if (vub->virtio_id && vub->virtio_id != vub->vhost_dev.specs.device_id) {
+            error_setg(errp, "vhost-user-device: backend id %d doesn't match cli %d",
+                       vub->vhost_dev.specs.device_id, vub->virtio_id);
+            return;
+        }
+        vub->virtio_id = vub->vhost_dev.specs.device_id;
+    }
+
     if (!vub->virtio_id) {
-        error_setg(errp, "vhost-user-device: need to define device id");
+        error_setg(errp, "vhost-user-device: need to define or be told device id");
         return;
     }
 
+    if (vub->vhost_dev.specs.min_vqs) {
+        if (vub->num_vqs) {
+            if (vub->num_vqs < vub->vhost_dev.specs.min_vqs ||
+                vub->num_vqs > vub->vhost_dev.specs.max_vqs) {
+                error_setg(errp,
+                           "vhost-user-device: selected nvqs (%d) out of bounds (%d->%d)",
+                           vub->num_vqs,
+                           vub->vhost_dev.specs.min_vqs, vub->vhost_dev.specs.max_vqs);
+                return;
+            }
+        } else {
+            vub->num_vqs = vub->vhost_dev.specs.min_vqs;
+        }
+    }
+
     if (!vub->num_vqs) {
-        vub->num_vqs = 1; /* reasonable default? */
+        error_setg(errp, "vhost-user-device: need to define number of vqs");
     }
 
     /*
@@ -287,16 +316,6 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
                         virtio_add_queue(vdev, 4, vub_handle_output));
     }
 
-    vub->vhost_dev.nvqs = vub->num_vqs;
-
-    /* connect to backend */
-    ret = vhost_dev_init(&vub->vhost_dev, &vub->vhost_user,
-                         VHOST_BACKEND_TYPE_USER, 0, errp);
-
-    if (ret < 0) {
-        do_vhost_user_cleanup(vdev, vub);
-    }
-
     qemu_chr_fe_set_handlers(&vub->chardev, NULL, NULL, vub_event, NULL,
                              dev, NULL, true);
 }
-- 
2.39.2

