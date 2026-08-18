Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF11B3CE0B4
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029966; cv=none; b=LS9CmX0mzRKHqY/T7P6z6AF6nFAkZFivBTlz2AIZSxuTV+oWvEmqFMDIKz1ELr/CtQyVyW8pe25dl16GQGg05EhC5sq/b26uWZzSTQVh5oPrl2uEs+fu4HYUaz+ZoivOzf18G4aF62ON8bN4AB6ZzPosbQD7aRYlw5Y8BBPExDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029966; c=relaxed/simple;
	bh=EM/PjlQw++6DCEU0UaWG6Z1mgIImjSnvKqIHao8jzr4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b3hYXWhdiyQfMvbPrRhmRxa2KS0I8t77nm7n5O+Io95Y33Hp5bI1wbSA2aLd08fxhSHXdkUxdOxy0x3UZiHxWgixphOaOT2XS4QYvbdOPdFqJ8Mjd3m1uxEktCgScwTwDo4s0MSYGes83D2FTpSa0ey84ediB+eX97qAt75CziQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvOCo/AX; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvOCo/AX"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so5013414a12.2
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029964; x=1787634764; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mm3IHLFoV1taMjKnzvr28Ku7UY4hQc5i3yvfG4WtmPU=;
        b=GvOCo/AXZHKJ2vPLPd1orwTIdIOb//oCFSH7X2VJHtarfv1SgZSBmtk9Nk+Po5P3dA
         SGFcVDBLU/Me4mIVQ4+mjv4lmUb1utBL/eVA4PZnrCXCNsCTZWM5BoyHt/3h8onDSZYS
         rmqx07kSD/rMt7RYQzSsqAIaud8H0xTbEeE3WTa6wV5fHbvwRV6e2vh/MFAfxAvj6tn7
         xpPKRI08NveU4LQptaVQVvcepg4JgoQ262+B1coE7f4HdGJ+rXqBIgtba0j7qRG0p1ex
         lSegduxB63hq48gCMdEmgb63DRg/Iel2UM43RUetq6CFknF4xVkhAGHLe7j+5aZ8QIvZ
         RfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029964; x=1787634764;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mm3IHLFoV1taMjKnzvr28Ku7UY4hQc5i3yvfG4WtmPU=;
        b=hCjwmafyUEuQjMLLR5qDP0wB5TRiPU6xJjUhUz1E1v9RCeV1NTonpykRrY7SnMK3hq
         MjDv1dp4KfEI1vI9ydgBm/w2nZEmP0NCkeXhXFL15AKWKdbTixplyDs7kVnfCZhbumGo
         upl2vqNROhcPdeLhfbfEMASnP4CP7diNMKeCNHrhCwNHyyAQNk7tY+S2W8GcXQp+5dKp
         lD3PPL9qGNYrkcA6TQyHHSgOiuNmxs3DDtpqw7cTWyeE8HwPT7aOJi2Ruy1B3jBuikCS
         g2Fh8E5uT4xyYtBnev/YWOGI/Bfdj1fHrqftVA5nDWxGkVUhypF6hEr8C0WuV5eWvaBN
         bMcA==
X-Forwarded-Encrypted: i=1; AHgh+RprtZGV5j48ypmxKLdAIw9DpaKOsX8gbgb3yXEr0cPvYeQwsM7Cn7GGILKPV/EEmd+qErDFtXtwkCY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiD06FNQt/obG65zPFnjwtGK2x9P7e45TRBX3Vg5i97xwWDH1B
	FssnpBKOY4F0W75qVzgNyuOe98L8RqflW64wT0urxTPI04QRWAWjfNfS
X-Gm-Gg: AR+sD12v1+ulU80zFzwwFQ272L3nZGmo0TPWHRIF4DwWZtwNLOIfVlY7veFHDDsFP5D
	LQ2czdhuCpgts4Z6lxiwiw6iF+Ty91QAG0shABaaRUdlaN3Po2XRVsVdVYE43lqA/Gu1EwWVguF
	qmFp9cOs+nloshR/mQ0L1Rh4/KJ492mWybopte8Ur/ABTV0vu9CdBVNF0GE5qxr0E5uhETc42fF
	9BNsigLS5dexYXYDnb1E2jn2IWfVtRoNM2X7gzPnGmc/VVGcKkdpPKrvETMJZtb73a+98jPPMAM
	C5fLjZ/aaqcLKUG3PpMB2OG5NDV0+1MDyn/yhEHCeInbywcPociIlSkZbfl1cE6b/4/sLU7pN5Z
	W+njyG5jcWmpreqj/RsBMiGebMcJ2Y0g740vtlJ71eN6x/tgDPhkz1qq0RJ4YijVTteiC8PPQFW
	26T5+gNWphCqEyWk/OQMzFopEfrQR/A2ebIJtGN6bCn8Qz6qyIRs0sM7JiNJW2CYwpQg==
X-Received: by 2002:a05:6a00:278b:b0:84e:2f2e:8c4f with SMTP id d2e1a72fcca58-851b877b568mr7241523b3a.10.1787029963893;
        Mon, 17 Aug 2026 22:12:43 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:43 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:24 -0700
Subject: [PATCH RFC v2 09/13] hw/virtio/vhost-user: add shadow virtqueues
 and eventfd intercepts
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-9-948aae960abb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=9404;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=EM/PjlQw++6DCEU0UaWG6Z1mgIImjSnvKqIHao8jzr4=;
 b=E3VPFG/PNlIUzUZxtU9++LwDFS+hH3gRp4CoQ/fnJjpf6gmv+Mx2dER69xXBhSKCU5v8SV8OS
 0doaRJ/cXw4Di60Rr3WEWoV19lFWLVxLxPsIr7NjE/CpsNZSC8BZZA/
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Adds shadow virtqueues that will eventually be used to transfer data
between device and host via bounce buffers when isolation mode is
active.  The svqs are initalized, and eventfd assignments are
intercepted so that notifications come to svqs first before
the guest or backend receive them.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-user.c | 136 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 119 insertions(+), 17 deletions(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index e1e5cba53d..ace328f5eb 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -18,6 +18,7 @@
 #include "hw/virtio/vhost-backend.h"
 #include "hw/virtio/virtio.h"
 #include "hw/virtio/virtio-net.h"
+#include "hw/virtio/vhost-shadow-virtqueue.h"
 #include "hw/virtio/vhost-iova-tree.h"
 #include "chardev/char-fe.h"
 #include "io/channel-socket.h"
@@ -331,6 +332,7 @@ typedef struct {
     size_t size; /* size of the mapped shared memory */
     int fd; /* descriptor of anonymous file backing shared iso region */
     Int128 iso_iova_offset; /* translation from IOVA to hva of iso region */
+    GPtrArray *shadow_vqs; /* shadow vqs with vrings in iso region*/
 } IsolationModeCtx;
 
 struct vhost_user {
@@ -1128,15 +1130,38 @@ static int vhost_user_set_mem_table_postcopy(struct vhost_dev *dev,
     return 0;
 }
 
-static void cleanup_isolation_regions(struct vhost_dev *dev)
+static void vhost_user_svq_cleanup(struct vhost_user *u, bool reset)
+{
+    VhostShadowVirtqueue *svq;
+    for (int i = 0; i < u->iso_mem_ctx.shadow_vqs->len; i++) {
+        svq = g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, i);
+        vhost_svq_stop(svq);
+        event_notifier_cleanup(&svq->hdev_call);
+        event_notifier_cleanup(&svq->hdev_kick);
+    }
+
+    if (!reset) {
+        g_ptr_array_free(u->iso_mem_ctx.shadow_vqs, true);
+    }
+}
+
+static void cleanup_isolation_regions(struct vhost_dev *dev, bool reset)
 {
     struct vhost_user *u = dev->opaque;
     if (u->iso_mem_ctx.shared_mem_addr) {
+        vhost_user_svq_cleanup(u, reset);
         vhost_iova_tree_delete(u->iso_mem_ctx.tree);
         qemu_memfd_free(u->iso_mem_ctx.shared_mem_addr,
                         u->iso_mem_ctx.size,
                         u->iso_mem_ctx.fd);
+
+        GPtrArray *temp = u->iso_mem_ctx.shadow_vqs;
         memset(&u->iso_mem_ctx, 0, sizeof(IsolationModeCtx));
+
+        if (!reset) {
+            u->iso_mem_ctx.shadow_vqs = temp;
+        }
+
     }
 }
 
@@ -1234,7 +1259,7 @@ static int init_isolation_regions(struct vhost_dev *dev,
     msg->hdr.request = VHOST_USER_SET_MEM_TABLE;
 
     /* In case of reset, clear old regions */
-    cleanup_isolation_regions(dev);
+    cleanup_isolation_regions(dev, true);
 
     /* Gather information for bounce buffers to be mapped */
     for (u_int32_t i = 0; i < nregions; i++) {
@@ -1267,7 +1292,7 @@ static int init_isolation_regions(struct vhost_dev *dev,
 
     if (err) {
         error_report_err(err);
-        cleanup_isolation_regions(dev);
+        cleanup_isolation_regions(dev, false);
         return -1;
     }
 
@@ -1295,7 +1320,7 @@ static int init_isolation_regions(struct vhost_dev *dev,
                                   (hwaddr)u->iso_mem_ctx.shared_mem_addr);
 
     if (r != IOVA_OK) {
-        cleanup_isolation_regions(dev);
+        cleanup_isolation_regions(dev, false);
         return r;
     }
 
@@ -1310,7 +1335,7 @@ static int init_isolation_regions(struct vhost_dev *dev,
                                           dev->mem->regions[i].guest_phys_addr);
 
         if (r != IOVA_OK) {
-            cleanup_isolation_regions(dev);
+            cleanup_isolation_regions(dev, false);
             return r;
         }
     }
@@ -1738,11 +1763,49 @@ static int vhost_set_vring_file(struct vhost_dev *dev,
     return 0;
 }
 
+static int vhost_user_get_vq_index(struct vhost_dev *dev, int idx)
+{
+    assert(idx >= dev->vq_index && idx < dev->vq_index + dev->nvqs);
+
+    return idx;
+}
+
 static int vhost_user_set_vring_kick(struct vhost_dev *dev,
                                      struct vhost_vring_file *file)
 {
-    int ret = vhost_set_vring_file(dev, VHOST_USER_SET_VRING_KICK, file);
+    struct vhost_user *u = dev->opaque;
+    int svq_idx = file->index - dev->vq_index;
+    VhostShadowVirtqueue *svq = NULL;
+    struct vhost_vring_file vr_file = *file;
+    int ret;
+
+    vhost_user_get_vq_index(dev, file->index); /* bounds checking */
+
+    if (u->user->memory_isolation) {
+        svq = g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, svq_idx);
+        vhost_svq_set_svq_kick_fd(svq, file->fd);
+
+        if (file->fd != -1) {
+            if (!svq->hdev_kick.initialized) {
+                ret = event_notifier_init(&svq->hdev_kick, 0);
+                if (ret < 0) {
+                    event_notifier_cleanup(&svq->hdev_kick);
+                    error_report("Failed to create kick event notifier");
+                    return ret;
+                }
+            }
+
+            vr_file.fd = event_notifier_get_fd(&svq->hdev_kick);
+        } else {
+            event_notifier_cleanup(&svq->hdev_kick);
+        }
+    }
+
+    ret = vhost_set_vring_file(dev, VHOST_USER_SET_VRING_KICK, &vr_file);
     if (ret < 0) {
+        if (svq != NULL) {
+            event_notifier_cleanup(&svq->hdev_kick);
+        }
         return ret;
     }
 
@@ -1750,15 +1813,18 @@ static int vhost_user_set_vring_kick(struct vhost_dev *dev,
      * Inject a kick in case the back-end only starts vring processing upon
      * receiving a kick. The spec suggests this to improve compatibility.
      */
-    if (file->fd != -1) {
+    if (vr_file.fd != -1) {
         uint64_t val = 1;
         ssize_t nwritten;
 
         do {
-            nwritten = write(file->fd, &val, sizeof(val));
+            nwritten = write(vr_file.fd, &val, sizeof(val));
         } while (nwritten < 0 && errno == EINTR);
 
         if (nwritten < 0 && errno != EAGAIN /* back-end can already read */) {
+            if (svq != NULL) {
+                event_notifier_cleanup(&svq->hdev_kick);
+            }
             return -errno;
         }
     }
@@ -1769,7 +1835,35 @@ static int vhost_user_set_vring_kick(struct vhost_dev *dev,
 static int vhost_user_set_vring_call(struct vhost_dev *dev,
                                      struct vhost_vring_file *file)
 {
-    return vhost_set_vring_file(dev, VHOST_USER_SET_VRING_CALL, file);
+    struct vhost_user *u = dev->opaque;
+    int svq_idx = file->index - dev->vq_index;
+    VhostShadowVirtqueue *svq = NULL;
+    struct vhost_vring_file vr_file = *file;
+    int ret;
+
+    vhost_user_get_vq_index(dev, file->index); /* bounds checking */
+
+    if (u->user->memory_isolation) {
+        svq = g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, svq_idx);
+        vhost_svq_set_svq_call_fd(svq, file->fd);
+
+        if (file->fd != -1) {
+            if (!svq->hdev_call.initialized) {
+                ret = event_notifier_init(&svq->hdev_call, 0);
+                if (ret < 0) {
+                    event_notifier_cleanup(&svq->hdev_call);
+                    error_report("Failed to create call event notifier");
+                    return ret;
+                }
+            }
+
+            vr_file.fd = event_notifier_get_fd(&svq->hdev_call);
+        } else {
+            event_notifier_cleanup(&svq->hdev_call);
+        }
+    }
+
+    return vhost_set_vring_file(dev, VHOST_USER_SET_VRING_CALL, &vr_file);
 }
 
 static int vhost_user_set_vring_err(struct vhost_dev *dev,
@@ -2763,6 +2857,17 @@ static int vhost_user_postcopy_notifier(NotifierWithReturn *notifier,
     return 0;
 }
 
+static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user *u)
+{
+    /*Modified from vhost-vdpa*/
+    u->iso_mem_ctx.shadow_vqs = g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
+    for (int i = 0; i < dev->nvqs; i++) {
+        VhostShadowVirtqueue *svq;
+        svq = vhost_svq_new(NULL, NULL);
+        g_ptr_array_add(u->iso_mem_ctx.shadow_vqs, svq);
+    }
+}
+
 static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
                                    Error **errp)
 {
@@ -2907,6 +3012,10 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
     u->postcopy_notifier.notify = vhost_user_postcopy_notifier;
     postcopy_add_notifier(&u->postcopy_notifier);
 
+    if (vus->memory_isolation) {
+        vhost_user_init_svq(dev, u);
+    }
+
     return 0;
 }
 
@@ -2935,20 +3044,13 @@ static int vhost_user_backend_cleanup(struct vhost_dev *dev)
     g_free(u->region_rb_offset);
     u->region_rb_offset = NULL;
     u->region_rb_len = 0;
-    cleanup_isolation_regions(dev);
+    cleanup_isolation_regions(dev, false);
     g_free(u);
     dev->opaque = 0;
 
     return 0;
 }
 
-static int vhost_user_get_vq_index(struct vhost_dev *dev, int idx)
-{
-    assert(idx >= dev->vq_index && idx < dev->vq_index + dev->nvqs);
-
-    return idx;
-}
-
 static int vhost_user_memslots_limit(struct vhost_dev *dev)
 {
     struct vhost_user *u = dev->opaque;

-- 
2.43.0

