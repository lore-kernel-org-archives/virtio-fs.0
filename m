Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C058357715
	for <virtio-fs@lists.linux.dev>; Mon, 12 Jan 2026 11:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768218331; cv=none; b=GbKUHQEhtijFkfR8vTGQatybh0DN9nqD/y0SMw/LxgXZ14zIolj5xNdYVEaDsnpSpkUyfzAQjdaUGzYHGZL81dLkOXNY7yqWqBus3dMCCMyS56boimQdl6tKrtjTPeCJXZ1EwRblH6F846vI8E8LlYdY8Y+Z+XdfVedQArmCiac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768218331; c=relaxed/simple;
	bh=0M6MhDkgu3beGy7lBTMWRuWeXmPGsngNhTxF7SmDOfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PENU6Q1Xr5SuiU7+GP1TyG+xeI5z0rCJrBcMDN+WowEF1b0EBWZNrtyh+udKCvELj9PAGkgELjwwq/wkDYm6Fq55RuwDNl539RZU+9ivIHSQ3pewMjXPOQtKrRB+KBTz5r85J3R+YBRWYIHsAuRsZjYOWC+q3MeHooXj0Ur1wIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=e6wmly16; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="e6wmly16"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 8BA8B80809;
	Mon, 12 Jan 2026 14:45:28 +0300 (MSK)
Received: from dtalexundeer-nx.yandex.net (unknown [2a02:6bf:803e:400:6fcf:dbb2:9b0:d80b])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 6jQQPI5AAW20-YNq35SCM;
	Mon, 12 Jan 2026 14:45:27 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768218328;
	bh=OuFWa9+MzavqJkI10h1F+5VsTtN4q5muV91G/8fFCZo=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=e6wmly16BEbGOQQVRGkU3FvAzTshHnEvmvmYPGhqXXzq45seztlShJTjFGMLp43DB
	 oBlIaBKM6+CQuJp01KpOzQ1UG4EDIp/Xel+SXCpaHk4XoE8/9iKyZJaSR6T4Mdz5AJ
	 418CWcUJLTEG6Q3XP7OkHcZLis6p6+c7olQEHRgA=
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
Subject: [PATCH v5 3/5] vmstate: introduce VMSTATE_VBUFFER_UINT64
Date: Mon, 12 Jan 2026 16:45:01 +0500
Message-Id: <20260112114503.1174330-4-dtalexundeer@yandex-team.ru>
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

This is an analog of VMSTATE_VBUFFER_UINT32 macro, but for uint64 type.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
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

