Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5AD3D0905
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029960; cv=none; b=sZJ0Y2NqrYl90NYypnmyGpePR9lomHx7wa55PswZpAYwuAYtySsLSBgvwWh/GOacj7Pg3e8JvwCp8Jyyx/3WxOeWLz5r9dhIweRzKNM0SStIt4MJPfK4wtywvwNOFEWsx/n9mIGsIC7pDiJqSxuB3IH4RNgXT0GgJi1N24pF+9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029960; c=relaxed/simple;
	bh=Y8FMqK8tl2z1lXfprKV5PVmmovyeXR0vRWxv7yRJE+M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HB9/KufMHVEut/Tvnc96vHw6LZd2RYqLAltT3ttrB7WL4gDJBucOy5jxoY4QVmMsatTBb/TW6YTa1kISj3plQaWT5wVyP0zKgsqdmpIgDzZZZwyTZHS+mfLQb6FBrYDTAzfT3pENv6rOTCM7rg9Om/A6p1ASLNJgZIMh9Omiy2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LsErPeke; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LsErPeke"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84a4d8fd6ecso4335611b3a.1
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029958; x=1787634758; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8wuYe3aPv+YJ4aJ8Ua2kMF85cw3TlH8w6CZl7jDCufE=;
        b=LsErPekejqH+vEeC2jhMCcc/P5tDVpm9h9xv7i/MxxQeCJBSkD9gUPE1ayoxxtwG8F
         IOOanL1uKLUNH2uymfvfMlSs3vRR501sgqWQLth96tylr4XHP3Ypudq2UvRofT9mVfKN
         UTLOXGX3YBvrWWvGb3Ix59e8yfRn0uNaA6CTbZ1iIzGa63PU+RHbB2ba77H+uGx6VJ2v
         EsMg+jhUZt0YNVPhacE5oFoTI9b6HIK4PKsW3Vf81wjaUfq/Lznt17Q6Veim9422qTiz
         8TSUbfQ3u4S7svMSadSgIPbKv427czT6oCMewRazUOMLhvY/oBg4taN1UHZfcoGncqTN
         ZxHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029958; x=1787634758;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8wuYe3aPv+YJ4aJ8Ua2kMF85cw3TlH8w6CZl7jDCufE=;
        b=B2f+BT25XmU/r+W3VRUUHI2G8iJBPEWdNdiDO499nairNO4SAyiQmuqXq6CrlEAS4F
         gullcS6FR94BUK3yqOmQtprVgFvHxdfuLstDkbh7ppTniidoitIjfbBdKgj6KMcqH36q
         OzXAPTqt4/F5fKPCpPAsegkmKk6/X8GI4prY2Lq9Rx835lncuUSJqgXxEp764dOPGArB
         qvWX6k/is4nvMHfeb/O7UyMZHtztDNIxqyNXZP+wxJQtCJ3bC8TgcXoyuldNgSkiPAn0
         3bNIuQzSFmBiTeXSNOC+wWXpWYIrDld99IzQ2PW06QPwfRXQELw9bDswFSyZix8+RJck
         aZgw==
X-Forwarded-Encrypted: i=1; AHgh+Rroo419P+adFdE/S35+u6IzO+P+FicYypOMVBLRtGTkZa3BPfjVs8Hk35SKlQldghUW9ctJAr2ii3c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7QOwKOQjQfmJbTINX6MICXQvg8fCPDq89L0/Uh8KHAIRkbhDo
	l3CQRe7QBs+81+6TnZ+7EE6yOoJatsE4RVjmcuRftotRluAAr55AdDOr
X-Gm-Gg: AR+sD11SbKUdWjMN2IzbZvYhHkfB89ayMLIMcPNLyu0XFu2WFdur8HDKPOfWSSvjoxJ
	JlPbMKMBB/9x6A2VmUJIqD0wPTwysIYAviadaQ2IM+cUooTHyopt9Q5HhkJp8NxP8h755KoylpV
	f+j4/dhkSrCYZ/DaIcukeTDZuYUW+t41lOlnwdKCW9hA6ycN/cEKj4jpq6wOfORcg1EuA49VvFi
	FeD+OsfwTpKhsSAVSVOqDx3xY5RdeKT/XL2KnsD9lWGIaTSq6wdhVLEw1edY4ShMJQYCuCuqFgi
	2AX57m8QBFnPqYp/33aPXgHC4FM8SXOxaqoI5R14jslEwxnLd76AYap3ezfzn5JgovQaJQPRRtZ
	JEIIThY1/l70uQZtXQu9rqaVTxiQ9jGix/xYvKzubctUJ5e6i9vi/iTXvKa9yUz+IJP9JM4wOFt
	rjDsgqOzKb4olWifX7iuNX+MO2jMznP3t+pczvINWxFsAooWCromUOnn9a7HJIlhmtVA==
X-Received: by 2002:a05:6a00:4193:b0:845:e9e8:645c with SMTP id d2e1a72fcca58-84fde11e46amr33116869b3a.6.1787029958217;
        Mon, 17 Aug 2026 22:12:38 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:37 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:22 -0700
Subject: [PATCH RFC v2 07/13] hw/virtio/vhost-user: create isolation region
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-7-948aae960abb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=7145;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=Y8FMqK8tl2z1lXfprKV5PVmmovyeXR0vRWxv7yRJE+M=;
 b=DaG7i69Lze5UQiIRdjFrHrvlHhMlGExbU4HaxptGfmc+ci4x+2veNzCD3oqlLHpolAAoJQUd6
 zh60ilHkTbrAZHEawyGYCD8tg5ozrk3Hu0VChDUafW8BKSBtXlO+1F0
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
 hw/virtio/vhost-user.c | 136 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 1c003e4d9d..7e9233e174 100644
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
@@ -320,6 +322,17 @@ static VhostUserMsg m __attribute__ ((unused));
 /* The version of the protocol we support */
 #define VHOST_USER_VERSION    (0x1)
 
+/* Memory region shared with back-end when memory-isolation is active */
+typedef struct {
+    void *shared_mem_addr; /* mapped shared memory */
+    VhostIOVATree *tree; /* controls mapping of regions into IOVA space */
+    void *vring_hva_addr; /* beginning of vring region in shared memory */
+    size_t vring_region_size; /* amount of shared memory reserved for vrings */
+    size_t size; /* size of the mapped shared memory */
+    int fd; /* descriptor of anonymous file backing shared iso region */
+    Int128 iso_iova_offset; /* translation from IOVA to hva of iso region */
+} IsolationModeCtx;
+
 struct vhost_user {
     struct vhost_dev *dev;
     /* Shared between vhost devs of the same virtio device */
@@ -353,6 +366,9 @@ struct vhost_user {
      * by the backend (see @features).
      */
     uint64_t protocol_features;
+
+    /* Data specfic to isolated memory mode */
+    IsolationModeCtx iso_mem_ctx;
 };
 
 struct scrub_regions {
@@ -1112,6 +1128,125 @@ static int vhost_user_set_mem_table_postcopy(struct vhost_dev *dev,
     return 0;
 }
 
+static void cleanup_isolation_regions(struct vhost_dev *dev)
+{
+    struct vhost_user *u = dev->opaque;
+    if (u->iso_mem_ctx.shared_mem_addr) {
+        vhost_iova_tree_delete(u->iso_mem_ctx.tree);
+        qemu_memfd_free(u->iso_mem_ctx.shared_mem_addr,
+                        u->iso_mem_ctx.size,
+                        u->iso_mem_ctx.fd);
+        memset(&u->iso_mem_ctx, 0, sizeof(IsolationModeCtx));
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
+
+    g_autofree DMAMap *buffer_regions = g_new0(DMAMap, nregions);
+    size_t buffer_reg_size = 0;
+    size_t total_vring_size = 0;
+    size_t total_mmap_size;
+    char *reg_name;
+    uint64_t first_IOVA_addr;
+    uint64_t last_IOVA_addr;
+    DMAMap *map;
+    DMAMap vring_map;
+    int r;
+
+    msg->hdr.request = VHOST_USER_SET_MEM_TABLE;
+
+    /* In case of reset, clear old regions */
+    cleanup_isolation_regions(dev);
+
+    /* Gather information for bounce buffers to be mapped */
+    for (u_int32_t i = 0; i < nregions; i++) {
+        hwaddr size = ROUND_UP(dev->mem->regions[i].memory_size,
+                      qemu_real_host_page_size());
+        buffer_regions[i].size = size - 1;
+        buffer_regions[i].perm = IOMMU_RW;
+
+        buffer_reg_size += size;
+    }
+
+    /* Get space required for all vrings */
+    for (int i = 0; i < dev->nvqs; i++) {
+        VirtQueue *vq = virtio_get_queue(dev->vdev, dev->vq_index + i);
+        total_vring_size += vhost_svq_vring_total_size(dev->vdev, vq);
+    }
+
+    total_mmap_size = buffer_reg_size + total_vring_size;
+    u->iso_mem_ctx.size = total_mmap_size;
+
+    /* Allocate and map an anonymous file to hold the isolation region */
+    reg_name = g_strconcat("iso_mem_", dev->vdev->name, NULL);
+    u->iso_mem_ctx.shared_mem_addr = qemu_memfd_alloc(reg_name,
+                                     total_mmap_size,
+                                     F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL,
+                                     &u->iso_mem_ctx.fd, &err);
+
+    assert(u->iso_mem_ctx.fd >= 0);
+    g_free(reg_name);
+
+    if (err) {
+        error_report_err(err);
+        cleanup_isolation_regions(dev);
+        return -1;
+    }
+
+    /* vhost-iova-tree enforces non-zero lower address */
+    first_IOVA_addr = qemu_real_host_page_size();
+    last_IOVA_addr = first_IOVA_addr + total_mmap_size - 1;
+    assert(last_IOVA_addr > first_IOVA_addr);
+
+    /* Use 128-bit operation in case of large negative offset */
+    u->iso_mem_ctx.iso_iova_offset =
+        int128_sub(int128_make64((uint64_t)u->iso_mem_ctx.shared_mem_addr),
+        int128_make64(first_IOVA_addr));
+
+    /*
+     * Instantiates iova tree sized to map bounce buffers and vrings to the
+     * isolation region in host va.
+     */
+    u->iso_mem_ctx.tree =
+        vhost_iova_tree_new(first_IOVA_addr, last_IOVA_addr);
+
+    /* Map vrings into IOVA tree */
+    vring_map.perm = IOMMU_RW;
+    vring_map.size = total_vring_size - 1;
+    r = vhost_iova_tree_map_alloc(u->iso_mem_ctx.tree, &vring_map,
+                                  (hwaddr)u->iso_mem_ctx.shared_mem_addr);
+
+    if (r != IOVA_OK) {
+        cleanup_isolation_regions(dev);
+        return r;
+    }
+
+    u->iso_mem_ctx.vring_hva_addr = (void *)int128_get64(
+                                    int128_add(int128_make64(vring_map.iova),
+                                               u->iso_mem_ctx.iso_iova_offset));
+    u->iso_mem_ctx.vring_region_size = total_vring_size;
+
+    for (int i = 0; i < nregions; i++) {
+        map = &buffer_regions[i];
+        r = vhost_iova_tree_map_alloc_gpa(u->iso_mem_ctx.tree, map,
+                                          dev->mem->regions[i].guest_phys_addr);
+
+        if (r != IOVA_OK) {
+            cleanup_isolation_regions(dev);
+            return r;
+        }
+    }
+
+    return 0;
+}
+
 static int vhost_user_set_mem_table(struct vhost_dev *dev,
                                     struct vhost_memory *mem)
 {
@@ -2684,6 +2819,7 @@ static int vhost_user_backend_cleanup(struct vhost_dev *dev)
     g_free(u->region_rb_offset);
     u->region_rb_offset = NULL;
     u->region_rb_len = 0;
+    cleanup_isolation_regions(dev);
     g_free(u);
     dev->opaque = 0;
 

-- 
2.43.0

