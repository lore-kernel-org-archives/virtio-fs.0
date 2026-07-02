Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0742E548EE
	for <virtio-fs@lists.linux.dev>; Thu,  2 Jul 2026 09:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782983477; cv=none; b=dVJowlYRAyo0WaR5Kk86lqIXG5TwoF8wV2b8Gtcsf2O8Wg2PnMZwp0t277m9ebCYGCZuZRfvOiO/MxQTlGVuK2j/Zcm+ZM0znHSptJ5iCdTs+6qb2Oyz82SxyS8Ec7Ge+x4AXS9OjQsoXJSn2ImOjh8oW3DxGu9raOmsN1BbDGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782983477; c=relaxed/simple;
	bh=+PVQ25zXt26jBEy+X04wLOlZGxBAyDcS09abEETLttE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uym/oriq5HD0kYNWLnnx9th6x2lSGLA2M4IwtCn5ySa9xK7VDJ3bZ4jqmUU+O8MEs+gCXPHfZwAJqHY56yfVlipbrzr4Ra1ouxDm8KprZDtLRGFhJ4BZJpOSZ4brm179stCyM9Q0yTlfW/oKs/IbtheSBU69shAYPphzU43Budw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=lQUnXfH2; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="lQUnXfH2"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 6D8D980B26;
	Thu, 02 Jul 2026 12:10:57 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:43d::1:15])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp) with ESMTPSA id NAc7BT0aDa60-qNjZ3yIG;
	Thu, 02 Jul 2026 12:10:56 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1782983456;
	bh=f+j6gspIE6UnGGrgywr9U7aGweypYBibhpvyef7zBVc=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=lQUnXfH2x+pJUdKRuIcQeyHCbgdi5pkZ+WV3/HkIm8WSrw5e7YtX946NwwbbZKVmx
	 PtlJkeAdanEIK8xXrFaf9FWppjDUl63LO+Lj8hvZwlS2N7fuYwfEK73VdMnKas4ArB
	 lrvk0BsS5CxJFq9uYqzdbR4uGTDIj1QR6A34EkjE=
Authentication-Results: mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowangio@gmail.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	virtio-fs@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	qemu-block@nongnu.org,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v4 6/6] vhost-user-blk: use GET_VRING_BASE_SKIP_DRAIN during inflight migration
Date: Thu,  2 Jul 2026 14:10:23 +0500
Message-Id: <20260702091023.3306378-7-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260702091023.3306378-1-dtalexundeer@yandex-team.ru>
References: <20260702091023.3306378-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of migration of QEMU from the new version (where the
inflight-migration parameter is present), to the old one (where it is
absent) there is no way to disable this feature on the backend during
runtime. Now inflight-migration param can be turned on and off, so this
logic will work correctly.

Now when inflight-migration is enabled and the device is stopping due to
live migration, send GET_VRING_BASE_SKIP_DRAIN message to the back-end,
allowing back-end to suspend inflight I/O immediately instead of
completing them. In case if inflight-migration is disabled, use default
GET_VRING_BASE message with back-end.

Also now QEMU will always try to setup
VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT protocol feature with
backend. This will allow to use GET_VRING_BASE_SKIP_DRAIN message.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c      | 30 ++++++++++++++++++++++++------
 hw/virtio/vhost-user.c         |  3 +--
 include/hw/virtio/vhost-user.h |  1 -
 3 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 156ed6de30..cd0a443b26 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -135,10 +135,7 @@ static bool vhost_user_blk_inflight_needed(void *opaque)
 {
     struct VHostUserBlk *s = opaque;
 
-    bool inflight_migration = virtio_has_feature(s->dev.protocol_features,
-                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
-
-    return inflight_migration;
+    return s->inflight_migration;
 }
 
 
@@ -239,11 +236,14 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
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
 
     err = k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
     if (err < 0) {
@@ -375,7 +375,6 @@ static int vhost_user_blk_connect(DeviceState *dev, Error **errp)
     vhost_dev_set_config_notifier(&s->dev, &blk_ops);
 
     s->vhost_user.supports_config = true;
-    s->vhost_user.supports_inflight_migration = s->inflight_migration;
     ret = vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
                          errp);
     if (ret < 0) {
@@ -598,10 +597,29 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
     return &s->dev;
 }
 
+static bool vhost_user_blk_pre_save(void *opaque, Error **errp)
+{
+    VHostUserBlk *s = VHOST_USER_BLK(opaque);
+
+    bool inflight_migration_enabled = vhost_user_has_protocol_feature(&s->dev,
+                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
+
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
index 2f71ede599..e3e0164707 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -2570,8 +2570,7 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
             }
         }
 
-        if (!u->user->supports_inflight_migration ||
-            !virtio_has_feature(protocol_features,
+        if (!virtio_has_feature(protocol_features,
                                 VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
             protocol_features &= ~(1ULL <<
                                VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
index 06c360af18..1ded2c2d27 100644
--- a/include/hw/virtio/vhost-user.h
+++ b/include/hw/virtio/vhost-user.h
@@ -72,7 +72,6 @@ typedef struct VhostUserState {
     GPtrArray *notifiers;
     int memory_slots;
     bool supports_config;
-    bool supports_inflight_migration;
 } VhostUserState;
 
 /**
-- 
2.34.1

