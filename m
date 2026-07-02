Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1644B3EB7FE
	for <virtio-fs@lists.linux.dev>; Thu,  2 Jul 2026 09:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782983463; cv=none; b=EE/H5S5uOCs4kPhI81GnLrMj/nD/HBm8HN62r6tk57gsrFUPQ8jVJWI4IIwTL0XPXxAI2ACYQthIumLEIQ4lpMArEMh7gScUs/T08vJZbXx972in74uNCwVMgtWmymj0PjVd8wFbf3wH8eD4gjf3dVTDNiQrOQW93cwcuisgRVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782983463; c=relaxed/simple;
	bh=eRr4S8xfWIwZQr+vkKFxX8fgRM+HVDgcgY0i6D9Gyp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C2Uou6JLrin0GsKkm87IMB1Kcl5ffdH6af+Cz5u4o0ayXiGYqU6C5yL4y7+mP3ttjDmjMFBdTTwE2OtLVe0y9vbxUjVpNTk4WXYQbPxQFA24i+temvJ/VZcpH2YQU9vJkyk9qE+NbTFmYDHVA9yqIaxj0fPxKRcqsvpMScxfuNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=wXhZPpIS; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="wXhZPpIS"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 9D07B80B12;
	Thu, 02 Jul 2026 12:10:55 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:43d::1:15])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp) with ESMTPSA id NAc7BT0aDa60-FNcjg5o8;
	Thu, 02 Jul 2026 12:10:55 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1782983455;
	bh=mD1cajfmxp5W/UieGTiWLlUmbqZcs39FiEsdPECcnMo=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=wXhZPpISWh0sXMKywGR4tnJGErZfOlLlXi+7xGUH6lRC5207hRD108xmTh2UB/jj8
	 iOuKJ50wW4ojFngalpdQhvMbnefRuIxNKJ3wdLHdKlMdzDa+SQzRs8QbiX1m4oTV/D
	 R5qUyoYC0PenbdwbQkCrR516Oqufpstc/DsWlcpU=
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
Subject: [PATCH v4 5/6] vhost-user-blk: move inflight_needed higher
Date: Thu,  2 Jul 2026 14:10:22 +0500
Message-Id: <20260702091023.3306378-6-dtalexundeer@yandex-team.ru>
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

Will be used in future commits for adding skip_drain param

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 650c004bde..156ed6de30 100644
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

