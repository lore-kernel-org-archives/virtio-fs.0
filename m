Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E6946AA7B
	for <virtio-fs@lists.linux.dev>; Fri, 11 Sep 2026 09:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789117459; cv=none; b=QbuONgtvG/e534qj+/0Rhumy4fxwAXASrwiEUU04VVgzLv4C9wVUgkvWazq/84kPI1nh8XDvydtvZ1/iANWHaHp9ffndjC2lFMJCd9PXZ6TXMuZC/oOmQFockyZTiLpO2eXFTx017loGc19HG+F0DROcmGaySvV0ne3gd940jO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789117459; c=relaxed/simple;
	bh=kjEqd/Ks/r7Qk9QQRhkFyOPvyWevbQe78ef59b27sxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=q1aExqBi9CUTVFvlX2q0ZBTZHFSZiOzjtfHTdImERmq+ElftU0D9T83NoGwzsE9FxkR8Jlpx6MS5HiPtau/LXC/pi3nIyyIhAO4CV5cHR48rBNn7PI893ltBpaQYukrTAX65PACLpxLZvsu5a4BtmzQtDt6cPVgW5mwvybCItBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JfQckxK0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JfQckxK0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789117455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v1olWRoVJuPWwSBJbdW2ynlLoWLMs3mS5pnDLdXpZdk=;
	b=JfQckxK0ncI/IpKX9CDgfEqzwFRp1Iq9Obk13n7ioVvQbwZGrdivy27jVtkiFGKxXlrSxk
	yROcZ5QWW5a3RsKDuZ2nZR0t4G63yWJpxxjhphmzHHQ0D2NupkF2jH/d7F/mDlslevQnRM
	ykV23m5dfopWtd1BU3whaI4JODS81mw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-0Ai0yRepMP2WNGota3jyyg-1; Fri, 11 Sep 2026 05:04:12 -0400
X-MC-Unique: 0Ai0yRepMP2WNGota3jyyg-1
X-Mimecast-MFC-AGG-ID: 0Ai0yRepMP2WNGota3jyyg_1789117451
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-486f1eee015so122753f8f.1
        for <virtio-fs@lists.linux.dev>; Fri, 11 Sep 2026 02:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789117451; x=1789722251;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v1olWRoVJuPWwSBJbdW2ynlLoWLMs3mS5pnDLdXpZdk=;
        b=EkrFdoWYbo1qmDuasHGxXW2LoPVd99pdjdKF+cJm8lqKM8T+4DuwWLIAOFp5oPWbfU
         KPmgwJL+jc14ylt443qUOj7676+rWYmkpN33dV5ZefTKYu/kLrjVR3oYAtxpn/BSs12z
         kDdhunjeyKjSgfiCTiWAU0XXrHvN4cVKM3xTUGp+Y4Sm6tK6PN8iucSMXR/AB+tYPxy1
         Sii15V1NQH4s1o/DmajIfHM36FDXgODZffHs3lHAbicL3XArHk+9NZAqh2s+n0vtf9Nz
         1RnVlePoP8d0sJ2sLTe7Aq1SmosEZhQAMgF8D3xB3uNsKkLX/x+4PVRhvGPCDG10PWqN
         /vdQ==
X-Forwarded-Encrypted: i=1; AKwUvByh0dQWVdcarnU7hIwcmfWdFVzj9RKnLiR7VWBhJJNwaMD2c0DTnfqqFX8wwKOleeLEPnx4nr4V5Zo=@lists.linux.dev
X-Gm-Message-State: AFuF++lkbf7LlZw4nvKjqq77yz2N5f/5bIMS4j1KLueOtwBAJVKxY4fV
	nHKfk1bvSIxbNmXe7v+pYkyvaIX3CPvYEentwE0kHHVkQOt7HWDy051HL+h0E5NaK7HCvnFwXhd
	AHaADDzK4HpSN60x/msKckNtxj/Dy4cRg4yB1PFW+X2wNynRnsXXcoKj2sIDwsQ==
X-Gm-Gg: AYBFou3Y8OvVYox0JoShUPfkRXq5+1VB4DkphVJAwVUBxJDSzysqZphfILlvx1qjmt5
	lIkKFGXL6/YpDlppxOVzEOZXty3j8AVUzENBILK50LjE218m/dY4GYNMm7KRxrYBccKK3ZlwwQ5
	1G1EBThs2dVV1LKoq/qehb5EeJ51mGNPPP1WJpCtcd/Z1g6dMXOlNI/Z2wZh0R7Xo6TkAo9mFzJ
	geYB80AkFaUVhaBrMsnRsg28JFK3WW6WFvjxlGf7F8vsb68lQz/YdNb6dqKQttznS+aW6M4ww10
	6AdTGWLw/1g2j74i7BqBi7wTzgt6UnagidHwMpYdgoWulqrc6rvqpA1qNLOMc38Stp9odAAdSr/
	2r97MWZzLrbupuik00UfWlWE=
X-Received: by 2002:adf:e00b:0:10b0:484:3310:710c with SMTP id ffacd0b85a97d-486eb351000mr4953707f8f.24.1789117450463;
        Fri, 11 Sep 2026 02:04:10 -0700 (PDT)
X-Received: by 2002:adf:e00b:0:10b0:484:3310:710c with SMTP id ffacd0b85a97d-486eb351000mr4953596f8f.24.1789117449920;
        Fri, 11 Sep 2026 02:04:09 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-79-236.inter.net.il. [80.230.79.236])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35bed0sm4420473f8f.32.2026.09.11.02.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 02:04:09 -0700 (PDT)
Date: Fri, 11 Sep 2026 05:04:06 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	Albert Esteve <aesteve@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>, qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev
Subject: [PULL v2 69/75] vhost-user: add skip_drain param to
 do_vhost_virtqueue_stop
Message-ID: <2e6881e1198dcb0c9ec0fe2dbbc04ac5d13ea696.1789117222.git.mst@redhat.com>
References: <cover.1789117222.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cover.1789117222.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qw4qSVoPMMeVrSsB5LvScKq8Rqe6dhbYx9y1_4GnDbI_1789117451
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>

Currently do_vhost_virtqueue_stop always sends GET_VRING_BASE to the
back-end, which requires the back-end to drain all in-flight I/O before
stopping the vring.

Add a skip_drain parameter to do_vhost_virtqueue_stop and propagate it
up through vhost_virtqueue_stop, vhost_dev_stop and their callers.
The parameter will be used in a follow-up commit to send a new protocol
message that instructs the back-end to suspend in-flight I/O immediately
instead of draining it.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260803072853.2920007-2-dtalexundeer@yandex-team.ru>
---
 include/hw/virtio/vhost.h      |  7 +++++--
 backends/cryptodev-vhost.c     |  2 +-
 backends/vhost-user.c          |  2 +-
 hw/block/vhost-user-blk.c      |  2 +-
 hw/display/vhost-user-media.c  |  2 +-
 hw/net/vhost_net.c             |  9 +++++----
 hw/scsi/vhost-scsi-common.c    |  2 +-
 hw/virtio/vdpa-dev.c           |  2 +-
 hw/virtio/vhost-user-base.c    |  2 +-
 hw/virtio/vhost-user-fs.c      |  2 +-
 hw/virtio/vhost-user-scmi.c    |  2 +-
 hw/virtio/vhost-vsock-common.c |  2 +-
 hw/virtio/vhost.c              | 28 +++++++++++++++++++---------
 13 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 3db56433b6..0a322efec1 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -228,6 +228,7 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
  * @hdev: common vhost_dev structure
  * @vdev: the VirtIODevice structure
  * @vrings: true to have vrings disabled in this call
+ * @skip_drain: true to notice back-end to skip draining all in-flight requests
  *
  * Stop the vhost device. After the device is stopped the notifiers
  * can be disabled (@vhost_dev_disable_notifiers) and the device can
@@ -235,7 +236,8 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
  *
  * Return: 0 on success, != 0 on error when stopping dev.
  */
-int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
+int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings,
+                   bool skip_drain);
 
 /**
  * vhost_dev_force_stop() - force stop the vhost device
@@ -396,7 +398,8 @@ int vhost_device_iotlb_miss(struct vhost_dev *dev, uint64_t iova, int write);
 int vhost_virtqueue_start(struct vhost_dev *dev, struct VirtIODevice *vdev,
                           struct vhost_virtqueue *vq, unsigned idx);
 int vhost_virtqueue_stop(struct vhost_dev *dev, struct VirtIODevice *vdev,
-                         struct vhost_virtqueue *vq, unsigned idx);
+                         struct vhost_virtqueue *vq, unsigned idx,
+                         bool skip_drain);
 
 void vhost_dev_reset_inflight(struct vhost_inflight *inflight);
 void vhost_dev_free_inflight(struct vhost_inflight *inflight);
diff --git a/backends/cryptodev-vhost.c b/backends/cryptodev-vhost.c
index c6069f4e5b..f1ca6bcd4e 100644
--- a/backends/cryptodev-vhost.c
+++ b/backends/cryptodev-vhost.c
@@ -109,7 +109,7 @@ static void
 cryptodev_vhost_stop_one(CryptoDevBackendVhost *crypto,
                                  VirtIODevice *dev)
 {
-    vhost_dev_stop(&crypto->dev, dev, false);
+    vhost_dev_stop(&crypto->dev, dev, false, false);
     vhost_dev_disable_notifiers(&crypto->dev, dev);
 }
 
diff --git a/backends/vhost-user.c b/backends/vhost-user.c
index 46dadb7480..de6b1ba267 100644
--- a/backends/vhost-user.c
+++ b/backends/vhost-user.c
@@ -108,7 +108,7 @@ vhost_user_backend_stop(VhostUserBackend *b)
         return 0;
     }
 
-    ret = vhost_dev_stop(&b->dev, b->vdev, true);
+    ret = vhost_dev_stop(&b->dev, b->vdev, true, false);
 
     if (k->set_guest_notifiers &&
         (err = k->set_guest_notifiers(qbus->parent, b->dev.nvqs, false)) < 0) {
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 2e5b3ae1b1..c3e3c37f8c 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -238,7 +238,7 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
                  qemu_force_shutdown_requested();
 
     ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
-                       vhost_dev_stop(&s->dev, vdev, true);
+                       vhost_dev_stop(&s->dev, vdev, true, false);
 
     err = k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
     if (err < 0) {
diff --git a/hw/display/vhost-user-media.c b/hw/display/vhost-user-media.c
index eaf99dc6a2..851af8ddc2 100644
--- a/hw/display/vhost-user-media.c
+++ b/hw/display/vhost-user-media.c
@@ -110,7 +110,7 @@ static void vu_media_stop(VirtIODevice *vdev)
         return;
     }
 
-    vhost_dev_stop(&media->vhost_dev, vdev, true);
+    vhost_dev_stop(&media->vhost_dev, vdev, true, false);
 
     ret = k->set_guest_notifiers(qbus->parent, media->vhost_dev.nvqs, false);
     if (ret < 0) {
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index 323d117735..6e05c995f1 100644
--- a/hw/net/vhost_net.c
+++ b/hw/net/vhost_net.c
@@ -384,7 +384,7 @@ fail:
     if (net->nc->info->poll) {
         net->nc->info->poll(net->nc, true);
     }
-    vhost_dev_stop(&net->dev, dev, false);
+    vhost_dev_stop(&net->dev, dev, false, false);
 fail_start:
     return r;
 }
@@ -403,7 +403,7 @@ static void vhost_net_stop_one(struct vhost_net *net,
     if (net->nc->info->poll) {
         net->nc->info->poll(net->nc, true);
     }
-    vhost_dev_stop(&net->dev, dev, false);
+    vhost_dev_stop(&net->dev, dev, false, false);
     if (net->nc->info->stop) {
         net->nc->info->stop(net->nc);
     }
@@ -636,7 +636,8 @@ void vhost_net_virtqueue_reset(VirtIODevice *vdev, NetClientState *nc,
     vhost_virtqueue_stop(&net->dev,
                          vdev,
                          net->dev.vqs + idx,
-                         net->dev.vq_index + idx);
+                         net->dev.vq_index + idx,
+                         false);
 }
 
 int vhost_net_virtqueue_restart(VirtIODevice *vdev, NetClientState *nc,
@@ -686,7 +687,7 @@ err_start:
         assert(ret >= 0);
     }
 
-    vhost_dev_stop(&net->dev, vdev, false);
+    vhost_dev_stop(&net->dev, vdev, false, false);
 
     return r;
 }
diff --git a/hw/scsi/vhost-scsi-common.c b/hw/scsi/vhost-scsi-common.c
index e19800a0bc..e546a6dc75 100644
--- a/hw/scsi/vhost-scsi-common.c
+++ b/hw/scsi/vhost-scsi-common.c
@@ -108,7 +108,7 @@ int vhost_scsi_common_stop(VHostSCSICommon *vsc)
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
     int ret = 0;
 
-    ret = vhost_dev_stop(&vsc->dev, vdev, true);
+    ret = vhost_dev_stop(&vsc->dev, vdev, true, false);
 
     if (k->set_guest_notifiers) {
         int r = k->set_guest_notifiers(qbus->parent, vsc->dev.nvqs, false);
diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
index 6dc684ab09..7e5cc040e9 100644
--- a/hw/virtio/vdpa-dev.c
+++ b/hw/virtio/vdpa-dev.c
@@ -301,7 +301,7 @@ static void vhost_vdpa_device_stop(VirtIODevice *vdev)
         return;
     }
 
-    vhost_dev_stop(&s->dev, vdev, false);
+    vhost_dev_stop(&s->dev, vdev, false, false);
 
     ret = k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
     if (ret < 0) {
diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
index 478ec68f09..1a377016e7 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -78,7 +78,7 @@ static int vub_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&vub->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&vub->vhost_dev, vdev, true, false);
 
     err = k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false);
     if (err < 0) {
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 209993918a..0d8842817a 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -111,7 +111,7 @@ static int vuf_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&fs->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&fs->vhost_dev, vdev, true, false);
 
     err = k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false);
     if (err < 0) {
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index 02dc088ea9..c4692bd6aa 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -101,7 +101,7 @@ static int vu_scmi_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(vhost_dev, vdev, true);
+    ret = vhost_dev_stop(vhost_dev, vdev, true, false);
 
     err = k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false);
     if (err < 0) {
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index b79f4c9ce6..4ef037627b 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -106,7 +106,7 @@ int vhost_vsock_common_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&vvc->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&vvc->vhost_dev, vdev, true, false);
 
     err = k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, false);
     if (err < 0) {
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 52ea142bd4..48fe1805bb 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -23,6 +23,7 @@
 #include "qemu/log.h"
 #include "standard-headers/linux/vhost_types.h"
 #include "hw/virtio/virtio-bus.h"
+#include "hw/virtio/vhost-user.h"
 #include "hw/mem/memory-device.h"
 #include "migration/blocker.h"
 #include "migration/qemu-file-types.h"
@@ -1499,8 +1500,13 @@ fail:
 static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
                                    struct VirtIODevice *vdev,
                                    struct vhost_virtqueue *vq,
-                                   unsigned idx, bool force)
+                                   unsigned idx, bool force,
+                                   bool skip_drain)
 {
+    if (skip_drain) {
+        assert(vhost_user_has_protocol_feature(dev,
+               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT));
+    }
     int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
     struct vhost_vring_state state = {
         .index = vhost_vq_index,
@@ -1550,9 +1556,10 @@ static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
 int vhost_virtqueue_stop(struct vhost_dev *dev,
                          struct VirtIODevice *vdev,
                          struct vhost_virtqueue *vq,
-                         unsigned idx)
+                         unsigned idx,
+                         bool skip_drain)
 {
-    return do_vhost_virtqueue_stop(dev, vdev, vq, idx, false);
+    return do_vhost_virtqueue_stop(dev, vdev, vq, idx, false, skip_drain);
 }
 
 static int vhost_virtqueue_set_busyloop_timeout(struct vhost_dev *dev,
@@ -2307,7 +2314,8 @@ fail_vq:
         vhost_virtqueue_stop(hdev,
                              vdev,
                              hdev->vqs + i,
-                             hdev->vq_index + i);
+                             hdev->vq_index + i,
+                             false);
     }
 
 fail_mem:
@@ -2322,7 +2330,7 @@ fail_features:
 
 /* Host notifiers must be enabled at this point. */
 static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
-                             bool vrings, bool force)
+                             bool vrings, bool force, bool skip_drain)
 {
     int i;
     int rc = 0;
@@ -2349,7 +2357,8 @@ static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
                                       vdev,
                                       hdev->vqs + i,
                                       hdev->vq_index + i,
-                                      force);
+                                      force,
+                                      skip_drain);
     }
     if (hdev->vhost_ops->vhost_reset_status) {
         hdev->vhost_ops->vhost_reset_status(hdev);
@@ -2371,15 +2380,16 @@ static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
     return rc;
 }
 
-int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings)
+int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings,
+                   bool skip_drain)
 {
-    return do_vhost_dev_stop(hdev, vdev, vrings, false);
+    return do_vhost_dev_stop(hdev, vdev, vrings, false, skip_drain);
 }
 
 int vhost_dev_force_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
                          bool vrings)
 {
-    return do_vhost_dev_stop(hdev, vdev, vrings, true);
+    return do_vhost_dev_stop(hdev, vdev, vrings, true, false);
 }
 
 int vhost_net_set_backend(struct vhost_dev *hdev,
-- 
MST

