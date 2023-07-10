Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003334; x=1691595334;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=JKWNeoNsx/2Bubdm0GX5BfFMkN3cqqCetF/HK2T9c0w=;
 b=rqCoGiZpI4oisj7FdN/P6Pm6psogPLWGKfNE+QfmXGA6uns8bkHBwl9nUUc7Slpoux
 REs3/Y/tHGGUIV+GKSrXZygLL22svBBmvZkICCzTUBMDW7ay24vp4zi2zSHT6gYaUtAl
 SlzIMHB5KsNOvlOohboHl7kwRCJIGofIdkMuGWnXw5tR735M3U9hDfYXGsA5UvsOf9/y
 HDkatK5aMg0f/ZRqh6y5/4DV0rQtdCDbIgq/MB4M5h/skqpFWG/+3Bu1c0OFDwVyaKR9
 YQP1UG8GnC5dtKmAch3dCV8FVxsfMYlgTM2qCA69dNIyF2SYYLTZnTkIbPjOC0zbFt6q
 yGaQ==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:17 +0100
Message-Id: <20230710153522.3469097-16-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-1-alex.bennee@linaro.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH v3 15/20] hw/virtio: move vhost_user_init
 earlier
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

In preparation for getting the details of the VirtIO device directly
from the vhost-user daemon we should connect once we have validated
the chardev. We will actually move the connection in the next patch to
keep the changes small and bisectable.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/virtio/vhost-user-device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/vhost-user-device.c b/hw/virtio/vhost-user-device.c
index 2b028cae08..d787f52364 100644
--- a/hw/virtio/vhost-user-device.c
+++ b/hw/virtio/vhost-user-device.c
@@ -250,6 +250,10 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
+    if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
+        return;
+    }
+
     if (!vub->virtio_id) {
         error_setg(errp, "vhost-user-device: need to define device id");
         return;
@@ -268,10 +272,6 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
         vub->vhost_user.supports_config = true;
     }
 
-    if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
-        return;
-    }
-
     virtio_init(vdev, vub->virtio_id, vub->config_size);
 
     /*
-- 
2.39.2

