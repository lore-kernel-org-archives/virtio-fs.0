Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1417526CE34
	for <virtio-fs@lists.linux.dev>; Mon, 29 Dec 2025 10:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767003718; cv=none; b=F1h9ExlfopbZRALFowix3uEQSOz+uB9gqLcGp/zcu53WWhW2nLTQumQvpu32VQJ3Anx+rmreAQBhnRS8zBJhvKU5Q29MCDj583P4Zx1+ur/JkA8ulOSECyfQSBRtFt/Tr6x5chUPRlp4P7/sUcVDNM6JVpO0HaAohroIxV7bn/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767003718; c=relaxed/simple;
	bh=HyOEGVlexS23OmOYzm1XLTCBABrI+fzmHSVR3aOfqos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kCq4AFg89mwPQjz9LLu4Nq2KHIMpEmZCVaNVb4fqbRlTrSrcVgWK4aNU1m/Zu5hhIjNvZFVqcYTTmcVDA8vXtE2lJRbDcTsY1MsmMTgKk5E6VP7CqUOTO7oYYl34gd7MBC94b/gaTMo9AZIgir94cgGYffX1z8yt89PdHMySufg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=cfZT2mhQ; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="cfZT2mhQ"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:7394:0:640:5a8a:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 3C762C0153;
	Mon, 29 Dec 2025 13:21:50 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:b4e::1:2a])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id HLeDGC1Ck0U0-63Zs01aL;
	Mon, 29 Dec 2025 13:21:49 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1767003709;
	bh=0QTa5kigaZbjsqfFKaBCY/LC6aKCIF/YeBz7edCUmjU=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=cfZT2mhQnoOIKVWU+mHfYsXAL2bZER2wAbZlBiiOrtZV5nL1/Z6drvN3Lr0JrgETZ
	 Njs+IAPP781Gp1y76BuswkJllUmTvwZp9LLrjCVD5+3mDPqqqnj85es8WueMYtUNhG
	 vMaM3nFB0/+g8jOROwHBiIz8a/O6hWJuZgDd4xcA=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	mzamazal@redhat.com,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v4 2/5] vhost-user: introduce should_drain on GET_VRING_BASE
Date: Mon, 29 Dec 2025 15:21:07 +0500
Message-Id: <20251229102107.1291790-3-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251229102107.1291790-1-dtalexundeer@yandex-team.ru>
References: <20251229102107.1291790-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now on GET_VRING_BASE QEMU can control whether to wait for in-flight
requests to complete or not.

It will be helpfull in future for in-flight requests migration in vhost-user
devices.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 backends/cryptodev-vhost.c     |  2 +-
 backends/vhost-user.c          |  2 +-
 docs/interop/vhost-user.rst    | 11 +++++++----
 hw/block/vhost-user-blk.c      |  3 ++-
 hw/net/vhost_net.c             |  9 +++++----
 hw/scsi/vhost-scsi-common.c    |  2 +-
 hw/virtio/vdpa-dev.c           |  2 +-
 hw/virtio/vhost-user-base.c    |  2 +-
 hw/virtio/vhost-user-fs.c      |  2 +-
 hw/virtio/vhost-user-scmi.c    |  2 +-
 hw/virtio/vhost-vsock-common.c |  2 +-
 hw/virtio/vhost.c              | 24 +++++++++++++++---------
 include/hw/virtio/vhost.h      |  7 +++++--
 13 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/backends/cryptodev-vhost.c b/backends/cryptodev-vhost.c
index b4dafb4062..aaa4e6bfcb 100644
--- a/backends/cryptodev-vhost.c
+++ b/backends/cryptodev-vhost.c
@@ -109,7 +109,7 @@ static void
 cryptodev_vhost_stop_one(CryptoDevBackendVhost *crypto,
                                  VirtIODevice *dev)
 {
-    vhost_dev_stop(&crypto->dev, dev, false);
+    vhost_dev_stop(&crypto->dev, dev, false, true);
     vhost_dev_disable_notifiers(&crypto->dev, dev);
 }
 
diff --git a/backends/vhost-user.c b/backends/vhost-user.c
index e65ba7b648..bb271c4d68 100644
--- a/backends/vhost-user.c
+++ b/backends/vhost-user.c
@@ -108,7 +108,7 @@ vhost_user_backend_stop(VhostUserBackend *b)
         return 0;
     }
 
-    ret = vhost_dev_stop(&b->dev, b->vdev, true);
+    ret = vhost_dev_stop(&b->dev, b->vdev, true, true);
 
     if (k->set_guest_notifiers &&
         k->set_guest_notifiers(qbus->parent, b->dev.nvqs, false) < 0) {
diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 02908b48fa..803d5c6b8f 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -1243,11 +1243,14 @@ Front-end message types
 
   When and as long as all of a device's vrings are stopped, it is
   *suspended*, see :ref:`Suspended device state
-  <suspended_device_state>`. The back-end must complete all inflight I/O
-  requests for the specified vring before stopping it.
+  <suspended_device_state>`.
 
-  The request payload's *num* field is currently reserved and must be
-  set to 0.
+  The request payload's *num* field controls inflight I/O handling:
+
+  * When *num* is set to 1, the back-end must complete all inflight I/O
+    requests for the specified vring before stopping it.
+  * When *num* is set to 0, the back-end may stop the vring immediately
+    without waiting for inflight I/O requests to complete.
 
 ``VHOST_USER_SET_VRING_KICK``
   :id: 12
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index a8fd90480a..56d55c18c8 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -227,6 +227,7 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
     int ret;
     bool force_stop = false;
+    bool should_drain = true;
 
     trace_vhost_user_blk_stop_in(vdev);
 
@@ -247,7 +248,7 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
          migrate_local_vhost_user_blk());
 
     ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
-                       vhost_dev_stop(&s->dev, vdev, true);
+                       vhost_dev_stop(&s->dev, vdev, true, should_drain);
 
     if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index c4526974fb..4be966432e 100644
--- a/hw/net/vhost_net.c
+++ b/hw/net/vhost_net.c
@@ -384,7 +384,7 @@ fail:
     if (net->nc->info->poll) {
         net->nc->info->poll(net->nc, true);
     }
-    vhost_dev_stop(&net->dev, dev, false);
+    vhost_dev_stop(&net->dev, dev, false, true);
 fail_start:
     return r;
 }
@@ -403,7 +403,7 @@ static void vhost_net_stop_one(struct vhost_net *net,
     if (net->nc->info->poll) {
         net->nc->info->poll(net->nc, true);
     }
-    vhost_dev_stop(&net->dev, dev, false);
+    vhost_dev_stop(&net->dev, dev, false, true);
     if (net->nc->info->stop) {
         net->nc->info->stop(net->nc);
     }
@@ -636,7 +636,8 @@ void vhost_net_virtqueue_reset(VirtIODevice *vdev, NetClientState *nc,
     vhost_virtqueue_stop(&net->dev,
                          vdev,
                          net->dev.vqs + idx,
-                         net->dev.vq_index + idx);
+                         net->dev.vq_index + idx,
+                         true);
 }
 
 int vhost_net_virtqueue_restart(VirtIODevice *vdev, NetClientState *nc,
@@ -686,7 +687,7 @@ err_start:
         assert(ret >= 0);
     }
 
-    vhost_dev_stop(&net->dev, vdev, false);
+    vhost_dev_stop(&net->dev, vdev, false, true);
 
     return r;
 }
diff --git a/hw/scsi/vhost-scsi-common.c b/hw/scsi/vhost-scsi-common.c
index 43525ba46d..57b40301ed 100644
--- a/hw/scsi/vhost-scsi-common.c
+++ b/hw/scsi/vhost-scsi-common.c
@@ -108,7 +108,7 @@ int vhost_scsi_common_stop(VHostSCSICommon *vsc)
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
     int ret = 0;
 
-    ret = vhost_dev_stop(&vsc->dev, vdev, true);
+    ret = vhost_dev_stop(&vsc->dev, vdev, true, true);
 
     if (k->set_guest_notifiers) {
         int r = k->set_guest_notifiers(qbus->parent, vsc->dev.nvqs, false);
diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
index b6b4ee7d38..45bb8ca59b 100644
--- a/hw/virtio/vdpa-dev.c
+++ b/hw/virtio/vdpa-dev.c
@@ -301,7 +301,7 @@ static void vhost_vdpa_device_stop(VirtIODevice *vdev)
         return;
     }
 
-    vhost_dev_stop(&s->dev, vdev, false);
+    vhost_dev_stop(&s->dev, vdev, false, true);
 
     ret = k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
     if (ret < 0) {
diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
index 0768231a88..8277d75ce9 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -77,7 +77,7 @@ static int vub_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&vub->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&vub->vhost_dev, vdev, true, true);
 
     if (k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 2a8eead90b..2b4b52de52 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -111,7 +111,7 @@ static int vuf_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&fs->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&fs->vhost_dev, vdev, true, true);
 
     if (k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index 40e567c18a..580ffa0e2e 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -101,7 +101,7 @@ static int vu_scmi_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(vhost_dev, vdev, true);
+    ret = vhost_dev_stop(vhost_dev, vdev, true, true);
 
     if (k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index c6c44d8989..a2c52c8914 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -106,7 +106,7 @@ int vhost_vsock_common_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&vvc->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&vvc->vhost_dev, vdev, true, true);
 
     if (k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index c46203eb9c..cb2e21bd75 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1426,11 +1426,13 @@ fail:
 static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
                                    struct VirtIODevice *vdev,
                                    struct vhost_virtqueue *vq,
-                                   unsigned idx, bool force)
+                                   unsigned idx, bool force,
+                                   bool should_drain)
 {
     int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
     struct vhost_vring_state state = {
         .index = vhost_vq_index,
+        .num = should_drain,
     };
     int r = 0;
 
@@ -1481,9 +1483,10 @@ static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
 int vhost_virtqueue_stop(struct vhost_dev *dev,
                          struct VirtIODevice *vdev,
                          struct vhost_virtqueue *vq,
-                         unsigned idx)
+                         unsigned idx,
+                         bool should_drain)
 {
-    return do_vhost_virtqueue_stop(dev, vdev, vq, idx, false);
+    return do_vhost_virtqueue_stop(dev, vdev, vq, idx, false, should_drain);
 }
 
 static int vhost_virtqueue_set_busyloop_timeout(struct vhost_dev *dev,
@@ -2310,7 +2313,8 @@ fail_vq:
         vhost_virtqueue_stop(hdev,
                              vdev,
                              hdev->vqs + i,
-                             hdev->vq_index + i);
+                             hdev->vq_index + i,
+                             true);
     }
 
 fail_mem:
@@ -2325,7 +2329,7 @@ fail_features:
 
 /* Host notifiers must be enabled at this point. */
 static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
-                             bool vrings, bool force)
+                             bool vrings, bool force, bool should_drain)
 {
     int i;
     int rc = 0;
@@ -2361,7 +2365,8 @@ static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
                                       vdev,
                                       hdev->vqs + i,
                                       hdev->vq_index + i,
-                                      force);
+                                      force,
+                                      should_drain);
     }
     if (hdev->vhost_ops->vhost_reset_status) {
         hdev->vhost_ops->vhost_reset_status(hdev);
@@ -2383,15 +2388,16 @@ static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
     return rc;
 }
 
-int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings)
+int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings,
+                   bool should_drain)
 {
-    return do_vhost_dev_stop(hdev, vdev, vrings, false);
+    return do_vhost_dev_stop(hdev, vdev, vrings, false, should_drain);
 }
 
 int vhost_dev_force_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
                          bool vrings)
 {
-    return do_vhost_dev_stop(hdev, vdev, vrings, true);
+    return do_vhost_dev_stop(hdev, vdev, vrings, true, false);
 }
 
 int vhost_net_set_backend(struct vhost_dev *hdev,
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 13ca2c319f..94fb9a6654 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -235,6 +235,7 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
  * @hdev: common vhost_dev structure
  * @vdev: the VirtIODevice structure
  * @vrings: true to have vrings disabled in this call
+ * @should_drain: true for notice back-end to drain in-flight requests
  *
  * Stop the vhost device. After the device is stopped the notifiers
  * can be disabled (@vhost_dev_disable_notifiers) and the device can
@@ -242,7 +243,8 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
  *
  * Return: 0 on success, != 0 on error when stopping dev.
  */
-int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
+int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
+                   bool vrings, bool should_drain);
 
 /**
  * vhost_dev_force_stop() - force stop the vhost device
@@ -400,7 +402,8 @@ int vhost_device_iotlb_miss(struct vhost_dev *dev, uint64_t iova, int write);
 int vhost_virtqueue_start(struct vhost_dev *dev, struct VirtIODevice *vdev,
                           struct vhost_virtqueue *vq, unsigned idx);
 int vhost_virtqueue_stop(struct vhost_dev *dev, struct VirtIODevice *vdev,
-                         struct vhost_virtqueue *vq, unsigned idx);
+                         struct vhost_virtqueue *vq, unsigned idx,
+                         bool should_drain);
 
 void vhost_dev_reset_inflight(struct vhost_inflight *inflight);
 void vhost_dev_free_inflight(struct vhost_inflight *inflight);
-- 
2.34.1

