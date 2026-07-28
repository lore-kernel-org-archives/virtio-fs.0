Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D13B42089D
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 10:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785233446; cv=none; b=nPpuBPXyqLGvSI7vPsONqebxBvdBJKAwCvJFnquv6KwO7zXFeLbxt14UpvLeunsCVctyGUCKIZY5PJDFwnrCw1KW55L8Dveiy5qWhnAHF+RWi6awjtJy38vW3VBSYK/bQA+UcsrY+lr2UakPj+i4AW5OvCuKbwHuGJ8C6Y2Zj1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785233446; c=relaxed/simple;
	bh=a6SZLw5Zcx4Lk7ISKhbahXyv/thwDm4caJwSCQSu+co=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bfsl9mCfiDJx16uuiGp4At1QoHqrWhnWdoE+evexObX4F0j2Exzi2qhEmKlvJBxxnmURmjulZA01wk+lMacoWYvxZL19KedoYuBo6H/DbnfAqdWvU/qtXHwWBioWg3S351KPB5+yX80c4hlaE5kmPzV78YnWWuN4t1dU6A9pGvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=def7u+xW; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="def7u+xW"
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (postfix) with ESMTPS id 95B4FC09AA;
	Tue, 28 Jul 2026 13:08:56 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:803e:400:f26c:359c:adc2:62a4])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp) with ESMTPSA id f8aui7IXWGk0-QrXkjAXf;
	Tue, 28 Jul 2026 13:08:56 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785233336;
	bh=B+SvFnKpqZMDs/vqqKEjUWy13JfM+QcgMQzbOfSc4Go=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=def7u+xWa1CiFJerR062MhYU5lKYdqlCNwADxEzw8Ic9u29LMSS7Rb7Ym8+ns+fM1
	 9s08L5tAboESLw+OaOWZIIO4I2q5I7UCyn/gkqY8GMWSMF8iLmuXWXLL4BTrmimOOK
	 TF6ttxZL5/wF5La55/ES76WNCMLh2k7IOfcyZ70s=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Jason Wang <jasowang@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	qemu-block@nongnu.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtio-fs@lists.linux.dev,
	Kevin Wolf <kwolf@redhat.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v5 5/6] vhost-user-blk: move inflight_needed higher
Date: Tue, 28 Jul 2026 15:08:40 +0500
Message-Id: <20260728100841.3475774-6-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
References: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
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

