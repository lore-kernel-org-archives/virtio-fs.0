Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0D31DDC35
	for <virtio-fs@lists.linux.dev>; Thu, 15 Jan 2026 08:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768464750; cv=none; b=flsHr4OyghvjZdvK/oCrNhlZqoslBosnyHfdbskpb5x7OkwAKzA2+qKKQ47DjO+qw/NSX6dAM3RkpsXX+TX9kX9sIeiad4bWvjyXZ/cilITbAH1ptBvcRtEPxsAPuFL80zOEmUZLdwe8O+53dOmTjhQ9b0R6g43V0ga8QobNLrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768464750; c=relaxed/simple;
	bh=4xxX7YgnUyaFwzhVn7oCmqEB6oN9dKSnubjsOtqhic4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IS2/op5KcTydXZhqb9iyTjTmiYhwAAYiEdpv6PHgjrlHnnuoj6Dpv4Z0ilzSS+NDS2J2FovaQQDlFeqAEMsaR8q+TDVj47SJ/MqAXOufJ9KT98LNH8BRYx5Y7xJp5l8PIXk+/Fw//y/z3KAwsP+3zP7Idjb7zWFIdOb36uE5LBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=BrwDHAtb; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="BrwDHAtb"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:5c05:0:640:ff67:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id D464C80860;
	Thu, 15 Jan 2026 11:12:26 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:973::1:c])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id PBQgfR0Ar8c0-cwpZoIb6;
	Thu, 15 Jan 2026 11:12:26 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768464746;
	bh=yWibqi19WvTNo5ModM1nu+rTjbF5ptLfVCEPC+ZLWJY=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=BrwDHAtbF7P6eQSj50sMp+ZcbTdmDyEL87+1vKdQfXEFooucrSJ9gfdRsFjhTssH3
	 2fS8lvAKG4j3qGcbAMF4dX5J9b8f+JrtyhGm5NnIZE96L6jzClvARGKPOVwnLxBf2e
	 XhEBtPiw9rAEjz6rt92gb4lcG0Q3LDGiaXUOb1DQ=
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
Subject: [PATCH v7 4/5] vhost: add vmstate for inflight region with inner buffer
Date: Thu, 15 Jan 2026 13:11:07 +0500
Message-Id: <20260115081103.655749-5-dtalexundeer@yandex-team.ru>
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

Prepare for future inflight region migration for vhost-user-blk.
We need to migrate size, queue_size, and inner buffer.

So firstly it migrate size and queue_size fields, then allocate memory
for buffer with
migrated size, then migrate inner buffer itself.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 hw/virtio/vhost.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 31e9704cdc..7ec2f6fc23 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1916,6 +1916,63 @@ void vhost_get_features_ex(struct vhost_dev *hdev,
     }
 }
 
+static bool vhost_inflight_buffer_pre_load(void *opaque, Error **errp)
+{
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
+    return true;
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
+static bool vhost_inflight_region_post_load(void *opaque,
+                                           int version_id,
+                                           Error **errp)
+{
+    struct vhost_inflight *inflight = opaque;
+
+    if (inflight->addr == NULL) {
+        error_setg(errp, "inflight buffer subsection has not been loaded");
+        return false;
+    }
+
+    return true;
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
 void vhost_ack_features_ex(struct vhost_dev *hdev, const int *feature_bits,
                            const uint64_t *features)
 {
-- 
2.34.1

