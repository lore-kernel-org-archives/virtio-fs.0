Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF851280325
	for <virtio-fs@lists.linux.dev>; Sun, 14 Jun 2026 19:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781464128; cv=none; b=IyLEA4BlRfO6fg6OHWtJtzEhoh0LAeD0SBhTRMsWH23ELfpic9Io5BKJ6f6sHg/IMpCnE+c47j4ytJFm6dihnCoDLKt0OIItcZ3nN9sUkWWJICW+HAWzBjCi3T+GSD3HpmgAiKORW2eXCWIKn0ZMBduK15eEH3eJS/QMCdXhdSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781464128; c=relaxed/simple;
	bh=pDPxoYBOn2PWI8j6wiNisSQBE+Qchz/+jscm86nCwsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VtHniBDBOJuHYgLT4kA0nc39VJsKpQEg4Tz9Pc1bDfWEvjUhAanJV4Du4pRZ+kle4XqLN59y0Gqi0GzVKg1W/qTWBhJ1fLUKpf82f2IkOoUYkUZHueP/N10SDLBnTzwkw6ZikKpbcBZgpRHGoa2980Rz2fw11EE56suwr5qA3RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dl66ma25; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dl66ma25"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781464125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sh5em8AlVrr5g6Oxe+hgEPBbAlPW7zFJt8787kbMrrY=;
	b=dl66ma256pf7frH44ei+YqmWQjK/+P50nUAtjQT5hAvrl7At9isHC6sd2aWsF8wp/c15QC
	B4zgwDtiC3et55J6R0PiuF24mA9Oj4RmfuHEJs0WLXZpTcfgTRiBaoNKT3Zjs1b0Qjrz3u
	XU3JEUhnl4ZrrIuML329/Xa7AEiCBKY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-GBa2QvNbN7aHq4gNJghAIw-1; Sun, 14 Jun 2026 15:08:44 -0400
X-MC-Unique: GBa2QvNbN7aHq4gNJghAIw-1
X-Mimecast-MFC-AGG-ID: GBa2QvNbN7aHq4gNJghAIw_1781464123
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45ef6b407b4so1215339f8f.1
        for <virtio-fs@lists.linux.dev>; Sun, 14 Jun 2026 12:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781464123; x=1782068923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sh5em8AlVrr5g6Oxe+hgEPBbAlPW7zFJt8787kbMrrY=;
        b=V9eeTVJV90nlogO3+Cg5SpZejS7akryrSZl9OauPXQNl8PdEI0c8IGBdyKhSWU8N/F
         rT2MINrFdSny38WxxQNz4830papf6D6aJvlWh9w4aQ9/VuHmg/4kaRiESXZiD/ISw39m
         kWfwZjN/PnLPKv9bobSxYR0dK8FbheW7cns5ZzMUXeplB9Y8Njy0NvD5Q331kv7et30F
         Ulg1zWoSD1v61HlgTC2aQLZd/3XShfi/zisUerbFc0PQcJ1R8E19szNQVB+2zc4s5Q/q
         QRpCXbPMjkHzyGKzX0uyZhLtQUWyXYbhSIcXGbxKqgJL+QIq47bvLEzZCP7dv/Tou9dK
         LHLA==
X-Forwarded-Encrypted: i=1; AFNElJ8EHtrNJyzMxQhr5rlvtt4nx+c99jhzM89jdHVxotcwQ+wZsirdn1KNdEzYoCobSyhBwrInScYu8KY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxq87Y5YeQMVz0I+aGoZmtekxVs7GQhe0TysPcqUoY6qn7yCMkZ
	xVIdPtJjndqPwH2PXOxNJ1U8zQbJfPV11z+WaF69qOR1p25N5E5RnFPnabh5wsYf5mQy6O2sS9H
	9QmIH745tl9i9YIESWSh6U8nNmQ4ai7E/3XDd+YUHpal+0RHFoTekqLZIldRY1g==
X-Gm-Gg: Acq92OHFlsGZqViBQ8Sq3os3guhfVz1/OB7FOAwEuUYN2BKnK0efBFYMN00JdxXOrUL
	R834Ug/LmzAKtUNRYPQlHBGyr3hiAhtlCIUBPEZ8h4aY0dXI6+Pg5uuVM33UbpocLNU/1b+Gt4L
	d9G7mA9YIrClCQuEkPDQ9UeUvoPR/SMPWqggdhsBxEVay9qRR1PLV88s7jg8MIFWBa5OT8x3Q4/
	6AWv0QmO1UGphQLbA2e4c+BQEil6yZv3V2yp9xphxj+ZfJhW646eNEQ/F4a/R9lhmIf2NyYgaRG
	2mXwkorSezfH9E1tLuo1M6F6UTF86oexmk+mXi0FEhMrN3WIrUAWaFHs3mF1RCiHrdwEPupr/4p
	qD+xgonAtXi8wSPmcDgPO5hUy1jNAOZHWetfiCDWnEwY=
X-Received: by 2002:a05:600c:3548:b0:490:ea8a:32d0 with SMTP id 5b1f17b1804b1-490ec501917mr155241075e9.20.1781464122924;
        Sun, 14 Jun 2026 12:08:42 -0700 (PDT)
X-Received: by 2002:a05:600c:3548:b0:490:ea8a:32d0 with SMTP id 5b1f17b1804b1-490ec501917mr155240785e9.20.1781464122343;
        Sun, 14 Jun 2026 12:08:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922037ba81sm178130015e9.15.2026.06.14.12.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 12:08:41 -0700 (PDT)
Date: Sun, 14 Jun 2026 15:08:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>, qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev
Subject: [PULL 069/106] vhost-user: Fix stale error logs and return values in
 teardown paths
Message-ID: <eef8552c474f9ed3a82cf37cf2c5b227521a5f4b.1781463125.git.mst@redhat.com>
References: <cover.1781463125.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cover.1781463125.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X3VFcCd1mSawHxa_hIJX7ERIYKyR1jJuRKHhYrx7J78_1781464123
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Kuan-Wei Chiu <visitorckw@gmail.com>

Commit bc85aae42045 ("vhost-user: return failure if backend crash when
live migration") refactored the set_guest_notifiers error handling but
introduced two regressions across multiple vhost devices.

By moving the function call directly into the if condition, the
subsequent error_report prints the stale ret variable instead of the
actual error code. Additionally, the refactoring hardcoded a return
value of -1 rather than propagating the true error status to the
caller.

Fix these issues by storing the set_guest_notifiers result in a local
err variable.

Fixes: bc85aae42045 ("vhost-user: return failure if backend crash when live migration")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260315231047.310029-1-visitorckw@gmail.com>
---
 backends/vhost-user.c          | 8 ++++----
 hw/block/vhost-user-blk.c      | 9 +++++----
 hw/scsi/vhost-scsi-common.c    | 2 +-
 hw/virtio/vhost-user-base.c    | 9 +++++----
 hw/virtio/vhost-user-fs.c      | 9 +++++----
 hw/virtio/vhost-user-scmi.c    | 9 +++++----
 hw/virtio/vhost-vsock-common.c | 9 +++++----
 7 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/backends/vhost-user.c b/backends/vhost-user.c
index 42845329e7..380d825023 100644
--- a/backends/vhost-user.c
+++ b/backends/vhost-user.c
@@ -102,7 +102,7 @@ vhost_user_backend_stop(VhostUserBackend *b)
 {
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(b->vdev)));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    int ret;
+    int ret, err;
 
     if (!b->started) {
         return 0;
@@ -111,9 +111,9 @@ vhost_user_backend_stop(VhostUserBackend *b)
     ret = vhost_dev_stop(&b->dev, b->vdev, true);
 
     if (k->set_guest_notifiers &&
-        k->set_guest_notifiers(qbus->parent, b->dev.nvqs, false) < 0) {
-        error_report("vhost guest notifier cleanup failed: %d", ret);
-        return -1;
+        (err = k->set_guest_notifiers(qbus->parent, b->dev.nvqs, false)) < 0) {
+        error_report("vhost guest notifier cleanup failed: %d", err);
+        return err;
     }
 
     vhost_dev_disable_notifiers(&b->dev, b->vdev);
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 5c73a58ee0..b2e46eb3f9 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -214,7 +214,7 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
     VHostUserBlk *s = VHOST_USER_BLK(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    int ret;
+    int ret, err;
     bool force_stop = false;
 
     trace_vhost_user_blk_stop_in(vdev);
@@ -234,9 +234,10 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
     ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
                        vhost_dev_stop(&s->dev, vdev, true);
 
-    if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false) < 0) {
-        error_report("vhost guest notifier cleanup failed: %d", ret);
-        return -1;
+    err = k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
+    if (err < 0) {
+        error_report("vhost guest notifier cleanup failed: %d", err);
+        return err;
     }
 
     vhost_dev_disable_notifiers(&s->dev, vdev);
diff --git a/hw/scsi/vhost-scsi-common.c b/hw/scsi/vhost-scsi-common.c
index 0bb4305de6..e19800a0bc 100644
--- a/hw/scsi/vhost-scsi-common.c
+++ b/hw/scsi/vhost-scsi-common.c
@@ -113,7 +113,7 @@ int vhost_scsi_common_stop(VHostSCSICommon *vsc)
     if (k->set_guest_notifiers) {
         int r = k->set_guest_notifiers(qbus->parent, vsc->dev.nvqs, false);
         if (r < 0) {
-            error_report("vhost guest notifier cleanup failed: %d", ret);
+            error_report("vhost guest notifier cleanup failed: %d", r);
             return r;
         }
     }
diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
index 5bbf4a7367..8b62c6c36e 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -71,7 +71,7 @@ static int vub_stop(VirtIODevice *vdev)
     VHostUserBase *vub = VHOST_USER_BASE(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    int ret;
+    int ret, err;
 
     if (!k->set_guest_notifiers) {
         return 0;
@@ -79,9 +79,10 @@ static int vub_stop(VirtIODevice *vdev)
 
     ret = vhost_dev_stop(&vub->vhost_dev, vdev, true);
 
-    if (k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false) < 0) {
-        error_report("vhost guest notifier cleanup failed: %d", ret);
-        return -1;
+    err = k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false);
+    if (err < 0) {
+        error_report("vhost guest notifier cleanup failed: %d", err);
+        return err;
     }
 
     vhost_dev_disable_notifiers(&vub->vhost_dev, vdev);
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index ad6fcacf06..209993918a 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -105,7 +105,7 @@ static int vuf_stop(VirtIODevice *vdev)
     VHostUserFS *fs = VHOST_USER_FS(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    int ret;
+    int ret, err;
 
     if (!k->set_guest_notifiers) {
         return 0;
@@ -113,9 +113,10 @@ static int vuf_stop(VirtIODevice *vdev)
 
     ret = vhost_dev_stop(&fs->vhost_dev, vdev, true);
 
-    if (k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false) < 0) {
-        error_report("vhost guest notifier cleanup failed: %d", ret);
-        return -1;
+    err = k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false);
+    if (err < 0) {
+        error_report("vhost guest notifier cleanup failed: %d", err);
+        return err;
     }
 
     vhost_dev_disable_notifiers(&fs->vhost_dev, vdev);
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index f9264c4374..9470f68c1f 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -89,7 +89,7 @@ static int vu_scmi_stop(VirtIODevice *vdev)
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
     struct vhost_dev *vhost_dev = &scmi->vhost_dev;
-    int ret;
+    int ret, err;
 
     /* vhost_dev_is_started() check in the callers is not fully reliable. */
     if (!scmi->started_vu) {
@@ -103,9 +103,10 @@ static int vu_scmi_stop(VirtIODevice *vdev)
 
     ret = vhost_dev_stop(vhost_dev, vdev, true);
 
-    if (k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false) < 0) {
-        error_report("vhost guest notifier cleanup failed: %d", ret);
-        return -1;
+    err = k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false);
+    if (err < 0) {
+        error_report("vhost guest notifier cleanup failed: %d", err);
+        return err;
     }
     vhost_dev_disable_notifiers(vhost_dev, vdev);
     return ret;
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index b33def900a..b79f4c9ce6 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -100,7 +100,7 @@ int vhost_vsock_common_stop(VirtIODevice *vdev)
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    int ret;
+    int ret, err;
 
     if (!k->set_guest_notifiers) {
         return 0;
@@ -108,9 +108,10 @@ int vhost_vsock_common_stop(VirtIODevice *vdev)
 
     ret = vhost_dev_stop(&vvc->vhost_dev, vdev, true);
 
-    if (k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, false) < 0) {
-        error_report("vhost guest notifier cleanup failed: %d", ret);
-        return -1;
+    err = k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, false);
+    if (err < 0) {
+        error_report("vhost guest notifier cleanup failed: %d", err);
+        return err;
     }
 
     vhost_dev_disable_notifiers(&vvc->vhost_dev, vdev);
-- 
MST

