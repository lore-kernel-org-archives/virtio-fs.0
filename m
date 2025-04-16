Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A902557C
	for <virtio-fs@lists.linux.dev>; Wed, 16 Apr 2025 02:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744771673; cv=none; b=rbydwExsZPlo5/xk3+/ljzY/QrbfBDEeve7pUyYnTks3hxqraA0qfmB5HCs/WvTJ7MLY2BxRFKzYCUuLM8Sn3kSzTNp0eJWIdy8Zp9gv4rC31OrRq0l0m8lDKvx1MQdKhUfE17ZYyyKjtOQCxJN+b0IvUSSGhYBu4xFSjHdduuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744771673; c=relaxed/simple;
	bh=J1C4OfFOtkayb1657hwVb1gKz5BvqtLukphGyt4Mdoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYbnS6/aaGY6P/INqj9x8msorIOV1kaY/T5a3lpMOn78juBJNHI8yBh6OVAa7Ux/n3IDjrxX282C+gSFICEBYimVXQs4eJwnsyACPg9cx/ku3SZPx1yhs15/K3qG+kxfI1/rUAJt6vymBwEAs4dB5uY3r3EQ9h5s2sQ+MMUVElA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=Ivl43xnZ; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="Ivl43xnZ"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-736a7e126c7so5434429b3a.3
        for <virtio-fs@lists.linux.dev>; Tue, 15 Apr 2025 19:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1744771670; x=1745376470; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4NXX1X4hRiRNZUknx8LsP9b/fPPtl0kWy3TtPAhKCeU=;
        b=Ivl43xnZjmKRh95nKPHcnWIjOWz9jzZnoZphYTGncJ1oMtg/WbjV6CewWdCGear/M7
         G2pUM+a6dwWikDCOw/Xg/hHb1pAhlT/9heNhvtUc+TlGbm8/4kKtDWKqJ+vYsYHGlgc6
         R/kEUceo7X1XYZi5XR/5GvdtgYrFNgC2rQvhaa73XbDlPw9P8SEDZESZkQPRd2k4TDg0
         GnDmVKKgf+HdQL2uKwkfHK6SrxLyWVJIVUHZIWdWn+RB2iyC4TNJetAj8cULjLUoeI1P
         a7qcupuI2qtBs0TVuv/zH5siuUqmP/2/jc74iE2C9J4jAUgY7iy5jMp6oYOLRQx+Tbgj
         UogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744771670; x=1745376470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4NXX1X4hRiRNZUknx8LsP9b/fPPtl0kWy3TtPAhKCeU=;
        b=pl/MpU9GNFXz0LZpxPHWX9IOgLbvuRCpsrHigkisEqSGdoKqO5jWjEEw8L1HMn+xIY
         TyEyTBxO8p71UfyyeNow6s0tT6jhYLq6GDD13pAmEqfdSxlM50qmLyg/g64QSM7/sIjD
         uJ4pDpAMQhLq+BYjz4n6LEgU5QhtJHXFjEtBdHgOREj24aiiRVZVo93DJe9FV1OXYHOU
         ff3n8o6zVLiF1dM7HOWydsZPEeqsxN1BBaTjBegnLWZZYlUGFl3FgAZ+ZWkr3U2atnAE
         c59GT7fHhItfY+dSv5bQ4UI3UswmNML1mGT1n3Nsc2XfZ2YMXaZn1pkcNzq7DSgw0Pi4
         s9rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgAN472Cv147hx3MDia9HRbg8x1KtobcJglrObwXQbFa1dHVJSHbpfCGsYQT+dSC4ruU0+U603mXU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlBRWdi9M4/p0GopyLnL3JG9/0ocoUcaBlHBTIctf1hiFASaP1
	Eozm4KjOAmxzOBte6+fTF+JveAP7divEpjFjs5TTn7qWqfQjCiGqXM1MwXeOtkI=
X-Gm-Gg: ASbGncvwPonJpXw0c8mm6TiEd6eqOW+Spz0GBeLf69EkH53kG2hUFRKF4c7wNbed6nu
	5rOlT2JmsyRbJbAKPsNr6Ox0KlKz34JHgyEUVcCYlKp4ekSFKnSNtt1arMQ6k9nuFjRyvK0bgCE
	v9dupqTjIDTHwep22eTvxnXN1WW9vQjT5wNY35RvjIFtTFD554gfbWFS81onsumafdK1Wg0QArm
	tao6yPu7FI+NOTnh0s563e8JecB7s+WplSdGbIC90aBZB6yrom4VdxX0q/RAfc/WR4ycF3KvaxS
	xRWOaSDfldzVTS+elspXAaAz84S0
X-Google-Smtp-Source: AGHT+IEfUB8DFCLLe9tH6N+sYDH+4LiBz8TB6y1hHe7fRDT0PfOqZJRD8qACJyassMrTKtI9xRazPQ==
X-Received: by 2002:a05:6a00:240c:b0:736:b402:533a with SMTP id d2e1a72fcca58-73c266b9c1emr176652b3a.1.1744771670180;
        Tue, 15 Apr 2025 19:47:50 -0700 (PDT)
Received: from fedora.smartx.com ([2001:df0:a640:1::4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd230e305sm9624958b3a.140.2025.04.15.19.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 19:47:49 -0700 (PDT)
From: Haoqian He <haoqian.he@smartx.com>
To: qemu-devel@nongnu.org,
	mst@redhat.com,
	sgarzare@redhat.com,
	raphael@enfabrica.net
Cc: fengli@smartx.com,
	yuhua@smartx.com,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Amit Shah <amit@kernel.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	mzamazal@redhat.com (reviewer:vhost-user-scmi),
	David Hildenbrand <david@redhat.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-block@nongnu.org (open list:Block layer core),
	virtio-fs@lists.linux.dev (open list:virtiofs)
Subject: [PATCH v5 2/3] vhost: return failure if stop virtqueue failed in vhost_dev_stop
Date: Tue, 15 Apr 2025 22:47:27 -0400
Message-ID: <20250416024729.3289157-3-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250416024729.3289157-1-haoqian.he@smartx.com>
References: <20250401151819.1526461-1-haoqian.he@smartx.com>
 <20250416024729.3289157-1-haoqian.he@smartx.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch captures the error of vhost_virtqueue_stop() in vhost_dev_stop()
and returns the error upward.

Specifically, if QEMU is disconnected from the vhost backend, some actions
in vhost_dev_stop() will fail, such as sending vhost-user messages to the
backend (GET_VRING_BASE, SET_VRING_ENABLE) and vhost_reset_status.

Considering that both set_vring_enable and vhost_reset_status require setting
the specific virtio feature bit, we can capture vhost_virtqueue_stop()'s
error to indicate that QEMU has lost connection with the backend.

This patch is the pre patch for 'vhost-user: return failure if backend crashes
when live migration', which makes the live migration aware of the loss of
connection with the vhost-user backend and aborts the live migration.

Signed-off-by: Haoqian He <haoqian.he@smartx.com>
---
 hw/virtio/vhost.c         | 23 +++++++++++++----------
 include/hw/virtio/vhost.h |  8 +++++---
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 6aa72fd434..bdd945c18d 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1368,10 +1368,10 @@ fail_alloc_desc:
     return r;
 }
 
-void vhost_virtqueue_stop(struct vhost_dev *dev,
-                          struct VirtIODevice *vdev,
-                          struct vhost_virtqueue *vq,
-                          unsigned idx)
+int vhost_virtqueue_stop(struct vhost_dev *dev,
+                         struct VirtIODevice *vdev,
+                         struct vhost_virtqueue *vq,
+                         unsigned idx)
 {
     int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
     struct vhost_vring_state state = {
@@ -1381,7 +1381,7 @@ void vhost_virtqueue_stop(struct vhost_dev *dev,
 
     if (virtio_queue_get_desc_addr(vdev, idx) == 0) {
         /* Don't stop the virtqueue which might have not been started */
-        return;
+        return 0;
     }
 
     r = dev->vhost_ops->vhost_get_vring_base(dev, &state);
@@ -1412,6 +1412,7 @@ void vhost_virtqueue_stop(struct vhost_dev *dev,
                        0, virtio_queue_get_avail_size(vdev, idx));
     vhost_memory_unmap(dev, vq->desc, virtio_queue_get_desc_size(vdev, idx),
                        0, virtio_queue_get_desc_size(vdev, idx));
+    return r;
 }
 
 static int vhost_virtqueue_set_busyloop_timeout(struct vhost_dev *dev,
@@ -2136,9 +2137,10 @@ fail_features:
 }
 
 /* Host notifiers must be enabled at this point. */
-void vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings)
+int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings)
 {
     int i;
+    int rc = 0;
 
     /* should only be called after backend is connected */
     assert(hdev->vhost_ops);
@@ -2157,10 +2159,10 @@ void vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings)
         vhost_dev_set_vring_enable(hdev, false);
     }
     for (i = 0; i < hdev->nvqs; ++i) {
-        vhost_virtqueue_stop(hdev,
-                             vdev,
-                             hdev->vqs + i,
-                             hdev->vq_index + i);
+        rc |= vhost_virtqueue_stop(hdev,
+                                   vdev,
+                                   hdev->vqs + i,
+                                   hdev->vq_index + i);
     }
     if (hdev->vhost_ops->vhost_reset_status) {
         hdev->vhost_ops->vhost_reset_status(hdev);
@@ -2177,6 +2179,7 @@ void vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings)
     hdev->started = false;
     vdev->vhost_started = false;
     hdev->vdev = NULL;
+    return rc;
 }
 
 int vhost_net_set_backend(struct vhost_dev *hdev,
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index a9469d50bc..fd96ec9c39 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -232,8 +232,10 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
  * Stop the vhost device. After the device is stopped the notifiers
  * can be disabled (@vhost_dev_disable_notifiers) and the device can
  * be torn down (@vhost_dev_cleanup).
+ *
+ * Return: 0 on success, != 0 on error when stopping dev.
  */
-void vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
+int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
 
 /**
  * DOC: vhost device configuration handling
@@ -333,8 +335,8 @@ int vhost_device_iotlb_miss(struct vhost_dev *dev, uint64_t iova, int write);
 
 int vhost_virtqueue_start(struct vhost_dev *dev, struct VirtIODevice *vdev,
                           struct vhost_virtqueue *vq, unsigned idx);
-void vhost_virtqueue_stop(struct vhost_dev *dev, struct VirtIODevice *vdev,
-                          struct vhost_virtqueue *vq, unsigned idx);
+int vhost_virtqueue_stop(struct vhost_dev *dev, struct VirtIODevice *vdev,
+                         struct vhost_virtqueue *vq, unsigned idx);
 
 void vhost_dev_reset_inflight(struct vhost_inflight *inflight);
 void vhost_dev_free_inflight(struct vhost_inflight *inflight);
-- 
2.44.0

