Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681834902; x=1684426902;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=2d/kTabziFWz81diPGPd2lcq9eXntPtMnKyAEA11+CY=;
 b=VBIl2DDITwHYzCBWk8T/c3PSW1X/2UIjoMDfUr0uzjO1UAEp9twCZm7Pu6X01Vb4TS
 MDDcY8sUPQvlfFBou1xMdSZ8oMBcyY6dAh7h/8HGUxYrlDuQpOYVKBdGUOEBs8g2oNF3
 hNzuNZHkf87fQTu/BlnAJKfu6mD4W6HV3DyZ7bElssGj2fsRDQsrLfOea90OVg7uuxST
 qICsIFBVYL9wzNoV0qnAMT7M1CnOdEBK+FF62kykL9Vm0ghchrwt9xpmxF2Z6mQYFGBY
 sIFy2WBte33dS4OPTCmE+njA9hediQv9SIC+QyHCjaymAv93BCJ0P0f+WGjfb6A/2xaC
 88og==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 18 Apr 2023 17:21:29 +0100
Message-Id: <20230418162140.373219-3-alex.bennee@linaro.org>
In-Reply-To: <20230418162140.373219-1-alex.bennee@linaro.org>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 02/13] include/hw: document the
 device_class_set_parent_* fns
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

These are useful functions for when you want proper inheritance of
functionality across realize/unrealize calls.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/qdev-core.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index d4bbc30c92..b1d194b561 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -795,9 +795,36 @@ void device_class_set_props(DeviceClass *dc, Property *props);
 void device_class_set_parent_reset(DeviceClass *dc,
                                    DeviceReset dev_reset,
                                    DeviceReset *parent_reset);
+
+/**
+ * device_class_set_parent_realize(): set up for chaining realize fns
+ * @dc: The device class
+ * @dev_realize: the device realize function
+ * @parent_realize: somewhere to save the parents realize function
+ *
+ * This is intended to be used when the new realize function will
+ * eventually call its parent realization function during creation.
+ * This requires storing the function call somewhere (usually in the
+ * instance structure) so you can eventually call:
+ *   my_dev->parent_realize(dev, errp);
+ */
 void device_class_set_parent_realize(DeviceClass *dc,
                                      DeviceRealize dev_realize,
                                      DeviceRealize *parent_realize);
+
+
+/**
+ * device_class_set_parent_unrealize(): set up for chaining unrealize fns
+ * @dc: The device class
+ * @dev_unrealize: the device realize function
+ * @parent_unrealize: somewhere to save the parents unrealize function
+ *
+ * This is intended to be used when the new unrealize function will
+ * eventually call its parent unrealization function during the
+ * unrealize phase. This requires storing the function call somewhere
+ * (usually in the instance structure) so you can eventually call:
+ *   my_dev->parent_unrealize(dev);
+ */
 void device_class_set_parent_unrealize(DeviceClass *dc,
                                        DeviceUnrealize dev_unrealize,
                                        DeviceUnrealize *parent_unrealize);
-- 
2.39.2

