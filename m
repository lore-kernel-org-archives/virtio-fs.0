Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DAC3AFCE6
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845887; cv=none; b=l2UhZPRnplfh82ORZNq9p2IzMOpERjjcR47D4omZW+KVofGhclEhrhWb758vdCKnSVvqGBc7JUYXOFRlUl65XLTFJBjuoK3CQ9dD3u6mSxJ6/b8RXbHcEpcRvg66TCPJcIZMIofNDfjVlm3bzu62+7NNYJaEjW8PwH2qKdDxg/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845887; c=relaxed/simple;
	bh=z+Lm2PsZk3LkweDB1zsNiYheTgHWbAa+oQgnW46zMuo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UzzHCdGTrtxSjhmcluRDZpN1vTU7OMHwUkOlMXHWBQFxJ6r44yPCbwel1ELfUchJLOOP5U0qDxh08FCPgzTanSYkJwoO+Yul61ye3lWSkoOZPH0NpAJ46ygfD1M1q3oe8YX3BsRODFTEkQ6GG4kgKeJ2blZHbklhgy4+YShZRUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Anb0r0/B; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Anb0r0/B"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81e6f0b4610so8057927b3.2
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845885; x=1785450685; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7g695DoaNeoeNqj+3zVdxB0K+XyGWJGyI59c0QJ8p1g=;
        b=Anb0r0/Bb0IbjgmV5j5R+awjQmsW/Cly10jg+wpG6uKCtODeOYzcczIBKFZkCyvkzM
         G0vLgVn3C5T9n5kB1aU51Zi0bhf6gV4Ub6VRDEZw0LqMyyi4WNupSUHywhOQAfcAsC8P
         yofUHZ4d3Ws4toAcv9fXMSJ7og8eA2ukCY4rzyfieq3GQypX85SAvuPGr2wW+cy6G3ps
         QMhfT3d3JyXNiyM6fqE5U3eevEruHXgOuGxBjTNmrHnA/+AkKBMPKmMLl3gG20As4qNG
         ialfZ7GUmT7ChZ3vpyLy0iTsdkIlFAHU6V3eIrsTF0Et0tiugRjcJOOmTv8Ep6QdASD3
         kXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845885; x=1785450685;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7g695DoaNeoeNqj+3zVdxB0K+XyGWJGyI59c0QJ8p1g=;
        b=fHkGjS3D2cTFJsE2iuhU/BI15euFrCqYcuLQH2hZ4nPq9iWbwdFEFRXSsNEo8zT1zF
         RGfJXRIIPjyIqDu515xql1peZ5eSt8KYb7wqvAklSOy6TfF1QZRPmX0Em/IqJN/UOtvl
         4OOjXVcmVlWd6ufnfVAN8V+br1dvNmNgUn/NC6t/0JCWuzJHe19lRMNJHcL0synbStGA
         AOjuHDTboUUK7ZkQW+piOAf7i9XLI8u0i8lA1hjIJ4DrK5e1EwHs7kwZ8WBcuU2HewfA
         qMkupOlw1FJg2IPsZ4+xPfN8dzv2+MORqZxzWsNvodQppSp1AcWF9unWug3SfU+Uo2Ww
         910A==
X-Forwarded-Encrypted: i=1; AHgh+RqP5BshL2USw49ya+zCO25KFjpXfxFuqe7eEcvewsIVUHE93UQi8bZiaT7uYLdczFqqRBMD9CILjws=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAYprIsiq0yA/w7/e/un/WoVAxTampBnqcCZZHQN5BUbOmNdZs
	lCS+4v/aNwu1s9KV09htT1aH46/cmU0OKBFM9B+B9rNFP1z1sUQx0FHS
X-Gm-Gg: AR+sD124uED6hw472f50OU2oQzbrRxvp4dPsRb+GTR1PnI0KRaiQ5uD71y3F/eJb0Ge
	Ovxsu7WLgsIei2iLWwO7tOM25o2b3HnrADCMHOkafTm1zF/7jrW8Wm31nWh8rehWQUQM7LF7LB4
	ACkIiTxeRw1Bohfti/XmxoodxJqzETjPm4Lk9vrp5Mw4C5oK07c3ZsND/BGVKnAs6KWuHZz+WdP
	eUDcyHRE9LpKeffh8ToU4EbaCcsYSmaM62Feif1BoUN65CscsrexFhPeS7ktjQ2ke7GLITzckzy
	VMYCLzbIaunwjUIW4A9Kl8pZSZ39liQNj7c3kp7R/ofgAKNJEvHv/XC0CPiy7Nqox0N0lgh1TON
	XFPcxOhK61VayO9v3ejRrhuS8OrdDuJVRjceYxU+cq/zRvwS10o96ruHachRnvUXgShQuixZEmg
	dBUF0upl0=
X-Received: by 2002:a05:690c:278a:b0:81f:2825:dfe with SMTP id 00721157ae682-81f4c2f355emr15747807b3.36.1784845884775;
        Thu, 23 Jul 2026 15:31:24 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:24 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:11 -0700
Subject: [PATCH RFC 12/15] hw/virtio/vhost-user: send isolation regions to
 device
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-12-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=4517;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=z+Lm2PsZk3LkweDB1zsNiYheTgHWbAa+oQgnW46zMuo=;
 b=pAp4Enx1zJP2EmdbaCYBM7rhebwhPIOXdD1Yc0E2HneL3odB9pvotznN3IuY7YEaMfZ6Z4Xvw
 SENASOV6t7FB6hpNXkSnX5kK1VCIllzRwx1gCdT9gw6vMRQYk77jHMP
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Adds features to fill a vhost_user_set_mem_table message with the
addresses of isolation memory regions corresponding to bounce buffers
and vrings.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-user.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 710cf966f8..acabfb7f1c 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -625,6 +625,21 @@ static void vhost_user_fill_msg_region(struct vhost_dev *dev,
     dst->mmap_offset = mmap_offset;
 }
 
+static void vhost_user_fill_msg_region_iso(VhostUserMemoryRegion *dst,
+                                           const struct vhost_user *u,
+                                           const struct vhost_memory_region
+                                           *iova_reg)
+{
+    assert(u != NULL && dst != NULL && iova_reg != NULL);
+    uint64_t offset;
+
+    offset = iova_reg->userspace_addr - u->iso_memory.base_addr;
+    dst->userspace_addr = iova_reg->userspace_addr;
+    dst->memory_size = iova_reg->memory_size;
+    dst->guest_phys_addr = iova_reg->userspace_addr;
+    dst->mmap_offset = offset;
+}
+
 static int vhost_user_fill_set_mem_table_msg(struct vhost_user *u,
                                              struct vhost_dev *dev,
                                              VhostUserMsg *msg,
@@ -1136,7 +1151,33 @@ static void cleanup_isolation_regions(struct vhost_dev *dev)
     }
 }
 
-__attribute__((unused))
+struct iova_tree_traversal_args {
+    VhostUserMsg *msg;
+    struct vhost_user *u;
+    int *fds;
+    size_t *fd_num;
+};
+
+static gboolean vhost_user_iova_tree_traverse_funct(gpointer key,
+                                                    gpointer value,
+                                                    gpointer data)
+{
+    struct iova_tree_traversal_args *args = data;
+    struct vhost_memory_region msg_region;
+    VhostUserMemoryRegion region_buffer;
+    DMAMap *map = key;
+    args->fds[*args->fd_num] = args->u->iso_memory.iso_fd;
+
+    msg_region.guest_phys_addr = map->iova;
+    msg_region.memory_size = map->size + 1;
+    msg_region.userspace_addr = map->iova;
+    vhost_user_fill_msg_region_iso(&region_buffer, args->u, &msg_region);
+    args->msg->payload.memory.regions[*args->fd_num] = region_buffer;
+    (*args->fd_num)++;
+
+    return false;
+}
+
 static int init_isolation_regions(struct vhost_dev *dev,
                                   VhostUserMsg *msg,
                                   int *fds, size_t *fd_num)
@@ -1234,6 +1275,24 @@ static int init_isolation_regions(struct vhost_dev *dev,
                                       map->translated_addr);
     }
 
+    struct iova_tree_traversal_args args = {
+        .fd_num = fd_num,
+        .fds = fds,
+        .msg = msg,
+        .u = u
+    };
+
+    vhost_iova_tree_foreach(u->iso_iova_tree,
+                            vhost_user_iova_tree_traverse_funct, &args);
+
+    msg->payload.memory.nregions = *fd_num;
+
+    assert(*fd_num != 0);
+
+    msg->hdr.size = sizeof(msg->payload.memory.nregions);
+    msg->hdr.size += sizeof(msg->payload.memory.padding);
+    msg->hdr.size += *fd_num * sizeof(VhostUserMemoryRegion);
+
     return 0;
 }
 
@@ -1241,6 +1300,7 @@ static int vhost_user_set_mem_table(struct vhost_dev *dev,
                                     struct vhost_memory *mem)
 {
     struct vhost_user *u = dev->opaque;
+    bool memory_isolation = u->user->memory_isolation;
     int fds[VHOST_MEMORY_BASELINE_NREGIONS];
     size_t fd_num = 0;
     bool do_postcopy = u->postcopy_listen && u->postcopy_fd.handler;
@@ -1268,6 +1328,24 @@ static int vhost_user_set_mem_table(struct vhost_dev *dev,
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

