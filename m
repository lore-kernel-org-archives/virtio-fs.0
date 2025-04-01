Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C4F20ADF4
	for <virtio-fs@lists.linux.dev>; Tue,  1 Apr 2025 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743520737; cv=none; b=SKE+PdYpJebURLM29Bf017Mkf+Dyvsyv0sM4lNe3OGtqX3cyXg3wpuB5tFvG2R7jmkSCtJB8LoaVJGDyHEtJgf2ADW2VpmjuUrbM7CAWS1lLDh0LYAvnKuFyv3nw6z+rq4S72dB6QppbYzXbRUEOSH5lWcA2BRqci1CbDWmGXEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743520737; c=relaxed/simple;
	bh=tzBgH/ry8kcwyczlqxRNXtWU9KT9aPd1pxzgcShBrck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qy7ygWdcdzqf//tUo7BLkUOQAnabo22CLA3VvemHe6Q9DM5ysrD8p4sPi7hSGphU+rXNPKnh7EG+HRJ9+0oJ5IDtEuvblliZHt87M0c/F5/d6o0ncR1ZJqCW0943th5AP9dOUxf7HrQx0dvYkc4ibf4KXKFw6cySqWMJq4M8IfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=Z/ycsw0B; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="Z/ycsw0B"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-225477548e1so102422655ad.0
        for <virtio-fs@lists.linux.dev>; Tue, 01 Apr 2025 08:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1743520734; x=1744125534; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vm9MtFXWVln57lA7/IXTowGkEZthI5sffUa9dh8rVt8=;
        b=Z/ycsw0BesMtgSC9cXolMM/C6yvyolVUe+ngwjpaNaQthpcFQDQIyzv6RD1wm3qkc3
         8/4yCvMBUhICR4xez3HX8Q+uUaRW7bKS1uzwoz2w+oDigYlmCmey0Muebj1k8Br1aO56
         RSfKTS6Ul26Db2Jr0l6mPfdq964aekshwtIJ4MaAgHWQ5vdH7uHOV/sJk09SE6boeMJE
         Y+lEWDpWHqLJ8s6EntynTwKGX1pOLfKTLh6hI5gpOsHTiV19lkX+geBi4aMnGfjKFE/C
         H1uilgETjr/owWhtbPMB5dpr9frGHVmrnkGReCcRs7lcAwbCfxNOjDn6MyQCnWK3NXLF
         btwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743520734; x=1744125534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vm9MtFXWVln57lA7/IXTowGkEZthI5sffUa9dh8rVt8=;
        b=Ld34KKVRK76d3qi+B75+spws88T0UVkgLJTS+aXjfIPMG8MyTkCISJy0IXKkiFyv5w
         nawV61qNgDoeyXEEfR3OQBWf6XtS0K/b6KgAOJwf6+ZXowrNB6GyanKwqbzemUiXsOwz
         WIOrp5A6ymO37goAxhAUf1tPB/2Myk0XZuf8pqaKZIjzMpzmgzg9tjxR3TDo+lwKQQXS
         zxkql/O3F7hayiXFUpMvCd5WGZ8RmsFefWJioXVnOyC6IDXBWhoa8WiENDsICf+8ooji
         oU3GTq8obHR5x0VVAwIP+/P/vcXbct2c+ShV8xKtoGr09Qm4rpLQ4LVCL5OKdOZloaLH
         l8hA==
X-Forwarded-Encrypted: i=1; AJvYcCVIZzbnWrtmH4zQRwuvE0NuDcjkMucxvvXljmG+66ZalRlbJdbw2INPRNngrM54sSeAXSauC2Tp9us=@lists.linux.dev
X-Gm-Message-State: AOJu0YyG/047tI7qHaRl6gXCOAi21uKfSE0xJRUrgi0JZH/v/beoOz7x
	XOA2t+PbaBVbmt/EdsZnOAGJL5L34eNjRooZQ3mVRSXGFOTGy0goYs36UCbhe28=
X-Gm-Gg: ASbGnctPZOvYc3EpSSFoXLrXRV4KdP1aZ4NHe6pCIKEg8IuPOgOZSJztQc3T89qjYxm
	Z213f+GmF8uUinfs9hMT9+zs0HxY3+pYBa8usNVwuVLqr6A2N805/yR05wNwcFfF2+E03lbwxEQ
	4m1cMEcJHp9PoZO/BWeOWcFwfaCJxw6EoK9gDeGUXbSdabAmixBuJ2jzdvt+Ng8GBPOHkAgZGF6
	NhfBArqS8ndLsru/P9nYfDvjITePCcgy0HAu9DvUDa7PdWJWejRscnbAr/vFnZQNdFDH89Gz/5W
	x7u+hjsCrn4rVycbdVN2Gp9o36R/4Ro=
X-Google-Smtp-Source: AGHT+IGteyF/P+76pb9JLnl2TfUX9lsiyV0kWd/JESCJi7PM7H/3e4lQDYV8px0pWKimZieZb2WEJg==
X-Received: by 2002:a17:902:d48a:b0:220:f140:f7be with SMTP id d9443c01a7336-2292f9f31c2mr230316105ad.41.1743520734030;
        Tue, 01 Apr 2025 08:18:54 -0700 (PDT)
Received: from fedora.smartx.com ([2001:df0:a640:1::4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2291eee029bsm90172195ad.62.2025.04.01.08.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 08:18:53 -0700 (PDT)
From: Haoqian He <haoqian.he@smartx.com>
To: qemu-devel@nongnu.org,
	sgarzare@redhat.com,
	mst@redhat.com,
	raphael@enfabrica.net
Cc: fengli@smartx.com,
	yuhua@smartx.com,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Amit Shah <amit@kernel.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	mzamazal@redhat.com (reviewer:vhost-user-scmi),
	David Hildenbrand <david@redhat.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-block@nongnu.org (open list:Block layer core),
	virtio-fs@lists.linux.dev (open list:virtiofs)
Subject: [PATCH v4 3/3] vhost-user: return failure if backend crash when live migration
Date: Tue,  1 Apr 2025 11:18:17 -0400
Message-ID: <20250401151819.1526461-4-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250401151819.1526461-1-haoqian.he@smartx.com>
References: <20250327064348.3595732-1-haoqian.he@smartx.com>
 <20250401151819.1526461-1-haoqian.he@smartx.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Live migration should be terminated if the vhost-user backend crashes
before the migration completes.

Specifically, since the vhost device will be stopped when VM is stopped
before the end of the live migration, in current implementation if the
backend crashes, vhost-user device set_status() won't return failure,
live migration won't perceive the disconnection between QEMU and the
backend.

When the VM is migrated to the destination, the inflight IO will be
resubmitted, and if the IO was completed out of order before, it will
cause IO error.

To fix this issue:
1. Add the return value to set_status() for VirtioDeviceClass.
  a. For the vhost-user device, return failure when the backend crashes.
  b. For other virtio devices, always return 0.
2. Return failure if vhost_dev_stop() failed for vhost-user device.

If QEMU loses connection with the vhost-user backend, virtio set_status()
can return failure to the upper layer, migration_completion() can handle
the error, terminate the live migration, and restore the VM, so that
inflight IO can be completed normally.

Signed-off-by: Haoqian He <haoqian.he@smartx.com>
---
 backends/vhost-user.c                  | 20 +++++++++----------
 hw/block/vhost-user-blk.c              | 27 ++++++++++++++------------
 hw/block/virtio-blk.c                  |  5 +++--
 hw/char/virtio-serial-bus.c            |  3 ++-
 hw/display/vhost-user-gpu.c            | 12 +++++++++---
 hw/input/virtio-input.c                |  3 ++-
 hw/net/virtio-net.c                    |  3 ++-
 hw/scsi/vhost-scsi-common.c            | 13 +++++++------
 hw/scsi/vhost-scsi.c                   |  5 +++--
 hw/scsi/vhost-user-scsi.c              | 18 ++++++++++-------
 hw/virtio/vdpa-dev.c                   |  5 +++--
 hw/virtio/vhost-user-base.c            | 23 +++++++++++++---------
 hw/virtio/vhost-user-fs.c              | 23 +++++++++++++---------
 hw/virtio/vhost-user-scmi.c            | 27 +++++++++++++++-----------
 hw/virtio/vhost-user-vsock.c           | 15 +++++++++-----
 hw/virtio/vhost-vsock-common.c         | 12 ++++++------
 hw/virtio/vhost-vsock.c                | 11 ++++++-----
 hw/virtio/virtio-balloon.c             |  3 ++-
 hw/virtio/virtio-crypto.c              |  3 ++-
 hw/virtio/virtio-iommu.c               |  3 ++-
 hw/virtio/virtio-rng.c                 |  5 +++--
 hw/virtio/virtio.c                     | 23 +++++++++++++++-------
 include/hw/virtio/vhost-scsi-common.h  |  2 +-
 include/hw/virtio/vhost-vsock-common.h |  2 +-
 include/hw/virtio/virtio.h             |  2 +-
 include/system/vhost-user-backend.h    |  2 +-
 26 files changed, 161 insertions(+), 109 deletions(-)

diff --git a/backends/vhost-user.c b/backends/vhost-user.c
index d0e4d71a63..5409e9d4eb 100644
--- a/backends/vhost-user.c
+++ b/backends/vhost-user.c
@@ -97,30 +97,28 @@ err_host_notifiers:
     vhost_dev_disable_notifiers(&b->dev, b->vdev);
 }
 
-void
+int
 vhost_user_backend_stop(VhostUserBackend *b)
 {
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(b->vdev)));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    int ret = 0;
+    int ret;
 
     if (!b->started) {
-        return;
+        return 0;
     }
 
-    vhost_dev_stop(&b->dev, b->vdev, true);
+    ret = vhost_dev_stop(&b->dev, b->vdev, true);
 
-    if (k->set_guest_notifiers) {
-        ret = k->set_guest_notifiers(qbus->parent,
-                                     b->dev.nvqs, false);
-        if (ret < 0) {
-            error_report("vhost guest notifier cleanup failed: %d", ret);
-        }
+    if (k->set_guest_notifiers &&
+        k->set_guest_notifiers(qbus->parent, b->dev.nvqs, false)< 0) {
+        error_report("vhost guest notifier cleanup failed: %d", ret);
+        return -1;
     }
-    assert(ret >= 0);
 
     vhost_dev_disable_notifiers(&b->dev, b->vdev);
     b->started = false;
+    return ret;
 }
 
 static void set_chardev(Object *obj, const char *value, Error **errp)
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index ae42327cf8..f355459123 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -204,7 +204,7 @@ err_host_notifiers:
     return ret;
 }
 
-static void vhost_user_blk_stop(VirtIODevice *vdev)
+static int vhost_user_blk_stop(VirtIODevice *vdev)
 {
     VHostUserBlk *s = VHOST_USER_BLK(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
@@ -212,26 +212,26 @@ static void vhost_user_blk_stop(VirtIODevice *vdev)
     int ret;
 
     if (!s->started_vu) {
-        return;
+        return 0;
     }
     s->started_vu = false;
 
     if (!k->set_guest_notifiers) {
-        return;
+        return 0;
     }
 
-    vhost_dev_stop(&s->dev, vdev, true);
+    ret = vhost_dev_stop(&s->dev, vdev, true);
 
-    ret = k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
-    if (ret < 0) {
+    if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
-        return;
+        return -1;
     }
 
     vhost_dev_disable_notifiers(&s->dev, vdev);
+    return ret;
 }
 
-static void vhost_user_blk_set_status(VirtIODevice *vdev, uint8_t status)
+static int vhost_user_blk_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserBlk *s = VHOST_USER_BLK(vdev);
     bool should_start = virtio_device_should_start(vdev, status);
@@ -239,11 +239,11 @@ static void vhost_user_blk_set_status(VirtIODevice *vdev, uint8_t status)
     int ret;
 
     if (!s->connected) {
-        return;
+        return -1;
     }
 
     if (vhost_dev_is_started(&s->dev) == should_start) {
-        return;
+        return 0;
     }
 
     if (should_start) {
@@ -253,9 +253,12 @@ static void vhost_user_blk_set_status(VirtIODevice *vdev, uint8_t status)
             qemu_chr_fe_disconnect(&s->chardev);
         }
     } else {
-        vhost_user_blk_stop(vdev);
+        ret = vhost_user_blk_stop(vdev);
+        if (ret < 0) {
+            return ret;
+        }
     }
-
+    return 0;
 }
 
 static uint64_t vhost_user_blk_get_features(VirtIODevice *vdev,
diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index 4a48a16790..4244ee3410 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -1269,7 +1269,7 @@ static uint64_t virtio_blk_get_features(VirtIODevice *vdev, uint64_t features,
     return features;
 }
 
-static void virtio_blk_set_status(VirtIODevice *vdev, uint8_t status)
+static int virtio_blk_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VirtIOBlock *s = VIRTIO_BLK(vdev);
 
@@ -1278,7 +1278,7 @@ static void virtio_blk_set_status(VirtIODevice *vdev, uint8_t status)
     }
 
     if (!(status & VIRTIO_CONFIG_S_DRIVER_OK)) {
-        return;
+        return 0;
     }
 
     /* A guest that supports VIRTIO_BLK_F_CONFIG_WCE must be able to send
@@ -1301,6 +1301,7 @@ static void virtio_blk_set_status(VirtIODevice *vdev, uint8_t status)
                                    virtio_vdev_has_feature(vdev,
                                                            VIRTIO_BLK_F_WCE));
     }
+    return 0;
 }
 
 static void virtio_blk_save_device(VirtIODevice *vdev, QEMUFile *f)
diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
index b6d2743a9c..22accfd8e4 100644
--- a/hw/char/virtio-serial-bus.c
+++ b/hw/char/virtio-serial-bus.c
@@ -622,7 +622,7 @@ static void guest_reset(VirtIOSerial *vser)
     }
 }
 
-static void set_status(VirtIODevice *vdev, uint8_t status)
+static int set_status(VirtIODevice *vdev, uint8_t status)
 {
     VirtIOSerial *vser;
     VirtIOSerialPort *port;
@@ -650,6 +650,7 @@ static void set_status(VirtIODevice *vdev, uint8_t status)
             vsc->enable_backend(port, vdev->vm_running);
         }
     }
+    return 0;
 }
 
 static void vser_reset(VirtIODevice *vdev)
diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
index 2aed6243f6..d7d159ecd9 100644
--- a/hw/display/vhost-user-gpu.c
+++ b/hw/display/vhost-user-gpu.c
@@ -513,7 +513,7 @@ vhost_user_gpu_set_config(VirtIODevice *vdev,
     }
 }
 
-static void
+static int
 vhost_user_gpu_set_status(VirtIODevice *vdev, uint8_t val)
 {
     VhostUserGPU *g = VHOST_USER_GPU(vdev);
@@ -522,18 +522,24 @@ vhost_user_gpu_set_status(VirtIODevice *vdev, uint8_t val)
     if (val & VIRTIO_CONFIG_S_DRIVER_OK && vdev->vm_running) {
         if (!vhost_user_gpu_do_set_socket(g, &err)) {
             error_report_err(err);
-            return;
+            return 0;
         }
         vhost_user_backend_start(g->vhost);
     } else {
+        int ret;
+
         /* unblock any wait and stop processing */
         if (g->vhost_gpu_fd != -1) {
             vhost_user_gpu_update_blocked(g, true);
             qemu_chr_fe_deinit(&g->vhost_chr, true);
             g->vhost_gpu_fd = -1;
         }
-        vhost_user_backend_stop(g->vhost);
+        ret = vhost_user_backend_stop(g->vhost);
+        if (ret < 0) {
+            return ret;
+        }
     }
+    return 0;
 }
 
 static bool
diff --git a/hw/input/virtio-input.c b/hw/input/virtio-input.c
index 1394d99c6b..7ce53b7449 100644
--- a/hw/input/virtio-input.c
+++ b/hw/input/virtio-input.c
@@ -189,7 +189,7 @@ static uint64_t virtio_input_get_features(VirtIODevice *vdev, uint64_t f,
     return f;
 }
 
-static void virtio_input_set_status(VirtIODevice *vdev, uint8_t val)
+static int virtio_input_set_status(VirtIODevice *vdev, uint8_t val)
 {
     VirtIOInputClass *vic = VIRTIO_INPUT_GET_CLASS(vdev);
     VirtIOInput *vinput = VIRTIO_INPUT(vdev);
@@ -202,6 +202,7 @@ static void virtio_input_set_status(VirtIODevice *vdev, uint8_t val)
             }
         }
     }
+    return 0;
 }
 
 static void virtio_input_reset(VirtIODevice *vdev)
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index de87cfadff..b7de824baa 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -382,7 +382,7 @@ static void virtio_net_drop_tx_queue_data(VirtIODevice *vdev, VirtQueue *vq)
     }
 }
 
-static void virtio_net_set_status(struct VirtIODevice *vdev, uint8_t status)
+static int virtio_net_set_status(struct VirtIODevice *vdev, uint8_t status)
 {
     VirtIONet *n = VIRTIO_NET(vdev);
     VirtIONetQueue *q;
@@ -437,6 +437,7 @@ static void virtio_net_set_status(struct VirtIODevice *vdev, uint8_t status)
             }
         }
     }
+    return 0;
 }
 
 static void virtio_net_set_link_status(NetClientState *nc)
diff --git a/hw/scsi/vhost-scsi-common.c b/hw/scsi/vhost-scsi-common.c
index 4c8637045d..43525ba46d 100644
--- a/hw/scsi/vhost-scsi-common.c
+++ b/hw/scsi/vhost-scsi-common.c
@@ -101,24 +101,25 @@ err_host_notifiers:
     return ret;
 }
 
-void vhost_scsi_common_stop(VHostSCSICommon *vsc)
+int vhost_scsi_common_stop(VHostSCSICommon *vsc)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(vsc);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
     int ret = 0;
 
-    vhost_dev_stop(&vsc->dev, vdev, true);
+    ret = vhost_dev_stop(&vsc->dev, vdev, true);
 
     if (k->set_guest_notifiers) {
-        ret = k->set_guest_notifiers(qbus->parent, vsc->dev.nvqs, false);
-        if (ret < 0) {
-                error_report("vhost guest notifier cleanup failed: %d", ret);
+        int r = k->set_guest_notifiers(qbus->parent, vsc->dev.nvqs, false);
+        if (r < 0) {
+            error_report("vhost guest notifier cleanup failed: %d", ret);
+            return r;
         }
     }
-    assert(ret >= 0);
 
     vhost_dev_disable_notifiers(&vsc->dev, vdev);
+    return ret;
 }
 
 uint64_t vhost_scsi_common_get_features(VirtIODevice *vdev, uint64_t features,
diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index 8039d13fd9..19d5261019 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -114,7 +114,7 @@ static void vhost_scsi_stop(VHostSCSI *s)
     vhost_scsi_common_stop(vsc);
 }
 
-static void vhost_scsi_set_status(VirtIODevice *vdev, uint8_t val)
+static int vhost_scsi_set_status(VirtIODevice *vdev, uint8_t val)
 {
     VHostSCSI *s = VHOST_SCSI(vdev);
     VHostSCSICommon *vsc = VHOST_SCSI_COMMON(s);
@@ -125,7 +125,7 @@ static void vhost_scsi_set_status(VirtIODevice *vdev, uint8_t val)
     }
 
     if (vhost_dev_is_started(&vsc->dev) == start) {
-        return;
+        return 0;
     }
 
     if (start) {
@@ -139,6 +139,7 @@ static void vhost_scsi_set_status(VirtIODevice *vdev, uint8_t val)
     } else {
         vhost_scsi_stop(s);
     }
+    return 0;
 }
 
 static void vhost_dummy_handle_output(VirtIODevice *vdev, VirtQueue *vq)
diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
index adb41b9816..aba9fb82d2 100644
--- a/hw/scsi/vhost-user-scsi.c
+++ b/hw/scsi/vhost-user-scsi.c
@@ -52,19 +52,19 @@ static int vhost_user_scsi_start(VHostUserSCSI *s, Error **errp)
     return ret;
 }
 
-static void vhost_user_scsi_stop(VHostUserSCSI *s)
+static int vhost_user_scsi_stop(VHostUserSCSI *s)
 {
     VHostSCSICommon *vsc = VHOST_SCSI_COMMON(s);
 
     if (!s->started_vu) {
-        return;
+        return 0;
     }
     s->started_vu = false;
 
-    vhost_scsi_common_stop(vsc);
+    return vhost_scsi_common_stop(vsc);
 }
 
-static void vhost_user_scsi_set_status(VirtIODevice *vdev, uint8_t status)
+static int vhost_user_scsi_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserSCSI *s = (VHostUserSCSI *)vdev;
     DeviceState *dev = DEVICE(vdev);
@@ -75,11 +75,11 @@ static void vhost_user_scsi_set_status(VirtIODevice *vdev, uint8_t status)
     int ret;
 
     if (!s->connected) {
-        return;
+        return -1;
     }
 
     if (vhost_dev_is_started(&vsc->dev) == should_start) {
-        return;
+        return 0;
     }
 
     if (should_start) {
@@ -91,8 +91,12 @@ static void vhost_user_scsi_set_status(VirtIODevice *vdev, uint8_t status)
             qemu_chr_fe_disconnect(&vs->conf.chardev);
         }
     } else {
-        vhost_user_scsi_stop(s);
+        ret = vhost_user_scsi_stop(s);
+        if (ret) {
+            return ret;
+        }
     }
+    return 0;
 }
 
 static void vhost_user_scsi_handle_output(VirtIODevice *vdev, VirtQueue *vq)
diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
index a7e73b1c99..d80d46baed 100644
--- a/hw/virtio/vdpa-dev.c
+++ b/hw/virtio/vdpa-dev.c
@@ -312,7 +312,7 @@ static void vhost_vdpa_device_stop(VirtIODevice *vdev)
     vhost_dev_disable_notifiers(&s->dev, vdev);
 }
 
-static void vhost_vdpa_device_set_status(VirtIODevice *vdev, uint8_t status)
+static int vhost_vdpa_device_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VhostVdpaDevice *s = VHOST_VDPA_DEVICE(vdev);
     bool should_start = virtio_device_started(vdev, status);
@@ -324,7 +324,7 @@ static void vhost_vdpa_device_set_status(VirtIODevice *vdev, uint8_t status)
     }
 
     if (s->started == should_start) {
-        return;
+        return 0;
     }
 
     if (should_start) {
@@ -335,6 +335,7 @@ static void vhost_vdpa_device_set_status(VirtIODevice *vdev, uint8_t status)
     } else {
         vhost_vdpa_device_stop(vdev);
     }
+    return 0;
 }
 
 static const Property vhost_vdpa_device_properties[] = {
diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
index 2bc3423326..37718653bd 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -66,7 +66,7 @@ err_host_notifiers:
     vhost_dev_disable_notifiers(&vub->vhost_dev, vdev);
 }
 
-static void vub_stop(VirtIODevice *vdev)
+static int vub_stop(VirtIODevice *vdev)
 {
     VHostUserBase *vub = VHOST_USER_BASE(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
@@ -74,34 +74,39 @@ static void vub_stop(VirtIODevice *vdev)
     int ret;
 
     if (!k->set_guest_notifiers) {
-        return;
+        return 0;
     }
 
-    vhost_dev_stop(&vub->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&vub->vhost_dev, vdev, true);
 
-    ret = k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false);
-    if (ret < 0) {
+    if (k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
-        return;
+        return -1;
     }
 
     vhost_dev_disable_notifiers(&vub->vhost_dev, vdev);
+    return ret;
 }
 
-static void vub_set_status(VirtIODevice *vdev, uint8_t status)
+static int vub_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserBase *vub = VHOST_USER_BASE(vdev);
     bool should_start = virtio_device_should_start(vdev, status);
 
     if (vhost_dev_is_started(&vub->vhost_dev) == should_start) {
-        return;
+        return 0;
     }
 
     if (should_start) {
         vub_start(vdev);
     } else {
-        vub_stop(vdev);
+        int ret;
+        ret = vub_stop(vdev);
+        if (ret < 0) {
+            return ret;
+        }
     }
+    return 0;
 }
 
 /*
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 3f00d79ed0..266c179671 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -100,7 +100,7 @@ err_host_notifiers:
     vhost_dev_disable_notifiers(&fs->vhost_dev, vdev);
 }
 
-static void vuf_stop(VirtIODevice *vdev)
+static int vuf_stop(VirtIODevice *vdev)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
@@ -108,34 +108,39 @@ static void vuf_stop(VirtIODevice *vdev)
     int ret;
 
     if (!k->set_guest_notifiers) {
-        return;
+        return 0;
     }
 
-    vhost_dev_stop(&fs->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&fs->vhost_dev, vdev, true);
 
-    ret = k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false);
-    if (ret < 0) {
+    if (k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
-        return;
+        return -1;
     }
 
     vhost_dev_disable_notifiers(&fs->vhost_dev, vdev);
+    return ret;
 }
 
-static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
+static int vuf_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
     bool should_start = virtio_device_should_start(vdev, status);
 
     if (vhost_dev_is_started(&fs->vhost_dev) == should_start) {
-        return;
+        return 0;
     }
 
     if (should_start) {
         vuf_start(vdev);
     } else {
-        vuf_stop(vdev);
+        int ret;
+        ret = vuf_stop(vdev);
+        if (ret < 0) {
+            return ret;
+        }
     }
+    return 0;
 }
 
 static uint64_t vuf_get_features(VirtIODevice *vdev,
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index 410a936ca7..a9778f1f4b 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -83,7 +83,7 @@ err_host_notifiers:
     return ret;
 }
 
-static void vu_scmi_stop(VirtIODevice *vdev)
+static int vu_scmi_stop(VirtIODevice *vdev)
 {
     VHostUserSCMI *scmi = VHOST_USER_SCMI(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
@@ -93,41 +93,46 @@ static void vu_scmi_stop(VirtIODevice *vdev)
 
     /* vhost_dev_is_started() check in the callers is not fully reliable. */
     if (!scmi->started_vu) {
-        return;
+        return 0;
     }
     scmi->started_vu = false;
 
     if (!k->set_guest_notifiers) {
-        return;
+        return 0;
     }
 
-    vhost_dev_stop(vhost_dev, vdev, true);
+    ret = vhost_dev_stop(vhost_dev, vdev, true);
 
-    ret = k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false);
-    if (ret < 0) {
+    if (k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
-        return;
+        return -1;
     }
     vhost_dev_disable_notifiers(vhost_dev, vdev);
+    return ret;
 }
 
-static void vu_scmi_set_status(VirtIODevice *vdev, uint8_t status)
+static int vu_scmi_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserSCMI *scmi = VHOST_USER_SCMI(vdev);
     bool should_start = virtio_device_should_start(vdev, status);
 
     if (!scmi->connected) {
-        return;
+        return -1;
     }
     if (vhost_dev_is_started(&scmi->vhost_dev) == should_start) {
-        return;
+        return 0;
     }
 
     if (should_start) {
         vu_scmi_start(vdev);
     } else {
-        vu_scmi_stop(vdev);
+        int ret;
+        ret = vu_scmi_stop(vdev);
+        if (ret < 0) {
+            return ret;
+        }
     }
+    return 0;
 }
 
 static uint64_t vu_scmi_get_features(VirtIODevice *vdev, uint64_t features,
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 293273080b..7a4aec7bf4 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -54,23 +54,28 @@ const VhostDevConfigOps vsock_ops = {
     .vhost_dev_config_notifier = vuv_handle_config_change,
 };
 
-static void vuv_set_status(VirtIODevice *vdev, uint8_t status)
+static int vuv_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
     bool should_start = virtio_device_should_start(vdev, status);
+    int ret;
 
     if (vhost_dev_is_started(&vvc->vhost_dev) == should_start) {
-        return;
+        return 0;
     }
 
     if (should_start) {
-        int ret = vhost_vsock_common_start(vdev);
+        ret = vhost_vsock_common_start(vdev);
         if (ret < 0) {
-            return;
+            return ret;
         }
     } else {
-        vhost_vsock_common_stop(vdev);
+        ret = vhost_vsock_common_stop(vdev);
+        if (ret < 0) {
+            return ret;
+        }
     }
+    return 0;
 }
 
 static uint64_t vuv_get_features(VirtIODevice *vdev,
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index 9ac587d20c..bbfbbdb317 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -95,7 +95,7 @@ err_host_notifiers:
     return ret;
 }
 
-void vhost_vsock_common_stop(VirtIODevice *vdev)
+int vhost_vsock_common_stop(VirtIODevice *vdev)
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
@@ -103,18 +103,18 @@ void vhost_vsock_common_stop(VirtIODevice *vdev)
     int ret;
 
     if (!k->set_guest_notifiers) {
-        return;
+        return 0;
     }
 
-    vhost_dev_stop(&vvc->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&vvc->vhost_dev, vdev, true);
 
-    ret = k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, false);
-    if (ret < 0) {
+    if (k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
-        return;
+        return -1;
     }
 
     vhost_dev_disable_notifiers(&vvc->vhost_dev, vdev);
+    return ret;
 }
 
 
diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
index 940b30fa27..62b36b28f5 100644
--- a/hw/virtio/vhost-vsock.c
+++ b/hw/virtio/vhost-vsock.c
@@ -67,37 +67,38 @@ static int vhost_vsock_set_running(VirtIODevice *vdev, int start)
 }
 
 
-static void vhost_vsock_set_status(VirtIODevice *vdev, uint8_t status)
+static int vhost_vsock_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
     bool should_start = virtio_device_should_start(vdev, status);
     int ret;
 
     if (vhost_dev_is_started(&vvc->vhost_dev) == should_start) {
-        return;
+        return 0;
     }
 
     if (should_start) {
         ret = vhost_vsock_common_start(vdev);
         if (ret < 0) {
-            return;
+            return 0;
         }
 
         ret = vhost_vsock_set_running(vdev, 1);
         if (ret < 0) {
             vhost_vsock_common_stop(vdev);
             error_report("Error starting vhost vsock: %d", -ret);
-            return;
+            return 0;
         }
     } else {
         ret = vhost_vsock_set_running(vdev, 0);
         if (ret < 0) {
             error_report("vhost vsock set running failed: %d", ret);
-            return;
+            return 0;
         }
 
         vhost_vsock_common_stop(vdev);
     }
+    return 0;
 }
 
 static uint64_t vhost_vsock_get_features(VirtIODevice *vdev,
diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index 2eb5a14fa2..e719c078aa 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -958,7 +958,7 @@ static void virtio_balloon_device_reset(VirtIODevice *vdev)
     s->poison_val = 0;
 }
 
-static void virtio_balloon_set_status(VirtIODevice *vdev, uint8_t status)
+static int virtio_balloon_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VirtIOBalloon *s = VIRTIO_BALLOON(vdev);
 
@@ -988,6 +988,7 @@ static void virtio_balloon_set_status(VirtIODevice *vdev, uint8_t status)
             qemu_mutex_unlock(&s->free_page_lock);
         }
     }
+    return 0;
 }
 
 static ResettableState *virtio_balloon_get_reset_state(Object *obj)
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index a1b3c90618..626279dc5b 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -1197,11 +1197,12 @@ static void virtio_crypto_vhost_status(VirtIOCrypto *c, uint8_t status)
     }
 }
 
-static void virtio_crypto_set_status(VirtIODevice *vdev, uint8_t status)
+static int virtio_crypto_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VirtIOCrypto *vcrypto = VIRTIO_CRYPTO(vdev);
 
     virtio_crypto_vhost_status(vcrypto, status);
+    return 0;
 }
 
 static void virtio_crypto_guest_notifier_mask(VirtIODevice *vdev, int idx,
diff --git a/hw/virtio/virtio-iommu.c b/hw/virtio/virtio-iommu.c
index b6e7e01ef7..63ec12014f 100644
--- a/hw/virtio/virtio-iommu.c
+++ b/hw/virtio/virtio-iommu.c
@@ -1522,9 +1522,10 @@ static void virtio_iommu_device_reset_exit(Object *obj, ResetType type)
                                    NULL, NULL, virtio_iommu_put_endpoint);
 }
 
-static void virtio_iommu_set_status(VirtIODevice *vdev, uint8_t status)
+static int virtio_iommu_set_status(VirtIODevice *vdev, uint8_t status)
 {
     trace_virtio_iommu_device_status(status);
+    return 0;
 }
 
 static void virtio_iommu_instance_init(Object *obj)
diff --git a/hw/virtio/virtio-rng.c b/hw/virtio/virtio-rng.c
index a515fc5cd9..4748d039f9 100644
--- a/hw/virtio/virtio-rng.c
+++ b/hw/virtio/virtio-rng.c
@@ -159,17 +159,18 @@ static void check_rate_limit(void *opaque)
     vrng->activate_timer = true;
 }
 
-static void virtio_rng_set_status(VirtIODevice *vdev, uint8_t status)
+static int virtio_rng_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VirtIORNG *vrng = VIRTIO_RNG(vdev);
 
     if (!vdev->vm_running) {
-        return;
+        return 0;
     }
     vdev->status = status;
 
     /* Something changed, try to process buffers */
     virtio_rng_process(vrng);
+    return 0;
 }
 
 static void virtio_rng_device_realize(DeviceState *dev, Error **errp)
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 202a052053..8d292b45c5 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -2221,12 +2221,12 @@ int virtio_set_status(VirtIODevice *vdev, uint8_t val)
 {
     VirtioDeviceClass *k = VIRTIO_DEVICE_GET_CLASS(vdev);
     trace_virtio_set_status(vdev, val);
+    int ret = 0;
 
     if (virtio_vdev_has_feature(vdev, VIRTIO_F_VERSION_1)) {
         if (!(vdev->status & VIRTIO_CONFIG_S_FEATURES_OK) &&
             val & VIRTIO_CONFIG_S_FEATURES_OK) {
-            int ret = virtio_validate_features(vdev);
-
+            ret = virtio_validate_features(vdev);
             if (ret) {
                 return ret;
             }
@@ -2239,11 +2239,15 @@ int virtio_set_status(VirtIODevice *vdev, uint8_t val)
     }
 
     if (k->set_status) {
-        k->set_status(vdev, val);
+        ret = k->set_status(vdev, val);
+        if (ret) {
+            qemu_log("set %s status to %d failed, old status: %d\n",
+                     vdev->name, val, vdev->status);
+        }
     }
     vdev->status = val;
 
-    return 0;
+    return ret;
 }
 
 static enum virtio_device_endian virtio_default_endian(void)
@@ -3419,7 +3423,7 @@ void virtio_cleanup(VirtIODevice *vdev)
     qemu_del_vm_change_state_handler(vdev->vmstate);
 }
 
-static void virtio_vmstate_change(void *opaque, bool running, RunState state)
+static int virtio_vmstate_change(void *opaque, bool running, RunState state)
 {
     VirtIODevice *vdev = opaque;
     BusState *qbus = qdev_get_parent_bus(DEVICE(vdev));
@@ -3436,8 +3440,13 @@ static void virtio_vmstate_change(void *opaque, bool running, RunState state)
     }
 
     if (!backend_run) {
-        virtio_set_status(vdev, vdev->status);
+        // the return value was used for stopping VM during migration
+        int ret = virtio_set_status(vdev, vdev->status);
+        if (ret) {
+            return ret;
+        }
     }
+    return 0;
 }
 
 void virtio_instance_init_common(Object *proxy_obj, void *data,
@@ -3489,7 +3498,7 @@ void virtio_init(VirtIODevice *vdev, uint16_t device_id, size_t config_size)
         vdev->config = NULL;
     }
     vdev->vmstate = qdev_add_vm_change_state_handler(DEVICE(vdev),
-            virtio_vmstate_change, NULL, vdev);
+            NULL, virtio_vmstate_change, vdev);
     vdev->device_endian = virtio_default_endian();
     vdev->use_guest_notifier_mask = true;
 }
diff --git a/include/hw/virtio/vhost-scsi-common.h b/include/hw/virtio/vhost-scsi-common.h
index c5d2c09455..d54d9c916f 100644
--- a/include/hw/virtio/vhost-scsi-common.h
+++ b/include/hw/virtio/vhost-scsi-common.h
@@ -40,7 +40,7 @@ struct VHostSCSICommon {
 };
 
 int vhost_scsi_common_start(VHostSCSICommon *vsc, Error **errp);
-void vhost_scsi_common_stop(VHostSCSICommon *vsc);
+int vhost_scsi_common_stop(VHostSCSICommon *vsc);
 char *vhost_scsi_common_get_fw_dev_path(FWPathProvider *p, BusState *bus,
                                         DeviceState *dev);
 void vhost_scsi_common_set_config(VirtIODevice *vdev, const uint8_t *config);
diff --git a/include/hw/virtio/vhost-vsock-common.h b/include/hw/virtio/vhost-vsock-common.h
index 75a74e8a99..01bf6062af 100644
--- a/include/hw/virtio/vhost-vsock-common.h
+++ b/include/hw/virtio/vhost-vsock-common.h
@@ -42,7 +42,7 @@ struct VHostVSockCommon {
 };
 
 int vhost_vsock_common_start(VirtIODevice *vdev);
-void vhost_vsock_common_stop(VirtIODevice *vdev);
+int vhost_vsock_common_stop(VirtIODevice *vdev);
 int vhost_vsock_common_pre_save(void *opaque);
 int vhost_vsock_common_post_load(void *opaque, int version_id);
 void vhost_vsock_common_realize(VirtIODevice *vdev);
diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 6386910280..a7ee9bec75 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -186,7 +186,7 @@ struct VirtioDeviceClass {
     void (*get_config)(VirtIODevice *vdev, uint8_t *config);
     void (*set_config)(VirtIODevice *vdev, const uint8_t *config);
     void (*reset)(VirtIODevice *vdev);
-    void (*set_status)(VirtIODevice *vdev, uint8_t val);
+    int (*set_status)(VirtIODevice *vdev, uint8_t val);
     /* Device must validate queue_index.  */
     void (*queue_reset)(VirtIODevice *vdev, uint32_t queue_index);
     /* Device must validate queue_index.  */
diff --git a/include/system/vhost-user-backend.h b/include/system/vhost-user-backend.h
index 327b0b84f1..87765a1218 100644
--- a/include/system/vhost-user-backend.h
+++ b/include/system/vhost-user-backend.h
@@ -43,6 +43,6 @@ struct VhostUserBackend {
 int vhost_user_backend_dev_init(VhostUserBackend *b, VirtIODevice *vdev,
                                 unsigned nvqs, Error **errp);
 void vhost_user_backend_start(VhostUserBackend *b);
-void vhost_user_backend_stop(VhostUserBackend *b);
+int vhost_user_backend_stop(VhostUserBackend *b);
 
 #endif
-- 
2.44.0

