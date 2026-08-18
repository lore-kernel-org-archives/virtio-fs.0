Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3A63CE0B4
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029963; cv=none; b=WgqvTvYLIL2GybMd5J6tkUT92h5xzBgW4BFDpzNi+mAAjPKiUawkaM3+Tg6ewNPNyshviGfzg7Bib75a/1k2/1gispHEyjfmn7T5CsCmY25ddtrkZ+UUACvU9G+vrIHfvcoDb37Des+oWzJjmexxFc04Y2Qk68I4PASEBYWyz58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029963; c=relaxed/simple;
	bh=isjwTQ10NMEWzyrtg5QOC8oSS6P/XZ9Z7iPYIanOq+I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dRK5ZeVcRu2RKKyx8fJ5yAJR3RGcP/CAqlLiIRyz2vzu4XKj7lO9XOxP8ps5TAWEJTbNusKzx+KcYOOuuVL/urp/GJ1gA6JltCso1tDwvAxMG6E137KSNfo1sRa8KfSuejDTKQZMzGW/tTDFlTlsIesYwVJw/OneFFMSATDxiFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a/AZe5Qr; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a/AZe5Qr"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84874b52eabso5627437b3a.0
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029961; x=1787634761; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IHrCv6J+A3qCWiBl5PFq1mBDnBGg+HWYNp3CHH4h1QI=;
        b=a/AZe5Qrew0gPVD7W3E84CPnutXoNn/kjlaYMrQ/39qjvIT4jvKDxK091+JlPaasFa
         Mh+upTmvROQF2Nq9xcXyt9CKUI6jZEVlXeojgvcRHsjSdWzpULzotQ2mHmCeEWz3Owxw
         6VkMXeemz3gyfcqkVqMr+j1hvVNnklVQfkrQ+r24bR6C0gJaVPVJpZitKjZW3E0bjRzz
         d+HZOWHQGlWT4RoeJGRs2DNek9tQvN0vcKd0WzK6zhu5D/NPE5nHZQ4N1l8tiTj4t0CN
         gUOZ5GlpchIiDU89im35D1dr0XALQyow6Lj+ZxWXiUX71X02EojNZYuWPZdgi2malGlc
         9IJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029961; x=1787634761;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IHrCv6J+A3qCWiBl5PFq1mBDnBGg+HWYNp3CHH4h1QI=;
        b=YsgfNRHXGqY6tzxqVD/zmTt87HGszqc4OEE4YT2nZ9hZ+9OsqJwkHQz+m4UX9uq0MK
         s55f+nmc4UTt8MTpupJmsboaNrzNUhItWlwFQMsRV1RuK02fXLMdWQLx8EhKr+WjDj7q
         SQHSYYU+MB1CQS1ZR6DKbqWaLndIDl8YaELHy5aEX/CxjzO/tuKSvsmAIKzpZYpLtrth
         XTLraEcu9mSKhZv0oW5XPTsuExEh+MofGiApu6PVLtVqgXK7X3QmSHHZpgsd44tQrj5o
         /Ne848/ukwC0hOxXipn+m4j3qpmjlbbzEWcyq3bEjT7HDgZNkD17LVywWhkUaJN5kl5O
         LGaQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro/MeMRwCtT7rvSpf16tr1uGJCzW9i/PJVQhv16jZ/a7RSlwn6bkDUBIj2RO2BLsnP0WrCd3Cx0OzM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyS/lvqF76hvR/zg1kFZtinGl1rzCIdqtNIQT6sJfIs4KmuO0o
	ElvnYdhqE7LPkPq52friSTAUAKFsNQPdNIOBvXGN4fY3ki44iZHBfUJu
X-Gm-Gg: AR+sD12CPIs6i27waMrCoeorg38fSeHtSywC1BQavUBc0TRh8puDC0aS4JKT+344apn
	9XkTMF+Gh1XR0F3L0hd5Y9k3rP55VXFny2v1Z2zPDF323AiJMNEWklwmnpHUzMND8MeGFhZUIWi
	K0TuMBvA6k2szrJrdDKjX6J8buooPUhtcGt/Fb3TdL1Rg0Hd5yvc1VhoX+2bCVna6P8FiCASlEI
	cKN9P6Mf4yHB0Gmm4oBR0XMniwMCcOH35zSF+pWRlfRhn+EepULvqhq9c1HIjwBjNJjYgiO7Iy+
	wUWbasn/Ot6IewVOntZkZWefXcUkdHwT9gu2QQqfOyuDkzpUfTCOfaijbzSkqSN/I2boK+X42SV
	z7Z0Jr2xhk92yRVs8JL7kmoxO1pR9TY3XU4H36ZwzP5pRwoobd4m35yYh8ZmS2hL227MbAtTvMw
	XOBTRza7cWxQSO7c9PjIWDQrYRLKayfqZXGEkZ9I4nVTxXGX/w51SbZoMnNOoRMWx2tA==
X-Received: by 2002:a05:6a00:3016:b0:848:5540:2377 with SMTP id d2e1a72fcca58-84fde13600amr30938208b3a.17.1787029960971;
        Mon, 17 Aug 2026 22:12:40 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:40 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:23 -0700
Subject: [PATCH RFC v2 08/13] hw/virtio/vhost-user: send isolation regions
 to device
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-8-948aae960abb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=6051;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=isjwTQ10NMEWzyrtg5QOC8oSS6P/XZ9Z7iPYIanOq+I=;
 b=FNRuemiXMG2dTKu828vACrnegRFejgIQS9WFd9Yooo1U9kbAgnOpgFkvJOc+vSQs5v6xxBexJ
 LzmC+iqgmKdBj2XM/hPHzFU/R9ir4emBc58pmw0V2fRnezwj1Iw1iA8
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Adds features to fill a vhost_user_set_mem_table message with the
addresses of isolation memory regions corresponding to bounce buffers
and vrings.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-user.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 117 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 7e9233e174..e1e5cba53d 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -1140,7 +1140,77 @@ static void cleanup_isolation_regions(struct vhost_dev *dev)
     }
 }
 
-__attribute__((unused))
+typedef struct {
+    VhostUserMsg *msg;
+    struct vhost_user *u;
+    int *fds;
+    size_t fds_size;
+    uint64_t vring_iova;
+    size_t vring_size;
+    bool vring_node_visited;
+    size_t *idx;
+} IOVATreeTraversalArgs;
+
+static gboolean vhost_user_fill_msg_reg_from_tree(gpointer key,
+                                                  gpointer value,
+                                                  gpointer data)
+{
+    IOVATreeTraversalArgs *args = data;
+    struct vhost_user *u;
+    VhostUserMsg *msg = args->msg;
+    DMAMap *map = key;
+    uint64_t offset;
+
+    assert(args && key && value);
+    if (!args->vring_node_visited) {
+        args->vring_node_visited = true;
+        return false;
+    }
+
+    u = args->u;
+    assert(*args->idx < args->fds_size);
+
+    args->fds[*args->idx] = args->u->iso_mem_ctx.fd;
+
+    /*
+     * If the number of regions is fixed, it would be wasteful to use one for
+     * only the vrings. The first vhost_iova_tree element is always
+     * reserved for the vrings, so we can simply combine the first and second
+     * elements, which are contiguous in IOVA space, when sending regions to
+     * the backend.
+     */
+    if (*args->idx == 0) {
+        offset = u->iso_mem_ctx.vring_hva_addr - u->iso_mem_ctx.shared_mem_addr;
+        msg->payload.memory.regions[*args->idx].userspace_addr =
+            args->vring_iova;
+        /*
+         * The size from the iova tree is inclusive, so 1 is added to it.
+         * args->vring_size is exclusive, so no addition is required.
+         */
+        msg->payload.memory.regions[*args->idx].memory_size =
+            args->vring_size + map->size + 1;
+        msg->payload.memory.regions[*args->idx].guest_phys_addr =
+            args->vring_iova;
+        msg->payload.memory.regions[*args->idx].mmap_offset = offset;
+    } else {
+        /* Use 128 bit operation in unlikely case of negative iso_iova_offset */
+        offset = int128_get64(int128_add(int128_make64(map->iova),
+                                        u->iso_mem_ctx.iso_iova_offset)) -
+                (uint64_t)u->iso_mem_ctx.shared_mem_addr;
+
+        msg->payload.memory.regions[*args->idx].userspace_addr = map->iova;
+        msg->payload.memory.regions[*args->idx].memory_size = map->size + 1;
+        msg->payload.memory.regions[*args->idx].guest_phys_addr = map->iova;
+        msg->payload.memory.regions[*args->idx].mmap_offset = offset;
+    }
+
+    assert(offset + msg->payload.memory.regions[*args->idx].memory_size <=
+        u->iso_mem_ctx.size);
+    (*args->idx)++;
+
+    return false;
+}
+
 static int init_isolation_regions(struct vhost_dev *dev,
                                   VhostUserMsg *msg,
                                   int *fds, size_t *fd_num)
@@ -1159,6 +1229,7 @@ static int init_isolation_regions(struct vhost_dev *dev,
     DMAMap *map;
     DMAMap vring_map;
     int r;
+    IOVATreeTraversalArgs trav_args;
 
     msg->hdr.request = VHOST_USER_SET_MEM_TABLE;
 
@@ -1244,6 +1315,27 @@ static int init_isolation_regions(struct vhost_dev *dev,
         }
     }
 
+    *fd_num = 0;
+    trav_args.idx = fd_num;
+    trav_args.fds = fds;
+    trav_args.msg = msg;
+    trav_args.u = u;
+    trav_args.vring_iova = vring_map.iova;
+    trav_args.vring_size = total_vring_size;
+    trav_args.fds_size = nregions;
+    trav_args.vring_node_visited = false;
+
+    vhost_iova_tree_foreach(u->iso_mem_ctx.tree,
+                            vhost_user_fill_msg_reg_from_tree, &trav_args);
+
+    msg->payload.memory.nregions = *fd_num;
+
+    assert(*fd_num == nregions);
+
+    msg->hdr.size = sizeof(msg->payload.memory.nregions);
+    msg->hdr.size += sizeof(msg->payload.memory.padding);
+    msg->hdr.size += *fd_num * sizeof(VhostUserMemoryRegion);
+
     return 0;
 }
 
@@ -1251,6 +1343,7 @@ static int vhost_user_set_mem_table(struct vhost_dev *dev,
                                     struct vhost_memory *mem)
 {
     struct vhost_user *u = dev->opaque;
+    bool memory_isolation = u->user->memory_isolation;
     int fds[VHOST_MEMORY_BASELINE_NREGIONS];
     size_t fd_num = 0;
     bool do_postcopy = u->postcopy_listen && u->postcopy_fd.handler;
@@ -1262,6 +1355,11 @@ static int vhost_user_set_mem_table(struct vhost_dev *dev,
     int ret;
 
     if (do_postcopy) {
+        /* Postcopy is not supported with memory isolation yet */
+        if (memory_isolation) {
+            return -1;
+        }
+
         /*
          * Postcopy has enough differences that it's best done in it's own
          * version
@@ -1278,6 +1376,24 @@ static int vhost_user_set_mem_table(struct vhost_dev *dev,
         msg.hdr.flags |= VHOST_USER_NEED_REPLY_MASK;
     }
 
+    if (memory_isolation) {
+        ret = init_isolation_regions(dev, &msg, fds, &fd_num);
+        if (ret < 0) {
+            return ret;
+        }
+
+        ret = vhost_user_write(dev, &msg, fds, fd_num);
+        if (ret < 0) {
+            return ret;
+        }
+
+        if (reply_supported) {
+            return process_message_reply(dev, &msg);
+        }
+
+        return 0;
+    }
+
     if (config_mem_slots) {
         ret = vhost_user_add_remove_regions(dev, &msg, reply_supported, false);
         if (ret < 0) {

-- 
2.43.0

