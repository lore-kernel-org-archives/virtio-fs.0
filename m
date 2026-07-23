Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB643AFCE6
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845894; cv=none; b=gzeCz02VyiID4IM7to8yzW9wH+XH6ij5NJZKs/b9oOrNBNnuDvqK9jlrd30ThVREjhrKfdY8oo8vFeawOVD4XwQF+c8i9qWjTTxy+yprr+lP0+2sMneOU+OhRMS9eHeakDmb3wr441jsx0wLbMwq5b2q57Y6j2U5rAR/blNTS8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845894; c=relaxed/simple;
	bh=xEeRhGfcKFx4bZNfrfgaBAeG54f3UIPcnr2JwcHSaLI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Tg8CafQe6UzjCCPFz5iT7FCUBFKo7njEAsK83qeXYV44+acoSjjE/uPlKjrdJtO6l5xXbMaDm3wk9DqR9mnf5K6N8QiSaOtsLa47CPo6z5lBZOjblNXgBglJqkeR7NAcPZzUywYhVRhxp6H8T2xRjS6dbo+o073bjVPYX1YN8J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UzSCYEeb; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UzSCYEeb"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-80cebd41372so10795027b3.3
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845892; x=1785450692; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GKRiouieuWI1DwlbrQ7+GSIDGiapIP1YbqHrv02aXj4=;
        b=UzSCYEeb5Gtqa2al5Gfr/HKjijXkz7UzVK7WPAHPm4v50YJYbAheopWGeQqCtv1o6H
         AUE7lpPGEA7TIgNsOVU2jkL7A08YH8x61cZa5B0MlS19qwUxmltvjFu7aidm4XwYY/qF
         jnkjVNuh/ykqZWhOy5xdzwpse7ybEoKNslvonmm/bUj4vpI5eFhaciopC4+QiXzJsqVb
         wNZdBUE1F+ekVHEMh79d3uK//ZgXndhVkwaGPiuFuvDUrFRIsWXahywaQMCV0byQbUJm
         bFMEugHVI4UX6nLpwT90ZAbsEqLoqd7I88K/AF3+UxCDAwYSQBSFadSIYN0fwseEopsE
         ZiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845892; x=1785450692;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GKRiouieuWI1DwlbrQ7+GSIDGiapIP1YbqHrv02aXj4=;
        b=U+TAAatW3M7dEMYfi0ZPRhUQKI7V8nOHHLMXtgcecgYjB5qMrUMjEhKvInKHx6Yu7l
         0kgRmRDK5igZUrkViBJe5ulzgOCWjKrkHjZV5MLHup1Fh4ipmrWiZZoC+j1SWBIoBgq0
         XWCxY91HFSskAHmzU5uoL18pFIg2K+aralgs8wHJh67Jb9OmBES6WW5bcYE0+UQUAOem
         D2CxUK3Pr31J9lnWNILGRfS188OqC/U0Ezu+8N779zFpcD35RPDNh7IxnUsY3xpLLPMh
         cjEHGOsx+Ylm+jHiM6qGkf4Q1HNxZlXl85gJ2sgpCgBrA7ol3wGnFMElo+eyzAGiv0+l
         BZ2w==
X-Forwarded-Encrypted: i=1; AHgh+Rqkkrvn8iBG5KdHY47nfrKozDMecX7YHqi7z2PmiiHSlXr+RRM6T0HaXci/9XRq32laryWWmwGoUpQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzE0gp9hQyn6IyW6pmABbSuppCanFLwu9+pg7jjd3ssBzvIa0OU
	CMbc7bYH1K21pNtYWfye9Jxt/X1trV6iGQB7OTX85IfGNH829xoQpZPs
X-Gm-Gg: AR+sD13c1ndg3S67kPLiTDDQ3wHbkt6Ix0JSO8vcs9dmMK3Ty8z0jwsmFvRecOFD4dW
	+z/kLOpz9/uq/5r51RNrUkU4QGyUCIagL9OWbCFXokt6jEffRPKZq0XQ9rMddcvu5h8bnQRNw7r
	l7/YGG84i49y+eU2Hszhle6fJTfb3x7JzE5mUBHvohtReSv5N/s9dkb0o0GQU7R3roIaPrp/qQA
	4p7ai74+ZwpUsLaKep4ZWRKKT6uzf2zoLgey5fDOyBPazEaxZlUmJqYSJEpKolIsvYyxm2kJgMi
	ELB+/518MfwUApCZ04m8HaW0YqRBZpIMsCRaPT9UTdVu27unZ776w7IvwjzyMcHyAMipGF5Dcpf
	XZ9+urvM3TO69VvTPpyIc6RrTVCf+Wm+omnG1PC6M0qWBgbaUH3ECeH8MdGwzL4mr4+GazmTP7F
	j1KmPBobY=
X-Received: by 2002:a05:690c:9a13:b0:80c:85c6:898f with SMTP id 00721157ae682-81f4c385c3cmr17699887b3.62.1784845891600;
        Thu, 23 Jul 2026 15:31:31 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:31 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:13 -0700
Subject: [PATCH RFC 14/15] hw/virtio/vhost-user: handle data movement with
 shadow vqs
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-14-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=7740;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=xEeRhGfcKFx4bZNfrfgaBAeG54f3UIPcnr2JwcHSaLI=;
 b=VzOWwZdOmRpBpOwUSyJ1rwROwiQiEWqNy3EW+u9gkPrYwZlbAlRWoUYraUqQK9Fn3BTl94e7d
 hzYa7doD71DA7T+oDrfN0eQ5QP9hEWzssolfhzJrOpyjbl88vMHSY2j
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

- Add start logic for shadow virtqueues, which sets vring addresses.
- Update logic for sending vring addresses to backend to point
  to the shadow vrings when isolation mode is active.
- Implement handlers for intercepted avail and used descriptors. These
  handlers copy buffer contents between bounce buffers in the isolation
  region and the buffers made available by the guest
- Implement logic to stop svqs

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-user.c | 167 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 166 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 75858289a2..e65f877f9a 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -1299,6 +1299,97 @@ static int init_isolation_regions(struct vhost_dev *dev,
     return 0;
 }
 
+static int vhost_user_memory_lookup(struct vhost_dev *dev, hwaddr gpa,
+                                    hwaddr *hva)
+{
+    int i;
+    hwaddr offset;
+
+    for (i = 0; i < dev->mem->nregions; i++) {
+        struct vhost_memory_region *reg = dev->mem->regions + i;
+
+        if (gpa >= reg->guest_phys_addr &&
+            reg->guest_phys_addr + reg->memory_size > gpa) {
+            offset = gpa - reg->guest_phys_addr;
+            *hva = reg->userspace_addr + offset;
+            return 0;
+        }
+    }
+
+    return -EFAULT;
+}
+
+static int vhost_user_svq_handle_used(VhostShadowVirtqueue *svq,
+                                      VirtQueueElement *elem,
+                                      void *opaque)
+{
+    hwaddr hva;
+    int r;
+    struct vhost_dev *dev = opaque;
+
+    for (int i = 0; i < elem->in_num; i++) {
+        r = vhost_user_memory_lookup(dev, elem->in_addr[i], &hva);
+        if (r < 0) {
+            return r;
+        }
+
+        memcpy((void *) hva, elem->in_sg[i].iov_base, elem->in_sg[i].iov_len);
+        elem->in_sg[i].iov_base = (void *) hva;
+    }
+
+    for (int i = 0; i < elem->out_num; i++) {
+        r = vhost_user_memory_lookup(dev, elem->out_addr[i], &hva);
+        if (r < 0) {
+            return r;
+        }
+
+        memcpy((void *) hva, elem->out_sg[i].iov_base, elem->out_sg[i].iov_len);
+        elem->out_sg[i].iov_base = (void *) hva;
+    }
+
+    return 0;
+}
+
+static int vhost_user_svq_handle_avail(VhostShadowVirtqueue *svq,
+                                       VirtQueueElement *elem,
+                                       void *opaque)
+{
+    hwaddr offset;
+    const DMAMap *map;
+    DMAMap needle;
+    hwaddr *iova_base;
+
+    for (int i = 0; i < elem->out_num; i++) {
+        needle.translated_addr = elem->out_addr[i];
+        needle.size = elem->out_sg[i].iov_len - 1;
+        map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
+        offset = needle.translated_addr - map->translated_addr;
+        iova_base = (void *)(map->iova + offset);
+
+        elem->out_sg[i].iov_base = iova_base;
+        memcpy(iova_base, elem->out_sg[i].iov_base, needle.size + 1);
+    }
+
+    for (int i = 0; i < elem->in_num; i++) {
+        needle.translated_addr = elem->in_addr[i];
+        needle.size = elem->in_sg[i].iov_len - 1;
+        map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
+        offset = needle.translated_addr - map->translated_addr;
+        iova_base = (void *)(map->iova + offset);
+
+        elem->in_sg[i].iov_base = iova_base;
+        memcpy(iova_base, elem->in_sg[i].iov_base, needle.size + 1);
+    }
+
+    vhost_svq_add(svq, elem->out_sg, elem->out_num, elem->out_addr,
+                  elem->in_sg, elem->in_num, elem->in_addr, elem);
+
+    return 0;
+}
+
+
+
+
 static int vhost_user_set_mem_table(struct vhost_dev *dev,
                                     struct vhost_memory *mem)
 {
@@ -1772,6 +1863,8 @@ static int vhost_user_set_vring_err(struct vhost_dev *dev,
 static int vhost_user_set_vring_addr(struct vhost_dev *dev,
                                      struct vhost_vring_addr *addr)
 {
+    struct vhost_user *u = dev->opaque;
+
     VhostUserMsg msg = {
         .hdr.request = VHOST_USER_SET_VRING_ADDR,
         .hdr.flags = VHOST_USER_VERSION,
@@ -1779,6 +1872,25 @@ static int vhost_user_set_vring_addr(struct vhost_dev *dev,
         .hdr.size = sizeof(msg.payload.addr),
     };
 
+    if (u->user->memory_isolation) {
+        if (!u->svqs_allocated) {
+            return 0;
+        }
+
+        int svq_idx = addr->index - dev->vq_index;
+        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs,
+                                                      svq_idx);
+
+        struct vhost_vring_addr svq_addr = {
+            .avail_user_addr = (uint64_t)(uintptr_t)svq->vring.avail,
+            .desc_user_addr = (uint64_t)(uintptr_t)svq->vring.desc,
+            .used_user_addr = (uint64_t)(uintptr_t)svq->vring.used,
+            .index = addr->index,
+        };
+
+        msg.payload.addr = svq_addr;
+    }
+
     /*
      * wait for a reply if logging is enabled to make sure
      * backend is actually logging changes
@@ -2754,13 +2866,18 @@ static int vhost_user_postcopy_notifier(NotifierWithReturn *notifier,
     return 0;
 }
 
+static const VhostShadowVirtqueueOps vhost_user_svq_ops = {
+    .avail_handler = vhost_user_svq_handle_avail,
+    .used_handler = vhost_user_svq_handle_used
+};
+
 static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user *u)
 {
     /*Modified from vhost-vdpa*/
     u->shadow_vqs = g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
     for (int i = 0; i < dev->nvqs; i++) {
         VhostShadowVirtqueue *svq;
-        svq = vhost_svq_new(NULL, NULL);
+        svq = vhost_svq_new(&vhost_user_svq_ops, dev);
         g_ptr_array_add(u->shadow_vqs, svq);
     }
 }
@@ -3466,8 +3583,56 @@ void vhost_user_async_close(DeviceState *d,
     }
 }
 
+static bool vhost_user_svqs_start(struct vhost_dev *dev)
+{
+    struct vhost_user *u = dev->opaque;
+    uint64_t vring_base = u->iso_memory.vring_base_addr;
+    u->svqs_allocated = true;
+
+    for (int i = 0; i < u->shadow_vqs->len; i++) {
+        VirtQueue *vq = virtio_get_queue(dev->vdev, dev->vq_index + i);
+        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs, i);
+        svq->base_addr = (hwaddr *) vring_base;
+        vhost_svq_start(svq, dev->vdev, vq, u->iso_iova_tree);
+
+        struct vhost_vring_addr addr = {
+            .index = dev->vq_index + i,
+            .desc_user_addr = vring_base,
+            .avail_user_addr = vring_base + sizeof(vring_desc_t) *
+                svq->vring.num,
+            .used_user_addr = vring_base + vhost_svq_driver_area_size(svq)
+        };
+
+        vhost_user_set_vring_addr(dev, &addr);
+
+        vring_base += vhost_svq_device_area_size(svq) +
+                      vhost_svq_driver_area_size(svq);
+    }
+
+    return false;
+}
+
+static void vhost_user_svqs_stop(struct vhost_dev *dev)
+{
+    struct vhost_user *u = dev->opaque;
+
+    for (int i = 0; i < u->shadow_vqs->len; i++) {
+        vhost_svq_stop(g_ptr_array_index(u->shadow_vqs, i));
+    }
+}
+
+
 static int vhost_user_dev_start(struct vhost_dev *dev, bool started)
 {
+    struct vhost_user *u = dev->opaque;
+    if (u->user->memory_isolation) {
+        if (started) {
+            vhost_user_svqs_start(dev);
+        } else {
+            vhost_user_svqs_stop(dev);
+        }
+    }
+
     if (!vhost_user_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_STATUS)) {
         return 0;
     }

-- 
2.43.0

