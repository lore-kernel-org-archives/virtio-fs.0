Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABCD3D0C1D
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029969; cv=none; b=BdxdRda/mhXfIl2/M/uVwLPAtLfmML1U2OeY6tclEbn77vac97Lm7cImm6CIHLJyn+rsOSparQ/6Y6vjzUWZn/42Sqd/0dyBV/nJd0xcSnIp0TaN0+kj7c1QaNIknur+Ea9tvO0XpKN7glvqbQ6K/Uy48VzSdas+49yjK8WS46o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029969; c=relaxed/simple;
	bh=bMPw0FwBRsEunQYzzG6BOXyVL5rIEfi5TeDivlNmsxo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dbstPHqs/prJNqgL/KT50WU4QciwXU7+4Gv/x1UWIbjs/bugqW+HqIwIQ4ayvrfik7KB1ssx0S1KNb/ecNL6QxCq3oDMRKReKIXshC8GnX6Y8ayrlRe143KqtjaqZvAtXk3x2wiRRqN4wIiiNQyL6phnGQjyZxLqYPDKj2NQr7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YnOcY5Ko; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnOcY5Ko"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84f38f3b36eso2726429b3a.1
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029967; x=1787634767; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q4geQjhEDcsmapDV/ZLiGXecFcqlx1SUv1jdKP/WSd8=;
        b=YnOcY5KoWVhiPavsFHITZX6Lh5OuR00A7OTxJeSGOMPRvQ0UyUS0PFNGSRRQl17/9a
         aStyeSnU3oHSOznm/hQmzhW89WDNDv6h5GW7lNIbEBZFrl4lCUs28EsH1PblPpvSRrJe
         RAPJSUge9XGAczSHZNt9C3NEK667kxLlhfz+y+8R8mOykCsJreKWWB/WebO1whTZItOz
         yF/fgRPQP+4pWsFblkuueEjnhiR/lXzoPCkpSygpe7x+Bsz54UJcujScRo2GOn/DG4X+
         IxRrcZIXB0KNSqtM31ByuwXMdTVAmS1BMQzbj/ukkcw/y99OQRdN8b9DNwJx+JSrPspE
         3owQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029967; x=1787634767;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q4geQjhEDcsmapDV/ZLiGXecFcqlx1SUv1jdKP/WSd8=;
        b=UM1CExJJhQbzVEfiz1SDv0mQn+lcwAyuAylCT7qM/iuif12y6ZXhdJzARVDkQ9u8x9
         Ti3RpiUjIYixhFpMuvXWrdeaC9tn05xsC2X0wq8EssTwiSrsev4s1MbkimwCD8sLpdIR
         ceAzXhB0eZtC1qJ6u7a59Bmsxvho/U6L1vi10vT67fXmbNwvRZ3u/4jsb8wZ4yPhC01F
         x48UIjxEGhqxWiajDlp8Jm+I96mflih3dxgzh9AHlaAgrMRYmeqy6vEYMPVVJDsFJMcP
         Zu6Oq/A+UqGKBckYArRA7hDaQBboUZ+6rjxs7s8CpJcZRdwH0kkN8kQ6bZdEs3e5KExa
         4dGg==
X-Forwarded-Encrypted: i=1; AHgh+Rqs+nnKUTNYwmPCS+pbf+9kMFu4b8skt4QPPSfAU6cVPrHymDd4xcgFQHG1uGqyfaH1fdwfcyxBjPk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyW4l5PxTNfsdGyEBwt4ap5C6VVabYyjlx6rsRweKF8qnwGTH3V
	zmi80FNyIwd/HcBGRMhDouH3HuDwwo7bWkVOpBAQRyuL2DiMqceXV+7+
X-Gm-Gg: AR+sD13GwxJ0nESRZnzjyiuIDZZClwWdBhsk9ApPaGaBYLe0ayuOYO8mxplhRMeNn/X
	h9fW0wnFCbGpTsHn2jQF8Li5N3Blpjp3EflE5hxk1XOSgBKk4pBwwwrp8lAMt+2UtVqXHVlU17Y
	rdwajQgXi0sLcOjnE0WK1ckgnYGj7jMykMeWb204t1EBxu/bSv0e8flCOTErZnXRDCMHnKQYU6A
	tZtzPXXrngUJHSOldJeDRhJ602qYrq8+z2mPiMzDrBigJa5LTRFK5lYdnw/MbcDwLHT9Wd7Zimq
	aJ+GwOWnQjq4ah1oLZl+q+Gnjo7AcsXUs1lECi7Z+dAcqA/1hN3jQXI9462saIoP7CZKWEVxRI2
	BQM2wJJacUU+xv1/B+dMbqmMILCljbgjoszRXh30ayMJakKL2aJmwjePz30s/VxInhDG75lOHXh
	VnbYddThJ92yIqpukMT30CqfIeBpL1PUuKHMjvm9EOLVuWiD1l5Du0ofYV7y3sSvvoZQ==
X-Received: by 2002:a05:6a00:1256:b0:845:e04b:565f with SMTP id d2e1a72fcca58-84fde122876mr28993614b3a.14.1787029966608;
        Mon, 17 Aug 2026 22:12:46 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:46 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:25 -0700
Subject: [PATCH RFC v2 10/13] hw/virtio/vhost-user: handle data movement
 with shadow vqs
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-10-948aae960abb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=14307;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=bMPw0FwBRsEunQYzzG6BOXyVL5rIEfi5TeDivlNmsxo=;
 b=l+69CvZv18/AgSDA22GB8a6pNf2J8er2Y8bngQir+ldlLYyWyDZABBr7A+7tpX8JE+L3eSUAL
 kmnpQ+dTI9/DssO6GBTKNuQcJZwVTjSAiT/L4vaKujaE7mwosTy1fcb
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
 hw/virtio/vhost-shadow-virtqueue.c |   2 +-
 hw/virtio/vhost-shadow-virtqueue.h |   1 +
 hw/virtio/vhost-user.c             | 292 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 286 insertions(+), 9 deletions(-)

diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index f54a61439a..80b0828d7c 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -350,7 +350,7 @@ int vhost_svq_add(VhostShadowVirtqueue *svq, const struct iovec *out_sg,
 }
 
 /* Convenience wrapper to add a guest's element to SVQ */
-static int vhost_svq_add_element(VhostShadowVirtqueue *svq,
+int vhost_svq_add_element(VhostShadowVirtqueue *svq,
                                  VirtQueueElement *elem)
 {
     return vhost_svq_add(svq, elem->out_sg, elem->out_num, elem->out_addr,
diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
index 1e0cc9e5e4..10a8db6c39 100644
--- a/hw/virtio/vhost-shadow-virtqueue.h
+++ b/hw/virtio/vhost-shadow-virtqueue.h
@@ -183,6 +183,7 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
 
 void vhost_svq_free(gpointer vq);
 void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr);
+int vhost_svq_add_element(VhostShadowVirtqueue *svq, VirtQueueElement *elem);
 
 G_DEFINE_AUTOPTR_CLEANUP_FUNC(VhostShadowVirtqueue, vhost_svq_free);
 
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index ace328f5eb..ca3aaf7a07 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -1364,6 +1364,231 @@ static int init_isolation_regions(struct vhost_dev *dev,
     return 0;
 }
 
+static inline int vhost_user_get_reg_idx(struct vhost_dev *dev, hwaddr gpa)
+{
+    int i;
+    struct vhost_memory_region *reg;
+
+    for (i = 0; i < dev->mem->nregions; i++) {
+        reg = dev->mem->regions + i;
+
+        if (gpa >= reg->guest_phys_addr &&
+            reg->guest_phys_addr + reg->memory_size > gpa) {
+            return i;
+        }
+    }
+
+    return -1;
+}
+
+static int vhost_user_svq_handle_used(VhostShadowVirtqueue *svq,
+                                      VirtQueueElement *elem,
+                                      void *opaque)
+{
+    uint64_t offset;
+    void *dst;
+    void *src;
+    size_t len, rem;
+    void *reg_last_addr;
+    void *reg_first_addr;
+    struct vhost_dev *dev = opaque;
+    struct vhost_user *u = dev->opaque;
+    void *shmem_addr = u->iso_mem_ctx.shared_mem_addr;
+    size_t shmem_size = u->iso_mem_ctx.size;
+    const DMAMap *map;
+    DMAMap needle;
+    int reg_idx;
+
+    for (int i = 0; i < elem->in_num; i++) {
+        needle.translated_addr = elem->in_addr[i];
+        needle.size = elem->in_sg[i].iov_len - 1;
+        map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
+
+        if (!map) {
+            return -EFAULT;
+        }
+
+        offset = needle.translated_addr - map->translated_addr;
+        src = (void *)int128_get64(int128_add(int128_make64(map->iova +
+                       offset), u->iso_mem_ctx.iso_iova_offset));
+        dst = elem->in_sg[i].iov_base;
+        len = elem->in_sg[i].iov_len;
+
+        /* Confirm that buffer range is fully within iso region */
+        if ((uint64_t)src + len - 1 > (uint64_t)shmem_addr + shmem_size - 1 ||
+            (uint64_t)src + len <= (uint64_t)src ||
+            (uint64_t)src < (uint64_t)shmem_addr) {
+
+            return -EFAULT;
+        }
+
+        reg_idx = vhost_user_get_reg_idx(dev, needle.translated_addr);
+        if (reg_idx < 0) {
+            return -EFAULT;
+        }
+
+        reg_first_addr = (void *)dev->mem->regions[reg_idx].userspace_addr;
+        reg_last_addr = (void *)(dev->mem->regions[reg_idx].userspace_addr +
+                        dev->mem->regions[reg_idx].memory_size - 1);
+
+        /* Confirm that hva from elem matches expected vhost memory region */
+        if (dst < reg_first_addr || dst > reg_last_addr) {
+            return -EFAULT;
+        }
+
+        /*
+         * copy buffer contents from shared memory into guest memory. If
+         * the buffer extends across region boundaries, it must be split and
+         * copied to the correct regions.
+         */
+        while ((uint64_t)reg_last_addr - (uint64_t)dst + 1 < len) {
+            rem = ((uint64_t)dst + len - 1) - (uint64_t)reg_last_addr;
+            len -= rem;
+            memcpy(dst, src, len);
+
+            reg_idx++;
+            if (reg_idx >= dev->mem->nregions) {
+                return -EFAULT;
+            }
+
+            src = (void *)((uint64_t)src + len);
+            dst = (void *)dev->mem->regions[reg_idx].userspace_addr;
+            len = rem;
+            reg_first_addr = (void *)dev->mem->regions[reg_idx].userspace_addr;
+            reg_last_addr = (void *)(dev->mem->regions[reg_idx].userspace_addr +
+                            dev->mem->regions[reg_idx].memory_size - 1);
+        }
+
+        memcpy(dst, src, len);
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
+    void *dst;
+    void *src;
+    void *reg_first_addr;
+    void *reg_last_addr;
+    size_t len, rem;
+    struct vhost_dev *dev = opaque;
+    struct vhost_user *u = dev->opaque;
+    void *shmem_addr = u->iso_mem_ctx.shared_mem_addr;
+    size_t shmem_size = u->iso_mem_ctx.size;
+    int reg_idx;
+
+    for (int i = 0; i < elem->out_num; i++) {
+        needle.translated_addr = elem->out_addr[i];
+        needle.size = elem->out_sg[i].iov_len - 1;
+        map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
+
+        if (!map) {
+            return -EFAULT;
+        }
+
+        offset = needle.translated_addr - map->translated_addr;
+        dst = (void *)int128_get64(int128_add(int128_make64(map->iova +
+                       offset), u->iso_mem_ctx.iso_iova_offset));
+        src = elem->out_sg[i].iov_base;
+        len = elem->out_sg[i].iov_len;
+
+        /* Confirm that buffer range is fully within iso region */
+        if ((uint64_t)dst + len - 1 > (uint64_t)shmem_addr + shmem_size - 1 ||
+            (uint64_t)dst + len <= (uint64_t)dst ||
+            (uint64_t)dst < (uint64_t)shmem_addr) {
+
+            return -EFAULT;
+        }
+
+        reg_idx = vhost_user_get_reg_idx(dev, needle.translated_addr);
+        if (reg_idx < 0) {
+            return -EFAULT;
+        }
+
+        reg_first_addr = (void *)dev->mem->regions[reg_idx].userspace_addr;
+        reg_last_addr = (void *)(dev->mem->regions[reg_idx].userspace_addr +
+                        dev->mem->regions[reg_idx].memory_size - 1);
+
+        /* Confirm that hva from elem matches expected vhost memory region */
+        if (src < reg_first_addr || src > reg_last_addr) {
+            return -EFAULT;
+        }
+
+        /*
+         * copy buffer contents from guest memory into shared memory. If
+         * the buffer extends across region boundaries, it must be split and
+         * copied from the correct regions.
+         */
+        while ((uint64_t)reg_last_addr - (uint64_t)src + 1 < len) {
+            rem = ((uint64_t)src + len - 1) - (uint64_t)reg_last_addr;
+            len -= rem;
+            memcpy(dst, src, len);
+
+            reg_idx++;
+            if (reg_idx >= dev->mem->nregions) {
+                return -EFAULT;
+            }
+
+            dst = (void *)((uint64_t)dst + len);
+            src = (void *)dev->mem->regions[reg_idx].userspace_addr;
+            len = rem;
+
+            reg_first_addr = (void *)dev->mem->regions[reg_idx].userspace_addr;
+            reg_last_addr = (void *)(dev->mem->regions[reg_idx].userspace_addr +
+                            dev->mem->regions[reg_idx].memory_size - 1);
+        }
+
+        memcpy(dst, src, len);
+    }
+
+    vhost_svq_add_element(svq, elem);
+
+    return 0;
+}
+
+static int vhost_user_get_vq_index(struct vhost_dev *dev, int idx)
+{
+    assert(idx >= dev->vq_index && idx < dev->vq_index + dev->nvqs);
+
+    return idx;
+}
+
+static int vhost_user_svqs_vring_map(struct vhost_dev *dev)
+{
+    int ret;
+    struct vhost_user *u = dev->opaque;
+    void *vring_base = u->iso_mem_ctx.vring_hva_addr;
+    uint64_t vring_last = (uint64_t)vring_base +
+                          u->iso_mem_ctx.vring_region_size - 1;
+
+    for (int i = 0; i < u->iso_mem_ctx.shadow_vqs->len; i++) {
+        vhost_user_get_vq_index(dev, dev->vq_index + i); /* bounds checking */
+
+        VirtQueue *vq = virtio_get_queue(dev->vdev, dev->vq_index + i);
+        VhostShadowVirtqueue *svq =
+            g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, i);
+
+        assert((uint64_t)vring_base +
+               vhost_svq_vring_total_size(dev->vdev, vq) - 1 <= vring_last);
+
+        vhost_svq_set_base_addr(svq, vring_base);
+        ret = vhost_svq_start(svq, dev->vdev, vq, u->iso_mem_ctx.tree);
+        if (ret < 0) {
+            return ret;
+        }
+        vring_base = (void *)((uint64_t)vring_base +
+                     vhost_svq_vring_total_size(dev->vdev, vq));
+    }
+
+    return 0;
+}
+
 static int vhost_user_set_mem_table(struct vhost_dev *dev,
                                     struct vhost_memory *mem)
 {
@@ -1407,6 +1632,11 @@ static int vhost_user_set_mem_table(struct vhost_dev *dev,
             return ret;
         }
 
+        ret = vhost_user_svqs_vring_map(dev);
+        if (ret < 0) {
+            return ret;
+        }
+
         ret = vhost_user_write(dev, &msg, fds, fd_num);
         if (ret < 0) {
             return ret;
@@ -1763,13 +1993,6 @@ static int vhost_set_vring_file(struct vhost_dev *dev,
     return 0;
 }
 
-static int vhost_user_get_vq_index(struct vhost_dev *dev, int idx)
-{
-    assert(idx >= dev->vq_index && idx < dev->vq_index + dev->nvqs);
-
-    return idx;
-}
-
 static int vhost_user_set_vring_kick(struct vhost_dev *dev,
                                      struct vhost_vring_file *file)
 {
@@ -1875,6 +2098,8 @@ static int vhost_user_set_vring_err(struct vhost_dev *dev,
 static int vhost_user_set_vring_addr(struct vhost_dev *dev,
                                      struct vhost_vring_addr *addr)
 {
+    struct vhost_user *u = dev->opaque;
+    ptrdiff_t offset = u->iso_mem_ctx.iso_iova_offset;
     VhostUserMsg msg = {
         .hdr.request = VHOST_USER_SET_VRING_ADDR,
         .hdr.flags = VHOST_USER_VERSION,
@@ -1882,6 +2107,25 @@ static int vhost_user_set_vring_addr(struct vhost_dev *dev,
         .hdr.size = sizeof(msg.payload.addr),
     };
 
+    if (u->user->memory_isolation) {
+        int svq_idx;
+        VhostShadowVirtqueue *svq;
+        struct vhost_vring_addr svq_addr;
+
+        vhost_user_get_vq_index(dev, addr->index); /* bounds checking */
+        svq_idx = addr->index - dev->vq_index;
+        svq = g_ptr_array_index(u->iso_mem_ctx.shadow_vqs,
+                                                      svq_idx);
+
+        svq_addr.avail_user_addr = (uint64_t)(uintptr_t)svq->vring.avail -
+                                   offset;
+        svq_addr.desc_user_addr = (uint64_t)(uintptr_t)svq->vring.desc - offset;
+        svq_addr.used_user_addr = (uint64_t)(uintptr_t)svq->vring.used - offset;
+        svq_addr.index = addr->index;
+
+        msg.payload.addr = svq_addr;
+    }
+
     /*
      * wait for a reply if logging is enabled to make sure
      * backend is actually logging changes
@@ -2857,13 +3101,18 @@ static int vhost_user_postcopy_notifier(NotifierWithReturn *notifier,
     return 0;
 }
 
+static const VhostShadowVirtqueueOps vhost_user_svq_ops = {
+    .avail_handler = vhost_user_svq_handle_avail,
+    .used_callback = vhost_user_svq_handle_used
+};
+
 static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user *u)
 {
     /*Modified from vhost-vdpa*/
     u->iso_mem_ctx.shadow_vqs = g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
     for (int i = 0; i < dev->nvqs; i++) {
         VhostShadowVirtqueue *svq;
-        svq = vhost_svq_new(NULL, NULL);
+        svq = vhost_svq_new(&vhost_user_svq_ops, dev);
         g_ptr_array_add(u->iso_mem_ctx.shadow_vqs, svq);
     }
 }
@@ -3562,8 +3811,35 @@ void vhost_user_async_close(DeviceState *d,
     }
 }
 
+static void vhost_user_svqs_stop(struct vhost_dev *dev)
+{
+    struct vhost_user *u = dev->opaque;
+    for (int i = 0; i < u->iso_mem_ctx.shadow_vqs->len; i++) {
+        vhost_svq_stop(g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, i));
+    }
+}
+
 static int vhost_user_dev_start(struct vhost_dev *dev, bool started)
 {
+    struct vhost_user *u = dev->opaque;
+    if (u->user->memory_isolation) {
+        if (vhost_dev_has_iommu(dev)) {
+            error_report("Memory isolation is not supported with IOMMU enabled."
+                         "Please disable one and try again");
+            return -1;
+        }
+
+        if (virtio_vdev_has_feature(dev->vdev, VIRTIO_F_RING_PACKED)) {
+            error_report("Memory isolation is not supported with packed"
+                         "vrings.  Please use split vrings");
+            return -1;
+        }
+
+        if (!started) {
+            vhost_user_svqs_stop(dev);
+        }
+    }
+
     if (!vhost_user_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_STATUS)) {
         return 0;
     }

-- 
2.43.0

