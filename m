Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F4C3CE0B4
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029954; cv=none; b=dOQora6FISqph3Smx1+OxWmQDF3YT/9GarDgs1wXtF9Ek7KRxApq577UTa4NVrcQmCMgicBQ+eEvIbzReRKEvfCerKh8LaZh/c1viYTAach6lpzLQsNAkYUKqW7FbPpGJYlGSGsNxldFytBsz0Rb3oJyLVG3a1H5erGwN6tbtIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029954; c=relaxed/simple;
	bh=zMLe3YYRkSQNcCO8gpXX8eru8I8FhRevRD5BzLCf9h0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NsLgYivNWz11qypw+8jh0INHh3y9SZjzyHYE3tVW4u1XlTHDvYSD3W8h9CuXWg0aQ1jAikQsVoZfj3Uy4q+7yzMkhp94YBqeCJXHAkVJhYC1K49p/4vdZaE76DakxwHjRflWGs2nZH7W3AgWaWZBpcNnxGl72T6A3bDmk0RzlD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=paNs+9/c; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="paNs+9/c"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84f38f3b36eso2726345b3a.1
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029953; x=1787634753; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5iSPjR4OWYgSwQ/ju8j1WMdGvtILP0xKe6fEY1lq/RU=;
        b=paNs+9/ckvropT7poWS6o9jY4uCICOfLJOQKmgSB8Xj8I0y1u4RvkT7JptoJI5C3Sc
         tO1OLVlTY2g9uLI6zThk+OhT9F5T1ky3Zwm+koBHkop0mS+ZwJPw+Qt70IQuxEaENzAL
         f1HxmPaTpgTc4htFFuHq/RaaXzHM5oa+lSi/Gm5F2Qtxjjhw+hWfSmXhR3Uos/hWGzx7
         oDjd8RtALJRnz8Vf5v0r/8RMqR/pQZeakI3bfuqGOkQq41J8IAH8noX2mecgIjIH8pYZ
         6teerL2XmDDWZb704axB+jlYGRtGlO6nMjARp3P0yFVG1VOnHMijoyFGGgQ0Nhjli/HO
         489A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029953; x=1787634753;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5iSPjR4OWYgSwQ/ju8j1WMdGvtILP0xKe6fEY1lq/RU=;
        b=TWD1RbfGzWI5T/ogbz7G+PZWl6N/WTvtBtLTxwnA26JXZuBZ4v7x+C0tJvDtieA1QN
         /UorSTW3+yNfGuQuIHz5mdVRQ9HZ2o1GDKDaRShWglJoiOx81A2p+tdRJ5dzjRaExGsi
         KGgSj1crsNVvdxpmc3yo/rvG0q0A8qf+VfljBWB3uIE4usttCgkngP0pLuU5ATBuNvnz
         TaQVd9TG+z6SIp//J6EwYHjljZcqV40BfSDP5Mshw5ngAuZrzj48e3zzk73rLq3mr7zp
         AgWeTMqFxDpf5DFBxmC7h4hjJJcQiVlWeTbiKYiOBMKIGwT9kFQd3uGJdEYcw4R9aTtv
         Ohsg==
X-Forwarded-Encrypted: i=1; AHgh+RpRahMSJ58egrPQ8pI4iDYyiNKsUpF45Jc6FvTA24kVTRoCbSnnJrkARREGz/OrDyamHT1nVMkvjVI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1WXCa1sdEuAARy3BImhKGHgzjKZxsN2GZDN1bUfnbgKHgVfOL
	MYCvuJ31kXTpf3WBju/uxxrIA1lM9oE44i2uPKx1C2rIgQji3M7XmiyK
X-Gm-Gg: AR+sD10z+ADU0S8KvoD71row6zwao/2Pz3rnNmRLE79AgND13zItvN2IfZ48ddr9YMR
	rX+1rupnd8EaCVZRTM/Xmo8FQcLpheArnDHsNVE1a1/YceW+7KzgI5F6iv6BZrKFg9Kdi2GmFf9
	e20+YG5n1esb+JWIFYSjYR4ie25kKPVyzKnCBxwEQz6AyrT2HS2kJq2O3QAHy+2u3gkba24O/B7
	RzPyfAUjgJb210P+Ovinj0gLRc72BF4w3BWlcv5rREe5Qc3Ab2GbY1KcvCdV5KCfSztDY9VLDW/
	glZNKrl4WNynxEHos53Kh56EQvwsHYVJaUyd8r31I0J0BzUqFDj+05boyvASH07oSI+UoLMRWGh
	4Tcm8+A4OlZsXNH2lfMiD1zekYHboMfpU/dq8bKiTtxNkXkk/DqQmGUz336za7iCZEmBZycGCiA
	sPLpoOUKAwJ73/pT9WFutKHvR3BJxTIDGfe92+UOlurewR90be6I6Vvicf9oAgMOGuwA==
X-Received: by 2002:a05:6a00:9508:b0:84a:29a7:f3b1 with SMTP id d2e1a72fcca58-84fde12721fmr25945799b3a.16.1787029952715;
        Mon, 17 Aug 2026 22:12:32 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:32 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:20 -0700
Subject: [PATCH RFC v2 05/13] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-5-948aae960abb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=6847;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=zMLe3YYRkSQNcCO8gpXX8eru8I8FhRevRD5BzLCf9h0=;
 b=89rGEsgnDJRxANQcPGgrkm/+un/OiboC53ebypLTch0HhTgwjPLd90rOF6xBlNmgXEPieR5tO
 M3II78hh4MbBjxsLiRFIaMsN7mmmp0N/KQLgNRDJDSzS8Vf8oaBycvV
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

By default svq vrings are placed in an anonymous memory map. As svqs
will be leveraged to enable memory isolation in vhost-user, it is useful
to be able to place the vrings in a shared isolation memory region.

Adds the option to specify vring placement by providing a vring base
address before starting the svq.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-shadow-virtqueue.c | 69 ++++++++++++++++++++++++++++++++------
 hw/virtio/vhost-shadow-virtqueue.h |  8 ++++-
 2 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index 496e7e58a3..f54a61439a 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -812,6 +812,13 @@ size_t vhost_svq_device_area_size(const VhostShadowVirtqueue *svq)
     return ROUND_UP(used_size, qemu_real_host_page_size());
 }
 
+size_t vhost_svq_vring_total_size(VirtIODevice *vdev, VirtQueue *vq)
+{
+    VhostShadowVirtqueue svq;
+    svq.vring.num = virtio_queue_get_num(vdev, virtio_get_queue_index(vq));
+    return vhost_svq_driver_area_size(&svq) + vhost_svq_device_area_size(&svq);
+}
+
 /**
  * Set a new file descriptor for the guest to kick the SVQ and notify for avail
  *
@@ -842,6 +849,19 @@ void vhost_svq_set_svq_kick_fd(VhostShadowVirtqueue *svq, int svq_kick_fd)
     }
 }
 
+/**
+ * Set vring base address if using fixed locations
+ *
+ * @svq: Shadow Virtqueue
+ * @addr: Points to new base address
+ */
+
+ void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr)
+ {
+    svq->base_addr = addr;
+ }
+
+
 /**
  * Start the shadow virtqueue operation.
  *
@@ -849,8 +869,10 @@ void vhost_svq_set_svq_kick_fd(VhostShadowVirtqueue *svq, int svq_kick_fd)
  * @vdev: VirtIO device
  * @vq: Virtqueue to shadow
  * @iova_tree: Tree to perform descriptors translations
+ *
+ * Return 0 on success, -errno on failure
  */
-void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
+int vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
                      VirtQueue *vq, VhostIOVATree *iova_tree)
 {
     size_t desc_size;
@@ -868,14 +890,27 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
 
     svq->vring.num = virtio_queue_get_num(vdev, virtio_get_queue_index(vq));
     svq->num_free = svq->vring.num;
-    svq->vring.desc = mmap(NULL, vhost_svq_driver_area_size(svq),
-                           PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
-                           -1, 0);
     desc_size = sizeof(vring_desc_t) * svq->vring.num;
-    svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
-    svq->vring.used = mmap(NULL, vhost_svq_device_area_size(svq),
-                           PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
-                           -1, 0);
+    if (svq->base_addr == NULL) {
+        svq->vring.desc = mmap(NULL, vhost_svq_driver_area_size(svq),
+                            PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
+                            -1, 0);
+        svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
+        svq->vring.used = mmap(NULL, vhost_svq_device_area_size(svq),
+                            PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
+                            -1, 0);
+    } else {
+        svq->vring.desc = (void *)svq->base_addr;
+        svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
+        svq->vring.used = (void *)((char *)svq->base_addr +
+                          vhost_svq_driver_area_size(svq));
+
+        if ((uint64_t)svq->vring.used + vhost_svq_device_area_size(svq) - 1 <
+           (uint64_t)svq->vring.desc) {
+                error_report("Invalid shadow vring location");
+                return -ENOMEM;
+        }
+    }
     svq->desc_state = g_new0(SVQDescState, svq->vring.num);
     if (virtio_vdev_has_feature(svq->vdev, VIRTIO_F_IN_ORDER)) {
         svq->batch_last.id = VIRTIO_RING_NOT_IN_BATCH;
@@ -884,6 +919,8 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
             svq->desc_state[i].next = i + 1;
         }
     }
+
+    return 0;
 }
 
 /**
@@ -920,8 +957,19 @@ void vhost_svq_stop(VhostShadowVirtqueue *svq)
     }
     svq->vq = NULL;
     g_free(svq->desc_state);
-    munmap(svq->vring.desc, vhost_svq_driver_area_size(svq));
-    munmap(svq->vring.used, vhost_svq_device_area_size(svq));
+
+    if (!svq->base_addr) {
+        munmap(svq->vring.desc, vhost_svq_driver_area_size(svq));
+        munmap(svq->vring.used, vhost_svq_device_area_size(svq));
+    } else{
+        if (svq->vring.desc) {
+            memset(svq->vring.desc, 0, vhost_svq_driver_area_size(svq));
+        }
+        if (svq->vring.used) {
+            memset(svq->vring.used, 0, vhost_svq_device_area_size(svq));
+        }
+    }
+
     event_notifier_set_handler(&svq->hdev_call, NULL);
 }
 
@@ -940,6 +988,7 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
     event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
     svq->ops = ops;
     svq->ops_opaque = ops_opaque;
+    svq->base_addr = NULL;
     return svq;
 }
 
diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
index fd68319fb7..1e0cc9e5e4 100644
--- a/hw/virtio/vhost-shadow-virtqueue.h
+++ b/hw/virtio/vhost-shadow-virtqueue.h
@@ -150,6 +150,9 @@ typedef struct VhostShadowVirtqueue {
 
     /* Size of SVQ vring free descriptors */
     uint16_t num_free;
+
+    /* Location assigned to vrings if not in default anon memory map */
+    void *base_addr;
 } VhostShadowVirtqueue;
 
 bool vhost_svq_valid_features(uint64_t features, Error **errp);
@@ -169,8 +172,9 @@ void vhost_svq_get_vring_addr(const VhostShadowVirtqueue *svq,
                               struct vhost_vring_addr *addr);
 size_t vhost_svq_driver_area_size(const VhostShadowVirtqueue *svq);
 size_t vhost_svq_device_area_size(const VhostShadowVirtqueue *svq);
+size_t vhost_svq_vring_total_size(VirtIODevice *vdev, VirtQueue *vq);
 
-void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
+int vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
                      VirtQueue *vq, VhostIOVATree *iova_tree);
 void vhost_svq_stop(VhostShadowVirtqueue *svq);
 
@@ -178,6 +182,8 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
                                     void *ops_opaque);
 
 void vhost_svq_free(gpointer vq);
+void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr);
+
 G_DEFINE_AUTOPTR_CLEANUP_FUNC(VhostShadowVirtqueue, vhost_svq_free);
 
 #endif

-- 
2.43.0

