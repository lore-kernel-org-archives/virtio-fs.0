Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E733D0939
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845884; cv=none; b=g+1ZQ2pi5PRH5Bvm2roKP+kOSrx6J2ppq7r6x7hAyjSAPIUxgHcQumoifDqt1eSj+CAUkM1YbjyeN8In0oKCxqhZfQA6ThAnCZASuq2wwHdm9KxTD+dYPD1EDx61EN83fWOlP0b+vjSwXU72p+SOOEEWvJAIuM5mNWqwJYIsF1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845884; c=relaxed/simple;
	bh=wDscEQxvQqYDZSfNPahD+DjyKJ1NxmTiWn45TwBb6QE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bkZl0mCYmErGirpxFmK6iHMc3buLYyhcC66OCN2og4Meoo5gYAHJXlLBy1R8CxHMIj/Z/DdEZjL31vu7vXlEMHClxI8EuKKhy+sMTIafRaEIQjenNjxFVic/EOiLgphqxv8aY/SxPpbZe5iWQuCbsVly0KPPLmmMVzySZSTKLOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r4mtHB/8; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r4mtHB/8"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-80dc4a68e4aso9924917b3.0
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845882; x=1785450682; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K2yffjOSvF7DKJc73OqN7e50BGgio3XnC3khWPJsclE=;
        b=r4mtHB/8at7jxnDgmZSDiZQHkUb/x6+s17Gep9yN+vn0OQXL/s3orBiul6Ks1eyyqn
         7CWe+yArbbCGlaGSgKjtAd180h2t9lnaQX6gDaeW6T6cA+ex+xsXB+fZUGh/LnRcBUUD
         jzFBebahjgqN9D0AlTXqo5w2RMWyw4+8ujNcJ236BTD8erFKoItDj67ZRyFGLsqFijOB
         KvP1Q95AsT3Yk+riHlBsdPxeftWhyjp5EKfywA5laSRrmz7MGL1+qaPXtY6vJwa6getU
         CPkqBZbKsrUcdtZuyORtcI6iFZV5cdBXWyjPo9NwzacAoOoaA/fRAJEw0zjezYeK1fq8
         HIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845882; x=1785450682;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K2yffjOSvF7DKJc73OqN7e50BGgio3XnC3khWPJsclE=;
        b=hKD5vnHpOXGbPU9IsfWucJMN7ZSjTbDhuc/c3EDcJ72P6laaandEn5iQZ0zptAcqok
         sopItXK+G+KT8y1C/qPsthPabXo8gMUElqLNtb9Y5KnpZFbLxzihODZZQVggj2PJnof/
         NxicyjwCb4koVQdYr9QkRwBWnn1zBeKfVbsbviwFrFiCTBKqO14CVPowUtK5uCvR4HlK
         nDmHn10fpPcRrVJlLBgrh7j5Bug72MLkwit/AuBqM/bLQ9m1wwl5x4wcqnRdHb4PMMTZ
         3TZp5+4hZQDQjqfCnZoK1AUeUbscrFoNMwHDNRIq1mWi/RRhX9kQZjnM92yWQ5/LXlVN
         o6IQ==
X-Forwarded-Encrypted: i=1; AHgh+RoK1RAdWzfTP9Ez7G2YCRZA/y/u+6ZU1HlUcYQlSpFcckr0htFB/3q+TnZ778evqtmeBu59oOLajTo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuMTDaNolHXKDj+l0z5PiUd6Phavlp+EN8kxMhpYlC1nGi1+n+
	mAwHRTPGYI2hDxmQgdbyE5P3k2V3joJHhkSRbkJJF8dJOu+PRijwWbrH
X-Gm-Gg: AR+sD105jWNqjDQPwRT0ac58KEipvjFl9pl6xmRkBjvuLICbyeSAMgHLaM3LBKu5Spc
	BOfjc8j4LI9akKaNykZmsTfkaoyaDWm2knsZgULe1XU8nbHZlSV/4LfKSiJaC46Xpmwluf09wRF
	hOpS6GiXIRoV6DYXBdY00p58NaNS1RKJ8tT88tjZtDDedVkbAs1fFY/p1a8zQlIj8niUTorx/Ph
	x5lft5n8gcv8070kzjjbufcPGhR/N3gNzyWbGANR/1nYGh8wJJfFDQkw2ktyRqPrE3V9y0vcRyJ
	SmmbDczu1P1vufkGclau3+liExqeWNSRt/T04ak3VPJvMzNnszY6uCQHIRG95I/YDywtr5pq6Tl
	RMHXKyEdz93vJ77VULWIRR0ujiPsp7wJswseiplDYvYX47SOquu0Yc2s94gRDNCpdlpFu0LWp7p
	ungBQ3gps=
X-Received: by 2002:a05:690c:6f0c:b0:80d:66b2:852 with SMTP id 00721157ae682-81f4c30bf1bmr16154247b3.44.1784845881639;
        Thu, 23 Jul 2026 15:31:21 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:21 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:10 -0700
Subject: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=6829;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=wDscEQxvQqYDZSfNPahD+DjyKJ1NxmTiWn45TwBb6QE=;
 b=CJBOJE+xeUrGOcOb0j1TMC/d/upLE8YRQ1ckKJaYNdC/WEZqJNmR6hP/uMpLdIVbgQQT72fZk
 /+ilUmq3t0wBqEgT68PxM+KMmkpBKIL4XbZU2459hbbQ9BZRoTOIlhX
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

If memory isolation mode is active for the vhost-user device adds
features to:
- Gather the size required for bounce buffers and vrings in shared
  isolation region
- Allocate the required space in an anonymous file
- Create a vhost-iova-tree with space to map entire isolation region
- Map guest memory regions and shared vrings into the tree
- Release these resources upon backend cleanup

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-user.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index f296b63fb9..710cf966f8 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -18,6 +18,7 @@
 #include "hw/virtio/vhost-backend.h"
 #include "hw/virtio/virtio.h"
 #include "hw/virtio/virtio-net.h"
+#include "hw/virtio/vhost-iova-tree.h"
 #include "chardev/char-fe.h"
 #include "io/channel-socket.h"
 #include "system/kvm.h"
@@ -25,6 +26,7 @@
 #include "qemu/main-loop.h"
 #include "qemu/uuid.h"
 #include "qemu/sockets.h"
+#include "qemu/memfd.h"
 #include "system/runstate.h"
 #include "system/cryptodev.h"
 #include "migration/postcopy-ram.h"
@@ -320,6 +322,13 @@ static VhostUserMsg m __attribute__ ((unused));
 /* The version of the protocol we support */
 #define VHOST_USER_VERSION    (0x1)
 
+typedef struct IsolationRegion {
+    uint64_t base_addr;
+    uint64_t vring_base_addr;
+    uint64_t size;
+    int iso_fd;
+} IsolationRegion;
+
 struct vhost_user {
     struct vhost_dev *dev;
     /* Shared between vhost devs of the same virtio device */
@@ -353,6 +362,10 @@ struct vhost_user {
      * by the backend (see @features).
      */
     uint64_t protocol_features;
+
+    /* Isolated memory data*/
+    struct IsolationRegion iso_memory;
+    VhostIOVATree *iso_iova_tree;
 };
 
 struct scrub_regions {
@@ -1109,6 +1122,121 @@ static int vhost_user_set_mem_table_postcopy(struct vhost_dev *dev,
     return 0;
 }
 
+/* TODO: Is there any notifier cleanup required here?*/
+static void cleanup_isolation_regions(struct vhost_dev *dev)
+{
+    struct vhost_user *u = dev->opaque;
+    if (u->iso_memory.base_addr) {
+        vhost_iova_tree_delete(u->iso_iova_tree);
+        u->iso_iova_tree = NULL;
+        memset(&u->iso_memory, 0, sizeof(IsolationRegion));
+        qemu_memfd_free((gpointer) u->iso_memory.base_addr, u->iso_memory.size,
+                         u->iso_memory.iso_fd);
+        u->iso_memory.base_addr = 0;
+    }
+}
+
+__attribute__((unused))
+static int init_isolation_regions(struct vhost_dev *dev,
+                                  VhostUserMsg *msg,
+                                  int *fds, size_t *fd_num)
+{
+    Error *err = NULL;
+    struct vhost_user *u = dev->opaque;
+    uint32_t nregions = dev->mem->nregions;
+    uint64_t buffer_reg_size = 0;
+    DMAMap newEntry = {
+        .perm = IOMMU_RW
+    };
+    g_autoptr(GArray) buffer_regions =
+        g_array_new(FALSE, TRUE, sizeof(DMAMap));
+
+    msg->hdr.request = VHOST_USER_SET_MEM_TABLE;
+
+    /* In case of reset, clear old regions*/
+    if (u->iso_memory.base_addr != 0) {
+        cleanup_isolation_regions(dev);
+        vhost_iova_tree_delete(u->iso_iova_tree);
+    }
+
+    /* Gather information for bounce buffers to be mapped */
+    for (int i = 0; i < nregions; i++) {
+        struct vhost_memory_region *dev_region = &dev->mem->regions[i];
+        hwaddr size = ROUND_UP(dev_region->memory_size,
+                      qemu_real_host_page_size());
+        newEntry.translated_addr = dev_region->guest_phys_addr;
+        newEntry.size = size - 1;
+        buffer_reg_size += size;
+        g_array_append_val(buffer_regions, newEntry);
+    }
+
+    int num;
+    size_t desc_size;
+    size_t avail_size;
+    size_t driver_area_size;
+    size_t device_area_size;
+    size_t total_vring_size = 0;
+    size_t total_mmap_size;
+
+    /* Get space required for all vrings */
+    for (int j = 0; j < dev->nvqs; j++) {
+        num = virtio_queue_get_num(dev->vdev, dev->vq_index + j);
+        desc_size = sizeof(vring_desc_t) * num;
+        avail_size = offsetof(vring_avail_t, ring[num]) +
+                        sizeof(uint16_t);
+        driver_area_size = ROUND_UP(desc_size + avail_size,
+                            qemu_real_host_page_size());
+        device_area_size = ROUND_UP(offsetof(vring_used_t, ring[num]) +
+                                    sizeof(uint16_t),
+                                    qemu_real_host_page_size());
+        total_vring_size += driver_area_size + device_area_size;
+    }
+
+    total_mmap_size = buffer_reg_size + total_vring_size;
+
+    /* Allocate and map an anonymous file to hold the isolation region */
+    u->iso_memory.base_addr = (uint64_t) qemu_memfd_alloc("iso_r",
+                              total_mmap_size,
+                              F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL,
+                              &u->iso_memory.iso_fd, &err);
+    u->iso_memory.size = total_mmap_size;
+
+    if (err) {
+        error_report_err(err);
+        cleanup_isolation_regions(dev);
+        return -1;
+    }
+
+    uint64_t last_addr = int128_get64(int128_add(u->iso_memory.base_addr,
+                                                 total_mmap_size - 1));
+
+    /*
+     * Instantiates iova tree sized to map bounce buffers and vrings to the
+     * isolation region in host va.
+     */
+    u->iso_iova_tree = vhost_iova_tree_new(u->iso_memory.base_addr, last_addr);
+
+    assert(&u->iso_memory.iso_fd >= 0);
+    DMAMap *map;
+    DMAMap vring_map = {
+        .perm = IOMMU_RW,
+        .size = total_vring_size - 1,
+        /*vrings are allocated on tree first, so will be assigned base addr*/
+        .translated_addr = u->iso_memory.base_addr
+    };
+
+    vhost_iova_tree_map_alloc(u->iso_iova_tree, &vring_map,
+                              vring_map.translated_addr);
+    u->iso_memory.vring_base_addr = vring_map.iova;
+    for (int i = 0; i < buffer_regions->len; i++) {
+        map = &g_array_index(buffer_regions, DMAMap, i);
+        vhost_iova_tree_map_alloc_gpa(u->iso_iova_tree, map,
+                                      map->translated_addr);
+    }
+
+    return 0;
+}
+
 static int vhost_user_set_mem_table(struct vhost_dev *dev,
                                     struct vhost_memory *mem)
 {
@@ -2681,6 +2809,7 @@ static int vhost_user_backend_cleanup(struct vhost_dev *dev)
     g_free(u->region_rb_offset);
     u->region_rb_offset = NULL;
     u->region_rb_len = 0;
+    cleanup_isolation_regions(dev);
     g_free(u);
     dev->opaque = 0;
 

-- 
2.43.0

