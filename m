Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C90C46AF08
	for <virtio-fs@lists.linux.dev>; Thu,  2 Jul 2026 09:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782983463; cv=none; b=kswXc9fOff11o/SWIrseuZpqPGTJUSd0nzbPt73p5qqx5l9yjO12RnA0hPyNis3dDOA19tfF4KWLgDGKf8fNnCN3cd+dFop+VbutjgAyZeHQx4usWMaM+VyC17j9Ql2CmA7IQWHzuxrIVoHZh9scUKQCk5P6hpRVfoF5TiGcX8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782983463; c=relaxed/simple;
	bh=+Ryycdc73ryoKh7LDmtWVJYi+u6/gFnEThlPOZLAnb4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EOnnfeEgzHlzIr2apzhzl3ikCA0ILTQP/eZ8lP6VFmmE2lnqiLJjA1TAiqSZQ9tedJ7hT2DCVdhXbTlJ+6VBhD/Hgp7qZJoNC1lfDjw9YPJNtuHQeVcnkvYTwkOjGSLoiGVsNJ65b/q5lAv1jbwoiMXVueCCzaRCJdtGQ6UWZhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=LG/jofjW; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="LG/jofjW"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 8FDE580AD7;
	Thu, 02 Jul 2026 12:10:53 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:43d::1:15])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp) with ESMTPSA id NAc7BT0aDa60-E9zXO6tG;
	Thu, 02 Jul 2026 12:10:52 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1782983453;
	bh=fnYdZrGDB2jf+p6qYkKFNYbklx4wqPr4tlqVx4gY4Is=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=LG/jofjWf9YvBR50R6jsC4n2CXaGLmTO9vAfKK+m+Adh85UI/nxh7wpxQBVTet0bS
	 yclJgYxdletiLgceau3dWDSKBY5G8cCmX8Er7oeJcUZcgxsdK2juX6u/BAwL1BLOHy
	 p+tPkQMNXKkdwsHM53eTmwTyyL68OkfwVbKe5ViY=
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
Subject: [PATCH v4 4/6] vhost-user-blk: make inflight-migration prop mutable
Date: Thu,  2 Jul 2026 14:10:21 +0500
Message-Id: <20260702091023.3306378-5-dtalexundeer@yandex-team.ru>
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

Now this property can be turned on or off using the qom-set

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

