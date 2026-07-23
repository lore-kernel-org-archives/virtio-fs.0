Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700D635C1AD
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845890; cv=none; b=Tefk5Av7qI/awX7mW9QAABoA2zg5FkbRpmhoXyRlJslQ1hzqKrEss6jZ1Jbke1M8eT2tNbgOw0n+K8wxMlUc3eY9nkiIIEId9p5nxkyozOevBE29K+SIMsHtMRiw7/VaLWGEJv8mmaIzzwZRqz3z+DupE8hTlfSO92iSbAPLXqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845890; c=relaxed/simple;
	bh=0C4OJBARAj4ugns9dH114UzMJ3emOVC06QOHSGg7dNA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uw7/YCZoZIzJDuuDQE9fdDRBMLYHyhDUkcm4dIgaD9uj+y11wztutzKYBUsmbXXocnFRKk7AvPUeIEvLnW5PI+fiNGxwcjWLUnnxrdQu9NrNW+nU3lIsQ4+AaCVubEXKD2A9ejkkOtMrXpuLtSUFiX7rwtaTFkuXU/WuT2YScSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rmHrFMqS; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rmHrFMqS"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-667b0ced2d3so1083339d50.2
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845888; x=1785450688; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1QFQi4UgZC12C/rG3wGbIoCAr9m0fHFGugO6XfGTbqc=;
        b=rmHrFMqS+B1bKdlkKZ6k5Rk4XkmKQOsxATw9oCk7TxQI3aqWCNYEdRppo7+jsYDaut
         Ucx08A3y+EiwmgzGFuBU7kE8BXlSJ+gtd5eRv1nuLWwyy1aG2GidQNsegQXwCX5kLERS
         K0O1Y7iS1Gxz/cUPlvbr3QHomRoIy68O0lyBAd9+p39pWzc4yKego7dWTYj0My54i/fV
         1nVAzM2xNaDgoOxfGmqAxUnc2k/DfM3//dFj1LhRGGL1M9xDgSt7CDb0Udc5RGP0bdtc
         c+JcmMel6OkXS17qsY/nDEwxgUu3Jewn1pLFrTejeWNfnIxkCnyKo+Z4woGs+gt8Pyha
         8IzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845888; x=1785450688;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1QFQi4UgZC12C/rG3wGbIoCAr9m0fHFGugO6XfGTbqc=;
        b=WB7LoSemgUZfLZJ/75wLtPJk1OdunD1rp0jM8ZiKPhAIuckpRfN4hIxXyfvqu2GpSP
         0IATXNMMNlJfnQUwM80ucLtw2AEsC74j8rJlKKtIpZYNmBGJmUFDlSwZCu4SzumQ27A2
         mBYN230FS4tm9/ZQthgVhv3ioYwKH3z6wMnkjVpoqc+h2VTK2N3Hfr/aAMXwR0qE6ZmW
         yxOba2X8Q521u1UEWWjnPl9FDkgDJ+exnhn4L4wLGLN963wYPsqMV0B+0Yx9L//EplMn
         07eQ35fEm1bYpkAYcjQre8yI7xInWXQOagTycT68uTlcwDcziMo03E0uZxqdVm4HLDB5
         R0RQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrs9RHAmG61nSAS9eP8YDU/gLZRUe9TCTPqtjqTMyQDGx5MqKdTE2aoLb6i9JRVaUzqOHuFL68QGxc=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywvef2DejyzHm/c6kb5fbRVi7GVBw+Op5aKsRzougV+hbFRWx3c
	9gzzwMbEjLmx7fUUQentbzPXwR9llHWVLajLYxLmKMYgDeJw/w+nVOwn
X-Gm-Gg: AR+sD13F/8clXzZ6larp6A6ydf+g2nrBNLjmPmt4YxY9/aA9f3mZwV49BhESZk2Ht6j
	hfY/PQ+umOloy4qkKHe7t64KoBg9XdHknE16ySyPfWhOzV3GzYDUT2yQJnX46zcyPGLCdRBVaQj
	YMFGUnTCUcizCxT/LAuF+yRLQG4TsykM1LBFnmujbefOGG4IX6Oe/uV5CGGt2dT/EM68Z7yJHWz
	10nSHj6cB1esvAUxe2KuWyGAXNfci1dCbv3fJD4IcbH2X0L7oOD1mK1bBmGVf7oJ2c85bCFHCrw
	2HAoxwWn72+p9wO5BufuhnYHiJwWtr6lhIK8/uzj49TkqOa3AWNnvkLSXaVNYatw8Epc3aVhX0t
	vbIyXHX7UfiMTjCJGGnX/Ud1zLZA4cwpqfMP9Bg3CkKqeoZAKkXt1kwV7OZy/T++AeYm8t/Dqt4
	ZQ9c4FPy8=
X-Received: by 2002:a05:690e:440d:b0:667:8b90:3577 with SMTP id 956f58d0204a3-668a503789dmr898097d50.105.1784845888389;
        Thu, 23 Jul 2026 15:31:28 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:27 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:12 -0700
Subject: [PATCH RFC 13/15] hw/virtio/vhost-user: add shadow virtqueues and
 eventfd intercepts
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=4076;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=0C4OJBARAj4ugns9dH114UzMJ3emOVC06QOHSGg7dNA=;
 b=7Cr+Jh0PFvuHJMvhUkVdgwIL9XxTyQhNW5PzLn4DD5mzQ22Oj5OWhm8yQ2gn2Pvw9DNYMooA8
 kVNl3CHuhXLDYIjyQp9zQdrRK2hiNrOOX2s3bPryNXpCM6/k9kMzka3
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Adds shadow virtqueues that will eventually be used to transfer data
between device and host via bounce buffers when isolation mode is
active.  The svqs are initalized, and eventfd assignments are
intercepted so that notifications come to svqs first before
the guest or backend receive them.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-user.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index acabfb7f1c..75858289a2 100644
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
@@ -365,7 +366,9 @@ struct vhost_user {
 
     /* Isolated memory data*/
     struct IsolationRegion iso_memory;
+    GPtrArray *shadow_vqs;
     VhostIOVATree *iso_iova_tree;
+    bool svqs_allocated;
 };
 
 struct scrub_regions {
@@ -1693,6 +1696,24 @@ static int vhost_set_vring_file(struct vhost_dev *dev,
 static int vhost_user_set_vring_kick(struct vhost_dev *dev,
                                      struct vhost_vring_file *file)
 {
+    struct vhost_user *u = dev->opaque;
+    int svq_idx = file->index - dev->vq_index;
+    if (u->user->memory_isolation) {
+        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs,
+                                                      svq_idx);
+        vhost_svq_set_svq_kick_fd(svq, file->fd);
+
+        if (svq->hdev_kick.initialized == false) {
+            int r = event_notifier_init(&svq->hdev_kick, 0);
+            if (r) {
+                error_report("Failed to create kick event notifier");
+                return r;
+            }
+        }
+
+        file->fd = event_notifier_get_fd(&svq->hdev_kick);
+    }
+
     int ret = vhost_set_vring_file(dev, VHOST_USER_SET_VRING_KICK, file);
     if (ret < 0) {
         return ret;
@@ -1721,6 +1742,24 @@ static int vhost_user_set_vring_kick(struct vhost_dev *dev,
 static int vhost_user_set_vring_call(struct vhost_dev *dev,
                                      struct vhost_vring_file *file)
 {
+    struct vhost_user *u = dev->opaque;
+    int svq_idx = file->index - dev->vq_index;
+    if (u->user->memory_isolation) {
+        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs,
+                                                      svq_idx);
+        vhost_svq_set_svq_call_fd(svq, file->fd);
+
+        if (svq->hdev_call.initialized == false) {
+            int r = event_notifier_init(&svq->hdev_call, 0);
+            if (r) {
+                error_report("Failed to create call event notifier");
+                return r;
+            }
+        }
+
+        file->fd = event_notifier_get_fd(&svq->hdev_call);
+    }
+
     return vhost_set_vring_file(dev, VHOST_USER_SET_VRING_CALL, file);
 }
 
@@ -2715,6 +2754,17 @@ static int vhost_user_postcopy_notifier(NotifierWithReturn *notifier,
     return 0;
 }
 
+static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user *u)
+{
+    /*Modified from vhost-vdpa*/
+    u->shadow_vqs = g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
+    for (int i = 0; i < dev->nvqs; i++) {
+        VhostShadowVirtqueue *svq;
+        svq = vhost_svq_new(NULL, NULL);
+        g_ptr_array_add(u->shadow_vqs, svq);
+    }
+}
+
 static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
                                    Error **errp)
 {
@@ -2859,6 +2909,10 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
     u->postcopy_notifier.notify = vhost_user_postcopy_notifier;
     postcopy_add_notifier(&u->postcopy_notifier);
 
+    if (vus->memory_isolation) {
+        vhost_user_init_svq(dev, u);
+    }
+
     return 0;
 }
 

-- 
2.43.0

