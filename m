Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326C73D16FC
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029971; cv=none; b=JWS3LFsdrXl5+7khBTLL3fsp/gvzd9SU78ewMEhGXzDLlqFXKSC13fTLJsi5hbuBIHVoIVQBN3iGyOSh9L7niMEO7MSLfrAhDHrktrMbohTcUG9plSy43UpkLKOBuphqZJZgRdCR/VI/nRwkPzfbTTGt16qEuyjsh6IccxUdzkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029971; c=relaxed/simple;
	bh=bDY61qv1aUuiJX5AihOusx4h4L9qjegBfYljF7KlWx8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mtQUUklIRZ4CcL4u23gKpAOc+tbrszICzUSiU7Z/+E+ukwcjcVqLSPeTKuDszF6UuqGdxYeGUsqk1OkDNXOnbiSTK7+RNmJIdaedw//cLqu9/36GFvj4/Tq9Oib7jObLUYTDAt1LO1sw5HLNP2RgcOb3OaFEtAwWJlevW/IIXjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GOvt0Q2/; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GOvt0Q2/"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84e04df8c46so4632682b3a.2
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029969; x=1787634769; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yDGWIbLiwCQZ5If+WfdVxDr1QS3FHpZI2ZH0Iio93r0=;
        b=GOvt0Q2/GUSkIOiDNp7aP1s/ahDXLKCrXuWjF+iOqwqgRsJNA+DCYbeU6LAku0mQrW
         5CTa1/6CCwPM0wTa6wIu2aoL5lqivO1zx2EA/uY7H9M5RSQZ7eqgR29d/7Bdq6aC8b0R
         sZhKTd1V5kTaUAN/N4B9gzKfR2fE9vPtaBtXsjuKCqJkNYLHn2UgZkuG9WFm62/eXjNo
         srCk+/EINIGEgTNUivQ7QzdnSgGjdYX1y1Nmmqh26zkS5RJE5ELZy/B8OZIHmlacl3ub
         8CN2rd+JmA92a4ZNjG1by+WQaDEnKMWiqAkpJMG0w18dkxoPFTdGWgZIwdNDsLe4BKX4
         wNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029969; x=1787634769;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yDGWIbLiwCQZ5If+WfdVxDr1QS3FHpZI2ZH0Iio93r0=;
        b=fHFUpRyuEjib9l2TA0gr966X17IRqN6/KBFxUmSbgC/JhY6OhR7Fc1zmgpaXnzCC6e
         XGWGhM0Mu6WNzjOwRNG68Zjy0quWvH+Ptqqetjsr1I5KqyGujOxrbWN0zI5SMe7GFtvy
         6cGtl/HWefF9d5YNWlWIFEJL/0F8I6drn6E0BUTLlFcpVN4pz/4y9BX0dTWUSAG/yt5C
         XJz6DuLwgNPLoSNGy4+O+2l2au+ioKUcZja7/T1oq5pEePlXY20CMzQMGjV+VbLC/1qH
         n8sDdwuX0ZdkJYGD/zgeklzwwcpxzKBW27autiYX2hm6Dypyl07UwHO+gSojufF9Et/w
         mZDw==
X-Forwarded-Encrypted: i=1; AHgh+Rr8OXh5aLLtVq7oGNXPnem4wujDAbhsdy0gFQIQAwQUufRzk+VSlHevLlqt3h+GyRofwMz2TD7ymw0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEQWiDUewfg3ARAEJW3YBiEqZPbhiV4AFx4oBsQIx6NsHyWFGO
	hAM3L/WKjchhMBq9rfoNgQe4UnBeE6mWEbOpfz0eIFGxuTaoAvrsrscM
X-Gm-Gg: AR+sD12AVIgjo9ZlOfLr3l08KWM97+Es0o5HHHGB4wLl+pMFtiQgElNkYJTCr8nIy4o
	jsqLKgD1wSi9qbTYGnU3/vWobVL0oaDNMM11B7BrzmSeZmLp6FhuIU3DADW4Be0vSjJfxmqdbgD
	VrzSrjF31QlM3CVXwZ+OywEkXb9Rc3f1+Y2zxDhuwBpD5srkjKFvw2uzAdynfRmTe41g0V5c0ou
	Vt69DmTBpm5wnOasnjOX/4avrHLin1gIabbyWhBFgCjUyKhT+84QNjg0GU4LsdIYpZ+IQ6EHaM8
	z89w23I8yFe4SMwma1EG6oMwmC7Zx0v405Nv8U2VitDDMLyG05HmPSDs6W4cmGZUykHKYZT+RsV
	y38F9XsSU+yHYJ7VuO0vPTUMIOK1wlkRVVyv2u753niDxBkmPgJzpwXz5t8nNgOEqf7WwaKZ8yQ
	ubWL7DwYr/TSukgbP3UlMm77+RhNDLhgXnNxnOsPsslW8tuvVaQFJ3qM28UixCWsJqk8CWhqllJ
	NPA
X-Received: by 2002:a05:6a00:4654:b0:848:4faa:480b with SMTP id d2e1a72fcca58-84fddfce887mr29626111b3a.12.1787029969420;
        Mon, 17 Aug 2026 22:12:49 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:48 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:26 -0700
Subject: [PATCH RFC v2 11/13] vhost-user: Add memory-isolation qdev
 property to vhost-user devices
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-11-948aae960abb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=10639;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=bDY61qv1aUuiJX5AihOusx4h4L9qjegBfYljF7KlWx8=;
 b=svydToQc3yKwRDJxMF6SXJDj73zDY4NnrZk9gFJeM50qtdYTDTQELdGbLi55zIK2/HyP27xha
 mBoDB2VpKtOCkPXCeACvJDDlFJSimZQTceBGaSg7jkYVd9WXhMuloXv
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

In support of future work to add a memory isolation mode to vhost-user devices, a
qdev property, "memory-isolation", is added to all vhost-user devices. This is
simply a bool representing whether the mode is active or not.

Signed-off-by: Connor Kite <connorkite@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 hw/block/vhost-user-blk.c            | 3 ++-
 hw/display/vhost-user-gpu.c          | 3 ++-
 hw/scsi/vhost-user-scsi.c            | 4 +++-
 hw/virtio/vhost-user-base.c          | 6 ++++--
 hw/virtio/vhost-user-fs.c            | 4 +++-
 hw/virtio/vhost-user-scmi.c          | 4 +++-
 hw/virtio/vhost-user-vsock.c         | 4 +++-
 include/hw/virtio/vhost-user-base.h  | 1 +
 include/hw/virtio/vhost-user-blk.h   | 1 +
 include/hw/virtio/vhost-user-fs.h    | 1 +
 include/hw/virtio/vhost-user-scmi.h  | 1 +
 include/hw/virtio/vhost-user-vsock.h | 1 +
 include/hw/virtio/virtio-gpu.h       | 1 +
 include/hw/virtio/virtio-scsi.h      | 1 +
 14 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 4640d7da04..5c1a19eb50 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -506,7 +506,7 @@ static void vhost_user_blk_device_realize(DeviceState *dev, Error **errp)
     }
 
     if (!vhost_user_init(&s->vhost_user, &s->chardev,
-                         false, errp)) {
+                         s->memory_isolation, errp)) {
         return;
     }
 
@@ -632,6 +632,7 @@ static const VMStateDescription vmstate_vhost_user_blk = {
 
 static const Property vhost_user_blk_properties[] = {
     DEFINE_PROP_CHR("chardev", VHostUserBlk, chardev),
+    DEFINE_PROP_BOOL("memory-isolation", VHostUserBlk, memory_isolation, false),
     DEFINE_PROP_UINT16("num-queues", VHostUserBlk, num_queues,
                        VHOST_USER_BLK_AUTO_NUM_QUEUES),
     DEFINE_PROP_UINT32("queue-size", VHostUserBlk, queue_size, 128),
diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
index 6655585b43..d8f710ed65 100644
--- a/hw/display/vhost-user-gpu.c
+++ b/hw/display/vhost-user-gpu.c
@@ -663,7 +663,7 @@ vhost_user_gpu_device_realize(DeviceState *qdev, Error **errp)
     VirtIODevice *vdev = VIRTIO_DEVICE(g);
 
     vhost_dev_set_config_notifier(&g->vhost->dev, &config_ops);
-    if (vhost_user_backend_dev_init(g->vhost, vdev, 2, false,
+    if (vhost_user_backend_dev_init(g->vhost, vdev, 2, g->memory_isolation,
                                     errp) < 0) {
         return;
     }
@@ -698,6 +698,7 @@ static struct vhost_dev *vhost_user_gpu_get_vhost(VirtIODevice *vdev)
 
 static const Property vhost_user_gpu_properties[] = {
     VIRTIO_GPU_BASE_PROPERTIES(VhostUserGPU, parent_obj.conf),
+    DEFINE_PROP_BOOL("memory-isolation", VhostUserGPU, memory_isolation, false),
 };
 
 static void
diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
index 05bc788304..6f162a7854 100644
--- a/hw/scsi/vhost-user-scsi.c
+++ b/hw/scsi/vhost-user-scsi.c
@@ -277,7 +277,7 @@ static void vhost_user_scsi_realize(DeviceState *dev, Error **errp)
     }
 
     if (!vhost_user_init(&s->vhost_user, &vs->conf.chardev,
-                         false, errp)) {
+                         vs->conf.memory_isolation, errp)) {
         goto free_virtio;
     }
 
@@ -347,6 +347,8 @@ static void vhost_user_scsi_unrealize(DeviceState *dev)
 
 static const Property vhost_user_scsi_properties[] = {
     DEFINE_PROP_CHR("chardev", VirtIOSCSICommon, conf.chardev),
+    DEFINE_PROP_BOOL("memory-isolation", VirtIOSCSICommon,
+                     conf.memory_isolation, false),
     DEFINE_PROP_UINT32("boot_tpgt", VirtIOSCSICommon, conf.boot_tpgt, 0),
     DEFINE_PROP_UINT32("num_queues", VirtIOSCSICommon, conf.num_queues,
                        VIRTIO_SCSI_AUTO_NUM_QUEUES),
diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
index c10851492a..657a7d174a 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -318,7 +318,7 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
     }
 
     if (!vhost_user_init(&vub->vhost_user, &vub->chardev,
-                         false, errp)) {
+                         vub->memory_isolation, errp)) {
         return;
     }
 
@@ -410,7 +410,9 @@ static void vub_device_unrealize(DeviceState *dev)
 
 /*Define common qdev properties.  Inherited by all children*/
 static const Property vub_properties[] = {
-    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev)
+    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
+    DEFINE_PROP_BOOL("memory-isolation", VHostUserBase, memory_isolation,
+                     false),
 };
 
 
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 34ccbdec10..5529a8afb0 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -239,7 +239,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
     }
 
     if (!vhost_user_init(&fs->vhost_user, &fs->conf.chardev,
-                         false, errp)) {
+                         fs->conf.memory_isolation, errp)) {
         return;
     }
 
@@ -411,6 +411,8 @@ static const VMStateDescription vuf_backend_vmstate = {
 
 static const Property vuf_properties[] = {
     DEFINE_PROP_CHR("chardev", VHostUserFS, conf.chardev),
+    DEFINE_PROP_BOOL("memory-isolation", VHostUserFS, conf.memory_isolation,
+                     false),
     DEFINE_PROP_STRING("tag", VHostUserFS, conf.tag),
     DEFINE_PROP_UINT16("num-request-queues", VHostUserFS,
                        conf.num_request_queues, 1),
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index bd0ec64daf..b32dc09b0c 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -245,7 +245,7 @@ static void vu_scmi_device_realize(DeviceState *dev, Error **errp)
     vdev->host_features |= (1ULL << VIRTIO_SCMI_F_P2A_CHANNELS);
 
     if (!vhost_user_init(&scmi->vhost_user, &scmi->chardev,
-                         false, errp)) {
+                         scmi->memory_isolation, errp)) {
         return;
     }
 
@@ -288,6 +288,8 @@ static const VMStateDescription vu_scmi_vmstate = {
 
 static const Property vu_scmi_properties[] = {
     DEFINE_PROP_CHR("chardev", VHostUserSCMI, chardev),
+    DEFINE_PROP_BOOL("memory-isolation", VHostUserSCMI, memory_isolation,
+                     false),
 };
 
 static void vu_scmi_class_init(ObjectClass *klass, const void *data)
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 44a90c76ad..7b62290167 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -107,7 +107,7 @@ static void vuv_device_realize(DeviceState *dev, Error **errp)
     }
 
     if (!vhost_user_init(&vsock->vhost_user, &vsock->conf.chardev,
-                         false, errp)) {
+                         vsock->conf.memory_isolation, errp)) {
         return;
     }
 
@@ -155,6 +155,8 @@ static void vuv_device_unrealize(DeviceState *dev)
 
 static const Property vuv_properties[] = {
     DEFINE_PROP_CHR("chardev", VHostUserVSock, conf.chardev),
+    DEFINE_PROP_BOOL("memory-isolation", VHostUserVSock, conf.memory_isolation,
+                     false),
 };
 
 static void vuv_class_init(ObjectClass *klass, const void *data)
diff --git a/include/hw/virtio/vhost-user-base.h b/include/hw/virtio/vhost-user-base.h
index d5d2f081ae..29bc40736c 100644
--- a/include/hw/virtio/vhost-user-base.h
+++ b/include/hw/virtio/vhost-user-base.h
@@ -25,6 +25,7 @@ struct VHostUserBase {
     uint32_t num_vqs;
     uint32_t vq_size; /* can't exceed VIRTIO_QUEUE_MAX */
     uint32_t config_size;
+    bool memory_isolation;
     /* State tracking */
     VhostUserState vhost_user;
     struct vhost_virtqueue *vhost_vq;
diff --git a/include/hw/virtio/vhost-user-blk.h b/include/hw/virtio/vhost-user-blk.h
index dee848cfd8..8126447a86 100644
--- a/include/hw/virtio/vhost-user-blk.h
+++ b/include/hw/virtio/vhost-user-blk.h
@@ -30,6 +30,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(VHostUserBlk, VHOST_USER_BLK)
 struct VHostUserBlk {
     VirtIODevice parent_obj;
     CharFrontend chardev;
+    bool memory_isolation;
     int32_t bootindex;
     struct virtio_blk_config blkcfg;
     uint16_t num_queues;
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 5699ea03a1..bf71990b9c 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -28,6 +28,7 @@ typedef struct {
     char *tag;
     uint16_t num_request_queues;
     uint16_t queue_size;
+    bool memory_isolation;
 } VHostUserFSConf;
 
 struct VHostUserFS {
diff --git a/include/hw/virtio/vhost-user-scmi.h b/include/hw/virtio/vhost-user-scmi.h
index 30ab0d7ab7..d346b42ed8 100644
--- a/include/hw/virtio/vhost-user-scmi.h
+++ b/include/hw/virtio/vhost-user-scmi.h
@@ -19,6 +19,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(VHostUserSCMI, VHOST_USER_SCMI);
 struct VHostUserSCMI {
     VirtIODevice parent;
     CharFrontend chardev;
+    bool memory_isolation;
     struct vhost_virtqueue *vhost_vqs;
     struct vhost_dev vhost_dev;
     VhostUserState vhost_user;
diff --git a/include/hw/virtio/vhost-user-vsock.h b/include/hw/virtio/vhost-user-vsock.h
index 5db6938b8b..6288b26fa4 100644
--- a/include/hw/virtio/vhost-user-vsock.h
+++ b/include/hw/virtio/vhost-user-vsock.h
@@ -21,6 +21,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(VHostUserVSock, VHOST_USER_VSOCK)
 
 typedef struct {
     CharFrontend chardev;
+    bool memory_isolation;
 } VHostUserVSockConf;
 
 struct VHostUserVSock {
diff --git a/include/hw/virtio/virtio-gpu.h b/include/hw/virtio/virtio-gpu.h
index 220231ec9d..d0de1437f8 100644
--- a/include/hw/virtio/virtio-gpu.h
+++ b/include/hw/virtio/virtio-gpu.h
@@ -276,6 +276,7 @@ struct VhostUserGPU {
     CharFrontend vhost_chr;
     QemuDmaBuf *dmabuf[VIRTIO_GPU_MAX_SCANOUTS];
     bool backend_blocked;
+    bool memory_isolation;
 };
 
 #define MAX_SLOTS 4096
diff --git a/include/hw/virtio/virtio-scsi.h b/include/hw/virtio/virtio-scsi.h
index b6028bb5cd..47fdc3785c 100644
--- a/include/hw/virtio/virtio-scsi.h
+++ b/include/hw/virtio/virtio-scsi.h
@@ -59,6 +59,7 @@ struct VirtIOSCSIConf {
     char *vhostfd;
     char *wwpn;
     CharFrontend chardev;
+    bool memory_isolation;
     uint32_t boot_tpgt;
     IOThread *iothread;
     IOThreadVirtQueueMappingList *iothread_vq_mapping_list;

-- 
2.43.0

