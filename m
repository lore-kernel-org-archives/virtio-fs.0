Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D1A32B12A
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845863; cv=none; b=Dwp95AK1ZJe/aXL348f+AXx9M1iL1mXehpw7Br73MoADMfbSuO7DmIcmHh5dCONFZYzlwlH7/JJvWm5H2BQ6m/D0Y79htr2Fl5OuPsoyl4IWcZtyyvPS+NYrGS3tIZmSAp+mG/fb/GEmUtnauC3tuadNuEitSYJGhknbQI9Xl8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845863; c=relaxed/simple;
	bh=e0y3nCskpzkZj4kyMOzgDnBn6vCXRdmOknYla343ncU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ICWxMnVDbgs2V73/o0pPJr4vQAwHoYflSEZeefAsq0a5msZMrfWto+ZzF3dt1tmFnGsPO71pVnfLOZHBq237CTzmdIEcGAcvV1E5JlMQQNArTlGnqQHlhVi7Zfv5paX9rkxPFUNewvqVqtTC7D87K2DlQSVBgMpRM8B6ssBsEak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nw4pJ0tW; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nw4pJ0tW"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-81e69a2db34so11705797b3.0
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845861; x=1785450661; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/jjfgEle2QNh6JABBQuFrx8Xpr2yY+fX3Wnyut93Uas=;
        b=nw4pJ0tWMXmqcWb4CnKwLR4akkZy244Tx4VadzygqxnH7v5/QBEiiqNP/5vrLFff08
         paeo4qXQAtzZ7IfFmpxbXedXYeoZXf/C16phXhsDtzAyjKZI5/lZFtp4iYJpVI42aU07
         L0tXIN2Ugv5zfCYsPm9gQ8EfNBZwXwFopocL0I+jK8WYNanBY3wf3wCzC8HSI2F1GzGe
         ldsHXLVGm+0DIHfC6g9c4D1axYDgFZ/n0Es97c2iuftkfHNQ7d+WYIAjc1hFyWnGIrth
         hx2c2cxHB8qL2eC+j3ofRnlofoUlFL53YQamcLUr+h1D2ImJqe2HRT9xGztzRfmKHmhI
         5gaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845861; x=1785450661;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/jjfgEle2QNh6JABBQuFrx8Xpr2yY+fX3Wnyut93Uas=;
        b=ionqfD7QfmldivarjFZgGOalDHAuE2a3/4y1CH9XLTPJwcYvHSKqVPSUZ07/hHR2W8
         mUhcWFrjkWwc49rHQ+OFEggLJqDV07+rUESwwPBt6y2ZnHVTwoxHshqdRUiIDArQTKvr
         hFfwgZlSZjuK172L973eYx1CkX6uCC+lBgAioR0exiAo5RzpqV14ZWZyAKgBQ6vbJKNd
         yZsN+E/3Yj5HscGGnI8o/KHQhUa0BHu0oVn2+ZXYiCHg1R7zQNVqiYQA6DJjPykoSg1B
         X4zYqqT27eEks/hmPSSVSqlAOHNC27sXHj0qjZtyWqW4ga8LlZhZ5O40jsUY7ggg1861
         aGEA==
X-Forwarded-Encrypted: i=1; AHgh+RpeNRwSHsajl8/Ph0JRgSc1L6DgcyJZ5tMHRbt8F+k90B6NAGRWtiTswhHE+Hx8JZJEVsgKL6F7RDY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwsA+kBV//N2nFeHDQTQO5sJp5LBPDFytp7kphahRXiw+CED8Dn
	YJ6iN66JFoBpPJRt9hToWLHlxKBAvCbMSVDX4ziv8SesPvVYERSIs9LJ
X-Gm-Gg: AR+sD11M8WjL/4Smd8nAVFXwHrCsHCGb+WDexjRyDX0Zde4Js2QRDgpdkCblgs491DD
	gb2nS6Bq5PfdiRwZVYLVE/m4t9Nm06g1F6DYLz7TQ+oO0IZ16B6JhvHiulpYV5EWST5Vairu6G6
	zvkAufyvmGCeNGYa0kslB9lEmjn++iFHvFny3GNf6TVWyhh/aa/ey94nWgb5K+5x5erhJ+vqRVh
	oZHHFujl4/LZK34BJx/ZAoYgB+4hpuwapphDDO6lx2iNkhlpMkO8EonsiubRbgQXQRhyfOZdt6O
	Ih7cXhtTD8SX8aEUCy+6GbqB6E8x3eTTDbx+ikVPx4meNYaTfh4UN4nBvnR1te6UnO+GwXggeie
	9n1ncs6HO4mpBi4108lTzDqY4RUV3Ip5gKlg9qIuNIf2hZXATZqSOFxb7qCaG4nB+jzqKncY/Al
	+3eJfgagLT4C+YK6cVDg==
X-Received: by 2002:a05:690c:6606:b0:80d:a249:4854 with SMTP id 00721157ae682-81f4c1ff813mr16496237b3.17.1784845860602;
        Thu, 23 Jul 2026 15:31:00 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:00 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:04 -0700
Subject: [PATCH RFC 05/15] vhost-user: add memory_isolation to
 VhostUserState
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-5-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=12759;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=e0y3nCskpzkZj4kyMOzgDnBn6vCXRdmOknYla343ncU=;
 b=9XNaHkONueEdA25B/5J+uN0TnlB4RppQdOFG/3neXY5pVon5glSxUn9WVvpNe4x60XkvBStE0
 6N0ri5d0aWHCjA0+jMHDIrLqNnDEV0Hq8XS3sfqWk4Wh5zRn4z+BkYQ
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Add a memory_isolation bool to the VhostUserState struct. This
bool is set within vhost_user_init(), which takes a
memory_isolation bool as an argument.

Refactor all call locations of vhost_user_init to include the new
argument.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 backends/cryptodev-vhost-user.c     |  2 +-
 backends/vhost-user.c               |  4 ++--
 hw/block/vhost-user-blk.c           |  3 ++-
 hw/display/vhost-user-gpu.c         |  3 ++-
 hw/scsi/vhost-user-scsi.c           |  3 ++-
 hw/virtio/vhost-stub.c              |  3 ++-
 hw/virtio/vhost-user-base.c         |  3 ++-
 hw/virtio/vhost-user-fs.c           |  3 ++-
 hw/virtio/vhost-user-scmi.c         |  3 ++-
 hw/virtio/vhost-user-vsock.c        |  3 ++-
 hw/virtio/vhost-user.c              |  5 ++++-
 include/hw/virtio/vhost-user.h      |  6 +++++-
 include/system/vhost-user-backend.h |  3 ++-
 net/passt.c                         | 13 ++++++++-----
 net/vhost-user.c                    |  9 +++++----
 15 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/backends/cryptodev-vhost-user.c b/backends/cryptodev-vhost-user.c
index e0547c5d40..328d7fbdfe 100644
--- a/backends/cryptodev-vhost-user.c
+++ b/backends/cryptodev-vhost-user.c
@@ -214,7 +214,7 @@ static void cryptodev_vhost_user_init(
         }
     }
 
-    if (!vhost_user_init(&s->vhost_user, &s->chr, errp)) {
+    if (!vhost_user_init(&s->vhost_user, &s->chr, s->memory_isolation, errp)) {
         return;
     }
 
diff --git a/backends/vhost-user.c b/backends/vhost-user.c
index 380d825023..470eba1775 100644
--- a/backends/vhost-user.c
+++ b/backends/vhost-user.c
@@ -22,13 +22,13 @@
 
 int
 vhost_user_backend_dev_init(VhostUserBackend *b, VirtIODevice *vdev,
-                            unsigned nvqs, Error **errp)
+                            unsigned nvqs, bool memory_isolation, Error **errp)
 {
     int ret;
 
     assert(!b->vdev && vdev);
 
-    if (!vhost_user_init(&b->vhost_user, &b->chr, errp)) {
+    if (!vhost_user_init(&b->vhost_user, &b->chr, memory_isolation, errp)) {
         return -1;
     }
 
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 9830dc6c35..5c1a19eb50 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -505,7 +505,8 @@ static void vhost_user_blk_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!vhost_user_init(&s->vhost_user, &s->chardev, errp)) {
+    if (!vhost_user_init(&s->vhost_user, &s->chardev,
+                         s->memory_isolation, errp)) {
         return;
     }
 
diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
index 6d0ede672a..b44c989f58 100644
--- a/hw/display/vhost-user-gpu.c
+++ b/hw/display/vhost-user-gpu.c
@@ -625,7 +625,8 @@ vhost_user_gpu_device_realize(DeviceState *qdev, Error **errp)
     VirtIODevice *vdev = VIRTIO_DEVICE(g);
 
     vhost_dev_set_config_notifier(&g->vhost->dev, &config_ops);
-    if (vhost_user_backend_dev_init(g->vhost, vdev, 2, errp) < 0) {
+    if (vhost_user_backend_dev_init(g->vhost, vdev, 2, g->memory_isolation,
+                                    errp) < 0) {
         return;
     }
 
diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
index c1a0393220..5a19182f2b 100644
--- a/hw/scsi/vhost-user-scsi.c
+++ b/hw/scsi/vhost-user-scsi.c
@@ -276,7 +276,8 @@ static void vhost_user_scsi_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!vhost_user_init(&s->vhost_user, &vs->conf.chardev, errp)) {
+    if (!vhost_user_init(&s->vhost_user, &vs->conf.chardev,
+                         vs->conf.memory_isolation, errp)) {
         goto free_virtio;
     }
 
diff --git a/hw/virtio/vhost-stub.c b/hw/virtio/vhost-stub.c
index 7321dc9210..d1e1075a31 100644
--- a/hw/virtio/vhost-stub.c
+++ b/hw/virtio/vhost-stub.c
@@ -12,7 +12,8 @@ unsigned int vhost_get_free_memslots(void)
     return UINT_MAX;
 }
 
-bool vhost_user_init(VhostUserState *user, CharFrontend *chr, Error **errp)
+bool vhost_user_init(VhostUserState *user, CharFrontend *chr,
+                     bool memory_isolation, Error **errp)
 {
     return false;
 }
diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
index d2a74a2860..11864a3f08 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -317,7 +317,8 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
         vub->vhost_user.supports_config = true;
     }
 
-    if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
+    if (!vhost_user_init(&vub->vhost_user, &vub->chardev,
+                         vub->memory_isolation, errp)) {
         return;
     }
 
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 3d980d814b..07ff2a35e0 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -238,7 +238,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!vhost_user_init(&fs->vhost_user, &fs->conf.chardev, errp)) {
+    if (!vhost_user_init(&fs->vhost_user, &fs->conf.chardev,
+                         fs->conf.memory_isolation, errp)) {
         return;
     }
 
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index d514d89392..2c1dbb723e 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -244,7 +244,8 @@ static void vu_scmi_device_realize(DeviceState *dev, Error **errp)
 
     vdev->host_features |= (1ULL << VIRTIO_SCMI_F_P2A_CHANNELS);
 
-    if (!vhost_user_init(&scmi->vhost_user, &scmi->chardev, errp)) {
+    if (!vhost_user_init(&scmi->vhost_user, &scmi->chardev,
+                         scmi->memory_isolation, errp)) {
         return;
     }
 
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 89aa789e22..33ab3b69e6 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -106,7 +106,8 @@ static void vuv_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!vhost_user_init(&vsock->vhost_user, &vsock->conf.chardev, errp)) {
+    if (!vhost_user_init(&vsock->vhost_user, &vsock->conf.chardev,
+                         vsock->conf.memory_isolation, errp)) {
         return;
     }
 
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 517cc4ca71..f296b63fb9 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -3118,13 +3118,16 @@ static void vhost_user_state_destroy(gpointer data)
     vhost_user_host_notifier_remove(n, NULL, true);
 }
 
-bool vhost_user_init(VhostUserState *user, CharFrontend *chr, Error **errp)
+bool vhost_user_init(VhostUserState *user, CharFrontend *chr,
+                     bool memory_isolation,
+                     Error **errp)
 {
     if (user->chr) {
         error_setg(errp, "Cannot initialize vhost-user state");
         return false;
     }
     user->chr = chr;
+    user->memory_isolation = memory_isolation;
     user->memory_slots = 0;
     user->notifiers = g_ptr_array_new_full(VIRTIO_QUEUE_MAX / 4,
                                            &vhost_user_state_destroy);
diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
index 06c360af18..72b5787efe 100644
--- a/include/hw/virtio/vhost-user.h
+++ b/include/hw/virtio/vhost-user.h
@@ -66,6 +66,7 @@ typedef struct VhostUserHostNotifier {
  * @chr: the character backend for the socket
  * @notifiers: GPtrArray of @VhostUserHostnotifier
  * @memory_slots:
+ * @memory_isolation: determines whether data is shared or copied
  */
 typedef struct VhostUserState {
     CharFrontend *chr;
@@ -73,12 +74,14 @@ typedef struct VhostUserState {
     int memory_slots;
     bool supports_config;
     bool supports_inflight_migration;
+    bool memory_isolation;
 } VhostUserState;
 
 /**
  * vhost_user_init() - initialise shared vhost_user state
  * @user: allocated area for storing shared state
  * @chr: the chardev for the vhost socket
+ * @memory_isolation: disables device access to guest memory
  * @errp: error handle
  *
  * User can either directly g_new() space for the state or embed
@@ -87,7 +90,8 @@ typedef struct VhostUserState {
  *
  * Return: true on success, false on error while setting errp.
  */
-bool vhost_user_init(VhostUserState *user, CharFrontend *chr, Error **errp);
+bool vhost_user_init(VhostUserState *user, CharFrontend *chr,
+                     bool memory_isolation, Error **errp);
 
 /**
  * vhost_user_cleanup() - cleanup state
diff --git a/include/system/vhost-user-backend.h b/include/system/vhost-user-backend.h
index 3184c8e799..c23f689182 100644
--- a/include/system/vhost-user-backend.h
+++ b/include/system/vhost-user-backend.h
@@ -41,7 +41,8 @@ struct VhostUserBackend {
 };
 
 int vhost_user_backend_dev_init(VhostUserBackend *b, VirtIODevice *vdev,
-                                unsigned nvqs, Error **errp);
+                                unsigned nvqs, bool memory_isolation,
+                                Error **errp);
 void vhost_user_backend_start(VhostUserBackend *b);
 int vhost_user_backend_stop(VhostUserBackend *b);
 
diff --git a/net/passt.c b/net/passt.c
index ce80186883..a3021f37ef 100644
--- a/net/passt.c
+++ b/net/passt.c
@@ -433,7 +433,9 @@ static void passt_vhost_user_event(void *opaque, QEMUChrEvent event)
     }
 }
 
-static int net_passt_vhost_user_init(NetPasstState *s, Error **errp)
+static int net_passt_vhost_user_init(NetPasstState *s,
+                                     bool memory_isolation,
+                                     Error **errp)
 {
     Chardev *chr;
     int sv[2];
@@ -457,7 +459,8 @@ static int net_passt_vhost_user_init(NetPasstState *s, Error **errp)
 
     s->vhost_user = g_new0(struct VhostUserState, 1);
     if (!qemu_chr_fe_init(&s->vhost_chr, chr, errp) ||
-        !vhost_user_init(s->vhost_user, &s->vhost_chr, errp)) {
+        !vhost_user_init(s->vhost_user, &s->vhost_chr, memory_isolation,
+                         errp)) {
         goto err;
     }
 
@@ -735,14 +738,14 @@ int net_init_passt(const Netdev *netdev, const char *name,
     s->pidfile = pidfile;
 
     if (netdev->u.passt.has_vhost_user && netdev->u.passt.vhost_user) {
-        bool memory_isolation G_GNUC_UNUSED = false;
+        bool memory_isolation = false;
 
         if (netdev->u.passt.has_memory_isolation &&
-           netdev->u.passt.memory_isolation) {
+            netdev->u.passt.memory_isolation) {
             memory_isolation = true;
         }
 
-        if (net_passt_vhost_user_init(s, errp) == -1) {
+        if (net_passt_vhost_user_init(s, memory_isolation, errp) == -1) {
             qemu_del_net_client(nc);
             return -1;
         }
diff --git a/net/vhost-user.c b/net/vhost-user.c
index 8fa303f901..722ab20228 100644
--- a/net/vhost-user.c
+++ b/net/vhost-user.c
@@ -370,7 +370,7 @@ static void net_vhost_user_event(void *opaque, QEMUChrEvent event)
 
 static int net_vhost_user_init(NetClientState *peer, const char *device,
                                const char *name, Chardev *chr,
-                               int queues)
+                               int queues, bool memory_isolation)
 {
     Error *err = NULL;
     NetClientState *nc, *nc0 = NULL;
@@ -390,7 +390,7 @@ static int net_vhost_user_init(NetClientState *peer, const char *device,
             nc0 = nc;
             s = DO_UPCAST(NetVhostUserState, nc, nc);
             if (!qemu_chr_fe_init(&s->chr, chr, &err) ||
-                !vhost_user_init(user, &s->chr, &err)) {
+                !vhost_user_init(user, &s->chr, memory_isolation, &err)) {
                 error_report_err(err);
                 goto err;
             }
@@ -459,7 +459,7 @@ int net_init_vhost_user(const Netdev *netdev, const char *name,
     int queues;
     const NetdevVhostUserOptions *vhost_user_opts;
     Chardev *chr;
-    bool memory_isolation G_GNUC_UNUSED;
+    bool memory_isolation;
 
     assert(netdev->type == NET_CLIENT_DRIVER_VHOST_USER);
     vhost_user_opts = &netdev->u.vhost_user;
@@ -480,5 +480,6 @@ int net_init_vhost_user(const Netdev *netdev, const char *name,
     memory_isolation = vhost_user_opts->has_memory_isolation ?
                        vhost_user_opts->memory_isolation : false;
 
-    return net_vhost_user_init(peer, "vhost_user", name, chr, queues);
+    return net_vhost_user_init(peer, "vhost_user", name, chr, queues,
+                               memory_isolation);
 }

-- 
2.43.0

