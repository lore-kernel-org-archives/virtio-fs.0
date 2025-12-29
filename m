Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D2C28643A
	for <virtio-fs@lists.linux.dev>; Mon, 29 Dec 2025 10:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767003754; cv=none; b=Bm1GoMxVlrPPoIT98tYYHZVsWzOiqD0crUQXe4QgY4D4JaMr0keo5SgI8fRqzKl1fMX6O0rVQorVVm4vIngEX31phid28HD9PM8LWwiw3NjV0WXmf2BqnwW1H6GcdPT9PP1NYIh+fN4eky93m7oaGXwxWfqjI4qUvi+7iCMcT00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767003754; c=relaxed/simple;
	bh=x586OW5dgCbxgMxAuMZqe2p+JJvZ3btp3P0OobpU/R4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XaNQfJnHGimT+m1B9bkfSjbbaGRubDgBsrMglb4GgkN8magThO31hz439NzB5wqNwWV9JNEFua8B2YTNRuFXYGE/E8sSQEm1ZVAggf/ptR7rHtPjzQdZh5mN5bs3Jv22AAeRe9/t43a1uJRszq3y/1SRcYB08Ovkl6Q0x9o0CC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=qjZrJbBl; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="qjZrJbBl"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:7394:0:640:5a8a:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 3BAA2C0161;
	Mon, 29 Dec 2025 13:22:27 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:b4e::1:2a])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id HLeDGC1Ck0U0-Q5LwhvEO;
	Mon, 29 Dec 2025 13:22:26 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1767003746;
	bh=BBaLzRPC1vSdvTfCEYutHaoyo6yavs9dofrXa1+5uLk=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=qjZrJbBlQxrgbzsbBZp0qOBZ5BDR26UIx4EwC3o0qNn1EtiboliYem6DOz7YCzImY
	 x1q8TbvoX2wqV9n+NmvEsniWwIaZnedX+GFBVAxTdxIFKIcH1u60CKx4/PLuy4HxaP
	 3Z98pBYyX8kckcRhqU4JIPdaTKcGD5YXdqsq0WY0=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
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
Subject: [PATCH v4 3/5] vmstate: introduce VMSTATE_VBUFFER_UINT64
Date: Mon, 29 Dec 2025 15:21:10 +0500
Message-Id: <20251229102107.1291790-4-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251229102107.1291790-1-dtalexundeer@yandex-team.ru>
References: <20251229102107.1291790-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an analog of VMSTATE_VBUFFER_UINT32 macro, but for uint64 type.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Acked-by: Peter Xu <peterx@redhat.com>
---
 include/migration/vmstate.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/migration/vmstate.h b/include/migration/vmstate.h
index 7f1f1c166a..4c9e212d58 100644
--- a/include/migration/vmstate.h
+++ b/include/migration/vmstate.h
@@ -707,6 +707,16 @@ extern const VMStateInfo vmstate_info_qlist;
     .offset       = offsetof(_state, _field),                        \
 }
 
+#define VMSTATE_VBUFFER_UINT64(_field, _state, _version, _test, _field_size) { \
+    .name         = (stringify(_field)),                             \
+    .version_id   = (_version),                                      \
+    .field_exists = (_test),                                         \
+    .size_offset  = vmstate_offset_value(_state, _field_size, uint64_t),\
+    .info         = &vmstate_info_buffer,                            \
+    .flags        = VMS_VBUFFER | VMS_POINTER,                       \
+    .offset       = offsetof(_state, _field),                        \
+}
+
 #define VMSTATE_VBUFFER_ALLOC_UINT32(_field, _state, _version,       \
                                      _test, _field_size) {           \
     .name         = (stringify(_field)),                             \
-- 
2.34.1

