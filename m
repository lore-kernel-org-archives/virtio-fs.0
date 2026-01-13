Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10353806B7
	for <virtio-fs@lists.linux.dev>; Tue, 13 Jan 2026 09:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768298347; cv=none; b=JHMcH3pE+RRYP39+KPYCX0iAxlMmgkh1OxdqkTfAhfKMY+wQXNOsGaV8tU9YbZ7p5Gafzn/qrMutQ5VflJ321uEqtLZZMm0E5iPqigBhaHBipqEqtlj5e1pGEk7bB1VGYXJlawMBXEy/RQi1BnPGprN+aVJDv1Wem4Nr5Duti0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768298347; c=relaxed/simple;
	bh=t55fqDFLRyj/RT7EU7+4oCtIowxZ93oJoEH6b40RFmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vDBsykw6nyeKSKY5xJLYKF/NtwgvL4WM+BqLb83YsizyAadqHJd3iicpnKh5UjLTqza3gia/irxaWiR1HL8Nk9lzuUfCh6CjUhbGsIi+bMpC7JFjHk6bhXZJpguLp75CepxZNIjodSXTLykLDF2vo2kvvgdYzgw8ukH+hIcbkC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=J58cdWhn; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="J58cdWhn"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 2C14A8085D;
	Tue, 13 Jan 2026 12:59:04 +0300 (MSK)
Received: from dtalexundeer-nx.yandex.net (unknown [2a02:6bf:803e:400:93c4:8e38:1f90:3c73])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id KwPsag5AAiE0-leX9UN8b;
	Tue, 13 Jan 2026 12:59:03 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768298343;
	bh=strUFTdyj30J5yE2cBIXci40KmPq9NaRqGWVIA7ALD4=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=J58cdWhn9GWLtrAhxFxJ2bkXJruf7DB8CCX8gzUSqpvE+dlLsohEOpvmndzahUvhP
	 sWYowF3d8SHCZ5jIqDSX+KJqIi0jNtNFb1IeNB3s5ZOaigojUmr7HK/B0VKIiTvIzV
	 dD4Ak6lzFgj7LqQeRy0vIWbRfoD7T4dIJDMDoWtU=
Authentication-Results: mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	mzamazal@redhat.com,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v6 5/5] vhost-user-blk: support inter-host inflight migration
Date: Tue, 13 Jan 2026 14:58:19 +0500
Message-Id: <20260113095813.134810-6-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During inter-host migration, waiting for disk requests to be drained
in the vhost-user backend can incur significant downtime.

This can be avoided if QEMU migrates the inflight region in
vhost-user-blk.
Thus, during the qemu migration, with feature flag the vhost-user
back-end can immediately stop vrings, so all in-flight requests will be
migrated to another host.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c          | 28 ++++++++++++++++++++++++++++
 include/hw/virtio/vhost-user-blk.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index a8fd90480a..9093e98841 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -377,6 +377,7 @@ static int vhost_user_blk_init(DeviceState *dev, bool connect, Error **errp)
     vhost_dev_set_config_notifier(&s->dev, &blk_ops);
 
     s->vhost_user.supports_config = true;
+    s->vhost_user.supports_inflight_migration = s->inflight_migration;
     ret = vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
                          false, errp);
     if (ret < 0) {
@@ -656,6 +657,27 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
     return &s->dev;
 }
 
+static bool vhost_user_blk_inflight_needed(void *opaque)
+{
+    struct VHostUserBlk *s = opaque;
+
+    bool inflight_migration = vhost_dev_has_feature(&s->dev,
+                        VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
+
+    return inflight_migration &&
+           !migrate_local_vhost_user_blk();
+}
+
+static const VMStateDescription vmstate_vhost_user_blk_inflight = {
+    .name = "vhost-user-blk/inflight",
+    .version_id = 1,
+    .needed = vhost_user_blk_inflight_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_VHOST_INFLIGHT_REGION(inflight, VHostUserBlk),
+        VMSTATE_END_OF_LIST()
+    },
+};
+
 static bool vhost_user_blk_pre_incoming(void *opaque, Error **errp)
 {
     VHostUserBlk *s = VHOST_USER_BLK(opaque);
@@ -678,6 +700,10 @@ static const VMStateDescription vmstate_vhost_user_blk = {
         VMSTATE_VIRTIO_DEVICE,
         VMSTATE_END_OF_LIST()
     },
+    .subsections = (const VMStateDescription * const []) {
+        &vmstate_vhost_user_blk_inflight,
+        NULL
+    }
 };
 
 static bool vhost_user_needed(void *opaque)
@@ -751,6 +777,8 @@ static const Property vhost_user_blk_properties[] = {
                       VIRTIO_BLK_F_WRITE_ZEROES, true),
     DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
                      skip_get_vring_base_on_force_shutdown, false),
+    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
+                     inflight_migration, false),
 };
 
 static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
diff --git a/include/hw/virtio/vhost-user-blk.h b/include/hw/virtio/vhost-user-blk.h
index b06f55fd6f..e1466e5cf6 100644
--- a/include/hw/virtio/vhost-user-blk.h
+++ b/include/hw/virtio/vhost-user-blk.h
@@ -52,6 +52,7 @@ struct VHostUserBlk {
     bool started_vu;
 
     bool skip_get_vring_base_on_force_shutdown;
+    bool inflight_migration;
 
     bool incoming_backend;
 };
-- 
2.34.1

