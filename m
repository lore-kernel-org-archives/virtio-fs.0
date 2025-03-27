Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57E51A9B3E
	for <virtio-fs@lists.linux.dev>; Thu, 27 Mar 2025 06:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743057851; cv=none; b=eVcZKo3Ml/Xz+8OUvJ5Hjyt3BPGtUiEEYL4W9nvEPspLNj5fggVMYWTYcJAUGJSrqvKM/TMdSJsKB24JawFd0kQDxna99zv2sCTk9uM7OT608NTFUzFu4E8jotOOqRc2CsAqNRIys0NdZHRpyUy3IfRibFSjamhK1IjBo92O+2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743057851; c=relaxed/simple;
	bh=J1C4OfFOtkayb1657hwVb1gKz5BvqtLukphGyt4Mdoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRaDMBRBgs555nO1yxOavZ95BrQcQQjxT+NRSUKP10w7trnen/mpVdcRunz1IMH6hm0cTnt30ulz/ZthYGSmUEaSNs0S/0Q93cSw3Xq7EDhv5FIx+I6KHsYC56R606fFLORCS6PEFMsGWbjQbLH6GFw6Isjtkb49luMN7y0E91Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=2c7IMVqF; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="2c7IMVqF"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224100e9a5cso12952045ad.2
        for <virtio-fs@lists.linux.dev>; Wed, 26 Mar 2025 23:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1743057849; x=1743662649; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4NXX1X4hRiRNZUknx8LsP9b/fPPtl0kWy3TtPAhKCeU=;
        b=2c7IMVqFMXGrFiqRMuT7yEIqEeBVvTn6HGfUyuq608oS+5e5vIKAZlQ+Pg07Ow4+mg
         +Nt8hDbaIBUMqZKMveaoG8JKkMKylKO/HagV2sX7M4680EARpazBXoHQl6s3hWcRu48t
         T8ubuJIhyXzt3RnhMfPd3JWRX2GOIjpeUc6D9RjAknuXHp5221L+HDE/Cgy/2DsUsxhA
         rqvStxzx9fwCXG8juTG3AZ1OU20AShFMOiKkWXXW/anK1hKVD21vLP9StyoB/6BvTGyx
         jABeTFFNzjbB9aMfk9av8HexnlJlgX9qzx/cW2TPPEas1MfKre7php2uw45+aeiE1i4E
         jsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743057849; x=1743662649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4NXX1X4hRiRNZUknx8LsP9b/fPPtl0kWy3TtPAhKCeU=;
        b=CvEnP+xSuyOwq50NbIno9IplT01Npmgn8hYZsJ1MC1NBsjqGSEZBkSC23NyDgzU3Ev
         oSFEuOrr5XcMctWQFUsd09gbaiP1kEOaqx5T6ekNrhfWjyFZTKM0xKXhhPE8Ntpq+4YU
         ZuoEWSRjxVZeIhkUfTSVfRrcDT1OmP+4QHyrsg/tbZrb2ehNTm0Rbav7Ol9EMeZirpMF
         ggfJFuDSUXludllEIgXkfbKy5klJD1N+wB5YL6xvwJV/1yanokmvFgRLTKAY3r74h1Ch
         bmgxiojiFjEW6ZfDvicM7jmWFKemZ9G1h28rENmTGuaLHBi7sjxfUlPnMAo+FNddnXDp
         kZsw==
X-Forwarded-Encrypted: i=1; AJvYcCVk4RA5w80d+GO5ZgtpMytY8PcicivqrAnI6BOGpe0ggheMT0U1I5ThFOJ312igTtujOdq+KngDDwU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjMt9KLO3sDtb0FSTDTwSJIznjVAIF2jxLQ47gtLpYB6zX6VUe
	5plgF1fPdM/0ghY/8TrJiL/9IZh8L49VUBnIYjs8nWPq2cTXp3cj8TpiRmQhSI4=
X-Gm-Gg: ASbGncu1l4QoFeMPrziBXdyl9UnO/rkD2x5ktwuBQ/I34ntruJwUfbTP1Kbn4j2A0nD
	tFUIa7TNxoojRl1OYPObAQoNoyy4/bwqom2KsO0tbA/2vPknnOvGHATIbH6Jdkis3BcmOKuHax7
	X3raNdyxLmPDFIGL/WAducFtxu62fPAfFbFghCbKZT1Lfpyd1TjpxFpeJ7BosSY4pE1a/viWKhX
	9KqrWY5XqReuqjgPRNVO+8FX0XEuRU97ZuapU8MBkaTUa6qcKxTtbNXk9UVcPFXo11qnXKE9bxJ
	mnO1OklwccBEuaQZNrXUhGzN4TLQIWc=
X-Google-Smtp-Source: AGHT+IHaOhLpe6TbeM+DqsxZp8oHnSg44s7BnhqVeoz3PH/V5XigwqmHEVGhiMCVf2y/Ww08jEXj4A==
X-Received: by 2002:a17:902:daca:b0:223:fabd:4f99 with SMTP id d9443c01a7336-2280482a885mr40124565ad.5.1743057848723;
        Wed, 26 Mar 2025 23:44:08 -0700 (PDT)
Received: from fedora.smartx.com ([2001:df0:a640:1::4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4599fsm121983015ad.67.2025.03.26.23.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 23:44:08 -0700 (PDT)
From: Haoqian He <haoqian.he@smartx.com>
To: qemu-devel@nongnu.org,
	sgarzare@redhat.com,
	mst@redhat.com,
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
Subject: [PATCH v3 2/3] vhost: return failure if stop virtqueue failed in vhost_dev_stop
Date: Thu, 27 Mar 2025 02:43:46 -0400
Message-ID: <20250327064348.3595732-3-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250327064348.3595732-1-haoqian.he@smartx.com>
References: <20250314101535.1059308-1-haoqian.he@smartx.com>
 <20250327064348.3595732-1-haoqian.he@smartx.com>
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

