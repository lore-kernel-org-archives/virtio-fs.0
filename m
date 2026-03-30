Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6633B27D3
	for <virtio-fs@lists.linux.dev>; Mon, 30 Mar 2026 09:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774864366; cv=none; b=nxa9lW9YitVjWAT0UW4WYy5tt++lroqyDq8qlyj5IS7DPnhbobLL6/Ei68VfyT3sVDrKgNGXWwnPcO/UHzm+SM05Jrj+et/nPlSu/9dbUQ4dsn1TGjMRFI4w63c1zzHb930rorTKfdn6dEh6UZlzunQtSFoPtm+/FqmNj9d3qTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774864366; c=relaxed/simple;
	bh=hBpvkpl2Obr+2aeu0/4RxGbHTzlkDEkHO85r00U5/oI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F+aYODG9sU7xjNQoF4AepMq/LFpwrxqWdmN7ycZQQ1HId2ZJ2L4WsJBkrm9DdxMVI9Kzs/dFq5xSMKGP7hilLrzRLkJ/WYC6HNHdsF2CERLp4AhxKhqxXMR7dJlCYS8m3/CjMUm6Nb4KUKSEW5Vco4v9RLWVaQVVtNtHJqCKeV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=Y7StvfMd; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="Y7StvfMd"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:3530:0:640:eca4:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 346B6C01FC;
	Mon, 30 Mar 2026 12:52:37 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:78d::1:13])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id QqVNFG1Af4Y0-8tPIkIoj;
	Mon, 30 Mar 2026 12:52:36 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774864356;
	bh=tvpetmyA7aRUautwgNAeiVLIXNe7ZPT4ooJEso7UfBg=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=Y7StvfMdG2Y6ODvynRtmLOJJ7PI6ce07buwgUWgk8gxCFTlT0iKv59ZpsTAr32DFQ
	 2/L49NLbuwLuULrj2TAvCl2Tvh3fgZRadSVs++ACmgwjh+Rmew01tDqUrxHLpYgCHs
	 DjjkY9wWZaSRmYddF1IAbhjXpWGtHGfKWLegbY0k=
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
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v3 2/5] vhost-user-blk: make inflight-migration prop mutable
Date: Mon, 30 Mar 2026 14:52:23 +0500
Message-Id: <20260330095226.158386-3-dtalexundeer@yandex-team.ru>
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

Now this property can be turned on or off using the qom-set

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index c151e83677..179f027cb4 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -603,6 +603,8 @@ static const VMStateDescription vmstate_vhost_user_blk = {
     }
 };
 
+static PropertyInfo vhost_user_blk_inflight_migration_prop;
+
 static const Property vhost_user_blk_properties[] = {
     DEFINE_PROP_CHR("chardev", VHostUserBlk, chardev),
     DEFINE_PROP_UINT16("num-queues", VHostUserBlk, num_queues,
@@ -616,8 +618,9 @@ static const Property vhost_user_blk_properties[] = {
                       VIRTIO_BLK_F_WRITE_ZEROES, true),
     DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
                      skip_get_vring_base_on_force_shutdown, false),
-    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
-                     inflight_migration, false),
+    DEFINE_PROP("inflight-migration", VHostUserBlk, inflight_migration,
+                vhost_user_blk_inflight_migration_prop, bool,
+                .set_default = true, .defval.u = false),
 };
 
 static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
@@ -649,6 +652,9 @@ static const TypeInfo vhost_user_blk_info = {
 
 static void virtio_register_types(void)
 {
+    vhost_user_blk_inflight_migration_prop = qdev_prop_bool;
+    vhost_user_blk_inflight_migration_prop.realized_set_allowed = true;
+
     type_register_static(&vhost_user_blk_info);
 }
 
-- 
2.34.1

