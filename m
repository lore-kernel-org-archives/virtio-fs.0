Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF4D2D7DF1
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 07:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785742167; cv=none; b=myPSsPngizt5PFsz4A88b59JSxXxlGVzlX33Y/rm136HBs6yVvTWLRvN25m/N006720xum8pi+QSf5Tlk06GmO11fOXbFLT5shyVHULoEcqhi+Qx8g/K/nf/KolZFO30aJ8f7Ay0jo2O0DCQ+8RQrBBns9mxbdq2TX6m9viuuzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785742167; c=relaxed/simple;
	bh=VSzcKaZ+6CEk3AOW1Xkx8uQQ6SMO5ORNsCU4bPeEbYc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bxjsxYfc+1PEmcrIz4RCNb7+rZaA6t1XQnue6vxoWAArmy1p4HAhu9O5H46Fd8gg1T1Q5pM8QtxQx9bc9fGyh9Ra+ZVQULOTyZCKQu9d3ZbfUtPWF+bQIGHVDF1idFFYQQa+V2Xj/BkI07a0FgRNQZj9uQvOI8IB2Imkw90uRsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=Zp+3dJlb; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="Zp+3dJlb"
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:65a0:0:640:e1de:0])
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id E3AB080B3C;
	Mon, 03 Aug 2026 10:29:22 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:a53::1:f])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp) with ESMTPSA id rSdSxZ08oGk0-K1yHyWne;
	Mon, 03 Aug 2026 10:29:22 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785742162;
	bh=sCc3cRm00jDODlA2ejp7X5uiHLJyu3SZc0Q/nAi9T2M=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=Zp+3dJlbbIEsHhxoGwaJMQvWQ51hBc/gTXgdLENaI3qeTBDWn5xUc1NC6Tovoa0Gq
	 Rqb4fx7EMvQewEXzvcmSV4mVI7FCdFccs1+TuBaenChcbG4sbnMRErf/b8hYYtnFR9
	 HY37e1ezlG7XgwFPXltL4iq86+vexHoQiX58gGu4=
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
Subject: [PATCH v6 5/6] vhost-user-blk: move inflight_needed higher
Date: Mon,  3 Aug 2026 12:28:52 +0500
Message-Id: <20260803072853.2920007-6-dtalexundeer@yandex-team.ru>
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

Move vhost_user_blk_inflight_needed() earlier in the file so it can
be called from vhost_user_blk_stop(), which is defined before the
VMState section. No functional change.

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 1aec3004de..7a7e1a6d19 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -131,6 +131,17 @@ const VhostDevConfigOps blk_ops = {
     .vhost_dev_config_notifier = vhost_user_blk_handle_config_change,
 };
 
+static bool vhost_user_blk_inflight_needed(void *opaque)
+{
+    struct VHostUserBlk *s = opaque;
+
+    bool inflight_migration = virtio_has_feature(s->dev.protocol_features,
+                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
+
+    return inflight_migration;
+}
+
+
 static int vhost_user_blk_start(VirtIODevice *vdev, Error **errp)
 {
     VHostUserBlk *s = VHOST_USER_BLK(vdev);
@@ -587,14 +598,6 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
     return &s->dev;
 }
 
-static bool vhost_user_blk_inflight_needed(void *opaque)
-{
-    struct VHostUserBlk *s = opaque;
-
-    return vhost_user_has_protocol_feature(
-        &s->dev, VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
-}
-
 static const VMStateDescription vmstate_vhost_user_blk_inflight = {
     .name = "vhost-user-blk/inflight",
     .version_id = 1,
-- 
2.34.1

