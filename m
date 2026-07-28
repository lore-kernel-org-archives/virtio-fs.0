Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D095420898
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 10:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785233446; cv=none; b=tPuerKlzGQfx2MnGl6Qmbkx2CEKG6GNK9JwBDZsbBt5uYgyNO4Djr+IaMXeZf61pPCyT6wQcDFp6+oE2jJHd01IRC/cWexxhoO7mpZG/jd4gMGc0/ui/BhEyNxIh1v+v1jlxbPEXVWZ9UmhQlWlwAB9U/6xzJOVXFoQPhsnsrlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785233446; c=relaxed/simple;
	bh=elG7xP9FGKc4L+Q31eOLMJnNbI0Z1hjSClpWMtJTEc8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYUMbSZjvX+CFwEZIv5Y0jVW2lrQyGJETC5PS2q38HLCxXAq/UgPUmsV9bxCMKtFEh9V96+8baHWgNPJp0E+rUQhgVqe0xf5sJvR8xJlL+Zli5PM4YoDhS/brbKbdHz+nFOWzI0mudHP2+j6+NoJ9NNUkHUd/rbK5aIpDsN5cuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=Y6zNZ7D2; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="Y6zNZ7D2"
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (postfix) with ESMTPS id 3E4D0C09A8;
	Tue, 28 Jul 2026 13:08:55 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:803e:400:f26c:359c:adc2:62a4])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp) with ESMTPSA id f8aui7IXWGk0-gb4Hb0eZ;
	Tue, 28 Jul 2026 13:08:54 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785233334;
	bh=jdQNLvdhebT2vqm43eZYdjlv2yvTQdHv5CPyo0YoEfE=;
	h=Cc:Message-Id:References:Date:In-Reply-To:Subject:To:From;
	b=Y6zNZ7D2Rd6BAf1s/g9MTGwnQ8RKQ0jwULlfGGLWi22w/cUN9vDIVB/gDPp80b5OD
	 uiMQb8CcrhtlJThTNZ3b5b68AxkHmkQIGU67u7GpkfgvIAypID3RnpHM4gAyy6aEHW
	 l7xBnTQzH06ugSfNgUYBpIYWHh0QUuiaqWub++io=
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
Subject: [PATCH v5 4/6] vhost-user-blk: make inflight-migration prop mutable
Date: Tue, 28 Jul 2026 15:08:39 +0500
Message-Id: <20260728100841.3475774-5-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
References: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When migrating from a QEMU version that supports inflight-migration to
an older one that does not, there is no way to disable the feature at
runtime — the VM must be stopped and reconfigured. This is impractical
in production environments.

Make the inflight-migration property mutable after device realization
so it can be toggled via qom-set without restarting the VM.

Acked-by: Raphael Norwitz <rnorwitz@nvidia.com>
Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index e3b873af7c..650c004bde 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -619,6 +619,8 @@ static const VMStateDescription vmstate_vhost_user_blk = {
     }
 };
 
+static PropertyInfo vhost_user_blk_inflight_migration_prop;
+
 static const Property vhost_user_blk_properties[] = {
     DEFINE_PROP_CHR("chardev", VHostUserBlk, chardev),
     DEFINE_PROP_UINT16("num-queues", VHostUserBlk, num_queues,
@@ -632,8 +634,9 @@ static const Property vhost_user_blk_properties[] = {
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
@@ -665,6 +668,9 @@ static const TypeInfo vhost_user_blk_info = {
 
 static void virtio_register_types(void)
 {
+    vhost_user_blk_inflight_migration_prop = qdev_prop_bool;
+    vhost_user_blk_inflight_migration_prop.realized_set_allowed = true;
+
     type_register_static(&vhost_user_blk_info);
 }
 
-- 
2.34.1

