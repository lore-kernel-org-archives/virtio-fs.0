Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F278E2874FF
	for <virtio-fs@lists.linux.dev>; Sun, 15 Mar 2026 23:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773616264; cv=none; b=mR5rKciVeZPz0Yj7g9he/64GelCBT3ZpVrJBq1FZKFGgGKBHyE+5/wICtmjCagn4PxIa5c0qtwMNeJpJ91k9lLy+dp3zX68ehVqV89gzl3K8DWXWTblkiLRBaHlgwh0SsG7NK62/rtvU3oHlhEH/TnkJSItjB5i2T1MujaCIkf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773616264; c=relaxed/simple;
	bh=6WbxZpIvfF1aXQG8lWwY0lcJIaf/hFJxLCPg83+b2qY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kDguMe0mRHsSN0UjDHEaBKfp+NfqZ35cWdMMBSN6160tdqYEUIQPV1KzMzD1agtHSpsfIxgkI1AXUBtw8Xr58eJfSD7nn7giyypbRgzCJLops1OMpZRtgunFxJDFEKh4nJPY7DtlUfqNBASqZouiPeTRxRxBc+ZEiTvteTHIJTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gA14YC0s; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gA14YC0s"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b04075d1e5so6590015ad.0
        for <virtio-fs@lists.linux.dev>; Sun, 15 Mar 2026 16:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773616262; x=1774221062; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BK3QiOXkHy9DVmr/GmN/dXj8oowzRtyTvOsgATq+HoQ=;
        b=gA14YC0sHLxbdQh7HVqVLV/DhbjIaVCbg2Rp6lhc/yqmbIOG18zzpJMf5WcZAVvSxh
         Y4m7nRb0k88sJgGRs3aIX22ni/cxDem2YNpXvNHtkm4AiRf3zN1wrI0P7U4palEmMX64
         Clg3dvmvaHukVEeIny63BDZuUACPbXehUoM1TXBtqnhBjCWsXJIaAY8ZY5vyUDCWfOgF
         3iL4jXVV8ap9VqNQW0ZVz+ytOX5HoTPVKW8jUWBjtXPWUTpoCAJoHgeelSJgZC1MgOh+
         CTUVdz2B0ki+DMVzTeNrvM/xPJAF4E1EOEKl7JUtUBqaIrmi3gykfEths+J3VanaPj5i
         YBSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773616262; x=1774221062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BK3QiOXkHy9DVmr/GmN/dXj8oowzRtyTvOsgATq+HoQ=;
        b=cDDieD+//ailMuvqTweaYU9EbKcafsdfsAfwxyBIXK4GVgt5lbu0J1wbH9fA7bnPK+
         t4v1WL/QzdbOYluVn6MYP27ZCYAg5lo5goI+c+ac5KHfm1bTKBMAlTWICmi+S7C6Hr73
         WfAbN+wmcFfwi8huv5N+gbUYQCa7BmFzqWhMFiNFUqUf1Q9/HIup5THjP41LwEMe4xvm
         eA856339012m8AHGstyWFh9jNhAmVoUvbfYSP6JQ+qN0eoQ21TtQBfED6ArGH3rOLsEp
         km3QZrHZ35ePY9zxFTkuLHeG2/pvNMuVrU394WOrMMTFylGhLxISF6fIhiuqK/g0y19c
         yOjA==
X-Forwarded-Encrypted: i=1; AJvYcCUf6oETpzH9bh5/p3mxiAHuIiJZELntjFn/KvQZGHtyNQ1Qd0osoIdHjlN6yWLSGQ251zpmFCbC2S4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFuT6fEgHuaLYtUhGttsZbg1TWrGD0cj/Y+4qJC6x4cyS28rQH
	q8rwmnqS10mRfHLJoDiWKaTymn5bTgGgxY0ArYJ6eCgUo+N504wWN8pg
X-Gm-Gg: ATEYQzz6kHp0FBGDB3AF8NYAtXSL1sIYVqZbI+fn0vAaPyabl5XLu46i1uqs6miQ4wI
	8xek2yOAm4xXsK0tD5L+faVfTHXnUgIeW+i9WOJdkPTbjuaa5N0rTyB8qJP70f6u9mvkNrhlW/7
	1zJRp3flsDnGVGVN2yKXB3Ew5dfRfZoF+b5LKQXF03Vi9I0OCgb5F4Q1ebzzDWEdllO5Y+zWYKn
	rA5JPklOvCMdRXY0+CQgmSM7PucqkHkMgJWCPGTQq+ffRarEqaygWzpOxPxh/bnpOCQ72ts+geh
	B5BC2DiRpSxQXE12a1heU+1JtJ6gMFmbTO4ZgVI5mLhY6bEtGMN7a5mpiwgFaC/lsXi6B8qBhxT
	XGDjdc0we1HneBxx6jQEDB7P22Fhn/zSffPHhz3BAgQAjU8CTfdelbohTx93Tq7QnrB0l5PK3D4
	i2a/A15F+WIlrQf0V744BqPUxjzWIXnedZ5U2EJ5CDT+XPAAI/t5XKVNq1orM/WZO8/fk4wnkH2
	jaMCQJeI0drc/UHu1Ki9k3zei3d4ErDP2w/
X-Received: by 2002:a17:902:f647:b0:2b0:5738:9817 with SMTP id d9443c01a7336-2b057389adamr14494125ad.31.1773616262291;
        Sun, 15 Mar 2026 16:11:02 -0700 (PDT)
Received: from visitorckw-work01.c.googlers.com.com (7.162.199.104.bc.googleusercontent.com. [104.199.162.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ee9f2sm87593565ad.56.2026.03.15.16.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 16:11:01 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: mst@redhat.com,
	sgarzare@redhat.com,
	rnorwitz@nvidia.com,
	kwolf@redhat.com,
	hreitz@redhat.com,
	pbonzini@redhat.com,
	fam@euphon.net,
	alex.bennee@linaro.org,
	stefanha@redhat.com,
	mzamazal@redhat.com
Cc: jserv@ccns.ncku.edu.tw,
	eleanor15x@gmail.com,
	qemu-devel@nongnu.org,
	qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH] vhost-user: Fix stale error logs and return values in teardown paths
Date: Sun, 15 Mar 2026 23:10:47 +0000
Message-ID: <20260315231047.310029-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index c151e83677..841fda273a 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -209,7 +209,7 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
     VHostUserBlk *s = VHOST_USER_BLK(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
-    int ret;
+    int ret, err;
     bool force_stop = false;
 
     if (!s->started_vu) {
@@ -227,9 +227,10 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
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
index 01ab9ca56b..1d9e99b824 100644
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
2.53.0.851.ga537e3e6e9-goog

