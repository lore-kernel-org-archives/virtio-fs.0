Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D44329E44
	for <virtio-fs@lists.linux.dev>; Thu, 15 Jan 2026 08:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768464726; cv=none; b=BI0if1O3lgBFZXo68C7lnJsA2kKje+5z4uz1S/9x94cuARX1o1qPj9WTVctgU4khh8yVOiDZcfRDFTTbOuO3aCMxBrLr93bBXIpLXKQfgHFS7m/8EEHWa75HCszhn224RxP/TXF/7Vgfc6JFDUQMowIY8+by37KmIeCcoJdSV2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768464726; c=relaxed/simple;
	bh=+kVm912SgPls0VW7rgc1oqy8ap6wa4x4wc/Mhs+vTQw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P66svh1Qrrl4f0j3vc8zuW4SARdIAlrPbdk0ypjKmaCRc2IoTbdkU28gApVslzXcOwlTjCVLA7cL+gHr2ww+J1vl4F6qS+g1rZQB0xGIKYQNmmdPgA8YdZolFd18JlT20fjOPjyyw/qW1UpdZjUxLHSUIXjmRY5i5QscywbNnV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=nLcRzy8R; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="nLcRzy8R"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:5c05:0:640:ff67:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 87F6A807CA;
	Thu, 15 Jan 2026 11:12:02 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:973::1:c])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id PBQgfR0Ar8c0-GnWGz1AX;
	Thu, 15 Jan 2026 11:12:01 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768464721;
	bh=nBeIMr42F2tRyBKJ/U0V/dSfZ6JJ9mJbTs32bIyfWW0=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=nLcRzy8RdkS0c3Ennb4BCKa7nAVe4kmCtluCPzed3DzpILHHGbuDKeQR98DCXmvZh
	 LKm+coEeZjSx+mryOcHE6GZVxzbcrqnPyFBrtKnDnvbIBWAyLrcKqm3GXSsWrCwIJz
	 OplWBC9nunIKhqMkykO01yaiGF+9aipmPd917rwQ=
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
Subject: [PATCH v7 3/5] vmstate: introduce VMSTATE_VBUFFER_UINT64
Date: Thu, 15 Jan 2026 13:11:05 +0500
Message-Id: <20260115081103.655749-4-dtalexundeer@yandex-team.ru>
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

This is an analog of VMSTATE_VBUFFER_UINT32 macro, but for uint64 type.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/migration/vmstate.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/migration/vmstate.h b/include/migration/vmstate.h
index ed9095a466..89f9f49d20 100644
--- a/include/migration/vmstate.h
+++ b/include/migration/vmstate.h
@@ -706,6 +706,16 @@ extern const VMStateInfo vmstate_info_qlist;
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

