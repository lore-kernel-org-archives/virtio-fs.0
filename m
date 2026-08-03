Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB50239FCB1
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 07:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785742167; cv=none; b=TWN/KW03LerUEUvXlDkRv90hC395YcnjlZGQaUO4P9GEMd5lSCKn4HoVym5CoxWdaldCj6HjYa918dEF71YCpUHP8M9J2SnGv4ekl2OOP0e8PG29by0gRWBw9qtVqjwPkCeU+W330e2AwqN6UexSCxoupEuGMjn6PQ+SCii/UyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785742167; c=relaxed/simple;
	bh=W9Uv/wsAxgK3G1RjTqceGHkv3MDd4fMcJQNPrQmjgSA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q14Fr8ldFUmkyNv0slDD0LDtfA5bwLDVFv06Fr2nVT2nNhjK+p8RShV8AOs4jaNX4Z4cpwcYb4MmAmGkRT53XVUAiu5zHyii0+uBCLTBhEggFx9DBwI416MGmcyy+mw6oglrjZjXzxz/fxJK4s6m3P8qVysPIN3BBCP5Psx7EDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=O7dzMKJE; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="O7dzMKJE"
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:65a0:0:640:e1de:0])
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id A1D0880D53;
	Mon, 03 Aug 2026 10:29:21 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:a53::1:f])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp) with ESMTPSA id rSdSxZ08oGk0-3qVFiAP3;
	Mon, 03 Aug 2026 10:29:21 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785742161;
	bh=16lP9WkId4tMUMj/wHCbByTfSWJyYK7Hisx0zTCruhY=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=O7dzMKJEKvy95xMQuC7D3PynJehYXBvS4eiuHrL1ATVe9NMjqvl/p13faJ1L0/X3F
	 vsDBDAIcUiF1cxKeTkTdJ7Zb4/t77uuxjzDIXnpzOAmVGaLZ7ce7KsKUrIU1kIgCqH
	 yToUViiYuRpcKiUo2BBd0i0lpcq1qsYaD+IOj3Lw=
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
Subject: [PATCH v6 4/6] vhost-user-blk: make inflight-migration prop mutable on running vm
Date: Mon,  3 Aug 2026 12:28:51 +0500
Message-Id: <20260803072853.2920007-5-dtalexundeer@yandex-team.ru>
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

The inflight-migration property currently can only be set before the
device is realized. This makes it impossible to disable inflight
migration at runtime without restarting the VM.

Make the property mutable, but only while the VM is running. Blocking
changes when the VM is not running ensures that the value at stop time
reliably reflects the intent set on a live VM, which allows
vhost_user_blk_stop() to use skip_drain unconditionally based on the
property value without inspecting migration runstate.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index e3b873af7c..1aec3004de 100644
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
@@ -663,8 +666,29 @@ static const TypeInfo vhost_user_blk_info = {
     .class_init = vhost_user_blk_class_init,
 };
 
+static void vhost_user_blk_set_inflight_migration(Object *obj, Visitor *v,
+                                                  const char *name,
+                                                  void *opaque, Error **errp)
+{
+    DeviceState *dev = DEVICE(obj);
+
+    if (dev->realized && !runstate_is_running()) {
+        error_setg(errp, "Property '%s' cannot be changed "
+                         "while VM is not running", name);
+        return;
+    }
+
+    qdev_prop_bool.set(obj, v, name, opaque, errp);
+}
+
+
 static void virtio_register_types(void)
 {
+    vhost_user_blk_inflight_migration_prop = qdev_prop_bool;
+    vhost_user_blk_inflight_migration_prop.realized_set_allowed = true;
+    vhost_user_blk_inflight_migration_prop.set =
+        vhost_user_blk_set_inflight_migration;
+
     type_register_static(&vhost_user_blk_info);
 }
 
-- 
2.34.1

