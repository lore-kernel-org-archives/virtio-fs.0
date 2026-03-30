Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4802238644E
	for <virtio-fs@lists.linux.dev>; Mon, 30 Mar 2026 09:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774864368; cv=none; b=PkC+JIXSMNmrM74xWED0FfJ53x9xRtbuNI1FVxPEWCEj9YJXp+neItngZb3kLZe0UCPXAUkmaqltdnLC0KX5rXH162nTInotUtj7nND7ue481Z3zmxI4VIHYHRWwLaGhcoQwRyiHfsACaNfjrLBBOC7L5z2YxNmTrv3fDbAe3T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774864368; c=relaxed/simple;
	bh=Ku/x46HEnsos70frvHNRX8FcSV5mOluPTYkyS7bg2Cg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mMZe/6lZ4vrI+jQjlvKNW06iPg44LDQH9ui9FtuHZn0R2+4FIFfy1RZyYiaGs3M+McPNvzoYfcSqi5Jlg9gQJW2nl/n+ngYvWHQTwDMBmFCvlrxOOs4n4cnB75zp/kH5+C51xRfl5sr/E3Goaqh08QuAlmNii6l25Ayr9mJ49Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=POzGlH0h; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="POzGlH0h"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:3530:0:640:eca4:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id BBA7DC01FD;
	Mon, 30 Mar 2026 12:52:38 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:78d::1:13])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id QqVNFG1Af4Y0-vonzmI8G;
	Mon, 30 Mar 2026 12:52:38 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774864358;
	bh=vQGG90HeFkAMc6aN0TMc7niUql1S8+VMjbGjzs+duaQ=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=POzGlH0hrvukFhTvbX7ClBGoLdrEnALQ5Cnt8aP+wMnUR1UzL70cnIcFZUfnsdyDJ
	 Y0go2EhHhMkSmGxKzmUzuXgaZS2Z90Fg/sRdm+ubxmk3j1LWLMCxXAdvCQmHCwhSF2
	 6yP3K0OccafyUJKkxgQSkeuNsGTINIwQp3snm7Ng=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Milan Zamazal <mzamazal@redhat.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	qemu-block@nongnu.org,
	Fam Zheng <fam@euphon.net>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Hanna Reitz <hreitz@redhat.com>,
	virtio-fs@lists.linux.dev,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Kevin Wolf <kwolf@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Subject: [PATCH v3 3/5] vhost-user: add skip_drain param to do_vhost_virtqueue_stop
Date: Mon, 30 Mar 2026 14:52:24 +0500
Message-Id: <20260330095226.158386-4-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
References: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Will be used in future commit for adding this param to GET_VRING_BASE

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 backends/cryptodev-vhost.c     |  2 +-
 backends/vhost-user.c          |  2 +-
 hw/block/vhost-user-blk.c      |  2 +-
 hw/net/vhost_net.c             |  9 +++++----
 hw/scsi/vhost-scsi-common.c    |  2 +-
 hw/virtio/vdpa-dev.c           |  2 +-
 hw/virtio/vhost-user-base.c    |  2 +-
 hw/virtio/vhost-user-fs.c      |  2 +-
 hw/virtio/vhost-user-scmi.c    |  2 +-
 hw/virtio/vhost-vsock-common.c |  2 +-
 hw/virtio/vhost.c              | 28 +++++++++++++++++++---------
 include/hw/virtio/vhost.h      |  7 +++++--
 12 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/backends/cryptodev-vhost.c b/backends/cryptodev-vhost.c
index 943680a23a..7a457380d0 100644
--- a/backends/cryptodev-vhost.c
+++ b/backends/cryptodev-vhost.c
@@ -110,7 +110,7 @@ static void
 cryptodev_vhost_stop_one(CryptoDevBackendVhost *crypto,
                                  VirtIODevice *dev)
 {
-    vhost_dev_stop(&crypto->dev, dev, false);
+    vhost_dev_stop(&crypto->dev, dev, false, false);
     vhost_dev_disable_notifiers(&crypto->dev, dev);
 }
 
diff --git a/backends/vhost-user.c b/backends/vhost-user.c
index 42845329e7..10be713ebd 100644
--- a/backends/vhost-user.c
+++ b/backends/vhost-user.c
@@ -108,7 +108,7 @@ vhost_user_backend_stop(VhostUserBackend *b)
         return 0;
     }
 
-    ret = vhost_dev_stop(&b->dev, b->vdev, true);
+    ret = vhost_dev_stop(&b->dev, b->vdev, true, false);
 
     if (k->set_guest_notifiers &&
         k->set_guest_notifiers(qbus->parent, b->dev.nvqs, false) < 0) {
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 179f027cb4..718fc94a29 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -225,7 +225,7 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
                  qemu_force_shutdown_requested();
 
     ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
-                       vhost_dev_stop(&s->dev, vdev, true);
+                       vhost_dev_stop(&s->dev, vdev, true, false);
 
     if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index a8ee18a912..604f19e03a 100644
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
@@ -641,7 +641,8 @@ void vhost_net_virtqueue_reset(VirtIODevice *vdev, NetClientState *nc,
     vhost_virtqueue_stop(&net->dev,
                          vdev,
                          net->dev.vqs + idx,
-                         net->dev.vq_index + idx);
+                         net->dev.vq_index + idx,
+                         false);
 }
 
 int vhost_net_virtqueue_restart(VirtIODevice *vdev, NetClientState *nc,
@@ -691,7 +692,7 @@ err_start:
         assert(ret >= 0);
     }
 
-    vhost_dev_stop(&net->dev, vdev, false);
+    vhost_dev_stop(&net->dev, vdev, false, false);
 
     return r;
 }
diff --git a/hw/scsi/vhost-scsi-common.c b/hw/scsi/vhost-scsi-common.c
index 0bb4305de6..41c1e45aac 100644
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
index 4532d63653..7279f18442 100644
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
index 01ab9ca56b..9d3875a04b 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -77,7 +77,7 @@ static int vub_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&vub->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&vub->vhost_dev, vdev, true, false);
 
     if (k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index ad6fcacf06..2f6f6df67f 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -111,7 +111,7 @@ static int vuf_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&fs->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&fs->vhost_dev, vdev, true, false);
 
     if (k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index f9264c4374..dbde342a6e 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -101,7 +101,7 @@ static int vu_scmi_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(vhost_dev, vdev, true);
+    ret = vhost_dev_stop(vhost_dev, vdev, true, false);
 
     if (k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index b33def900a..3d086ed825 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -106,7 +106,7 @@ int vhost_vsock_common_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&vvc->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&vvc->vhost_dev, vdev, true, false);
 
     if (k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index b4cdb7762f..ac4d6fca73 100644
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
@@ -1387,8 +1388,13 @@ fail_alloc_desc:
 static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
                                    struct VirtIODevice *vdev,
                                    struct vhost_virtqueue *vq,
-                                   unsigned idx, bool force)
+                                   unsigned idx, bool force,
+                                   bool skip_drain)
 {
+    if (skip_drain) {
+        assert(virtio_has_feature(dev->protocol_features,
+                VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT));
+    }
     int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
     struct vhost_vring_state state = {
         .index = vhost_vq_index,
@@ -1439,9 +1445,10 @@ static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
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
@@ -2220,7 +2227,8 @@ fail_vq:
         vhost_virtqueue_stop(hdev,
                              vdev,
                              hdev->vqs + i,
-                             hdev->vq_index + i);
+                             hdev->vq_index + i,
+                             false);
     }
 
 fail_mem:
@@ -2235,7 +2243,7 @@ fail_features:
 
 /* Host notifiers must be enabled at this point. */
 static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
-                             bool vrings, bool force)
+                             bool vrings, bool force, bool skip_drain)
 {
     int i;
     int rc = 0;
@@ -2262,7 +2270,8 @@ static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
                                       vdev,
                                       hdev->vqs + i,
                                       hdev->vq_index + i,
-                                      force);
+                                      force,
+                                      skip_drain);
     }
     if (hdev->vhost_ops->vhost_reset_status) {
         hdev->vhost_ops->vhost_reset_status(hdev);
@@ -2282,15 +2291,16 @@ static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
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
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 89817bd848..3881f6784b 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -233,6 +233,7 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
  * @hdev: common vhost_dev structure
  * @vdev: the VirtIODevice structure
  * @vrings: true to have vrings disabled in this call
+ * @skip_drain: true to notice back-end to skip draining all in-flight requests
  *
  * Stop the vhost device. After the device is stopped the notifiers
  * can be disabled (@vhost_dev_disable_notifiers) and the device can
@@ -240,7 +241,8 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
  *
  * Return: 0 on success, != 0 on error when stopping dev.
  */
-int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
+int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings,
+                   bool skip_drain);
 
 /**
  * vhost_dev_force_stop() - force stop the vhost device
@@ -398,7 +400,8 @@ int vhost_device_iotlb_miss(struct vhost_dev *dev, uint64_t iova, int write);
 int vhost_virtqueue_start(struct vhost_dev *dev, struct VirtIODevice *vdev,
                           struct vhost_virtqueue *vq, unsigned idx);
 int vhost_virtqueue_stop(struct vhost_dev *dev, struct VirtIODevice *vdev,
-                         struct vhost_virtqueue *vq, unsigned idx);
+                         struct vhost_virtqueue *vq, unsigned idx,
+                         bool skip_drain);
 
 void vhost_dev_reset_inflight(struct vhost_inflight *inflight);
 void vhost_dev_free_inflight(struct vhost_inflight *inflight);
-- 
2.34.1

