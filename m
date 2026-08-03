Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5652B3A785C
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 07:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785742168; cv=none; b=XuCsgidpBjbaN1LQQzwDC8Wg99uVpbrHIWOdsewYOvd1uytNjJlcW0GEKVIhsv8Y0mJ3p5Hme+0yPalXvEN5E8RpJaAc5sorZ6dNOvczVX/8BspoO5wE7ec1+m5sd67ZBzk5ShJqpjQLTK1IlikfEqMyBMg1zYYVZ1b9YmR0/aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785742168; c=relaxed/simple;
	bh=d/NgMqKY16KA3a0gnvqUGSmksjYhM/0CJjZ5uYHCY/c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I/TdD52iICDYiSeroOOfO7ZroiW+KxquyaAagTXdO1o/4DKTuw9G31dZHxnRzULaAMcv5qN2fDc7F/gv853bSy6I7/tjZg73X7ZqbcowUST9f0qglSfHfBmrf3lunsgqtFVe77MSMvfGAdcetJL6CgEr/ft0gG+FDFTjfEHNKB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=xBrWYAFg; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="xBrWYAFg"
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:65a0:0:640:e1de:0])
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id 5815A80D93;
	Mon, 03 Aug 2026 10:29:24 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:a53::1:f])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp) with ESMTPSA id rSdSxZ08oGk0-tOK2oaWC;
	Mon, 03 Aug 2026 10:29:23 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785742163;
	bh=jmKCJp1iaPfwL9g4BXdCpfOJn8v1FlQIelet4JuFyoc=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=xBrWYAFgGo4O3RPDUtbj95WirrfSSW8a3x9gkhJFoyk/L8btLIMJr+JDpzZL2dgk1
	 o6AEPjgSq92inKAFcXyqwycK3AeKIswnz1+DtsnKATnMxS9dAKB1Sz/crHfzGQcQQ7
	 9KlJwSnf0TXb+cZRa+TDyAkHV3EH1sjT7KOCh6rU=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Jason Wang <jasowangio@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Milan Zamazal <mzamazal@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-block@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	virtio-fs@lists.linux.dev,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v6 6/6] vhost-user-blk: use GET_VRING_BASE_SKIP_DRAIN when inflight-migration is on
Date: Mon,  3 Aug 2026 12:28:53 +0500
Message-Id: <20260803072853.2920007-7-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260803072853.2920007-1-dtalexundeer@yandex-team.ru>
References: <20260803072853.2920007-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently during live migration vhost-user-blk sends GET_VRING_BASE to
stop vrings, which causes the back-end to drain all in-flight I/O before
returning. This blocks the migration source until all I/O completes,
adding significant downtime proportional to the I/O load.

When inflight-migration is enabled, send GET_VRING_BASE_SKIP_DRAIN
instead. This instructs the back-end to immediately suspend in-flight
I/O and record it in the shared inflight region, which is then migrated
to the destination host along with the rest of the device state.

Since inflight-migration can only be toggled while the VM is running,
i2ts value at stop time reliably reflects the intent set on a live VM.
There is no need to check migration runstate to decide whether to skip
draining. Using GET_VRING_BASE_SKIP_DRAIN on a regular VM stop is
safe - the back-end records any in-flight requests in the shared
inflight region, and they will be resubmitted when the VM starts again
via SET_INFLIGHT_FD.

If the back-end does not support
VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN,
migration is aborted with an error in pre_save rather than hitting an
assert at runtime.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c      | 29 +++++++++++++++++++++++------
 hw/virtio/vhost-user.c         |  3 +--
 include/hw/virtio/vhost-user.h |  1 -
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 7a7e1a6d19..6a11dc23c3 100644
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
 
 
@@ -239,11 +236,13 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
         return 0;
     }
 
+    bool skip_drain = vhost_user_blk_inflight_needed(s);
+
     force_stop = s->skip_get_vring_base_on_force_shutdown &&
                  qemu_force_shutdown_requested();
 
     ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
-                       vhost_dev_stop(&s->dev, vdev, true, false);
+                       vhost_dev_stop(&s->dev, vdev, true, skip_drain);
 
     err = k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
     if (err < 0) {
@@ -375,7 +374,6 @@ static int vhost_user_blk_connect(DeviceState *dev, Error **errp)
     vhost_dev_set_config_notifier(&s->dev, &blk_ops);
 
     s->vhost_user.supports_config = true;
-    s->vhost_user.supports_inflight_migration = s->inflight_migration;
     ret = vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
                          errp);
     if (ret < 0) {
@@ -598,10 +596,29 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
     return &s->dev;
 }
 
+static bool vhost_user_blk_pre_save(void *opaque, Error **errp)
+{
+    VHostUserBlk *s = VHOST_USER_BLK(opaque);
+
+    bool inflight_migration_enabled = vhost_user_has_protocol_feature(&s->dev,
+                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN);
+
+    if (vhost_user_blk_inflight_needed(s) && !inflight_migration_enabled) {
+        error_setg(errp, "can't migrate vhost-user-blk device: "
+                         "backend doesn't support "
+                         "VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN "
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
index 58b142cbee..c8a3d184c8 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -2571,8 +2571,7 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
             }
         }
 
-        if (!u->user->supports_inflight_migration ||
-            !virtio_has_feature(protocol_features,
+        if (!virtio_has_feature(protocol_features,
                                 VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
             protocol_features &= ~(1ULL <<
                                VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
index 47c13f8677..78b4fba27f 100644
--- a/include/hw/virtio/vhost-user.h
+++ b/include/hw/virtio/vhost-user.h
@@ -73,7 +73,6 @@ typedef struct VhostUserState {
     GPtrArray *notifiers;
     int memory_slots;
     bool supports_config;
-    bool supports_inflight_migration;
 } VhostUserState;
 
 /**
-- 
2.34.1

