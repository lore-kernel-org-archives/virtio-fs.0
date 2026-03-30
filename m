Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EC13AB265
	for <virtio-fs@lists.linux.dev>; Mon, 30 Mar 2026 09:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774864367; cv=none; b=OmfN2P01AHswp3I86522X3UKDzeVflYQSZjO3z9ebw6wFUVGuipMgIyVFDJAAGY/Qnae5y0pPVFwWkOmBzXDo0dbu/UGBJ94eMd48UPuSZUggMuSjMROwRyJCaXQRi49xO9sw2upTmR6G2CG/jQPDejaWqsXYlhB08cbvdjCldE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774864367; c=relaxed/simple;
	bh=rjgbqVIyuvD25SBRFHN64jC+xFU18szt5wHvbb1hxoM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qw9+A1/lsz1RwY2hE1iKorEIkIE/AjP2lBVGaNFw66Tu2guDsjz/bhCEEJCUhYfPQDXRZ/FRcX6SyPsEDkUef72TpUZ2DXoLa23FsqxT8kCJsecVkMTko5qlqpR00vfT/czpeqOracOkRr3+Vb8wJPeLUQ/HtsDo9xBs/bjO5dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=YS9HkHhn; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="YS9HkHhn"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:3530:0:640:eca4:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id A3243C01E5;
	Mon, 30 Mar 2026 12:52:35 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:78d::1:13])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id QqVNFG1Af4Y0-XlRxK0sQ;
	Mon, 30 Mar 2026 12:52:35 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774864355;
	bh=cmwYlbRQeO8i6Sbb89Cm3qYzyWoFQi611UFOyJsDgVI=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=YS9HkHhnegztKtTz0nTwS+9rSCTCeV51yUorWZj6rAvkmHG0dC/O771bPtoYTQNTd
	 iaRneoCMFsgMmNDLwRZY0EZJk4Aqg7JxmJhDW5avvYQVHItxjroNADplU8tZDky6WL
	 sJvNR7OKl6HTZvyBhFLqrcqpfLM3j2PrF9wz1HiI=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Milan Zamazal <mzamazal@redhat.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	qemu-block@nongnu.org,
	Fam Zheng <fam@euphon.net>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Hanna Reitz <hreitz@redhat.com>,
	virtio-fs@lists.linux.dev,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Kevin Wolf <kwolf@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Subject: [PATCH v3 1/5] vhost-user.rst: fix typo
Date: Mon, 30 Mar 2026 14:52:22 +0500
Message-Id: <20260330095226.158386-2-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
References: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 docs/interop/vhost-user.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 137c9f3669..bfa75ff9a3 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -1268,7 +1268,7 @@ Front-end message types
   How to suspend an in-flight request depends on the implementation of the back-end
   but it typically can be done by aborting or cancelling the underlying I/O
   request. The ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT``
-  protocol feature must only be neogotiated if
+  protocol feature must only be negotiated if
   ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD`` is also negotiated.
 
 ``VHOST_USER_SET_VRING_KICK``
-- 
2.34.1

