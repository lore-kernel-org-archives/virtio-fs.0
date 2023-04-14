Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681488276; x=1684080276;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=KH5LwiCrOTvBSCuNpYnxQcsypFz8wThrZQsAnqkj0KQ=;
 b=Sdj8gbiDPb4tzbA4IYEDhfIDNGgL1BAPjP2dI1RtO2mEIx2afuqR93ODe/ARptkGMc
 OgrYZvwPP6KoAwSs5SjkutYwzuhrQlzjuuxr0G+o2LSvwb6Y1kvL6uIBJstB8P+wqtoe
 ZTeSWcIx1YWMUCxRL9wvz/X3q8WBD0U2tbl6amzaot3mxH6pnjcWbbuS5HFkfxiL+Bpy
 R53uVYPdY7iEmXSAU/7QL4cxkwptnm0QpBRPx3945N/rbB1S0votndKpLEDWbPuhOuy8
 eyFgy61kF0I/tJipXdrdET3GXQ1o/RNL/WXgJfybuXLoV4+RUH/4OIyfpAieu92Jjpgs
 ueLA==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Fri, 14 Apr 2023 17:04:23 +0100
Message-Id: <20230414160433.2096866-3-alex.bennee@linaro.org>
In-Reply-To: <20230414160433.2096866-1-alex.bennee@linaro.org>
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 02/12] include/hw/virtio: document
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
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>

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

