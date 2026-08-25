Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B2246C4D1
	for <virtio-fs@lists.linux.dev>; Tue, 25 Aug 2026 21:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787693926; cv=none; b=HjSTYehDyBEc4pL5DzSH2FYj5/+sH5nFeB5kzttvFdVF4LydSMuVrO7cn0oqRLZ3G4MmZSDEAeSi410h+aQHiWHYbs1FRVpUpjj1Rv2ScyRUQcXE088uUX455tBcKZN4YKFG/fRhwrRUtvyCKizctLGLgTVMKkzv4ZwBxVj55mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787693926; c=relaxed/simple;
	bh=EB01B1T1xAs7r91WIEw1MHXmkZj31u0Pru99F42mIJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ru/6vvpkMi3OfbyOgqN3a11PpAvLK6M1t93Fn7YrBZ2oH/7d/TMdmlOJkkeDIC+cxG88CvsRQU6EMzvSiMVdS0agysNXF/i8gCGP8lgQig2aq+SeEGr9KbhoeresOkBmxBb+AhK+v31EUm/gtq6KatatIG3xSWqGHEJzp90Lhso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=TBgShofE; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="TBgShofE"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:39a2:0:640:ae2d:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 25BE680873;
	Wed, 26 Aug 2026 00:38:37 +0300 (MSK)
Received: from i115954770.yandex-team.ru (unknown [2a02:6bf:8080:630::1:39])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp) with ESMTPSA id QckKa93ZVmI0-NWxBerbr;
	Wed, 26 Aug 2026 00:38:36 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1787693916;
	bh=3JreOw/yxjMpt9tVH1GrL9YNuns9LMVw6WHNE68YnwM=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=TBgShofEnzzg3Xzi0ABmZ60kGYKIOHelpjk5X+gyG60Nxw8vbzLqT+zbpPozWFzf3
	 aWTSwdyWsI99cjdWtMjL5p4Et+qPfNmHVdoqNbbYWt7PiBQY1uFaSI0ejlRmOZNsM5
	 KPosYAtrBIVCPeLcPDVIW1hwLkvNhPnKGEWhv8eM=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
To: peterx@redhat.com
Cc: farosas@suse.de,
	qemu-devel@nongnu.org,
	vsementsov@yandex-team.ru,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	virtio-fs@lists.linux.dev (open list:virtiofs)
Subject: [PATCH 06/30] hw/virtio: remaining: move to new migration APIs
Date: Wed, 26 Aug 2026 00:37:46 +0300
Message-ID: <20260825213811.3725682-7-vsementsov@yandex-team.ru>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260825213811.3725682-1-vsementsov@yandex-team.ru>
References: <20260825213811.3725682-1-vsementsov@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
---
 hw/virtio/vhost-user-fs.c |  68 +++++++++----------
 hw/virtio/virtio.c        | 133 +++++++++++++++++++-------------------
 2 files changed, 100 insertions(+), 101 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 209993918a3..215aff77282 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -307,49 +307,50 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
 /**
  * Fetch the internal state from virtiofsd and save it to `f`.
  */
-static int vuf_save_state(QEMUFile *f, void *pv, size_t size,
-                          const VMStateField *field, JSONWriter *vmdesc)
+static bool vuf_save_state(QEMUFile *f, void *pv, size_t size,
+                           const VMStateField *field, JSONWriter *vmdesc,
+                           Error **errp)
 {
+    ERRP_GUARD();
     VirtIODevice *vdev = pv;
     VHostUserFS *fs = VHOST_USER_FS(vdev);
-    Error *local_error = NULL;
     int ret;
 
-    ret = vhost_save_backend_state(&fs->vhost_dev, f, &local_error);
+    ret = vhost_save_backend_state(&fs->vhost_dev, f, errp);
     if (ret < 0) {
-        error_reportf_err(local_error,
-                          "Error saving back-end state of %s device %s "
-                          "(tag: \"%s\"): ",
-                          vdev->name, vdev->parent_obj.canonical_path,
-                          fs->conf.tag ?: "<none>");
-        return ret;
+        error_prepend(errp,
+                      "Error saving back-end state of %s device %s "
+                      "(tag: \"%s\"): ",
+                      vdev->name, vdev->parent_obj.canonical_path,
+                      fs->conf.tag ?: "<none>");
+        return false;
     }
 
-    return 0;
+    return true;
 }
 
 /**
  * Load virtiofsd's internal state from `f` and send it over to virtiofsd.
  */
-static int vuf_load_state(QEMUFile *f, void *pv, size_t size,
-                          const VMStateField *field)
+static bool vuf_load_state(QEMUFile *f, void *pv, size_t size,
+                           const VMStateField *field, Error **errp)
 {
+    ERRP_GUARD();
     VirtIODevice *vdev = pv;
     VHostUserFS *fs = VHOST_USER_FS(vdev);
-    Error *local_error = NULL;
     int ret;
 
-    ret = vhost_load_backend_state(&fs->vhost_dev, f, &local_error);
+    ret = vhost_load_backend_state(&fs->vhost_dev, f, errp);
     if (ret < 0) {
-        error_reportf_err(local_error,
-                          "Error loading back-end state of %s device %s "
-                          "(tag: \"%s\"): ",
-                          vdev->name, vdev->parent_obj.canonical_path,
-                          fs->conf.tag ?: "<none>");
-        return ret;
+        error_prepend(errp,
+                      "Error loading back-end state of %s device %s "
+                      "(tag: \"%s\"): ",
+                      vdev->name, vdev->parent_obj.canonical_path,
+                      fs->conf.tag ?: "<none>");
+        return false;
     }
 
-    return 0;
+    return true;
 }
 
 static bool vuf_is_internal_migration(void *opaque)
@@ -358,20 +359,21 @@ static bool vuf_is_internal_migration(void *opaque)
     return true;
 }
 
-static int vuf_check_migration_support(void *opaque)
+static bool vuf_check_migration_support(void *opaque, Error **errp)
 {
     VirtIODevice *vdev = opaque;
     VHostUserFS *fs = VHOST_USER_FS(vdev);
 
     if (!vhost_supports_device_state(&fs->vhost_dev)) {
-        error_report("Back-end of %s device %s (tag: \"%s\") does not support "
-                     "migration through qemu",
-                     vdev->name, vdev->parent_obj.canonical_path,
-                     fs->conf.tag ?: "<none>");
-        return -ENOTSUP;
+        error_setg(errp,
+                   "Back-end of %s device %s (tag: \"%s\") does not support "
+                   "migration through qemu",
+                   vdev->name, vdev->parent_obj.canonical_path,
+                   fs->conf.tag ?: "<none>");
+        return false;
     }
 
-    return 0;
+    return true;
 }
 
 static const VMStateDescription vuf_backend_vmstate;
@@ -393,15 +395,15 @@ static const VMStateDescription vuf_backend_vmstate = {
     .name = "vhost-user-fs-backend",
     .version_id = 0,
     .needed = vuf_is_internal_migration,
-    .pre_load = vuf_check_migration_support,
-    .pre_save = vuf_check_migration_support,
+    .pre_load_errp = vuf_check_migration_support,
+    .pre_save_errp = vuf_check_migration_support,
     .fields = (const VMStateField[]) {
         {
             .name = "back-end",
             .info = &(const VMStateInfo) {
                 .name = "virtio-fs back-end state",
-                .get = vuf_load_state,
-                .put = vuf_save_state,
+                .load = vuf_load_state,
+                .save = vuf_save_state,
             },
         },
         VMSTATE_END_OF_LIST()
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index a9338af6d00..0b1ec41ac97 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -62,8 +62,8 @@
  */
 #define VIRTIO_PCI_VRING_ALIGN         4096
 
-static int coroutine_mixed_fn
-virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id);
+static bool coroutine_mixed_fn
+virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id, Error **errp);
 
 typedef struct VRingDesc
 {
@@ -3070,19 +3070,17 @@ static const VMStateDescription vmstate_virtio = {
     }
 };
 
-static int virtio_save(VirtIODevice *vdev, QEMUFile *f)
+static bool virtio_save(VirtIODevice *vdev, QEMUFile *f, Error **errp)
 {
     BusState *qbus = qdev_get_parent_bus(DEVICE(vdev));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
     VirtioDeviceClass *vdc = VIRTIO_DEVICE_GET_CLASS(vdev);
     uint32_t guest_features_lo = (vdev->guest_features & 0xffffffff);
-    int i, ret;
-    Error *local_err = NULL;
+    int i;
 
     if (k->save_config) {
-        if (!k->save_config(qbus->parent, f, &local_err)) {
-            error_report_err(local_err);
-            return -EINVAL;
+        if (!k->save_config(qbus->parent, f, errp)) {
+            return false;
         }
     }
 
@@ -3124,19 +3122,13 @@ static int virtio_save(VirtIODevice *vdev, QEMUFile *f)
     }
 
     if (vdc->vmsd) {
-        ret = vmstate_save_state(f, vdc->vmsd, vdev, NULL, &local_err);
-        if (ret) {
-            error_report_err(local_err);
-            return ret;
+        if (!vmstate_save_vmsd(f, vdc->vmsd, vdev, NULL, errp)) {
+            return false;
         }
     }
 
     /* Subsections */
-    ret = vmstate_save_state(f, &vmstate_virtio, vdev, NULL, &local_err);
-    if (ret < 0) {
-        error_report_err(local_err);
-    }
-    return ret;
+    return vmstate_save_vmsd(f, &vmstate_virtio, vdev, NULL, errp);
 }
 
 VirtioSharedMemory *virtio_new_shmem_region(VirtIODevice *vdev, uint8_t shmid, uint64_t size)
@@ -3307,27 +3299,28 @@ void virtio_del_shmem_map(VirtioSharedMemory *shmem, hwaddr offset,
 }
 
 /* A wrapper for use as a VMState .put function */
-static int virtio_device_put(QEMUFile *f, void *opaque, size_t size,
-                              const VMStateField *field, JSONWriter *vmdesc)
+static bool virtio_device_save(QEMUFile *f, void *opaque, size_t size,
+                               const VMStateField *field, JSONWriter *vmdesc,
+                               Error **errp)
 {
-    return virtio_save(VIRTIO_DEVICE(opaque), f);
+    return virtio_save(VIRTIO_DEVICE(opaque), f, errp);
 }
 
 /* A wrapper for use as a VMState .get function */
-static int coroutine_mixed_fn
-virtio_device_get(QEMUFile *f, void *opaque, size_t size,
-                  const VMStateField *field)
+static bool coroutine_mixed_fn
+virtio_device_load(QEMUFile *f, void *opaque, size_t size,
+                   const VMStateField *field, Error **errp)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(opaque);
     DeviceClass *dc = DEVICE_CLASS(VIRTIO_DEVICE_GET_CLASS(vdev));
 
-    return virtio_load(vdev, f, dc->vmsd->version_id);
+    return virtio_load(vdev, f, dc->vmsd->version_id, errp);
 }
 
 const VMStateInfo  virtio_vmstate_info = {
     .name = "virtio",
-    .get = virtio_device_get,
-    .put = virtio_device_put,
+    .load = virtio_device_load,
+    .save = virtio_device_save,
 };
 
 static int virtio_set_features_nocheck(VirtIODevice *vdev, const uint64_t *val)
@@ -3513,8 +3506,8 @@ size_t virtio_get_config_size(const VirtIOConfigSizeParams *params,
     return config_size;
 }
 
-static int coroutine_mixed_fn
-virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
+static bool coroutine_mixed_fn
+virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id, Error **errp)
 {
     int i, ret;
     uint32_t config_len;
@@ -3523,7 +3516,6 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
     BusState *qbus = qdev_get_parent_bus(DEVICE(vdev));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
     VirtioDeviceClass *vdc = VIRTIO_DEVICE_GET_CLASS(vdev);
-    Error *local_err = NULL;
 
     /*
      * We poison the endianness to ensure it does not get used before
@@ -3532,8 +3524,8 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
     vdev->device_endian = VIRTIO_DEVICE_ENDIAN_UNKNOWN;
 
     if (k->load_config) {
-        if (!k->load_config(qbus->parent, f, &local_err)) {
-            return -EINVAL;
+        if (!k->load_config(qbus->parent, f, errp)) {
+            return false;
         }
     }
 
@@ -3541,7 +3533,9 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
     qemu_get_8s(f, &vdev->isr);
     qemu_get_be16s(f, &vdev->queue_sel);
     if (vdev->queue_sel >= VIRTIO_QUEUE_MAX) {
-        return -1;
+        error_setg(errp, "virtio_load: queue_sel %u out of range",
+                   vdev->queue_sel);
+        return false;
     }
     qemu_get_be32s(f, &features);
 
@@ -3566,7 +3560,9 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
 
     while (config_len > vdev->config_len) {
         if (qemu_file_get_error(f)) {
-            return -1;
+            error_setg(errp, "virtio_load: stream error while skipping "
+                       "excess config");
+            return false;
         }
         qemu_get_byte(f);
         config_len--;
@@ -3575,24 +3571,25 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
     num = qemu_get_be32(f);
 
     if (num > VIRTIO_QUEUE_MAX) {
-        error_report("Invalid number of virtqueues: 0x%x", num);
-        return -1;
+        error_setg(errp, "Invalid number of virtqueues: 0x%x", num);
+        return false;
     }
 
     if (vdc->pre_load_queues) {
         ret = vdc->pre_load_queues(vdev, num);
         if (ret) {
-            return ret;
+            error_setg(errp, "virtio_load: pre_load_queues failed");
+            return false;
         }
     }
 
     for (i = 0; i < num; i++) {
         vdev->vq[i].vring.num = qemu_get_be32(f);
         if (vdev->vq[i].vring.num > vdev->vq[i].vring.num_default) {
-            error_report("VQ %d vring.num %u exceeds allocated max %u",
-                         i, vdev->vq[i].vring.num,
-                         vdev->vq[i].vring.num_default);
-            return -1;
+            error_setg(errp, "VQ %d vring.num %u exceeds allocated max %u",
+                       i, vdev->vq[i].vring.num,
+                       vdev->vq[i].vring.num_default);
+            return false;
         }
         if (k->has_variable_vring_alignment) {
             vdev->vq[i].vring.align = qemu_get_be32(f);
@@ -3603,15 +3600,17 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
         vdev->vq[i].notification = true;
 
         if (!vdev->vq[i].vring.desc && vdev->vq[i].last_avail_idx) {
-            error_report("VQ %d address 0x0 "
-                         "inconsistent with Host index 0x%x",
-                         i, vdev->vq[i].last_avail_idx);
-            return -1;
+            error_setg(errp, "VQ %d address 0x0 "
+                       "inconsistent with Host index 0x%x",
+                       i, vdev->vq[i].last_avail_idx);
+            return false;
         }
         if (k->load_queue) {
             ret = k->load_queue(qbus->parent, i, f);
-            if (ret)
-                return ret;
+            if (ret) {
+                error_setg(errp, "virtio_load: load_queue failed for vq %d", i);
+                return false;
+            }
         }
     }
 
@@ -3620,23 +3619,20 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
     if (vdc->load != NULL) {
         ret = vdc->load(vdev, f, version_id);
         if (ret) {
-            return ret;
+            error_setg(errp, "virtio_load: device load failed");
+            return false;
         }
     }
 
     if (vdc->vmsd) {
-        ret = vmstate_load_state(f, vdc->vmsd, vdev, version_id, &local_err);
-        if (ret) {
-            error_report_err(local_err);
-            return ret;
+        if (!vmstate_load_vmsd(f, vdc->vmsd, vdev, version_id, errp)) {
+            return false;
         }
     }
 
     /* Subsections */
-    ret = vmstate_load_state(f, &vmstate_virtio, vdev, 1, &local_err);
-    if (ret) {
-        error_report_err(local_err);
-        return ret;
+    if (!vmstate_load_vmsd(f, &vmstate_virtio, vdev, 1, errp)) {
+        return false;
     }
 
     if (vdev->device_endian == VIRTIO_DEVICE_ENDIAN_UNKNOWN) {
@@ -3649,11 +3645,11 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
      */
     if (virtio_set_features_nocheck_maybe_co(vdev,
                                              vdev->guest_features_ex) < 0) {
-        error_report("Features 0x" VIRTIO_FEATURES_FMT " unsupported. "
-                     "Allowed features: 0x" VIRTIO_FEATURES_FMT,
-                     VIRTIO_FEATURES_PR(vdev->guest_features_ex),
-                     VIRTIO_FEATURES_PR(vdev->host_features_ex));
-        return -1;
+        error_setg(errp, "Features 0x" VIRTIO_FEATURES_FMT " unsupported. "
+                   "Allowed features: 0x" VIRTIO_FEATURES_FMT,
+                   VIRTIO_FEATURES_PR(vdev->guest_features_ex),
+                   VIRTIO_FEATURES_PR(vdev->host_features_ex));
+        return false;
     }
 
     if (!virtio_device_started(vdev, vdev->status) &&
@@ -3710,12 +3706,12 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
             vdev->vq[i].inuse = (uint16_t)(vdev->vq[i].last_avail_idx -
                                 vdev->vq[i].used_idx);
             if (vdev->vq[i].inuse > vdev->vq[i].vring.num) {
-                error_report("VQ %d size 0x%x < last_avail_idx 0x%x - "
-                             "used_idx 0x%x",
-                             i, vdev->vq[i].vring.num,
-                             vdev->vq[i].last_avail_idx,
-                             vdev->vq[i].used_idx);
-                return -1;
+                error_setg(errp, "VQ %d size 0x%x < last_avail_idx 0x%x - "
+                           "used_idx 0x%x",
+                           i, vdev->vq[i].vring.num,
+                           vdev->vq[i].last_avail_idx,
+                           vdev->vq[i].used_idx);
+                return false;
             }
         }
     }
@@ -3723,11 +3719,12 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
     if (vdc->post_load) {
         ret = vdc->post_load(vdev);
         if (ret) {
-            return ret;
+            error_setg(errp, "virtio_load: post_load failed");
+            return false;
         }
     }
 
-    return 0;
+    return true;
 }
 
 void virtio_cleanup(VirtIODevice *vdev)
-- 
2.43.0

