Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117FA3AEF2E
	for <virtio-fs@lists.linux.dev>; Mon, 30 Mar 2026 09:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774864366; cv=none; b=hBzOIYFptwbAxASj2gce03BNKm4j25Ka7DbG2eJCa6aL4I6Qu/oaSIkraDT0pUXRikKbm41ITpoMDCtdWk6cEIs8e2hA5lK2KjTYZmbYhAJ3KjqTkgmiGT6G+xiKM9uFYFcFZ1taZKq1t2xkNMvVZzgqJgZ6icAcO+ZYwDq/vvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774864366; c=relaxed/simple;
	bh=FLFXc1TuP8wKdrMdDK37T++xtPa20WW4olm1TGajA1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ggKpnDwL4ZKLox3K0t/A2L8huQg3jDhgSl8DF5EFlBjYkTM+bYA8ETgx2WYU+/rdiMi7Qm0Y/Oy/0fVLivTRtz0BPmMFHCKwJuNCC0XI1Passjzffjx8721ADzRHGUnVU4RVJgBIXimLuV0mpfRmOFqItjCusk7cSLOXsB2qVoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=ZKUQHXLH; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="ZKUQHXLH"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:3530:0:640:eca4:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 2869AC0200;
	Mon, 30 Mar 2026 12:52:40 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:78d::1:13])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id QqVNFG1Af4Y0-NyqoIar9;
	Mon, 30 Mar 2026 12:52:39 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774864359;
	bh=cM/Vyd4WfmKyR8Aw4O7A4tlOTXfmYaFOA9HmSDbiY40=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=ZKUQHXLHo2yvTB/D1//L80K+DCIDC4YhX3BOIYaiQnYJgdX9Z0ROKUXhgZzxHRv62
	 61u5kZZh7j43/8yk0VBSpPDmzcleK7YnjoJ24V9xg3u52qH1AEmH4QKFQcTuuqx1Kd
	 Kxnc+vwbz2DR0lHjNE7KJygen5TvUD02xVYRONgQ=
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
Subject: [PATCH v3 4/5] vhost-user-blk: move inflight_needed higher
Date: Mon, 30 Mar 2026 14:52:25 +0500
Message-Id: <20260330095226.158386-5-dtalexundeer@yandex-team.ru>
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

Will be used in future commits for adding skip_drain param

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 718fc94a29..a3ecd83f54 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -130,6 +130,17 @@ const VhostDevConfigOps blk_ops = {
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
@@ -569,16 +580,6 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
     return &s->dev;
 }
 
-static bool vhost_user_blk_inflight_needed(void *opaque)
-{
-    struct VHostUserBlk *s = opaque;
-
-    bool inflight_migration = virtio_has_feature(s->dev.protocol_features,
-                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
-
-    return inflight_migration;
-}
-
 static const VMStateDescription vmstate_vhost_user_blk_inflight = {
     .name = "vhost-user-blk/inflight",
     .version_id = 1,
-- 
2.34.1

