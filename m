Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B3926FD97
	for <virtio-fs@lists.linux.dev>; Mon, 29 Dec 2025 10:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767003811; cv=none; b=WIckIPzdW7ZXQjenBdWdBklI0H6JBIGdjAH37ZxE9tmxz/I4KmGuB1Wn6uVl1x72P24Yw0AATncITqYQEXmrz9pKQH4tra4VN3JcYJPHzTxGydd/NXBWSh4z/78Jyp4fVPsCj4+Xd/VC87ya1++Ug2L/C/dirm+0hf2q+XJtcHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767003811; c=relaxed/simple;
	bh=LhLfNGBcZOCC0hPGOFWS/12nCnquWsQ3TGMiPr+oFsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n5ZVqJwC6DhvDE2LXTLffRjFO7TZ36WJ9Mm8dEm7bOBg3x23DGAwvv6fxEQ3RN5n/N5YpN78Ge/JqoUw7vkvc8S/X8dj85J2qOVZIgFcO4Uxe0l/2G+TBQc0pifvYn4IW+crTUpkooMSgaUKAOWZESpl+hpvZR6MCv3Ju9KhBI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=yjZLNBs/; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="yjZLNBs/"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:7394:0:640:5a8a:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 83D3DC0154;
	Mon, 29 Dec 2025 13:21:34 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:b4e::1:2a])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id HLeDGC1Ck0U0-KSSM3rgi;
	Mon, 29 Dec 2025 13:21:33 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1767003694;
	bh=ZAd/Fxgvks8ojlWBXFbKSd9KMAVUVGhazsRwe+yiqKM=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=yjZLNBs/3TdfWU3E7J/lzviCsR+GMrsoHkmhNJ3nirKhJCiW4EauPlZS6IZhilZFW
	 fkBP1GqkXVuC8kVpN7FB5X8n57f6lv0l/NKb8c4gARSuJ/KUV3Y0Ah83w3ZN3+xtp7
	 sRy1ApHHZXs7cqOUczb+oij1HuFCdyT/7xDuv/Y0=
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
Subject: [PATCH v4 1/5] vhost-user.rst: specify vhost-user back-end action on GET_VRING_BASE
Date: Mon, 29 Dec 2025 15:21:05 +0500
Message-Id: <20251229102107.1291790-2-dtalexundeer@yandex-team.ru>
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

By default, we assume that server need to wait all inflight IO on
GET_VRING_BASE. However, this fact is not recorded anywhere in the
documentation.
So, add this info in rst.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 docs/interop/vhost-user.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 2e50f2ddfa..02908b48fa 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -1243,7 +1243,8 @@ Front-end message types
 
   When and as long as all of a device's vrings are stopped, it is
   *suspended*, see :ref:`Suspended device state
-  <suspended_device_state>`.
+  <suspended_device_state>`. The back-end must complete all inflight I/O
+  requests for the specified vring before stopping it.
 
   The request payload's *num* field is currently reserved and must be
   set to 0.
-- 
2.34.1

