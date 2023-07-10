Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003328; x=1691595328;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=A5nrdE1EbWfnKTXnpPgJZ0uBCr/0VA1ZCTtf34qEAwI=;
 b=OrGn7Nwjm+XbE+PNmSMJuXVthHH3ULc6N4kPsnLW92+NTRe49XPenOJcvcj+rac9Pt
 nVKbFaUa4sjJBQ5JMRiOtgrIVvCNWGvOPL1tNcAW4f4tOH/emMZuKxg7rRXyDxt7iER4
 EVh843PUSJyRGBg3xZ2xsIqDnW8rBcSrOAnhBIdapzKLBQsvkCG7acr4Oq+d69200Srw
 WAsJ6ZdhbU8XMqnISdOThSNRm8ngNvfiGC5+pbMHzTRiBD+XPPnMyUiJhMWsDe9+zFNk
 fdGqiHCURsd4iiM3nGDx0bqt3xGWg0iHSBm2E2YXRApK8AGI5dMq9qV0vcb1IsF4Oe5i
 GRWg==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:04 +0100
Message-Id: <20230710153522.3469097-3-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-1-alex.bennee@linaro.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 02/20] include/hw: document the
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
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

These are useful functions for when you want proper inheritance of
functionality across realize/unrealize calls.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/qdev-core.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index 196ebf6d91..884c726a87 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -952,9 +952,36 @@ void device_class_set_props(DeviceClass *dc, Property *props);
 void device_class_set_parent_reset(DeviceClass *dc,
                                    DeviceReset dev_reset,
                                    DeviceReset *parent_reset);
+
+/**
+ * device_class_set_parent_realize() - set up for chaining realize fns
+ * @dc: The device class
+ * @dev_realize: the device realize function
+ * @parent_realize: somewhere to save the parents realize function
+ *
+ * This is intended to be used when the new realize function will
+ * eventually call its parent realization function during creation.
+ * This requires storing the function call somewhere (usually in the
+ * instance structure) so you can eventually call
+ * dc->parent_realize(dev, errp)
+ */
 void device_class_set_parent_realize(DeviceClass *dc,
                                      DeviceRealize dev_realize,
                                      DeviceRealize *parent_realize);
+
+
+/**
+ * device_class_set_parent_unrealize() - set up for chaining unrealize fns
+ * @dc: The device class
+ * @dev_unrealize: the device realize function
+ * @parent_unrealize: somewhere to save the parents unrealize function
+ *
+ * This is intended to be used when the new unrealize function will
+ * eventually call its parent unrealization function during the
+ * unrealize phase. This requires storing the function call somewhere
+ * (usually in the instance structure) so you can eventually call
+ * dc->parent_unrealize(dev);
+ */
 void device_class_set_parent_unrealize(DeviceClass *dc,
                                        DeviceUnrealize dev_unrealize,
                                        DeviceUnrealize *parent_unrealize);
-- 
2.39.2

