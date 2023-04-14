Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681488275; x=1684080275;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=9tB5/chm/xr33XCg/P0FBnvaCeSkgyIRzyFrSzsSo0k=;
 b=nfBBBpcykoTEqquKkMJXT0yVy3hlK6944jFPb+9q/eLqYGwR6OqL1NKSzrzDZu4z5V
 aDTXWqxVpV6+PU1xcb26oAR56WQCQBD8X9IHbnAGfTGAvflVAZffs+BqKjdkaU8W0PCZ
 SOLzokotez54WLEyTiP8xIshpQDcPfgfVPWnEDoqCU/xZae902SRbgKJPNabP9k4sle9
 d9MpjhkbOO5OchlXX/gtLJx0/DenVWuyB4C+olBQd9dKiLUB6kim93kCQlEQAoWlJtT3
 g0k43sMM4yK4Od+sWIGf4FsN/Bz85625AhyE+dnsQsZPzIei7PpsvwgfRdUo5PS7kiFA
 pkKw==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Fri, 14 Apr 2023 17:04:24 +0100
Message-Id: <20230414160433.2096866-4-alex.bennee@linaro.org>
In-Reply-To: <20230414160433.2096866-1-alex.bennee@linaro.org>
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 03/12] include/hw/virtio: add kerneldoc for
 virtio_init
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
 include/hw/virtio/virtio.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 22ec098462..1ba7a9dd74 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -217,6 +217,12 @@ struct VirtioDeviceClass {
 void virtio_instance_init_common(Object *proxy_obj, void *data,
                                  size_t vdev_size, const char *vdev_name);
 
+/**
+ * virtio_init() - initialise the common VirtIODevice structure
+ * @vdev: pointer to VirtIODevice
+ * @device_id: the VirtIO device ID (see virtio_ids.h)
+ * @config_size: size of the config space
+ */
 void virtio_init(VirtIODevice *vdev, uint16_t device_id, size_t config_size);
 
 void virtio_cleanup(VirtIODevice *vdev);
-- 
2.39.2

