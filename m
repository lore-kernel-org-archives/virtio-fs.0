Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681834903; x=1684426903;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=9tB5/chm/xr33XCg/P0FBnvaCeSkgyIRzyFrSzsSo0k=;
 b=uxF/LM8P9SZYpCizN3Zui8qVlBYHD8UmnmrC1P4/cPHgzoMR+6tpEocqtb4OTObdFu
 MkKKQLOd1q0sqZlccxyH79EF8Db7LqSH5t0w6Kz6I1XZaW+wf3uDOiFWRaXBNVT+Sosk
 1fdAurJNSm2ochL9YoawEwmvEVBOBOR73UBembnnlJRi35X+u2AHAbjvX25jWfbtoM7o
 l0tjtL1FEYufZXHPZxvC2aBfP/FDGzY09bo3q6ZCjvzCp0GRuxM/va62LMOY0UN8C2SG
 Clwy3iaEr3rEXPYtcaBYs2rBsHDMhCblSAqmqIGWohtaZZnUJzou1hJ3TDc36wjPmCnl
 K75g==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 18 Apr 2023 17:21:32 +0100
Message-Id: <20230418162140.373219-6-alex.bennee@linaro.org>
In-Reply-To: <20230418162140.373219-1-alex.bennee@linaro.org>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 05/13] include/hw/virtio: add kerneldoc for
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
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Jason Wang <jasowang@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Gerd Hoffmann <kraxel@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>

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

