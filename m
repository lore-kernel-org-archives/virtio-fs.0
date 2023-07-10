Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003329; x=1691595329;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=y4Dz/cKQcjk2Q/25bTqazNT9L0/TcrBA5Nkd7fUVra8=;
 b=IQ6KxQRuWoZTFUkZL8wqDIz4YT5YYYlpRTK64s4+asCrYQkq5sXvq0jbS4LgRX+juo
 FtY4+9d3ucFJRqycocNYzmkhe4UgUBGlsz3IrUIOp0FByx1E9dRL0/zMBv+TcbnnJReW
 tQjCnWQqFqJR2PF0iIBVAb7oWo9T8iWebaIaek0j3O3PolB/hK7o0uSDLJk5cX1Hd9Ui
 wjUTkyz46AX11puBd1fk3BeKwLDm8YLQLeSp7imUg4gwcmcCan+Ke0NUqy19t5G1D/7Q
 TG73nLUjtZpcj4x+O2BS3mK1qixN6ydz9YwDwJ8lWw9nC7Bp8SUjREKhknKybzAN/DNp
 9uMg==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:06 +0100
Message-Id: <20230710153522.3469097-5-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-1-alex.bennee@linaro.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 04/20] include/hw/virtio: document
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
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/virtio/virtio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 0492d26900..0671989383 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -276,6 +276,13 @@ extern const VMStateInfo virtio_vmstate_info;
 
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

