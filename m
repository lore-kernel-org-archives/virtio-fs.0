Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96E731F984
	for <virtio-fs@lists.linux.dev>; Wed, 11 Mar 2026 08:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773218947; cv=none; b=CVnCX9pmuOe5GnWJzL//4Fw0Fi7EJ9cbebmZVZ4Fek0mnFSJPKM307BHVvA4Ni9nPf8G9Nus4yhhzHd7BOnqZY6itQrqRXUUH4T3X+iBYsDt+I3itR2v7I7hPTRD1Xsi7nqs02r/40nrdCquMWmKSSkDfLLxC1jVMmfTVJI+pKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773218947; c=relaxed/simple;
	bh=W0cUT52sfHlmsiwL0OPpJBMIoafLAexA+MiycbsCZfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J406iOQotMdASe8DMPlA253/mk5YUygpnxJhsemR2bXDmKNOo5CF0nq58k3pT/91o46jqwTckZxdnAtiXTrUxS0DL5vWNK/BoLDSwjBKvr6p5+MgpFpCOp5EUsGbHqsax8I9u1rWYqJiA+cNFQhgAblSltijSBBS/DBSbvWqdoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=C0DVaJSA; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="C0DVaJSA"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:bf1f:0:640:c739:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 8543D8083A;
	Wed, 11 Mar 2026 11:47:45 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:b38::1:12])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TlBqj00AleA0-5I5vzvDM;
	Wed, 11 Mar 2026 11:47:44 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1773218864;
	bh=XWLPZj7cmzs67wX3ra2kw3JqxOVTlQxWDior2dN+oJU=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=C0DVaJSApbDJQGnO9n62+3dnoOUgToGf+hG+n+UkHDI/BbQ+7JRFZHs9FwPy3enbB
	 y995yjfi9QDQuv2yRtPnj97kuRz3RXx/msslxejIauWQ18KTB34lAxwAM/4PYGxCvZ
	 1miEffY6jSnKP78NW5AlFFYr+kdTye2cMmSIP//4=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: virtio-fs@lists.linux.dev,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Hanna Reitz <hreitz@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	qemu-block@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	Kevin Wolf <kwolf@redhat.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v2 4/4] vhost-user: add skip_drain param to GET_VRING_BASE
Date: Wed, 11 Mar 2026 13:47:28 +0500
Message-Id: <20260311084728.751169-5-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260311084728.751169-1-dtalexundeer@yandex-team.ru>
References: <20260311084728.751169-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of migration of QEMU from the new version (where the
inllight-migration parameter is present), to the old one (where it is
absent) there is no way to disable this feature on the backend during
runtime.

This commit slightly changes the semantics of the protocol feature
VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature
adds a new parameter for GET_VRING_BASE, which allows to control the
drain in-flight requests on the backend.
Thus, QEMU will be able to turn this feature on GET_VRING_BASE off and
on anytime.

In vhost-user-blk use inflight_migration param to enable skip_drain to
suspend in-flight I/O requests, and then migrate them throught inflight
subsection.

Also now QEMU will always try to setup
VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT protocol featrue with
backend. This will allow to use skip_drain parameter on GET_VRING_BASE
message.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 docs/interop/vhost-user.rst    |  6 ++----
 hw/block/vhost-user-blk.c      | 29 +++++++++++++++++++++++------
 hw/virtio/vhost-user.c         |  3 +--
 hw/virtio/vhost.c              |  4 +---
 include/hw/virtio/vhost-user.h |  1 -
 5 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index bfa75ff9a3..63efc87264 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -1255,14 +1255,12 @@ Front-end message types
   *suspended*, see :ref:`Suspended device state
   <suspended_device_state>`.
 
-  The request payload's *num* field is currently reserved and must be
-  set to 0.
-
   By default, the back-end must complete all inflight I/O requests for the
   specified vring before stopping it.
 
   If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol
-  feature has been negotiated, the back-end may suspend in-flight I/O
+  feature has been negotiated, using request payload's *num* field,
+  when *num* is set to 1, QEMU can tell the back-end to suspend in-flight I/O
   requests and record them as described in :ref:`Inflight I/O tracking
   <inflight_io_tracking>` instead of completing them before stopping the vring.
   How to suspend an in-flight request depends on the implementation of the back-end
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 1dc49c104e..8cc80eb0c3 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -134,10 +134,7 @@ static bool vhost_user_blk_inflight_needed(void *opaque)
 {
     struct VHostUserBlk *s = opaque;
 
-    bool inflight_migration = virtio_has_feature(s->dev.protocol_features,
-                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
-
-    return inflight_migration;
+    return s->inflight_migration;
 }
 
 
@@ -232,11 +229,14 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
         return 0;
     }
 
+    bool skip_drain = vhost_user_blk_inflight_needed(s) &&
+                      runstate_check(RUN_STATE_FINISH_MIGRATE);
+
     force_stop = s->skip_get_vring_base_on_force_shutdown &&
                  qemu_force_shutdown_requested();
 
     ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
-                       vhost_dev_stop(&s->dev, vdev, true, false);
+                       vhost_dev_stop(&s->dev, vdev, true, skip_drain);
 
     if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
@@ -364,7 +364,6 @@ static int vhost_user_blk_connect(DeviceState *dev, Error **errp)
     vhost_dev_set_config_notifier(&s->dev, &blk_ops);
 
     s->vhost_user.supports_config = true;
-    s->vhost_user.supports_inflight_migration = s->inflight_migration;
     ret = vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
                          errp);
     if (ret < 0) {
@@ -580,10 +579,28 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
     return &s->dev;
 }
 
+static bool vhost_user_blk_pre_save(void *opaqueue, Error **errp)
+{
+    VHostUserBlk *s = VHOST_USER_BLK(vdev);
+
+    bool inflight_migration_enabled = vhost_user_has_protocol_feature(&s->dev,
+                            VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
+    if (vhost_user_blk_inflight_needed(s) && !inflight_migration_enabled) {
+        error_setg(errp, "can't migrate vhost-user-blk device: "
+                         "backend doesn't support "
+                         "VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT "
+                         "protocol feature");
+        return false;
+    }
+
+    return true;
+}
+
 static const VMStateDescription vmstate_vhost_user_blk_inflight = {
     .name = "vhost-user-blk/inflight",
     .version_id = 1,
     .needed = vhost_user_blk_inflight_needed,
+    .pre_save_errp = vhost_user_blk_pre_save,
     .fields = (const VMStateField[]) {
         VMSTATE_VHOST_INFLIGHT_REGION(inflight, VHostUserBlk),
         VMSTATE_END_OF_LIST()
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index bb8f8eab77..ed95ec7523 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -2225,8 +2225,7 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
             }
         }
 
-        if (!u->user->supports_inflight_migration ||
-            !virtio_has_feature(protocol_features,
+        if (!virtio_has_feature(protocol_features,
                                 VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
             protocol_features &= ~(1ULL <<
                                VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 4e196fc773..c04bb53159 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1390,12 +1390,10 @@ static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
                                    unsigned idx, bool force,
                                    bool skip_drain)
 {
-    /* TODO: support skip drain */
-    assert(!skip_drain);
-
     int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
     struct vhost_vring_state state = {
         .index = vhost_vq_index,
+        .num = skip_drain,
     };
     int r = 0;
 
diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
index 53fe996686..c95bad5ddc 100644
--- a/include/hw/virtio/vhost-user.h
+++ b/include/hw/virtio/vhost-user.h
@@ -69,7 +69,6 @@ typedef struct VhostUserState {
     GPtrArray *notifiers;
     int memory_slots;
     bool supports_config;
-    bool supports_inflight_migration;
 } VhostUserState;
 
 /**
-- 
2.34.1

