Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D8F1C4A17
	for <virtio-fs@lists.linux.dev>; Tue,  1 Apr 2025 15:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743520729; cv=none; b=n4er6ovp522Y5dcGm56UYYIutM31FSqy10Z9mhgPg6DaENDLuRXUqx/61+26bIYoaJP8p89NhRS2c3Ok2NG3/BxNePh27O/tt2nuSav4pLwQyebl4sue4xrnyEMUWXGmUwwtz4Sdqa/58bx7W0aFHjk8WYVrmrAdb1pl1WhHqcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743520729; c=relaxed/simple;
	bh=J1C4OfFOtkayb1657hwVb1gKz5BvqtLukphGyt4Mdoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQ7Q0wRK9IJ/+UuggKNdY/lnycXDsbyW/uYe9daQpOAKxA9hfLGRoBY4qzKoaJKam+kSqdZp5GaUc8cu+JzXhq6tS9o8s8CLXX5V/QIvMd+v0h//cxKh1TC2Ks0x7UiVIwU/HBcRUUTL3+y4BEbUQSL7o3dURnflfbH2DTStp5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=uzcExAH8; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="uzcExAH8"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3018e2d042bso6780167a91.2
        for <virtio-fs@lists.linux.dev>; Tue, 01 Apr 2025 08:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1743520726; x=1744125526; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4NXX1X4hRiRNZUknx8LsP9b/fPPtl0kWy3TtPAhKCeU=;
        b=uzcExAH8+1VB8EsHT5NdSnJwL90N+O7d4Skt03PZWWiIkKBwPBVcgYZmffmjkXQwkr
         oR0wGFPeAnfnrZZvZdVH7Y3nJvPdf2QPWmsnVESMnYFw1aQg4O/YqYtMbPsFtjXMcnzy
         YrRox8widXswygOcW25xJbGNdSTiLPPlqyqXu4An0AQG2DH4qX6chlVUtSAmLm9F8ary
         XoESKT+DjaLcPIOPR5jdE3P4keNAYTyVlNthtWXrzy4186hl/Dq7hIw5pDa5uwVfw5xb
         HRy9VKmwYgku9QUpYc0uDnjZAFqSPFMxW47t5Fi/hQXX7BcAhXmrlgngEcGij2S1B0Aq
         XkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743520726; x=1744125526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4NXX1X4hRiRNZUknx8LsP9b/fPPtl0kWy3TtPAhKCeU=;
        b=GGF/zer9L2XxeHMR6FOIEj4T6CXgYyiMA5dPLFDPZEQjoekeJtZW7N9lZGRTtZugHD
         Qczp6WTwB5KWLFj+mDEf776WUcCnqJVBwa7nCyxmJ7yJ1PfKjHDOGgg77SyaA2VHlwYc
         qAR7KVfx1Ud/SJT/zx2cNdcw2BfTwQmZ/0XTWteLrDKodcnywXn9XdSTDfkGz9Vn52Mf
         g/wPvXukutWSwoW4QOUcewdjcr0s2ptqDWFpw+Yeb6SIb3FMmJJc2rpxbmEyj2csDFE9
         XpqPtrEYEXMjCi+6LyOpduw9VlBuDitIMxc+VT7862YKgJRPVAcjXLtjLMNLctTagULJ
         gcOg==
X-Forwarded-Encrypted: i=1; AJvYcCUjghcFkE2nyYrMUvCWFZuTmZbApU6tkC6WhMvVMtzs8rr9sZuZgsl2+6mrDPN1Vg5gvRtauWVJSYM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyuZ9KOMcPMGuFfI4X+Tphds1u3oBCaAv0oS2zGP0yLyrBSHPpc
	z70t/0L0Ti22yqx46GLJTmoi3g0lhEwpIU3tvuqSe0lylRaOaRqsXNv3T46erQU=
X-Gm-Gg: ASbGncvlLTpAQWAYO2g1d8x6+t/bTFS710/fLk7iV89vAPcfMToxrAdHV2xSh8lZRZi
	rMvEntBovatMW1fS6mDJMKJwLvYXPsShuItKISGlSy2l65vzakC4FIVhhAqazCtTnWGgQ5WRP4B
	1/S6J+U1BGz1DODMTjUUAyg+Rtk82/dP6RVqc0WmIwyzOm7NDoECfIQWuMYQybt1BBL0VODv6uO
	gDyn7K0kc8Pgyz9mnKnpCfedsjzJgntZIe3w3cO5EqQad4ilE7t4Xo47HjXZKJRNA04IeO9LxlE
	G7TCIvg7LayCMqNwcuRFF7Vj55o9iTE=
X-Google-Smtp-Source: AGHT+IFtnBfm3iEUuKkmkY4Wgfbu6YeM2h6VlJT3NVowOQMfk4p479pWxi+aoJAGqxAnh7LQT7UBvw==
X-Received: by 2002:a17:90b:5446:b0:2f9:c139:b61f with SMTP id 98e67ed59e1d1-305608793e6mr6498428a91.14.1743520726364;
        Tue, 01 Apr 2025 08:18:46 -0700 (PDT)
Received: from fedora.smartx.com ([2001:df0:a640:1::4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2291eee029bsm90172195ad.62.2025.04.01.08.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 08:18:45 -0700 (PDT)
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
Subject: [PATCH v4 2/3] vhost: return failure if stop virtqueue failed in vhost_dev_stop
Date: Tue,  1 Apr 2025 11:18:16 -0400
Message-ID: <20250401151819.1526461-3-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250401151819.1526461-1-haoqian.he@smartx.com>
References: <20250327064348.3595732-1-haoqian.he@smartx.com>
 <20250401151819.1526461-1-haoqian.he@smartx.com>
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

