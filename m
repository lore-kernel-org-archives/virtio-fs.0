Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589D43D0939
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845877; cv=none; b=Pkntd1Y0InIb5E3d/PIOxAnKHZ6BG/SYU7xca5q0NcyOxlpoQH97dw8GCkvbyTcuM9F2Z+Wa0rA6p8KDLwTgAjgma6aTq/yatut+7goKBQR8XqG+prnGyidQHf3yVWfh+z0dhjvJuLe1gUt19yZl03tKipleqICS2LTbzccb6dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845877; c=relaxed/simple;
	bh=jUAZQS3R6KxjXedQOFVXhZurjmT2dN3NOYDdWrU4F2s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o+Ietki5mFilsjJVBZ7mnTtM7hOs1HIGxHCtRAKuDgamsYfMqKxYgEnuC15i9/KvfTi+uovH6dB077pmxUIPE2fLf/k+6rGezffrQHPpDrVRFDt/9AiJy9wOo6w8CmNAq88x4XWY/3P578HEvcIs2Mou8PHLWVsetl47eI3j9qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BeGcrr73; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BeGcrr73"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81ec29f1d07so9904967b3.1
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845875; x=1785450675; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3daCLJ1kp7Y+iaqF144Ru8UeiZ4TA3+qTjsGJpJy0rA=;
        b=BeGcrr73eLnRX2hnBQTCpv/XmuMRWgM/S9FFFXU7R8Vg0W/OTWgJLYS0oDFBM0uHdw
         st0s9rUz/9o5xZeIfjum+LcwjdZfwiHns7ZZAf5juMK/1AscB0/dS1Mv9cthuUh3I52B
         U6K4u9naCfTXVwguH7LhXJGRx82xYZu8FTYI8c9Fb4J1n/QhE1ywMnxVU8mbA6M4mv28
         FV4FqUVRmf8AhR2X9Z/t4mN2N6+e6akuvy9wfX97ypkAuPUbVb2Djhe3j8tWueirqoxg
         ZAYgp/m3sNsAN/4XT7n/5nVjSHakOdIOa9+gUReSGUA+hE/BJGCwQ76pQ4hHcdvgq5P2
         o4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845875; x=1785450675;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3daCLJ1kp7Y+iaqF144Ru8UeiZ4TA3+qTjsGJpJy0rA=;
        b=D8TMRUJOn+mh6rjZ1wn4DAgm0NR3wYeMEP604FfVlUvxShwJuxbNvTchx8NJK1Y2EZ
         +pcPqDgTALjWouz6apLLwE+YIGbWHlyHAVZ0TUeWJpdCCnmjIQLevq+CE5mX3QamWalT
         K7ZTji4gLVeT01P+MYexr6LZ9nN63BDAdDseoUuUtf/7YQeKYAJ0Rhacd7ZxG5d1XWY2
         Df3d3Gf29hR0cNCDFethKt49qTg5VWrwLb0vHe97SoO+2WSY1Uld9/OT0d6E1w8/JGR1
         pHqN9/sQY5Qe17rD/wi7xg0Cq45q+MDMUCayJc4whFl0j0nNN9Vht5osTaIdzYzzyE6q
         CzBg==
X-Forwarded-Encrypted: i=1; AHgh+RpEgn3DNlrgCHDB72Dzk2hP3AYPXXHDJfxonEIFXah+K/HpGr74nJFEiQVEvmtLTdYIdm1YTEOCMak=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFGCTC5o44HYnpUgwswNTdL8j0naMBeMt8Zo/e2lW/cHFaGBaT
	mXErOT3p63Ft9ptg0wlEo/IBg6er6dAPbDY+AQlkh51JYrXgrpkOPlaB
X-Gm-Gg: AR+sD13tfok6I5p+pcerDJTa7vSi+wpD41szlssgbrofU2FsvzV2we+0h9HKQWeTMkB
	n2td+r9EkeygrCe7Id3MRalfzG/NW5OpIoupTo3Co1yekII8v5BGZdLnJRVTpUwY/jJ3UnCmXGA
	k+Go82MhdRSNzngUPG5xjqrnl/WVV6NYvYKmPeolC4+uuPtKjWbbPa/JNS4WhJalHYfj3k20Cd+
	WIP6Ryqf77X3oiLhPQhTi43xjeYyye5qynNh2oDuyUDd83VfAWFtsEHpF13WTHl0yUu7fl5TF+m
	MUQqdb31Ysel+zMsc+h7A3wldAA8aGx0vDeX0uk96sNqp0mLAy5DDNp67/kFmvWXz6kgj8n12R6
	leRPTIPSdSQOMlHlxd0OxtiURjphHBobeqKayQ8vsXB75+6FvCWCclXkUMyh8ShwL/doFyAwLGy
	1C7TbC707EtnFemY8jVQ==
X-Received: by 2002:a05:690c:c4e4:b0:81e:edfb:3194 with SMTP id 00721157ae682-81f4c351402mr14830007b3.59.1784845875169;
        Thu, 23 Jul 2026 15:31:15 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:14 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:08 -0700
Subject: [PATCH RFC 09/15] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=3241;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=jUAZQS3R6KxjXedQOFVXhZurjmT2dN3NOYDdWrU4F2s=;
 b=IWJbWb4oHeq4FxWn0jL2j3GKcWqBbUU4hHnG/ZyZI07odrLByCvEjJtwoFfYsgny3mm4atw8s
 /1LXUxIIArRCuPgCozwIugnJKZV1NTK95p5EDr/SbrWDmNMoWG6Tvc6
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

By default svq vrings are placed in an anonymous memory map. As svqs
will be leveraged to enable memory isolation in vhost-user, it is useful
to be able to place the vrings in a shared isolation memory region.

Adds the option to specify vring placement by providing a vring base
address before starting the svq.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-shadow-virtqueue.c | 22 +++++++++++++++-------
 hw/virtio/vhost-shadow-virtqueue.h |  3 +++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index eb86c1ee37..9e3c359f50 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -857,14 +857,21 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
 
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
+        svq->vring.desc = (void *) svq->base_addr;
+        svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
+        svq->vring.used = (void *)((char *)svq->base_addr +
+                          vhost_svq_driver_area_size(svq));
+    }
     svq->desc_state = g_new0(SVQDescState, svq->vring.num);
     if (virtio_vdev_has_feature(svq->vdev, VIRTIO_F_IN_ORDER)) {
         svq->batch_last.id = VIRTIO_RING_NOT_IN_BATCH;
@@ -929,6 +936,7 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
     event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
     svq->ops = ops;
     svq->ops_opaque = ops_opaque;
+    svq->base_addr = NULL;
     return svq;
 }
 
diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
index ccfeee36d7..39f69e6455 100644
--- a/hw/virtio/vhost-shadow-virtqueue.h
+++ b/hw/virtio/vhost-shadow-virtqueue.h
@@ -148,6 +148,9 @@ typedef struct VhostShadowVirtqueue {
 
     /* Size of SVQ vring free descriptors */
     uint16_t num_free;
+
+    /* Location assigned to vrings if not in default anon memory map*/
+    hwaddr *base_addr;
 } VhostShadowVirtqueue;
 
 bool vhost_svq_valid_features(uint64_t features, Error **errp);

-- 
2.43.0

