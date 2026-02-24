Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29D73644AD
	for <virtio-fs@lists.linux.dev>; Tue, 24 Feb 2026 07:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771919567; cv=none; b=qpf6d/T1MaDL+EW8y064wB4rkO4x7LBKR1xghWOY/z26TiVZGclrciewBtVptKYQKHEyzoTqnyMSEmPlaVhl90aV+IZQtJL0h0WOJawrQYo9K3se1HvPcEefCCmV39cp77EJxlaTejNu5FJeboNYTVb90d7IBdI5zctmgOYPTYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771919567; c=relaxed/simple;
	bh=5ShYPjtYeXe5VWy0guK4YZiWcVTFh0O1ZkqFzkVxQ44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X+2ICXW71dr3My3w2cxfusXlLBnvT89q5pGSIJd+3es4fYXseXy7kAa2+mf0WEO1sPOTkjEFEI4PsmjmTC+MtoCEfFV13WMdSxffO6aeyf4Opl7DCGolk8yvq9Fnz/EF52faR/eYXHo3Whrx9lxa/k3voBT9KJWp23DF2hE6erM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=sSvSIg8U; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="sSvSIg8U"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1e1e:0:640:c6a6:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id D6054808F0;
	Tue, 24 Feb 2026 10:51:15 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:515::1:1d])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id uoat9O6Am8c0-fCWuIHaQ;
	Tue, 24 Feb 2026 10:51:15 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1771919475;
	bh=s8Mhu3rvPCe/9cEIkSGWUVgs1v5Ac7g2d4QYfePZHl0=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=sSvSIg8UZRftLLnu+vBW3EChK0wvh7wAxUqA4VUNLJT/C/V9B4u39YAtGnELlGoT5
	 RAZiae8j25ReAfcKXtLzC3e8L4L3nMpPM1c1J2mK/tghy7vvtvF+JyLBXdfIFquCpO
	 WDfk9VBAQm6lZbrXY0tnDBqfLNTjsa1Qt/vuFXI0=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Raphael Norwitz <rnorwitz@nvidia.com>,
	virtio-fs@lists.linux.dev,
	Milan Zamazal <mzamazal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	qemu-block@nongnu.org,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH 4/4] vhost-user-blk: make inflight migration throught skip_drain
Date: Tue, 24 Feb 2026 12:50:55 +0500
Message-Id: <20260224075055.863068-5-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260224075055.863068-1-dtalexundeer@yandex-team.ru>
References: <20260224075055.863068-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use skip_drain on GET_VRING_BASE to suspend in-flight I/O requests, and
then migrate them throught inflight subsection.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 3421145f23..4e606fd0fc 100644
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
+    return inflight_migration && s->inflight_migration;
+}
+
+
 static int vhost_user_blk_start(VirtIODevice *vdev, Error **errp)
 {
     VHostUserBlk *s = VHOST_USER_BLK(vdev);
@@ -221,11 +232,13 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
         return 0;
     }
 
+    bool skip_drain = vhost_user_blk_inflight_needed(s);
+
     force_stop = s->skip_get_vring_base_on_force_shutdown &&
                  qemu_force_shutdown_requested();
 
     ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
-                       vhost_dev_stop(&s->dev, vdev, true, false);
+                       vhost_dev_stop(&s->dev, vdev, true, skip_drain);
 
     if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false) < 0) {
         error_report("vhost guest notifier cleanup failed: %d", ret);
@@ -568,16 +581,6 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
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

