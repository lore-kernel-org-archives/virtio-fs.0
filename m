Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48581DDC35
	for <virtio-fs@lists.linux.dev>; Thu, 15 Jan 2026 08:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768464765; cv=none; b=DNGCsm8vx/WM35pOAztJzh8sCdlzK4uHy6fARhFqXbQcdA9BgRUdL0pIvDHqzwlec/Sc8VD9ChnVmekrDbPa/6/56Udoa+9gCd2k6iRPK9y1lvgCzVCDy91JjcO4uSGT9qnkQD3wLepdBkbjUErePZJSj1eWHmMYpcj4DLlKJHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768464765; c=relaxed/simple;
	bh=yuM2XO8Fi5rVV3SBX59mXLpKxRIetZ9aIjzWf8wJJWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aF4DJ5GTVJYuj0I6ntdRM9JbSD0H7CMlrlotrMniKzONn0qoklthVfxJ1//ilUmuNxy5iZUeu3KN+DdFPbOc7bEp8OrYlWXhdI5P9MFcgcEs2Sad3sjo9xTJCaOz9XCy+RCsUsh42hSf24tj0Rf2MRns1v6oJCEk82RWmuDd5fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=EJl5erSo; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="EJl5erSo"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:5c05:0:640:ff67:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 241CCC0151;
	Thu, 15 Jan 2026 11:12:41 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:973::1:c])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id PBQgfR0Ar8c0-OgOdefDm;
	Thu, 15 Jan 2026 11:12:40 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768464760;
	bh=X3OeDLmKjVV7/P6aJCTi/mebxCg/pOWZ8d2ftLLT6Rg=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=EJl5erSoqRp2bfoZbkQIRY1krXauPegVhb7e0mJOS0XUOCftw1Rizq7aV3PXWjG4g
	 sPrbRl/s+hIeZEPGajNBp7hidYTD7H3TkDnj1EhjZNqkrHbYJ/4ua1j0jLrWI9/CPT
	 GbZDw4MXyctD6kCxDHu+f7AdMSc8on0x+iY6QXBU=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
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
Subject: [PATCH v7 5/5] vhost-user-blk: support inter-host inflight migration
Date: Thu, 15 Jan 2026 13:11:09 +0500
Message-Id: <20260115081103.655749-6-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260115081103.655749-1-dtalexundeer@yandex-team.ru>
References: <20260115081103.655749-1-dtalexundeer@yandex-team.ru>
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
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 hw/block/vhost-user-blk.c          | 27 +++++++++++++++++++++++++++
 include/hw/virtio/vhost-user-blk.h |  1 +
 include/hw/virtio/vhost.h          |  6 ++++++
 3 files changed, 34 insertions(+)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 4d81d2dc34..c151e83677 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -353,6 +353,7 @@ static int vhost_user_blk_connect(DeviceState *dev, Error **errp)
     vhost_dev_set_config_notifier(&s->dev, &blk_ops);
 
     s->vhost_user.supports_config = true;
+    s->vhost_user.supports_inflight_migration = s->inflight_migration;
     ret = vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
                          errp);
     if (ret < 0) {
@@ -568,6 +569,26 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
     return &s->dev;
 }
 
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
 static const VMStateDescription vmstate_vhost_user_blk = {
     .name = "vhost-user-blk",
     .minimum_version_id = 1,
@@ -576,6 +597,10 @@ static const VMStateDescription vmstate_vhost_user_blk = {
         VMSTATE_VIRTIO_DEVICE,
         VMSTATE_END_OF_LIST()
     },
+    .subsections = (const VMStateDescription * const []) {
+        &vmstate_vhost_user_blk_inflight,
+        NULL
+    }
 };
 
 static const Property vhost_user_blk_properties[] = {
@@ -591,6 +616,8 @@ static const Property vhost_user_blk_properties[] = {
                       VIRTIO_BLK_F_WRITE_ZEROES, true),
     DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
                      skip_get_vring_base_on_force_shutdown, false),
+    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
+                     inflight_migration, false),
 };
 
 static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
diff --git a/include/hw/virtio/vhost-user-blk.h b/include/hw/virtio/vhost-user-blk.h
index 8158d4673d..1e41a2bcdf 100644
--- a/include/hw/virtio/vhost-user-blk.h
+++ b/include/hw/virtio/vhost-user-blk.h
@@ -52,6 +52,7 @@ struct VHostUserBlk {
     bool started_vu;
 
     bool skip_get_vring_base_on_force_shutdown;
+    bool inflight_migration;
 };
 
 #endif
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 08bbb4dfe9..89817bd848 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -554,4 +554,10 @@ static inline int vhost_load_backend_state(struct vhost_dev *dev, QEMUFile *f,
 }
 #endif
 
+extern const VMStateDescription vmstate_vhost_inflight_region;
+#define VMSTATE_VHOST_INFLIGHT_REGION(_field, _state) \
+    VMSTATE_STRUCT_POINTER(_field, _state, \
+                           vmstate_vhost_inflight_region, \
+                           struct vhost_inflight)
+
 #endif
-- 
2.34.1

