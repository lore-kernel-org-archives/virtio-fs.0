Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44D3CE0B4
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029957; cv=none; b=dqPEeFNQtkQ4r5ISVDPCojSiYdFzb8zObGJrD8kgm+STX6mQuFeZp/hDcvMBwzP5Ki/f4Z1qvyMm7/umq0VDWF1JRy4v1PQbQURuTPNJPP1Zbzt6GC5QIFdbiEeHmS9qMYeSDWOAGHMp96Bex4Q4owz7Pt9AkyMU9rfEJS2Ummc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029957; c=relaxed/simple;
	bh=CgCmodYY3hh2gpX/jaQuylcKS6MagmlBraNfgqmJ4X0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Zt/rzv0B1mYmPraCueodu0+2q7FZadmct5rnPpnmdoJSFWStjRZhOqPqRXWy6E+XOVCVzhLXjXti5RUO4g/q/93FGZ3/19iuUw0MgdjVjQI/C6qAIgpDB1eq0BZUHjEPSYznFLcQdBKd6VXkDvVx5SQ6rHThofQYQWNajSsqYbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mc+NnOTA; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mc+NnOTA"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84830c774a0so3667111b3a.1
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029955; x=1787634755; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uI/bGUOPiZtgA7sRPmLikAJa60Bs+xkxXw4S9cHkhMQ=;
        b=mc+NnOTArxzsfsRkt7sEs6zrpf2Z5zS8aP9SfyNCf6j7Z3YN9BbtZIMHAa1j72Oz/3
         NtvjzGYDRM2feqLggoRZZUJ0bQabdCvyf0C9//Q3rYgkI0nU6/x/+Nl2wZTZCKLF2qnJ
         zwnUEQ41q72L4XlymO2YVP1utl5Fo6ca6YQMCKKCkSsF5hH98wXo0Qy7f6ptg+tNTR6t
         0EJcNHVH0vPFAn3+NhkNDuZecju70Xb3RpNgGEKZaDlybV+U4lS3z7vIHyIdpKkbIDlL
         cueIB9mScSzNTxU1EfE2nS2ewCUpRznnex0/Dbfci6XhHW5vrM1mSgIlorND8iZspvXE
         v+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029955; x=1787634755;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uI/bGUOPiZtgA7sRPmLikAJa60Bs+xkxXw4S9cHkhMQ=;
        b=ljtwZpUsg4dBAKob5LgXUdwnj/vtx0WYS82xlEJfLaWQJPeAjGUbwubXUFiBTQJjjr
         Z7caVpL7cRqg1M6yho02IS+1/qr36mZcqK8+HFLWtb+oSl0AX1IlVThPHtz8BWJFlif3
         V92mJkhA9tdIYiOaZcnkHlSSWK1/KL5bRNfX24NStDvBAgmjZxkFVxmpKFgRFLTZ+Uwk
         ovyGgNmFNjYBphMYiWD8vE2/iOM+hl6Ft8Jg9XNwhFluWNijePsne63lXg/314ty8ZRg
         /pjJjwtP+aBVLKBsHx9Z8aqnOHAJtVXtCXU/fwUS6mxMhYK3z2Rii9WmaIKfnmtYr/Bb
         NF/A==
X-Forwarded-Encrypted: i=1; AHgh+RpYo1t6ErtdbCm7fIDBprqOKTIkuMlEnrUe3zMKAdQazuC4FAWINSEOQ3LuyUzTgzaq5EHPtf2SGxA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyeBKYbNkkVywR+6QFYVnyVMNB0RAhFXKHcmDMKVUSiJUaXQuxk
	1b8AuXv05cxcMkSxtc3v9il3SryqkqODGXR94TpFxA6P85OpBEjTXJJ+
X-Gm-Gg: AR+sD11s/XEWorcWZrlbBRblVb0/swZSg7/a5XjyYLH7Jny9Jkji6IKG+PBLLMiHy/1
	hwqNt6YW84mGt+jMeZHINxh4bKp8KrmTZvcTPEI+H1zqoh+LP5//Ee9GX5S4zlVLAkh7zeeMIZE
	7LIRPI3MoUjqNrIXuLSEJ00x25m9lO7xPHVyKLyUTLst2CWX+Df++/Hqopzl26MTGO+15Naocao
	+okppX5hYJfQH/U3VI1MzTZ7qvt+PObmGeMl6yDdrf629YPysPNhAqpgeaLpP4TY9mdn+Ta/72W
	4hawq36g0P+ye9mcwMv/i/hnXmWQX3GXX0nu2CT2xI4Me231xvgnOG67JZeq+3tp2lzswlkG1Pz
	TepQlcYhB8rgiDwCqd7Qyfzl5k7GIT4M3qvK5a5wuPowPVw1t4y1RsuSQJ/OeY9YEOYv3PjIRbl
	QnxIzpWQXOCaWdk2H3Bp371VFNEocw9p5H0986PN0azSkLAI+5YhL4Bh5Z2a9/zgLh8Y/6vM2O6
	sLR
X-Received: by 2002:a05:6a00:4193:b0:847:9315:fb8b with SMTP id d2e1a72fcca58-84fde1500e7mr32736377b3a.6.1787029955327;
        Mon, 17 Aug 2026 22:12:35 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:34 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:21 -0700
Subject: [PATCH RFC v2 06/13] vhost-user: add memory_isolation to
 VhostUserState
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-6-948aae960abb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=12563;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=CgCmodYY3hh2gpX/jaQuylcKS6MagmlBraNfgqmJ4X0=;
 b=wHHi3W9jMtEUW9xqnPHbGay0kwhnFDuOGxjd8uOeLr1jwuCApSV29JYjB+ly1riYUfkFEpDoC
 yXUW9FgBtIPAqjZ8C1cqJ7+5I4PQlz2AFXV6vjYBMLvMxGgYbRmx1ss
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
 net/passt.c                         | 14 ++++++++++----
 net/vhost-user.c                    |  8 +++++---
 15 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/backends/cryptodev-vhost-user.c b/backends/cryptodev-vhost-user.c
index cc478d9902..fa1f9b76d3 100644
--- a/backends/cryptodev-vhost-user.c
+++ b/backends/cryptodev-vhost-user.c
@@ -213,7 +213,7 @@ static void cryptodev_vhost_user_init(
         }
     }
 
-    if (!vhost_user_init(&s->vhost_user, &s->chr, errp)) {
+    if (!vhost_user_init(&s->vhost_user, &s->chr, false, errp)) {
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
index 2e5b3ae1b1..4640d7da04 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -505,7 +505,8 @@ static void vhost_user_blk_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!vhost_user_init(&s->vhost_user, &s->chardev, errp)) {
+    if (!vhost_user_init(&s->vhost_user, &s->chardev,
+                         false, errp)) {
         return;
     }
 
diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
index cd684d6363..6655585b43 100644
--- a/hw/display/vhost-user-gpu.c
+++ b/hw/display/vhost-user-gpu.c
@@ -663,7 +663,8 @@ vhost_user_gpu_device_realize(DeviceState *qdev, Error **errp)
     VirtIODevice *vdev = VIRTIO_DEVICE(g);
 
     vhost_dev_set_config_notifier(&g->vhost->dev, &config_ops);
-    if (vhost_user_backend_dev_init(g->vhost, vdev, 2, errp) < 0) {
+    if (vhost_user_backend_dev_init(g->vhost, vdev, 2, false,
+                                    errp) < 0) {
         return;
     }
 
diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
index 5070178dc2..05bc788304 100644
--- a/hw/scsi/vhost-user-scsi.c
+++ b/hw/scsi/vhost-user-scsi.c
@@ -276,7 +276,8 @@ static void vhost_user_scsi_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!vhost_user_init(&s->vhost_user, &vs->conf.chardev, errp)) {
+    if (!vhost_user_init(&s->vhost_user, &vs->conf.chardev,
+                         false, errp)) {
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
index 90bd2903db..c10851492a 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -317,7 +317,8 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
         vub->vhost_user.supports_config = true;
     }
 
-    if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
+    if (!vhost_user_init(&vub->vhost_user, &vub->chardev,
+                         false, errp)) {
         return;
     }
 
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 209993918a..34ccbdec10 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -238,7 +238,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!vhost_user_init(&fs->vhost_user, &fs->conf.chardev, errp)) {
+    if (!vhost_user_init(&fs->vhost_user, &fs->conf.chardev,
+                         false, errp)) {
         return;
     }
 
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index 02dc088ea9..bd0ec64daf 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -244,7 +244,8 @@ static void vu_scmi_device_realize(DeviceState *dev, Error **errp)
 
     vdev->host_features |= (1ULL << VIRTIO_SCMI_F_P2A_CHANNELS);
 
-    if (!vhost_user_init(&scmi->vhost_user, &scmi->chardev, errp)) {
+    if (!vhost_user_init(&scmi->vhost_user, &scmi->chardev,
+                         false, errp)) {
         return;
     }
 
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index c2cd376e73..44a90c76ad 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -106,7 +106,8 @@ static void vuv_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!vhost_user_init(&vsock->vhost_user, &vsock->conf.chardev, errp)) {
+    if (!vhost_user_init(&vsock->vhost_user, &vsock->conf.chardev,
+                         false, errp)) {
         return;
     }
 
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 2881cec72d..1c003e4d9d 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -3121,13 +3121,16 @@ static void vhost_user_state_destroy(gpointer data)
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
index 06c360af18..0eca9b1668 100644
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
+ * @memory_isolation: restrict direct access to guest memory from back-end
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
index 45440c399b..35ec6ad6de 100644
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
 
@@ -487,7 +490,8 @@ err:
     return -1;
 }
 #else
-static int net_passt_vhost_user_init(NetPasstState *s, Error **errp)
+static int net_passt_vhost_user_init(NetPasstState *s, bool memory_isolation,
+                                     Error **errp)
 {
     error_setg(errp, "vhost-user support has not been built");
 
@@ -735,7 +739,9 @@ int net_init_passt(const Netdev *netdev, const char *name,
     s->pidfile = pidfile;
 
     if (netdev->u.passt.has_vhost_user && netdev->u.passt.vhost_user) {
-        if (net_passt_vhost_user_init(s, errp) == -1) {
+        bool memory_isolation = false;
+
+        if (net_passt_vhost_user_init(s, memory_isolation, errp) == -1) {
             qemu_del_net_client(nc);
             return -1;
         }
diff --git a/net/vhost-user.c b/net/vhost-user.c
index 2d0fc49b4d..b6ee9ed297 100644
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
@@ -459,6 +459,7 @@ int net_init_vhost_user(const Netdev *netdev, const char *name,
     int queues;
     const NetdevVhostUserOptions *vhost_user_opts;
     Chardev *chr;
+    bool memory_isolation = false;
 
     assert(netdev->type == NET_CLIENT_DRIVER_VHOST_USER);
     vhost_user_opts = &netdev->u.vhost_user;
@@ -476,5 +477,6 @@ int net_init_vhost_user(const Netdev *netdev, const char *name,
         return -1;
     }
 
-    return net_vhost_user_init(peer, "vhost_user", name, chr, queues);
+    return net_vhost_user_init(peer, "vhost_user", name, chr, queues,
+                               memory_isolation);
 }

-- 
2.43.0

