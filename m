Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E392DCF57
	for <virtio-fs@lists.linux.dev>; Tue, 13 Jan 2026 09:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768298340; cv=none; b=JB9xx5zsM4nBN6EThfb/dJ2DqrkqserxEmr8/WQdt/G1qlv2kL3mnwoikopQyl9arUTQnC5vsTkG8/CzLG8KcpndflkiDDbGhc9YS/azMKIEyC8CK/oaDpFwHx11oJD7spZAsDshioIxWbrlCJulIxlkqjHzGIjI78WMQZ1DwyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768298340; c=relaxed/simple;
	bh=XllB+raYIfePbKCQPUP+v0nu5bHaUHFvEJkjc8G6ATs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dH10PWXzAB6+nRy3I3oOA3eCsDSYNjFMpkdXmVCt/AuCCHKE7MYAnChj44k7kLpGqSqQqKw5ebeMBdh1XOn/3D0/KIcyR9RmWTrxQEK63J+wk8W1svVR6GydfIsGgzDPeN0/gDcKKDeIUVfHiT6Nzzsu56W6VNtXH0oiC47kwrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=z6eIawIK; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="z6eIawIK"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 7F3FB80872;
	Tue, 13 Jan 2026 12:58:57 +0300 (MSK)
Received: from dtalexundeer-nx.yandex.net (unknown [2a02:6bf:803e:400:93c4:8e38:1f90:3c73])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id KwPsag5AAiE0-9RUEQUNk;
	Tue, 13 Jan 2026 12:58:56 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768298337;
	bh=XMMSdWsV7hoMkKSn+5aQ4Vb4bLkyzG3T3BxpqQSyRxY=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=z6eIawIK1k28FBJ8W8Agi0YANlCVLNm3iHKIJbjS4RXxftRmRdmMmgSoX+qy9iysw
	 N5yvMy3allltUXdm3Bp460Idj02Nfy8aHeYvZ8XlAEzArgvSE/OBzQmnaPJ3y/1AQx
	 /uilIBWONTYZTguXqHOsCRqasvFNUACf3vOKcWrQ=
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
Subject: [PATCH v6 4/5] vhost: add vmstate for inflight region with inner buffer
Date: Tue, 13 Jan 2026 14:58:17 +0500
Message-Id: <20260113095813.134810-5-dtalexundeer@yandex-team.ru>
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

Prepare for future inflight region migration for vhost-user-blk.
We need to migrate size, queue_size, and inner buffer.

So firstly it migrate size and queue_size fields, then allocate memory for buffer with
migrated size, then migrate inner buffer itself.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/virtio/vhost.c         | 57 +++++++++++++++++++++++++++++++++++++++
 include/hw/virtio/vhost.h |  6 +++++
 2 files changed, 63 insertions(+)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index c46203eb9c..f655c53b67 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -2028,6 +2028,63 @@ const VMStateDescription vmstate_backend_transfer_vhost_inflight = {
     }
 };
 
+static int vhost_inflight_buffer_pre_load(void *opaque, Error **errp)
+{
+    info_report("vhost_inflight_region_buffer_pre_load");
+    struct vhost_inflight *inflight = opaque;
+
+    int fd = -1;
+    void *addr = qemu_memfd_alloc("vhost-inflight", inflight->size,
+                                  F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL,
+                                  &fd, errp);
+    if (*errp) {
+        return -ENOMEM;
+    }
+
+    inflight->offset = 0;
+    inflight->addr = addr;
+    inflight->fd = fd;
+
+    return 0;
+}
+
+const VMStateDescription vmstate_vhost_inflight_region_buffer = {
+    .name = "vhost-inflight-region/buffer",
+    .pre_load_errp = vhost_inflight_buffer_pre_load,
+    .fields = (const VMStateField[]) {
+        VMSTATE_VBUFFER_UINT64(addr, struct vhost_inflight, 0, NULL, size),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static int vhost_inflight_region_post_load(void *opaque,
+                                           int version_id,
+                                           Error **errp)
+{
+    struct vhost_inflight *inflight = opaque;
+
+    if (inflight->addr == NULL) {
+        error_setg(errp, "inflight buffer subsection has not been loaded");
+        return -EINVAL;
+    }
+
+    return 0;
+}
+
+const VMStateDescription vmstate_vhost_inflight_region = {
+    .name = "vhost-inflight-region",
+    .post_load_errp = vhost_inflight_region_post_load,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT64(size, struct vhost_inflight),
+        VMSTATE_UINT16(queue_size, struct vhost_inflight),
+        VMSTATE_END_OF_LIST()
+    },
+    .subsections = (const VMStateDescription * const []) {
+        &vmstate_vhost_inflight_region_buffer,
+        NULL
+    }
+};
+
 const VMStateDescription vmstate_vhost_virtqueue = {
     .name = "vhost-virtqueue",
     .fields = (const VMStateField[]) {
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 13ca2c319f..dd552de91f 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -596,6 +596,12 @@ extern const VMStateDescription vmstate_backend_transfer_vhost_inflight;
                            vmstate_backend_transfer_vhost_inflight, \
                            struct vhost_inflight)
 
+extern const VMStateDescription vmstate_vhost_inflight_region;
+#define VMSTATE_VHOST_INFLIGHT_REGION(_field, _state) \
+    VMSTATE_STRUCT_POINTER(_field, _state, \
+                           vmstate_vhost_inflight_region, \
+                           struct vhost_inflight)
+
 extern const VMStateDescription vmstate_vhost_dev;
 #define VMSTATE_BACKEND_TRANSFER_VHOST(_field, _state) \
     VMSTATE_STRUCT(_field, _state, 0, vmstate_vhost_dev, struct vhost_dev)
-- 
2.34.1

