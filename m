Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52DC3570BE
	for <virtio-fs@lists.linux.dev>; Mon, 12 Jan 2026 11:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768218334; cv=none; b=Lx8jTZOl8sCmOlUCv56v/FoSmc/qaEKhoX4D2YCim/1XJjj8PnoYPTxXg1kJFNxK9lwywUVSQks9hNeIKp9SfCCWJJxUhRyykcc6ig9SMjNb7I1RU2FZ5XxcKJuaO3cOc6URa/2B/TQHe1r5A0egUWyGsDLtjMbRn0HIlkoRKT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768218334; c=relaxed/simple;
	bh=LjlBgC6W2VvgCdOH7sx5M/ZJOQGVnx8NbiSWjFyG0bg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nztcoyEpnKi1fs53S570M8bxeNOSMazU8ZSTwNhhqZjZSyG9rEhtORIV9AUoLVvnDaKx1L9OmLyLaMj2yTLXTbF/Xh+Yxg/D7CdMeCOvudcfviHf7KQg98RC2qUJEWZRCuKjUgxbLRDafEAXxMzIJz/4KY3QSmpmIhzWB8FB8MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=LmDKMe3w; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="LmDKMe3w"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 35C48885CF;
	Mon, 12 Jan 2026 14:45:31 +0300 (MSK)
Received: from dtalexundeer-nx.yandex.net (unknown [2a02:6bf:803e:400:6fcf:dbb2:9b0:d80b])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 6jQQPI5AAW20-VkRKLOIh;
	Mon, 12 Jan 2026 14:45:30 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768218330;
	bh=z8PGdUQGuutXpE5KQ/Zomo9S+sDSgjZY1LOIsQYZrpI=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=LmDKMe3wTln9h3nZBQEMkxhuMIFKR7qr4HlyUdPKEe6IfuuK92TRKLVcWlwYpInw9
	 +aLgpVgnQTURHmpAJg50T9GPAD0BGargW4gvAMLDgYsHhoWJMPQ7iRBvxSGkhgZJwl
	 461asNhsmftuDoLYhYScaCvWkXN4s1E/d8j8s4v8=
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
Subject: [PATCH v5 4/5] vhost: add vmstate for inflight region with inner buffer
Date: Mon, 12 Jan 2026 16:45:02 +0500
Message-Id: <20260112114503.1174330-5-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260112114503.1174330-1-dtalexundeer@yandex-team.ru>
References: <20260112114503.1174330-1-dtalexundeer@yandex-team.ru>
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
 hw/virtio/vhost.c         | 42 +++++++++++++++++++++++++++++++++++++++
 include/hw/virtio/vhost.h |  6 ++++++
 2 files changed, 48 insertions(+)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index c46203eb9c..9a746c9861 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -2028,6 +2028,48 @@ const VMStateDescription vmstate_backend_transfer_vhost_inflight = {
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
+const VMStateDescription vmstate_vhost_inflight_region = {
+    .name = "vhost-inflight-region",
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

