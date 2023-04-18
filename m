Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681834903; x=1684426903;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=KH5LwiCrOTvBSCuNpYnxQcsypFz8wThrZQsAnqkj0KQ=;
 b=XyBsieux2yV2IhpLu6LipUTherdcEmwmOtkCXSVxv6547QiZd/H7LzT/Lsa08V0kNr
 DpeP09zRP5qEJwpmyoYKqjV+zaoikE48DCCYH5W/XC7GuQTKoj8l0ecOV7Y66A8vlGQJ
 ogPOIcz6atx6ZQqW0SCMGMzRdFZh+rIEnCiNAf5tPo80IDMIBMkSLwKKnBuhq3oK1/ER
 illWpRqxPTZjET+nssfUxDZVnRVO4wgcfbDDff1ZRDwdtiw20K2X78Z6bZ4OzVMZgllh
 hi6fClMr9hsqUFbgItsCKU4+kSFoVpQVJATOM0PHQb7FLEusH+GUkwMsZcoKHSot5bll
 z8Mw==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 18 Apr 2023 17:21:31 +0100
Message-Id: <20230418162140.373219-5-alex.bennee@linaro.org>
In-Reply-To: <20230418162140.373219-1-alex.bennee@linaro.org>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 04/13] include/hw/virtio: document
 virtio_notify_config
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

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/virtio/virtio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index f236e94ca6..22ec098462 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -274,6 +274,13 @@ extern const VMStateInfo virtio_vmstate_info;
 
 int virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id);
 
+/**
+ * virtio_notify_config() - signal a change to device config
+ * @vdev: the virtio device
+ *
+ * Assuming the virtio device is up (VIRTIO_CONFIG_S_DRIVER_OK) this
+ * will trigger a guest interrupt and update the config version.
+ */
 void virtio_notify_config(VirtIODevice *vdev);
 
 bool virtio_queue_get_notification(VirtQueue *vq);
-- 
2.39.2

