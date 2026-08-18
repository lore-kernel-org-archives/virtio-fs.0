Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E13D3C456F
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029944; cv=none; b=VERxiNbAmyI6/9GBrejzyPfIUi7Db5V77UuNI4u7REMA9Fz7RA+8QOIjvEo4NMGL4Ip2zlZAGW4bcuwyyAy3AYvjlkrb3IqVjyJW43nYGRlP/uyF+rKFa3psmWBYQPWYNmRXSBaVco2yW8sPd/i5m2AUEDvlznDYVDugfl1b/uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029944; c=relaxed/simple;
	bh=y46aEYYWs6g66G1yduLOZWbS9jprmJN0wGotjR+n/g4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WIxCdsW2bMXYChq0kIj5AdRWGIGM+kUUU35DPI72Dcgz6HkdkjcYrlMX4DNmofRJ4oQdSMcN0BRye+YMK8Xdp5LB+31havM8cjTzOZg+9puSsb8Qirq2F3DTjI9XCsDF56pgUM07XH7Y47g19uO3W3rHGgJjnnjRMOOoKm6Nwbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vs6baM4h; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vs6baM4h"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84867f07d63so4367294b3a.2
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029942; x=1787634742; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AkZeRoc3E17YBp5XADn9w+7xUKDSvBeBFuBZM8xExpk=;
        b=Vs6baM4hCSMxtwrGSyLG86oRT2qVfMVYscWpBsmz2OxppzLbCVaS/v+8oE/SjnFsb3
         xGFm7lRHwkZyTOaO2e+ckWG/B9E+UvhoBCIFZwurjrCuvMe+8XiPS6FviFUnm1A71Q7G
         3x8DYE4cx+grj74rrcLsCJ91wBVTOuIoBUt/HM4ecuhop3D/CYCBcSnT/3Ihixq/uJyG
         lCPal4OSdytDzyhDqLD2VUcxjuTrJ5hznQYi4ik/p7gHW5wgWCkgfN6Z8nMaxGo8szOx
         yEvHp4HPlXtUkQHEOG4isT0EzMTWZAeZ/TODNlBg2X4KpBX7WF1heQlbxbb4svCTqxNV
         E//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029942; x=1787634742;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AkZeRoc3E17YBp5XADn9w+7xUKDSvBeBFuBZM8xExpk=;
        b=A91uBWpw7+VJ2GMjEcfV35/tJN59x2C/njbSDYKAbS93e2+S+yw6wu2tPpdw6Nvg8o
         Aqoa+HUeTdKgxuCP3EGs+3FhL+lB+jkFxa2Q2Bu5i19F5p9p/97xVjs9LvmFiy23MS6o
         qrG/KikSZq5x3uHqSMrNU1vjGc12WEwqkz067Lu9WjiZDdYSBM7VBUZz9sUPBAINRgff
         lRyYhbYmKmq+nsH/35CHHvITDrmb/B8TS+tx5LmBLX1IMihL7veeQevRNzwg1YwccxyS
         X3pCu3YC94Tpirl4I8FZ7DYY+2sQdBFFkYRaZtNfDyOWG37S0QK8I+1eQviG52dErwXm
         rNJA==
X-Forwarded-Encrypted: i=1; AHgh+RrODUrS+crUdA8HQ5kUZJ1ckhTMliKQlysp4o5n372ZkVj+yKbgD2qOQ5VzyZPAz9e61kWjxHq7uQ0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yypep9vZ5204ENBUiN0jO/ipXAG6zDvWudUTajG/fvCE1aIhxmc
	fAQXuenaVN87dxG93m7Xe2v3Wwcrr8pWOl2EobQzjkOutDh+7puNDHOB
X-Gm-Gg: AR+sD12JHDpkN+avrDh9Mmv7rBp5lMl0OpD2HFn4aONZguq7CFiuwLiMNP0Ym8WCa/e
	kFaBKmPTSn9wjEI+h16tbjYX0WIcpYXm3Rgo3qA8y4GsTlkHHSN87GMas+J51edwgwu5fJIW2KG
	AJQklSBbNYYzFkABZx4iHGuPJN0C1KA4m7TNRoIP6IowOBqwQm5xbV1SY6sSp4JDIRdx2zlsKfl
	I8KN7TCrQrkUFOdWK8LNaE/naeKunSgCzrZZbFzKy5QI8qUPgYW/50Q7yblH644gIze48yXIetG
	+r2ooydW8qWdNbelPZqq+yfRIzP/hKYHscxVoaX2cXqwbGIc0fVuRHJu+CKY+Sj+V8Oj4AGwoO5
	62BDpGAbaHShkw7A0nU/owyTIrE25M3/GKoLJ+RZXSD7bAXzAqW+QD4mXB9Eaq0j+FaEpImRpYP
	XRl0rLR4iS7lWJFnxi4kIIpzit5EqS9KfzdwDJlUygToWU8g1UVLwrr0alyM9k6DpDj9pKt54=
X-Received: by 2002:a05:6a00:3d96:b0:851:8012:c38b with SMTP id d2e1a72fcca58-8518012c611mr22777756b3a.10.1787029942322;
        Mon, 17 Aug 2026 22:12:22 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:21 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:16 -0700
Subject: [PATCH RFC v2 01/13] vhost-user: Consolidate chardev property
 definitions
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-1-948aae960abb@gmail.com>
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 =?utf-8?q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
 Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, 
 Hanna Reitz <hreitz@redhat.com>, 
 =?utf-8?q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
 zhenwei pi <zhenwei.pi@linux.dev>, 
 =?utf-8?q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>, 
 Connor Kite <connorkite@gmail.com>, 
 20260817233147.2867623-1-connorkite@gmail.com
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=8233;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=y46aEYYWs6g66G1yduLOZWbS9jprmJN0wGotjR+n/g4=;
 b=/WflkskraN4ES9D2WSPAizCPRVsCc0v4+MbDwiiAO/iCI3qYDfgVUf8zepKSO8EByiytIW9ZK
 odU/jff+RptAg8X1jFangGqsKMl7gc1tv/1bMwgVFCGIgm/Z36CQucb
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Move chardev qdev property definitions from children into
VHostUserBase. This reduces code duplication and allows children
to simply inherit the property during initialization.

Signed-off-by: Connor Kite <connorkite@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 hw/virtio/vhost-user-base.c        | 9 +++++++++
 hw/virtio/vhost-user-gpio.c        | 4 ----
 hw/virtio/vhost-user-i2c.c         | 5 -----
 hw/virtio/vhost-user-input.c       | 5 -----
 hw/virtio/vhost-user-rng.c         | 5 -----
 hw/virtio/vhost-user-rtc.c         | 4 ----
 hw/virtio/vhost-user-snd.c         | 1 -
 hw/virtio/vhost-user-spi.c         | 5 -----
 hw/virtio/vhost-user-test-device.c | 1 -
 9 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
index 478ec68f09..90bd2903db 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -407,9 +407,16 @@ static void vub_device_unrealize(DeviceState *dev)
     do_vhost_user_cleanup(vdev, vub);
 }
 
+/*Define common qdev properties.  Inherited by all children*/
+static const Property vub_properties[] = {
+    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev)
+};
+
+
 static void vub_class_init(ObjectClass *klass, const void *data)
 {
     VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
+    DeviceClass *dc = DEVICE_CLASS(klass);
 
     vdc->realize = vub_device_realize;
     vdc->unrealize = vub_device_unrealize;
@@ -417,6 +424,8 @@ static void vub_class_init(ObjectClass *klass, const void *data)
     vdc->get_config = vub_get_config;
     vdc->set_config = vub_set_config;
     vdc->set_status = vub_set_status;
+
+    device_class_set_props(dc, vub_properties);
 }
 
 static const TypeInfo vub_types[] = {
diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
index d473f87077..33b8752282 100644
--- a/hw/virtio/vhost-user-gpio.c
+++ b/hw/virtio/vhost-user-gpio.c
@@ -14,9 +14,6 @@
 #include "standard-headers/linux/virtio_ids.h"
 #include "standard-headers/linux/virtio_gpio.h"
 
-static const Property vgpio_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
-};
 
 static void vgpio_realize(DeviceState *dev, Error **errp)
 {
@@ -42,7 +39,6 @@ static void vu_gpio_class_init(ObjectClass *klass, const void *data)
     VHostUserBaseClass *vubc = VHOST_USER_BASE_CLASS(klass);
 
     dc->vmsd = &vu_gpio_vmstate;
-    device_class_set_props(dc, vgpio_properties);
     device_class_set_parent_realize(dc, vgpio_realize,
                                     &vubc->parent_realize);
     set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
index 152b1f6740..3f5427b5b2 100644
--- a/hw/virtio/vhost-user-i2c.c
+++ b/hw/virtio/vhost-user-i2c.c
@@ -14,10 +14,6 @@
 #include "qemu/error-report.h"
 #include "standard-headers/linux/virtio_ids.h"
 
-static const Property vi2c_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
-};
-
 static void vi2c_realize(DeviceState *dev, Error **errp)
 {
     VHostUserBase *vub = VHOST_USER_BASE(dev);
@@ -42,7 +38,6 @@ static void vu_i2c_class_init(ObjectClass *klass, const void *data)
     VHostUserBaseClass *vubc = VHOST_USER_BASE_CLASS(klass);
 
     dc->vmsd = &vu_i2c_vmstate;
-    device_class_set_props(dc, vi2c_properties);
     device_class_set_parent_realize(dc, vi2c_realize,
                                     &vubc->parent_realize);
     set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
diff --git a/hw/virtio/vhost-user-input.c b/hw/virtio/vhost-user-input.c
index 5cfc5bbb56..8fe6349ffc 100644
--- a/hw/virtio/vhost-user-input.c
+++ b/hw/virtio/vhost-user-input.c
@@ -7,10 +7,6 @@
 #include "qemu/osdep.h"
 #include "hw/virtio/virtio-input.h"
 
-static const Property vinput_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
-};
-
 static void vinput_realize(DeviceState *dev, Error **errp)
 {
     VHostUserBase *vub = VHOST_USER_BASE(dev);
@@ -36,7 +32,6 @@ static void vhost_input_class_init(ObjectClass *klass, const void *data)
     DeviceClass *dc = DEVICE_CLASS(klass);
 
     dc->vmsd = &vmstate_vhost_input;
-    device_class_set_props(dc, vinput_properties);
     device_class_set_parent_realize(dc, vinput_realize,
                                     &vubc->parent_realize);
     set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
index 106c8f211a..664aee403d 100644
--- a/hw/virtio/vhost-user-rng.c
+++ b/hw/virtio/vhost-user-rng.c
@@ -20,10 +20,6 @@ static const VMStateDescription vu_rng_vmstate = {
     .unmigratable = 1,
 };
 
-static const Property vrng_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
-};
-
 static void vu_rng_base_realize(DeviceState *dev, Error **errp)
 {
     VHostUserBase *vub = VHOST_USER_BASE(dev);
@@ -43,7 +39,6 @@ static void vu_rng_class_init(ObjectClass *klass, const void *data)
     VHostUserBaseClass *vubc = VHOST_USER_BASE_CLASS(klass);
 
     dc->vmsd = &vu_rng_vmstate;
-    device_class_set_props(dc, vrng_properties);
     device_class_set_parent_realize(dc, vu_rng_base_realize,
                                     &vubc->parent_realize);
 
diff --git a/hw/virtio/vhost-user-rtc.c b/hw/virtio/vhost-user-rtc.c
index 88b0c70b90..6d80cb6263 100644
--- a/hw/virtio/vhost-user-rtc.c
+++ b/hw/virtio/vhost-user-rtc.c
@@ -19,9 +19,6 @@ static const VMStateDescription vu_rtc_vmstate = {
     .unmigratable = 1,
 };
 
-static const Property vrtc_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
-};
 
 static void vu_rtc_base_realize(DeviceState *dev, Error **errp)
 {
@@ -42,7 +39,6 @@ static void vu_rtc_class_init(ObjectClass *klass, const void *data)
     VHostUserBaseClass *vubc = VHOST_USER_BASE_CLASS(klass);
 
     dc->vmsd = &vu_rtc_vmstate;
-    device_class_set_props(dc, vrtc_properties);
     device_class_set_parent_realize(dc, vu_rtc_base_realize,
                                     &vubc->parent_realize);
 
diff --git a/hw/virtio/vhost-user-snd.c b/hw/virtio/vhost-user-snd.c
index 7129b77d9c..3663450aed 100644
--- a/hw/virtio/vhost-user-snd.c
+++ b/hw/virtio/vhost-user-snd.c
@@ -34,7 +34,6 @@ static const VMStateDescription vu_snd_vmstate = {
 };
 
 static const Property vsnd_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
     DEFINE_PROP_BIT64("controls", VHostUserBase,
                       parent_obj.host_features, VIRTIO_SND_F_CTLS, false),
 };
diff --git a/hw/virtio/vhost-user-spi.c b/hw/virtio/vhost-user-spi.c
index 707f96c250..fb6168d391 100644
--- a/hw/virtio/vhost-user-spi.c
+++ b/hw/virtio/vhost-user-spi.c
@@ -15,10 +15,6 @@
 #include "standard-headers/linux/virtio_ids.h"
 #include "standard-headers/linux/virtio_spi.h"
 
-static const Property vspi_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
-};
-
 static void vspi_realize(DeviceState *dev, Error **errp)
 {
     VHostUserBase *vub = VHOST_USER_BASE(dev);
@@ -44,7 +40,6 @@ static void vu_spi_class_init(ObjectClass *klass, const void *data)
     VHostUserBaseClass *vubc = VHOST_USER_BASE_CLASS(klass);
 
     dc->vmsd = &vu_spi_vmstate;
-    device_class_set_props(dc, vspi_properties);
     device_class_set_parent_realize(dc, vspi_realize,
                                     &vubc->parent_realize);
     set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
diff --git a/hw/virtio/vhost-user-test-device.c b/hw/virtio/vhost-user-test-device.c
index a2f963fdf6..91e23bf07a 100644
--- a/hw/virtio/vhost-user-test-device.c
+++ b/hw/virtio/vhost-user-test-device.c
@@ -30,7 +30,6 @@ static const VMStateDescription vud_vmstate = {
 };
 
 static const Property vud_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
     DEFINE_PROP_UINT16("virtio-id", VHostUserBase, virtio_id, 0),
     DEFINE_PROP_UINT32("vq_size", VHostUserBase, vq_size, 64),
     DEFINE_PROP_UINT32("num_vqs", VHostUserBase, num_vqs, 1),

-- 
2.43.0

