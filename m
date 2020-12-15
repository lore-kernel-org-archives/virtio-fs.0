DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=Lt7I1LwZl6Zuc9JO4eKlmm2JT6wwWS/9n7gImdcBKJg=;
	b=D3HJ9lkKP+XQ5V4scQ5VeM6JxVcvkMAvCLl3Gg4/1nYYWYJfcDGR8NdVPqXYHXjxMO
	ABE2y///QMGAGrqrFjzfiREns39LLBMgYGrUneKyWJEHszBfS4KVQjRQfewAHE2VE3AZ
	HHm5Zt66wi9ZfNWqGY629/4ROD7iNS9Ecm6xv1SnmpiGnDoSA0QPrMT+H6104QYtw87i
	PDsgMmBQ0ge/pUCp613LlDYWHiJRUI4Jb/kDdsAC5GSMUQrBDqhKtLZMjSMzzFrAPzKA
	uwVr+jOi7XwJFwDk7J5PRTPXZBIAFrHBaZkmR8HvOAFmsVMG4LeQFEAMd81tPnSX9DxZ
	Zjjg==
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Wed, 16 Dec 2020 00:21:11 +0800
Message-Id: <20201215162119.27360-2-zhangjiachen.jaycee@bytedance.com>
In-Reply-To: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [RFC PATCH 1/9] vhost-user-fs: Add support for
	reconnection of vhost-user-fs backend
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr . David Alan Gilbert" <dgilbert@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Xie Yongji <xieyongji@bytedance.com>
Cc: virtio-fs@redhat.com, Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>, qemu-devel@nongnu.org

Based on vhost-user's inflight I/O tracking infrastructure, we now add
support for the vhost-user-fs backend (or virtiofs daemon) reconnection.

Note that, till this patch, since the state information of virtiofsd is
not saved, virtiofsd will lose its information after reconnected to
QEMU. Following patches of this patchset will focus on state persistence
and restoring, with the help of some new vhost-user message types.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 hw/virtio/vhost-user-fs.c         | 218 +++++++++++++++++++++++++++---
 include/hw/virtio/vhost-user-fs.h |   2 +
 2 files changed, 200 insertions(+), 20 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 1bc5d03a00..ce343101d4 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -21,6 +21,7 @@
 #include "qemu/error-report.h"
 #include "hw/virtio/vhost-user-fs.h"
 #include "monitor/monitor.h"
+#include "sysemu/runstate.h"
 
 static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
 {
@@ -35,7 +36,7 @@ static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
     memcpy(config, &fscfg, sizeof(fscfg));
 }
 
-static void vuf_start(VirtIODevice *vdev)
+static int vuf_start(VirtIODevice *vdev)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
@@ -45,13 +46,13 @@ static void vuf_start(VirtIODevice *vdev)
 
     if (!k->set_guest_notifiers) {
         error_report("binding does not support guest notifiers");
-        return;
+        return -ENOSYS;
     }
 
     ret = vhost_dev_enable_notifiers(&fs->vhost_dev, vdev);
     if (ret < 0) {
         error_report("Error enabling host notifiers: %d", -ret);
-        return;
+        return ret;
     }
 
     ret = k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, true);
@@ -61,6 +62,22 @@ static void vuf_start(VirtIODevice *vdev)
     }
 
     fs->vhost_dev.acked_features = vdev->guest_features;
+
+    if (!fs->inflight->addr) {
+        ret = vhost_dev_get_inflight(&fs->vhost_dev, fs->conf.queue_size,
+                                     fs->inflight);
+        if (ret < 0) {
+            error_report("Error get inflight: %d", -ret);
+            goto err_guest_notifiers;
+        }
+    }
+
+    ret = vhost_dev_set_inflight(&fs->vhost_dev, fs->inflight);
+    if (ret < 0) {
+        error_report("Error set inflight: %d", -ret);
+        goto err_guest_notifiers;
+    }
+
     ret = vhost_dev_start(&fs->vhost_dev, vdev);
     if (ret < 0) {
         error_report("Error starting vhost: %d", -ret);
@@ -76,12 +93,14 @@ static void vuf_start(VirtIODevice *vdev)
         vhost_virtqueue_mask(&fs->vhost_dev, vdev, i, false);
     }
 
-    return;
+    return ret;
 
 err_guest_notifiers:
     k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false);
 err_host_notifiers:
     vhost_dev_disable_notifiers(&fs->vhost_dev, vdev);
+
+    return ret;
 }
 
 static void vuf_stop(VirtIODevice *vdev)
@@ -110,17 +129,27 @@ static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
     bool should_start = status & VIRTIO_CONFIG_S_DRIVER_OK;
+    int ret;
 
     if (!vdev->vm_running) {
         should_start = false;
     }
 
+    if (!fs->connected) {
+        return;
+    }
+
     if (fs->vhost_dev.started == should_start) {
         return;
     }
 
     if (should_start) {
-        vuf_start(vdev);
+        ret = vuf_start(vdev);
+        if (ret < 0) {
+            error_report("vhost-user-fs: vhost start failed: %s",
+                         strerror(-ret));
+            qemu_chr_fe_disconnect(&fs->conf.chardev);
+        }
     } else {
         vuf_stop(vdev);
     }
@@ -140,30 +169,161 @@ static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
      * Not normally called; it's the daemon that handles the queue;
      * however virtio's cleanup path can call this.
      */
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+    int i, ret;
+
+    if (!vdev->start_on_kick) {
+        return;
+    }
+
+    if (!fs->connected) {
+        return;
+    }
+
+    if (fs->vhost_dev.started) {
+        return;
+    }
+
+    /*
+     * Some guests kick before setting VIRTIO_CONFIG_S_DRIVER_OK so start
+     * vhost here instead of waiting for .set_status().
+     */
+    ret = vuf_start(vdev);
+    if (ret < 0) {
+        error_report("vhost-user-fs: vhost start failed: %s",
+                     strerror(-ret));
+        qemu_chr_fe_disconnect(&fs->conf.chardev);
+        return;
+    }
+
+    /* Kick right away to begin processing requests already in vring */
+    for (i = 0; i < fs->vhost_dev.nvqs; i++) {
+        VirtQueue *kick_vq = virtio_get_queue(vdev, i);
+
+        if (!virtio_queue_get_desc_addr(vdev, i)) {
+            continue;
+        }
+        event_notifier_set(virtio_queue_get_host_notifier(kick_vq));
+    }
 }
 
-static void vuf_guest_notifier_mask(VirtIODevice *vdev, int idx,
-                                            bool mask)
+static bool vuf_guest_notifier_pending(VirtIODevice *vdev, int idx)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
 
-    vhost_virtqueue_mask(&fs->vhost_dev, vdev, idx, mask);
+    return vhost_virtqueue_pending(&fs->vhost_dev, idx);
 }
 
-static bool vuf_guest_notifier_pending(VirtIODevice *vdev, int idx)
+static void vuf_reset(VirtIODevice *vdev)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
+    vhost_dev_free_inflight(fs->inflight);
+}
 
-    return vhost_virtqueue_pending(&fs->vhost_dev, idx);
+static int vuf_connect(DeviceState *dev)
+{
+    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+    int ret = 0;
+
+    if (fs->connected) {
+        return 0;
+    }
+    fs->connected = true;
+
+    /* 1 high prio queue, plus the number configured */
+    fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
+    fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
+    ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
+                         VHOST_BACKEND_TYPE_USER, 0);
+    if (ret < 0) {
+        error_report("vhost-user-fs: vhost initialization failed: %s",
+                     strerror(-ret));
+        return ret;
+    }
+
+    /* restore vhost state */
+    if (vdev->started) {
+        ret = vuf_start(vdev);
+        if (ret < 0) {
+            error_report("vhost-user-fs: vhost start failed: %s",
+                         strerror(-ret));
+            return ret;
+        }
+    }
+
+    return 0;
+}
+
+static void vuf_disconnect(DeviceState *dev)
+{
+    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+
+    if (!fs->connected) {
+        return;
+    }
+    fs->connected = false;
+
+    if (fs->vhost_dev.started) {
+        vuf_stop(vdev);
+    }
+
+    vhost_dev_cleanup(&fs->vhost_dev);
+}
+
+static void vuf_event(void *opaque, QEMUChrEvent event);
+
+static void vuf_chr_closed_bh(void *opaque)
+{
+    DeviceState *dev = opaque;
+    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+
+    vuf_disconnect(dev);
+    qemu_chr_fe_set_handlers(&fs->conf.chardev, NULL, NULL, vuf_event,
+            NULL, opaque, NULL, true);
+}
+
+static void vuf_event(void *opaque, QEMUChrEvent event)
+{
+    DeviceState *dev = opaque;
+    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+
+    switch (event) {
+    case CHR_EVENT_OPENED:
+        if (vuf_connect(dev) < 0) {
+            qemu_chr_fe_disconnect(&fs->conf.chardev);
+            return;
+        }
+        break;
+    case CHR_EVENT_CLOSED:
+        /* delay disconnectting according to commit 4bcad76f4c390f */
+        if (runstate_is_running()) {
+            AioContext *ctx = qemu_get_current_aio_context();
+
+            qemu_chr_fe_set_handlers(&fs->conf.chardev, NULL, NULL, NULL, NULL,
+                    NULL, NULL, false);
+            aio_bh_schedule_oneshot(ctx, vuf_chr_closed_bh, opaque);
+        }
+        break;
+    case CHR_EVENT_BREAK:
+    case CHR_EVENT_MUX_IN:
+    case CHR_EVENT_MUX_OUT:
+         /* Ignore */
+            break;
+    }
 }
 
+
 static void vuf_device_realize(DeviceState *dev, Error **errp)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VHostUserFS *fs = VHOST_USER_FS(dev);
     unsigned int i;
     size_t len;
-    int ret;
+    Error *err = NULL;
 
     if (!fs->conf.chardev.chr) {
         error_setg(errp, "missing chardev");
@@ -217,16 +377,24 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
         fs->req_vqs[i] = virtio_add_queue(vdev, fs->conf.queue_size, vuf_handle_output);
     }
 
-    /* 1 high prio queue, plus the number configured */
-    fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
-    fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
-    ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
-                         VHOST_BACKEND_TYPE_USER, 0);
-    if (ret < 0) {
-        error_setg_errno(errp, -ret, "vhost_dev_init failed");
+    /* init reconnection related variables */
+    fs->inflight = g_new0(struct vhost_inflight, 1);
+    fs->connected = false;
+
+    qemu_chr_fe_set_handlers(&fs->conf.chardev,  NULL, NULL, vuf_event,
+                                 NULL, (void *)dev, NULL, true);
+
+reconnect:
+    if (qemu_chr_fe_wait_connected(&fs->conf.chardev, &err) < 0) {
+        error_report_err(err);
         goto err_virtio;
     }
 
+    /* check whether vuf_connect() failed or not */
+    if (!fs->connected) {
+        goto reconnect;
+    }
+
     return;
 
 err_virtio:
@@ -236,6 +404,9 @@ err_virtio:
         virtio_delete_queue(fs->req_vqs[i]);
     }
     g_free(fs->req_vqs);
+    fs->req_vqs = NULL;
+    g_free(fs->inflight);
+    fs->inflight = NULL;
     virtio_cleanup(vdev);
     g_free(fs->vhost_dev.vqs);
     return;
@@ -248,7 +419,7 @@ static void vuf_device_unrealize(DeviceState *dev)
     int i;
 
     /* This will stop vhost backend if appropriate. */
-    vuf_set_status(vdev, 0);
+    virtio_set_status(vdev, 0);
 
     vhost_dev_cleanup(&fs->vhost_dev);
 
@@ -259,9 +430,16 @@ static void vuf_device_unrealize(DeviceState *dev)
         virtio_delete_queue(fs->req_vqs[i]);
     }
     g_free(fs->req_vqs);
+    fs->req_vqs = NULL;
+    qemu_chr_fe_set_handlers(&fs->conf.chardev,  NULL, NULL, NULL,
+                             NULL, NULL, NULL, false);
+
     virtio_cleanup(vdev);
+    vhost_dev_free_inflight(fs->inflight);
     g_free(fs->vhost_dev.vqs);
     fs->vhost_dev.vqs = NULL;
+    g_free(fs->inflight);
+    fs->inflight = NULL;
 }
 
 static const VMStateDescription vuf_vmstate = {
@@ -291,8 +469,8 @@ static void vuf_class_init(ObjectClass *klass, void *data)
     vdc->get_features = vuf_get_features;
     vdc->get_config = vuf_get_config;
     vdc->set_status = vuf_set_status;
-    vdc->guest_notifier_mask = vuf_guest_notifier_mask;
     vdc->guest_notifier_pending = vuf_guest_notifier_pending;
+    vdc->reset = vuf_reset;
 }
 
 static const TypeInfo vuf_info = {
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 6985752771..9ef47568e7 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -39,6 +39,8 @@ struct VHostUserFS {
     VhostUserState vhost_user;
     VirtQueue **req_vqs;
     VirtQueue *hiprio_vq;
+    struct vhost_inflight *inflight;
+    bool connected;
 
     /*< public >*/
 };
-- 
2.20.1

