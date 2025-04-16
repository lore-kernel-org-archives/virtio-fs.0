Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1C1161302
	for <virtio-fs@lists.linux.dev>; Wed, 16 Apr 2025 02:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744771667; cv=none; b=uNg2EsBU10XIh0eurXsaUtANqq3cV1CzqB5117D3wXjoJr/RRvlid+0CE/Zs7cCer3OEKRVMmU4E+QKoMuxvf2yPzxhCdpOOn8bY5b/tY8aaxE0/kGtqjYiP91PvDAwX4uZE6RBj3g/3/EskqwqTMNDnxIp3ObcMdLUIf74HgFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744771667; c=relaxed/simple;
	bh=b5Iou63s079CIVtwWRPQjjXPx9cAv+qRj+u6W8RVC6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1Gpi94J6DStjX4S7lt+GO0UhQ56y4tmL4mov17DyXxNMRV9nVH3fPmcwQDwyjEot0/yHPu2DjwKAnb+y1kZtKmUHclPqcEII9r6wVdYYX4muqFKmUypF5vf6WZmiquHEIu0yuN0ik5GC+zpFQZ6M2sucuN3UED+ZbalhhKCVpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=F087X7Yr; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="F087X7Yr"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-73bf1cef6ceso2983979b3a.0
        for <virtio-fs@lists.linux.dev>; Tue, 15 Apr 2025 19:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1744771664; x=1745376464; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+67DiggxgIdjM5tawOq0HI43N1ZmR5vY23znSpxIlc=;
        b=F087X7Yr/WiEgyGoE/vs1oY0ME7vuRxrD85vB5m5cM2MdA/sVAMdjWqcESByRetL3y
         6u9iwYwh0o4lIogY8pqaUTJG5Al63H1xYo3BaQl44IWQMzHsX8HXJLQaDQ4HjqxT62zP
         hkZmNTY7HdeyZ96lExU9kb80rjR6ZIA0NUIHlWGm/EDdrweM/EU6zJtcHE1Izfb6Wmji
         LqiDs5n5a3U2cGXltLvPLbqsXnOuZoX/tzxC1QmFgegQ4M18ad0DsYozsTjLhZGRGVxA
         /9mFXzKoKMcaBw6VqwXcvbmOXk0WyP5FoQu3BAtscWStH11rDxwU/gG5SbeiVNJFX4gu
         KqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744771664; x=1745376464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T+67DiggxgIdjM5tawOq0HI43N1ZmR5vY23znSpxIlc=;
        b=B2dKnwdVJk0DxSmxDGauq2hOeHu3//plkgbA/2nFe3WSCifz8pHvmn+uXq2s3lBPdV
         iB7gTLWO1Qm8DGjFkjTxrb+4M3EFKULCzJfzLbr/H3pkpiC+IaJOiL5DOONrSmtPHXzR
         SYfjVhZ6aK0luxuVrTQPFG7rcZJoxg42drXbWXBvfR6c82iA4vsA1NW/JKFsRl+OSGwb
         o4dnMHpXH10gHnZ7YVIERv8aeTfzzxr4A/TsdIwN2IJR2jWS+4KnUUJqBwXkxKaKUFxN
         Elj+fA75IWlne4/ZgzkDus1Xi6KkGktco0RAmUDrMGZVFeV9zRgbEy9PqQy/n4HJc1ak
         O4rw==
X-Forwarded-Encrypted: i=1; AJvYcCVAtksVlERw/hcG1DZqK/mRda9XZFwfP7lL7oR0fS0xPGFxQ/8/d8wusi7a8E4FzVSeLYJcMc0glU0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGohAO1UsODAY/c+ij4rNCdk1li5W7FiSk2rD/QGEs/pM25QW3
	fiK4JmG9PatIrLzIwMjxlTvG4llEAmuIYaUc61Dkz0jiv7QzZozkSfN+JlihWNE=
X-Gm-Gg: ASbGnctY2DwYM6wknyyKKXUW1CfLQX8pR2Fq916P0mryZnoCzwJz3flC/HWNp1gRjzi
	xHq3dS/iBrRxWzkmmTks+zUzG2SneT/dNpGTntQqd6usY9sRNXayOYfg4V39jaAbQsnFRXi2ngX
	uH2QXZzRvFuVWDtaxGG1b2kKUrh0vRJuG87FWMsTQ8cKi/QIU9rA/VUzPhv4wT/Cmjeif8tW3yY
	FGHQg5fdf782dJmDJYc3wtIDkkL0I9lhy2wJLJmaqYqMd5kLvAlSpoMAQ0qYMCTkmgdyOhfF3mG
	4bKQKnGJCoTlaIpjQnhJFBcGuWVyVPkutngA3Rk=
X-Google-Smtp-Source: AGHT+IHlW4empTSlFl+GLMLNMWxZ1ueXtBMfa39wSAyT2nB5A7zeMnXOIt5J0tVNhDhr323+MU7eoQ==
X-Received: by 2002:a05:6a00:3cc2:b0:736:7960:981f with SMTP id d2e1a72fcca58-73c266e86a3mr227901b3a.8.1744771664152;
        Tue, 15 Apr 2025 19:47:44 -0700 (PDT)
Received: from fedora.smartx.com ([2001:df0:a640:1::4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd230e305sm9624958b3a.140.2025.04.15.19.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 19:47:43 -0700 (PDT)
From: Haoqian He <haoqian.he@smartx.com>
To: qemu-devel@nongnu.org,
	mst@redhat.com,
	sgarzare@redhat.com,
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
Subject: [PATCH v5 1/3] system/runstate: add VM state change cb with return value
Date: Tue, 15 Apr 2025 22:47:26 -0400
Message-ID: <20250416024729.3289157-2-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250416024729.3289157-1-haoqian.he@smartx.com>
References: <20250401151819.1526461-1-haoqian.he@smartx.com>
 <20250416024729.3289157-1-haoqian.he@smartx.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds the new VM state change cb type `VMChangeStateHandlerWithRet`,
which has return value for `VMChangeStateEntry`.

Thus, we can register a new VM state change cb with return value for device.
Note that `VMChangeStateHandler` and `VMChangeStateHandlerWithRet` are mutually
exclusive and cannot be provided at the same time.

This patch is the pre patch for 'vhost-user: return failure if backend crashes
when live migration', which makes the live migration aware of the loss of
connection with the vhost-user backend and aborts the live migration.

Virtio device will use VMChangeStateHandlerWithRet.

Signed-off-by: Haoqian He <haoqian.he@smartx.com>
---
 hw/block/virtio-blk.c             |  2 +-
 hw/core/vm-change-state-handler.c | 18 ++++++++++------
 hw/scsi/scsi-bus.c                |  2 +-
 hw/vfio/migration.c               |  2 +-
 hw/virtio/virtio.c                |  2 +-
 include/system/runstate.h         | 13 +++++++++---
 system/cpus.c                     |  8 +++++--
 system/runstate.c                 | 35 ++++++++++++++++++++++++++-----
 8 files changed, 62 insertions(+), 20 deletions(-)

diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index 5077793e5e..458871ea2b 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -1802,7 +1802,7 @@ static void virtio_blk_device_realize(DeviceState *dev, Error **errp)
      * called after ->start_ioeventfd() has already set blk's AioContext.
      */
     s->change =
-        qdev_add_vm_change_state_handler(dev, virtio_blk_dma_restart_cb, s);
+        qdev_add_vm_change_state_handler(dev, virtio_blk_dma_restart_cb, NULL, s);
 
     blk_ram_registrar_init(&s->blk_ram_registrar, s->blk);
     blk_set_dev_ops(s->blk, &virtio_block_ops, s);
diff --git a/hw/core/vm-change-state-handler.c b/hw/core/vm-change-state-handler.c
index 7064995578..99c642b558 100644
--- a/hw/core/vm-change-state-handler.c
+++ b/hw/core/vm-change-state-handler.c
@@ -40,6 +40,7 @@ static int qdev_get_dev_tree_depth(DeviceState *dev)
  * qdev_add_vm_change_state_handler:
  * @dev: the device that owns this handler
  * @cb: the callback function to be invoked
+ * @cb_ret: the callback function with return value to be invoked
  * @opaque: user data passed to the callback function
  *
  * This function works like qemu_add_vm_change_state_handler() except callbacks
@@ -50,25 +51,30 @@ static int qdev_get_dev_tree_depth(DeviceState *dev)
  * controller's callback is invoked before the children on its bus when the VM
  * starts running.  The order is reversed when the VM stops running.
  *
+ * Note that the parameter `cb` and `cb_ret` are mutually exclusive.
+ *
  * Returns: an entry to be freed with qemu_del_vm_change_state_handler()
  */
 VMChangeStateEntry *qdev_add_vm_change_state_handler(DeviceState *dev,
                                                      VMChangeStateHandler *cb,
+                                                     VMChangeStateHandlerWithRet *cb_ret,
                                                      void *opaque)
 {
-    return qdev_add_vm_change_state_handler_full(dev, cb, NULL, opaque);
+    assert(!cb || !cb_ret);
+    return qdev_add_vm_change_state_handler_full(dev, cb, NULL, cb_ret, opaque);
 }
 
 /*
  * Exactly like qdev_add_vm_change_state_handler() but passes a prepare_cb
- * argument too.
+ * and the cb_ret arguments too.
  */
 VMChangeStateEntry *qdev_add_vm_change_state_handler_full(
-    DeviceState *dev, VMChangeStateHandler *cb,
-    VMChangeStateHandler *prepare_cb, void *opaque)
+    DeviceState *dev, VMChangeStateHandler *cb, VMChangeStateHandler *prepare_cb,
+    VMChangeStateHandlerWithRet *cb_ret, void *opaque)
 {
     int depth = qdev_get_dev_tree_depth(dev);
 
-    return qemu_add_vm_change_state_handler_prio_full(cb, prepare_cb, opaque,
-                                                      depth);
+    assert(!cb || !cb_ret);
+    return qemu_add_vm_change_state_handler_prio_full(cb, prepare_cb, cb_ret,
+                                                      opaque, depth);
 }
diff --git a/hw/scsi/scsi-bus.c b/hw/scsi/scsi-bus.c
index ece1107ee8..4fa0d9769a 100644
--- a/hw/scsi/scsi-bus.c
+++ b/hw/scsi/scsi-bus.c
@@ -400,7 +400,7 @@ static void scsi_qdev_realize(DeviceState *qdev, Error **errp)
         return;
     }
     dev->vmsentry = qdev_add_vm_change_state_handler(DEVICE(dev),
-            scsi_dma_restart_cb, dev);
+            scsi_dma_restart_cb, NULL, dev);
 }
 
 static void scsi_qdev_unrealize(DeviceState *qdev)
diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
index fbff46cfc3..42948dffc5 100644
--- a/hw/vfio/migration.c
+++ b/hw/vfio/migration.c
@@ -1014,7 +1014,7 @@ static int vfio_migration_init(VFIODevice *vbasedev)
                      vfio_vmstate_change_prepare :
                      NULL;
     migration->vm_state = qdev_add_vm_change_state_handler_full(
-        vbasedev->dev, vfio_vmstate_change, prepare_cb, vbasedev);
+        vbasedev->dev, vfio_vmstate_change, prepare_cb, NULL, vbasedev);
     migration_add_notifier(&migration->migration_state,
                            vfio_migration_state_notifier);
 
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 85110bce37..202a052053 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -3489,7 +3489,7 @@ void virtio_init(VirtIODevice *vdev, uint16_t device_id, size_t config_size)
         vdev->config = NULL;
     }
     vdev->vmstate = qdev_add_vm_change_state_handler(DEVICE(vdev),
-            virtio_vmstate_change, vdev);
+            virtio_vmstate_change, NULL, vdev);
     vdev->device_endian = virtio_default_endian();
     vdev->use_guest_notifier_mask = true;
 }
diff --git a/include/system/runstate.h b/include/system/runstate.h
index bffc3719d4..fdd5c4a517 100644
--- a/include/system/runstate.h
+++ b/include/system/runstate.h
@@ -12,6 +12,7 @@ bool runstate_needs_reset(void);
 void runstate_replay_enable(void);
 
 typedef void VMChangeStateHandler(void *opaque, bool running, RunState state);
+typedef int VMChangeStateHandlerWithRet(void *opaque, bool running, RunState state);
 
 VMChangeStateEntry *qemu_add_vm_change_state_handler(VMChangeStateHandler *cb,
                                                      void *opaque);
@@ -20,21 +21,27 @@ VMChangeStateEntry *qemu_add_vm_change_state_handler_prio(
 VMChangeStateEntry *
 qemu_add_vm_change_state_handler_prio_full(VMChangeStateHandler *cb,
                                            VMChangeStateHandler *prepare_cb,
+                                           VMChangeStateHandlerWithRet *cb_ret,
                                            void *opaque, int priority);
 VMChangeStateEntry *qdev_add_vm_change_state_handler(DeviceState *dev,
                                                      VMChangeStateHandler *cb,
+                                                     VMChangeStateHandlerWithRet *cb_ret,
                                                      void *opaque);
 VMChangeStateEntry *qdev_add_vm_change_state_handler_full(
-    DeviceState *dev, VMChangeStateHandler *cb,
-    VMChangeStateHandler *prepare_cb, void *opaque);
+    DeviceState *dev, VMChangeStateHandler *cb, VMChangeStateHandler *prepare_cb,
+    VMChangeStateHandlerWithRet *cb_ret, void *opaque);
 void qemu_del_vm_change_state_handler(VMChangeStateEntry *e);
 /**
  * vm_state_notify: Notify the state of the VM
  *
  * @running: whether the VM is running or not.
  * @state: the #RunState of the VM.
+ *
+ * Return the result of the callback which has return value.
+ * If no callback has return value, still return 0 and the
+ * upper layer should not do additional processing.
  */
-void vm_state_notify(bool running, RunState state);
+int vm_state_notify(bool running, RunState state);
 
 static inline bool shutdown_caused_by_guest(ShutdownCause cause)
 {
diff --git a/system/cpus.c b/system/cpus.c
index 2cc5f887ab..d16b0dff98 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -299,14 +299,18 @@ static int do_vm_stop(RunState state, bool send_stop)
         if (oldstate == RUN_STATE_RUNNING) {
             pause_all_vcpus();
         }
-        vm_state_notify(0, state);
+        ret = vm_state_notify(0, state);
         if (send_stop) {
             qapi_event_send_stop();
         }
     }
 
     bdrv_drain_all();
-    ret = bdrv_flush_all();
+    /*
+     * Even if vm_state_notify() return failure,
+     * it would be better to flush as before.
+     */
+    ret |= bdrv_flush_all();
     trace_vm_stop_flush_all(ret);
 
     return ret;
diff --git a/system/runstate.c b/system/runstate.c
index 272801d307..de74d962bc 100644
--- a/system/runstate.c
+++ b/system/runstate.c
@@ -297,6 +297,7 @@ void qemu_system_vmstop_request(RunState state)
 struct VMChangeStateEntry {
     VMChangeStateHandler *cb;
     VMChangeStateHandler *prepare_cb;
+    VMChangeStateHandlerWithRet *cb_ret;
     void *opaque;
     QTAILQ_ENTRY(VMChangeStateEntry) entries;
     int priority;
@@ -320,14 +321,15 @@ static QTAILQ_HEAD(, VMChangeStateEntry) vm_change_state_head =
 VMChangeStateEntry *qemu_add_vm_change_state_handler_prio(
         VMChangeStateHandler *cb, void *opaque, int priority)
 {
-    return qemu_add_vm_change_state_handler_prio_full(cb, NULL, opaque,
-                                                      priority);
+    return qemu_add_vm_change_state_handler_prio_full(cb, NULL, NULL,
+                                                      opaque, priority);
 }
 
 /**
  * qemu_add_vm_change_state_handler_prio_full:
  * @cb: the main callback to invoke
  * @prepare_cb: a callback to invoke before the main callback
+ * @cb_ret: the main callback to invoke with return value
  * @opaque: user data passed to the callbacks
  * @priority: low priorities execute first when the vm runs and the reverse is
  *            true when the vm stops
@@ -344,6 +346,7 @@ VMChangeStateEntry *qemu_add_vm_change_state_handler_prio(
 VMChangeStateEntry *
 qemu_add_vm_change_state_handler_prio_full(VMChangeStateHandler *cb,
                                            VMChangeStateHandler *prepare_cb,
+                                           VMChangeStateHandlerWithRet *cb_ret,
                                            void *opaque, int priority)
 {
     VMChangeStateEntry *e;
@@ -352,6 +355,7 @@ qemu_add_vm_change_state_handler_prio_full(VMChangeStateHandler *cb,
     e = g_malloc0(sizeof(*e));
     e->cb = cb;
     e->prepare_cb = prepare_cb;
+    e->cb_ret = cb_ret;
     e->opaque = opaque;
     e->priority = priority;
 
@@ -379,9 +383,10 @@ void qemu_del_vm_change_state_handler(VMChangeStateEntry *e)
     g_free(e);
 }
 
-void vm_state_notify(bool running, RunState state)
+int vm_state_notify(bool running, RunState state)
 {
     VMChangeStateEntry *e, *next;
+    int ret = 0;
 
     trace_vm_state_notify(running, state, RunState_str(state));
 
@@ -393,7 +398,17 @@ void vm_state_notify(bool running, RunState state)
         }
 
         QTAILQ_FOREACH_SAFE(e, &vm_change_state_head, entries, next) {
-            e->cb(e->opaque, running, state);
+            if (e->cb) {
+                e->cb(e->opaque, running, state);
+            } else if (e->cb_ret) {
+                /*
+                 * Here ignore the return value of cb_ret because
+                 * we only care about the stopping the device during
+                 * the VM live migration to indicate whether the
+                 * connection between qemu and backend is normal.
+                 */
+                e->cb_ret(e->opaque, running, state);
+            }
         }
     } else {
         QTAILQ_FOREACH_REVERSE_SAFE(e, &vm_change_state_head, entries, next) {
@@ -403,9 +418,19 @@ void vm_state_notify(bool running, RunState state)
         }
 
         QTAILQ_FOREACH_REVERSE_SAFE(e, &vm_change_state_head, entries, next) {
-            e->cb(e->opaque, running, state);
+            if (e->cb) {
+                e->cb(e->opaque, running, state);
+            } else if (e->cb_ret) {
+                /*
+                 * We should execute all registered callbacks even if
+                 * one of them returns failure, otherwise, some cleanup
+                 * work of the device will be skipped.
+                 */
+                ret |= e->cb_ret(e->opaque, running, state);
+            }
         }
     }
+    return ret;
 }
 
 static ShutdownCause reset_requested;
-- 
2.44.0

