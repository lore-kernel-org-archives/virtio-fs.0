Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C623E7BA9
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845859; cv=none; b=oRl6bu8p18LySOtwRTErYA3d1wWYYOzoF4dwW8bGWz226ILfs+OTfc1GCOXi/xlC3hi0M0kyoiXcEm0C3UsM4Foq3kczot6qLf7zEsFFSu4UDdzksSthjAXizqdcsf+bmVnh8C9XcdPaOCKJHFX9vT/w05t3/gcIyuy0fwedeiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845859; c=relaxed/simple;
	bh=u55pm1DDJmv5TyBlbSFATydrnGuQo+DHFoyjUl5G2XI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UQy2yhtsHgYdTOGMz0abp5QLrpvZt2kXTw7wMWM7g2Q20FBeanV3OmmoegASbGucxDF0Mb3SpQCTY32oxb526Xb3oS/wsBskyfeR213mi8iY0eqCa4Y5we7pRoNbNbDbL8NrPaqFlkAweazyNpmu0QS6ljqFv7sMXvFS71IwfIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=khFv3K27; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khFv3K27"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81dfdbd86d1so10866667b3.1
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845854; x=1785450654; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dn72UNvpMJmsMe5tRQU7u6qlwqtNn/DM1PthO2EpZ4E=;
        b=khFv3K27H0hEEkFza5LDzqxzFSubOWnfRNyFkilLK5m8bglX5IKs41N7Y7jBUHdJFY
         DCnW3O2Yqeif7itBIXhaYS9oZM+tabPVb07yp1bFBR/Yp9+RMEyJsSbAVitIhxA7/pYx
         sLueVkODun0OUzF8uEq0vJFeprVpmK/Cy1EBGFqnN3TbebjiJ06xzqjmnkSnvp73SlsE
         qfDlsNb8+4ROBfIey2kUZGou5Jf8GvSpq8SBg2CZRIjsLudY/2KDOLc8znfWz9LvlEp9
         lwqPzY9yG32Ije4L5NsIe4cGBdnsVsY1E5aO6v5NmMt0Ncg1oyib069I3g7UXyQOIm9A
         qprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845854; x=1785450654;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dn72UNvpMJmsMe5tRQU7u6qlwqtNn/DM1PthO2EpZ4E=;
        b=ghWqZVvNFU+1tS7b9oJ36kQ8FjBapAE7bKdLP/82HPUsPm06QNawdU3DyuCDbFmNA4
         cHPJaEVTOVT1SGHDHTNvg3d9cLZd5bwnw17yxrQyE9p2KJoLdVp8yh5bQ1bvPoTQ85BM
         rQ3izNDgrAieJB4x7KNZilmqGLfAtU7waW2a86kHe8YqkVFnvDBKj29oHQme1y4GQjxd
         9+8pK+rRfhwqEAoSO9i2EbpWGQoJvYM6BKi+gv+ak6ScJEX3KEnJOwwPrEkIwAcYYbUv
         JRNjYr42h1KsYHxYKx6Hd5EzyXnD+/ylXMwtu1GRVEw7AGLeEk1izf9ZH5RYXEV/AlJB
         cZcQ==
X-Forwarded-Encrypted: i=1; AHgh+RrHFiqEVyhBiW+IA7lLrvNqHlAgWEdL47B2zWk/I1z7xmN7/O5tI2krWLAdYlArs7G/ChvtMFHqEvY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy88/3stXM6sQ55GpE7aXfDAJMMrDzPUPaL5hVVD/h9mC0P3/rT
	s+Zektgacf+KMn9WQP9GvuCJD1v41T43jOKaw16Jq7AbW0nhyHO8bi8h
X-Gm-Gg: AR+sD11I3E4ohxcjbKwaqmrk8i2M0hwg6njFXR5CYCPygK5mSR/UMfZfJEhZ86M2Uyn
	tc11psH4BHS/mqkq1l7fxtVVhOhE/rniuqa52weJBCWj+nqT4BIKBQodl4US6n7fvRiDL5P9tcs
	c5jdPCgR1EvxQZDpLi3FRb5Zh1aDPblnqqqT5d44WbzNGoBXkvV3yMQptOGITt5jcFiZ66OY1nE
	foMHcOO6R3jZHFK0+GGdVcp5cGbF3IvmsGRpGntnxT8zlHBu2Y6C77/rCn1aMmM91MXuchlSeub
	KlSScQMUWxBAdPTY3trAB46DJ1gB/ZHPSCeR46SxKhuRAHux7JlCXHND8V2l8UBGNsDcRxpqgG2
	8k3jfBwdwwy9X7+qXkjiTi3pkIgUrii1zYpn9JGJYXCAv3i4lPpNMQ/cnvyB0Gv1Mt9IJQiQ5ef
	lXarzT19Q=
X-Received: by 2002:a05:690c:7343:b0:81e:84dd:213b with SMTP id 00721157ae682-81f4c36f62fmr13959557b3.71.1784845853861;
        Thu, 23 Jul 2026 15:30:53 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:30:53 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:02 -0700
Subject: [PATCH RFC 03/15] backends/cryptodev-vhost-user: add memory
 isolation bool
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-3-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=2812;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=u55pm1DDJmv5TyBlbSFATydrnGuQo+DHFoyjUl5G2XI=;
 b=TKXB2eR8dH4lHlo1pG799OEHZtgpI+vA0TcqAB661T4YwOkzPCVblVNFBDayPTk2anqinPips
 qyvcLjbXIxLB5oSrVZfjuyh2gM4AkJZud/hWSQw6WX2d4QaC2o04ymR
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Add a memory_isolation property to CryptoDevBackendVhostUser and
add add it as an optional member of CryptodevVhostUserProperties
in qapi.

This is needed to be able to specify memory isolation for
cryptodev-vhost-user objects, and the bool will eventually be
passed to vhost_user_init() in a future patch.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 backends/cryptodev-vhost-user.c | 22 ++++++++++++++++++++++
 qapi/qom.json                   |  6 +++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/backends/cryptodev-vhost-user.c b/backends/cryptodev-vhost-user.c
index cc478d9902..e0547c5d40 100644
--- a/backends/cryptodev-vhost-user.c
+++ b/backends/cryptodev-vhost-user.c
@@ -49,6 +49,7 @@ struct CryptoDevBackendVhostUser {
     CharFrontend chr;
     char *chr_name;
     bool opened;
+    bool memory_isolation;
     CryptoDevBackendVhost *vhost_crypto[MAX_CRYPTO_QUEUE_NUM];
 };
 
@@ -392,6 +393,23 @@ static void cryptodev_vhost_user_finalize(Object *obj)
     g_free(s->chr_name);
 }
 
+static void cryptodev_vhost_user_set_mem_isolation(Object *obj, bool value,
+                                                   Error **errp)
+{
+    CryptoDevBackendVhostUser *s =
+                      CRYPTODEV_BACKEND_VHOST_USER(obj);
+
+    s->memory_isolation = value;
+}
+
+static bool cryptodev_vhost_user_get_mem_isolation(Object *obj, Error **errp)
+{
+    CryptoDevBackendVhostUser *s =
+                      CRYPTODEV_BACKEND_VHOST_USER(obj);
+
+    return s->memory_isolation;
+}
+
 static void
 cryptodev_vhost_user_class_init(ObjectClass *oc, const void *data)
 {
@@ -407,6 +425,10 @@ cryptodev_vhost_user_class_init(ObjectClass *oc, const void *data)
                                   cryptodev_vhost_user_get_chardev,
                                   cryptodev_vhost_user_set_chardev);
 
+    object_class_property_add_bool(oc, "memory-isolation",
+                                   cryptodev_vhost_user_get_mem_isolation,
+                                   cryptodev_vhost_user_set_mem_isolation);
+
 }
 
 static const TypeInfo cryptodev_vhost_user_info = {
diff --git a/qapi/qom.json b/qapi/qom.json
index c55776af7d..d7ca1b4203 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -350,11 +350,15 @@
 # @chardev: the name of a Unix domain socket character device that
 #     connects to the vhost-user server
 #
+# @memory-isolation: disables access from cryptodev to guest memory.
+#     (default: false)
+#
 # Since: 2.12
 ##
 { 'struct': 'CryptodevVhostUserProperties',
   'base': 'CryptodevBackendProperties',
-  'data': { 'chardev': 'str' },
+  'data': { 'chardev': 'str',
+            '*memory-isolation': 'bool' },
   'if': 'CONFIG_VHOST_CRYPTO' }
 
 ##

-- 
2.43.0

