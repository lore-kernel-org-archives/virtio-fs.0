Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441F32BF22
	for <virtio-fs@lists.linux.dev>; Thu, 15 Jan 2026 08:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768464707; cv=none; b=a2pVKd6z63h5PTSXWgx3jJZxDmRyGxDygfOAO4zg0lmHJbg8a1jcKIoE9M6aNhbUKkOgROf84EBvHMMuCwA26Qr+2QgoCC87lIwBXEHxJmLeO4bU6PUjs1127PCKA6zBzyUsv6CgpeWPIe+FGRbuiZMQXLGVC/FO5zf0ZV33IqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768464707; c=relaxed/simple;
	bh=3SBAxyhYeHSsIt+0LJRhr5aB2GDPq/yj/etT/D0JAGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PiYvrGIM6PXFCjgRag7ElcqCHNogP7Gfbl34ZpqoaRqrBzMBN/xjhBi2X/LP6BiGEDa5cJVBQHvWOy7v/T0Z3fnZc0xtQJ6K57bQ9QWFZNtPkSnkPTbwTiGkmBGOVU3HiuyYn+hqpHOV7l5G/OH8mZOFWLVP57UoC4YYEFTbEMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=wWZnlsEe; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="wWZnlsEe"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:5c05:0:640:ff67:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 9F5858079D;
	Thu, 15 Jan 2026 11:11:42 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:973::1:c])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id PBQgfR0Ar8c0-b6xzHH6u;
	Thu, 15 Jan 2026 11:11:41 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768464701;
	bh=9PPLyoAF9uKjuVtoYn1MDGNfeL/dGnEkHlCxh6noEqU=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=wWZnlsEef2jWKtgfbUvULnFiIs2HJa/xg9SaQvvrE0mT5OE6lsWDITpYP+aZR24gu
	 8K9axNx4l5pENwBlC2wuCvwrfuCF4FNZe0ZwfxjjJWK+2wXU7RhJWlaiGfeICIG+ws
	 J5LJ+DA69Umdg4WVYN+jVfQkQ733W5uIKWNuj8Kw=
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
Subject: [PATCH v7 1/5] vhost-user.rst: specify vhost-user back-end action on GET_VRING_BASE
Date: Thu, 15 Jan 2026 13:11:01 +0500
Message-Id: <20260115081103.655749-2-dtalexundeer@yandex-team.ru>
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

By default, we assume that server need to wait all inflight IO on
GET_VRING_BASE. However, this fact is not recorded anywhere in the
documentation.
So, add this info in rst.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 docs/interop/vhost-user.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 93a9c8df2b..66a8a2fbf3 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -1250,7 +1250,8 @@ Front-end message types
 
   When and as long as all of a device's vrings are stopped, it is
   *suspended*, see :ref:`Suspended device state
-  <suspended_device_state>`.
+  <suspended_device_state>`. The back-end must complete all inflight I/O
+  requests for the specified vring before stopping it.
 
   The request payload's *num* field is currently reserved and must be
   set to 0.
-- 
2.34.1

