Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2B53B9DA7
	for <virtio-fs@lists.linux.dev>; Wed, 11 Mar 2026 08:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773218883; cv=none; b=miz1vUYZ4i2twc00ALWHQoGFonDcoSNy5YF0PFxOA8CNMCetky7DIiko4RSF8/ELcSn+qwKfsraBF3Lfzid6d5OJ8PswN47/Zb6a/VlO78bz7Er7GiM7CJt08rHUSuMx/sS/WXjP4KG8XUb0FURpLJIOYlCv8AIFFPvo/qf/Xfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773218883; c=relaxed/simple;
	bh=F7FXrDKKtzgg+/wgH67pqv69oezdSKThAcgd3+nB+5k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X3q/wO5o0hgn39LSNVEdEV2UALz8UBFuQP3ZNatadyI0fxR8+B9eOcd+F7RQ7rJiVGAI17mI9XQnyXqnXpBaf82xKxsdzBr/aEgAQkLsOwSBs5tkz9RWtN9WJ+ZY81SCp+z59IsFPABOkE54MCgrytUd5ATrlDYGCqzAy2Oayrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=TbVnyTZi; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="TbVnyTZi"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:bf1f:0:640:c739:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 28D48C01DB;
	Wed, 11 Mar 2026 11:47:44 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:b38::1:12])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TlBqj00AleA0-bwq3hMn9;
	Wed, 11 Mar 2026 11:47:43 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1773218863;
	bh=l2VVl6HCktb8Trn3uewOdbN+NvGoEaqcvBgkzvKy+JA=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=TbVnyTZiUVGCENZdrhusnbwtreoZKo0hXWSCgIgKDI7XRTl4dwsDmJLG8l6vRmK/d
	 bYG0ag6bdiR9cTwABakxK7BHS3hQbV/Kjl/qGEvu0u1l49SmXxtXyinTZERxMQk5UN
	 x5ktoAp5Tl+l9ElrkcJXS5/Z7D9iwHMiaGNRU9kg=
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
Subject: [PATCH v2 3/4] vhost-user-blk: move inflight_needed higher
Date: Wed, 11 Mar 2026 13:47:27 +0500
Message-Id: <20260311084728.751169-4-dtalexundeer@yandex-team.ru>
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

Will be used in future commits for adding skip_drain param

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 7f2067d6cf..1dc49c104e 100644
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

