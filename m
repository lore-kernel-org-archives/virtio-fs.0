Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003336; x=1691595336;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=+hje6WZSjT0couLKOVg8pz8KNazy1XWWPGcIUxlVXlw=;
 b=dScf+GYEj3ctwO9WuCXFy0yxJ3B0LV0V0i8bC1r6JpbiaAldVwo/K8eKPwhd/jg/pI
 2jLPNATky/tXkRu2pPN8+ioJ97SQUzIlDpQLrxDSlvwfVfWbThhbQrbNBYSEtrCnRtL5
 D7roIwllb2KQ2lhMVeuxvMyeE2bCgCOyJkHj3vWjkJEK1eQXm1PDbsr1y9RPsbHqxK3g
 g4i9CY2MWPTZZ7n5c5jqdl6l5dtXGUHtrMNgwnkAFio/uKQe5zWfwF+Y7TdFKDOJDEbr
 Vwxa/MDPutQf07jM78ZWbk5VhP2xZwFAsmcLSL7K34PP8WESfI9RNkae8oYxfTJ0FcqJ
 n/bg==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:20 +0100
Message-Id: <20230710153522.3469097-19-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-1-alex.bennee@linaro.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH v3 18/20] hw/virtio: validate F_STANDALONE
 also supports other protocol features
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

If the backend advertises F_STANDALONE validate that it supports the
other mandatory features or error out.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/virtio/vhost-user.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 28b021d5d3..3116b3e46a 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -74,6 +74,8 @@ enum VhostUserProtocolFeature {
     /* Feature 14 reserved for VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS. */
     VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS = 15,
     VHOST_USER_PROTOCOL_F_STATUS = 16,
+    VHOST_USER_PROTOCOL_F_XEN_MMAP = 17,
+    VHOST_USER_PROTOCOL_F_STANDALONE = 18,
     VHOST_USER_PROTOCOL_F_MAX
 };
 
@@ -2048,6 +2050,21 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
             }
         }
 
+        /*
+         * If the backend supports F_STANDALONE we should validate it
+         * supports the other features we expect. We can't check for
+         * F_CONFIG support until we know if there is a config space
+         * to manage.
+         */
+        if (virtio_has_feature(protocol_features,
+                               VHOST_USER_PROTOCOL_F_STANDALONE)) {
+            if (!virtio_has_feature(protocol_features, VHOST_USER_PROTOCOL_F_STATUS)) {
+                error_setg(errp, "vhost-user device expecting F_STANDALONE device to also "
+                           "support F_STATUS but it does not.");
+                return -EPROTO;
+            }
+        }
+
         /* final set of protocol features */
         dev->protocol_features = protocol_features;
         err = vhost_user_set_protocol_features(dev, dev->protocol_features);
-- 
2.39.2

