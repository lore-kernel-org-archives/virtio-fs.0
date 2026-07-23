Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D49403AEB
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845850; cv=none; b=sJCa3eJGjNsR6BtPDmq+cjuJSiCdQtoCTMsSmIhQyOQHc5yYMDbxgoTXb1N6q3fZp15zNB6hFoebh4TJEOb1Nq/FCQcPgb6Tq5CkpSTHqTUf0gaLhvrvL9YVY360enPHskcthS3H0v01Xt7azK2vWQkNM7UlxG8q9NMSwiESuGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845850; c=relaxed/simple;
	bh=y46aEYYWs6g66G1yduLOZWbS9jprmJN0wGotjR+n/g4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c3q0wsbP47VGVe0YYPZP4i/0MEhQ26v7HXwEmDRLxbaATh3xBIzHcw32QxfPg3busFuSLg+N4f8f5cpRaB1MNNgNeGf29iU/Vzwyj8qT0sLozfVMFPWpR4gozbORf75X8JRjzdNywSMfVtaAd5Qnmd/VLk06J+aISCglOh4gWvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OM7P4TDu; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OM7P4TDu"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-667bae10ba3so1143324d50.2
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845847; x=1785450647; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AkZeRoc3E17YBp5XADn9w+7xUKDSvBeBFuBZM8xExpk=;
        b=OM7P4TDuJ7jx76eojnPKz56jo3SfY8AIsQOr3cznZ7YKhBPk2WvD/kDAGR0KLKkoXp
         2GgM3TFGYo90fKnLgs/O5Xm1SxfspjWGs0uUymK+AJ6ihKZ7vq/Nk8IydMaw8VXp/FBU
         3kvx4FtKtclz7nNVhs67ofme4ge86Zv8aIpX3zafpgOdFt0HZ9+gvlsXHn9MKG9iflf4
         8nomJvPc6Lo5cHyRZrz41Bm7BzoDiv+jdfQdsFmMLwWa8y68u49B1wy+FQ+mK45dUMtr
         g3yXhi00srMgOK56WcHXw0jVW19K+SFHWcFummh5XE/tqmbNyGGt2fJlWdhnTRQlZDV/
         AYPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845847; x=1785450647;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AkZeRoc3E17YBp5XADn9w+7xUKDSvBeBFuBZM8xExpk=;
        b=QBaMcrs54vcJZKW2iE14ht4RI1TBE1oAGyN03xUay773jXXBCDTW+YwSom0UTSB+8o
         2B5y1Sl/HNoJwPvkNymjhLzBUnR/slgAclHwfq89engylNzmBe8aAJCWEzcJhGv0WyIV
         VCSRtCJqNmNHVDhr23DFU0rlX80qXrTUoUOD/CSLH7BBhpY3JN99NBCqXANggMP8MxLb
         xDDe6XJeCnE7YW/tWSerHyUE09eGbplK6abvbmWkH7nd7yzUicplb00N3m7HnufUoWfV
         1LWsIrlpVILHPxbPV+xgq0lyDECTXqwY/mVQDXkTnGDeHdVt7pGTZKwoew3dcxmNqti6
         rffg==
X-Forwarded-Encrypted: i=1; AHgh+RoNbm+GuYL1b+vnADJXnoHDU6HD+Pemyx7XT5F5EEbVHS5eDofez4iA6Nkw8JKDLSo0kKJAiAaX4pM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzN0DDTzypobO2Eq6dV6e8Aq2USTa9EX+dZymA8BDOEU5hC1IdS
	ucethTxbInV9ZFDoIByCZQ9rnjdG5RU8NquQh6dkNtkzK9bCe2YhMTmV
X-Gm-Gg: AR+sD131/8ojxfAAKOAhMM/K1iDvNmsJzuWKGlyZYY9pL0IyKBPVUUNlcCEzm12dRPb
	i4wXDmDEhl7jduLv7ir9trFrSD8H+P0AJuJ/yzfDkCYOVAUs7cPOgky/Gd0md+Y1Jfe/gWaxMf8
	e72yzILWMrFUv/6OyFSIarFDlhkUpbRPUqbOnVwMXjox7b1Yoz5ZXrMBkZnbgGt4wg9uM/yKE7C
	gSU55h2rfS2+j4uGyVEVR7d8j55wm8YuJTIuKGYVwbshemR3zJV3eah1i8ANyVA1Da/GFzHD6OD
	27JRUAMdtTQSmWaQk3gcU2UXHRgSWMJHytnI3oL1cOOmFlIDWRpZuZ4/DMqGNrZeG7M8q8su+KF
	8gkbbf1yBJ2J28HvdZvd0SFqudMYx4JnWBdY6SP8PgUSB+IFaUTZEbMdPiBl1eqAU7c7d6X69iH
	bcaVa12gk=
X-Received: by 2002:a05:690e:2497:b0:668:2353:1585 with SMTP id 956f58d0204a3-668a4bc2664mr970417d50.13.1784845846663;
        Thu, 23 Jul 2026 15:30:46 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:30:46 -0700 (PDT)
From: ConKite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:00 -0700
Subject: [PATCH RFC 01/15] vhost-user: Consolidate chardev property
 definitions
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-1-6b97c439eb28@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 =?utf-8?q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>, 
 Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
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
 Connor Kite <connorkite@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=8233;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=y46aEYYWs6g66G1yduLOZWbS9jprmJN0wGotjR+n/g4=;
 b=//WY7dSmSnB3vYw09xpugMmsjQh3QQRotc/Sm/xroedRqBJKHANludIn3yXkteT9VmhDUo2F9
 RgBJ+b+nnEZAzVg7m+KzvXlHZiONuJjhqqtLr7tWJGPc6Oif6hkx8wF
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

