Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD553B8926
	for <virtio-fs@lists.linux.dev>; Wed, 11 Mar 2026 08:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773219002; cv=none; b=GsogGI2Nvru3cIFoA9VF7lRiC8qSO26G706UIsTGB/gS7Tiso5Y7DQ8alJ6TLGtScwXXnHYILIwFwLjL+BnHR8UT3IGGhXgHtCuVlShh9ePz6c1AKR82lBEOe6kLusdoKxM2oB6J0YkZS6ejIJITXECHsqpEj/IOImkXTOIaRdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773219002; c=relaxed/simple;
	bh=cm07KD5jp2qxcgeslliQlxUWu7FQO1bDQcAUc1SZ9zQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nk2ni5ee7N3LiIaaflkK0XnkxBggjCHQCYDFVGTFkF22/Q/tW1yZjUfyTiTN3tw5K6UpsFcz6G/omj9bwwapXQ3uySUgQbD3lwK5NUYtYj1CrCVNb30Hs+TiviFzOqx5w3Nf2zjKQDTkBbXREgPD1BduJ1SXXp9eH7VxIAS1o88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=nlZfs4F6; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="nlZfs4F6"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:bf1f:0:640:c739:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id D5D368082C;
	Wed, 11 Mar 2026 11:47:40 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:b38::1:12])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TlBqj00AleA0-LSrHIX8r;
	Wed, 11 Mar 2026 11:47:40 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1773218860;
	bh=eyqrprl6+xFGXQOmGuqrFJPUo2zVTAn+JMzLZkciUPY=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=nlZfs4F6G8VFnXfw2a0tfeJfvypGW36ijB8w4D6Uxrq0FXq5hXfDPWNwHzBvOXp66
	 HCUvODBfe4J3k2bMNzJ3rKaJfiY5loccPLGY3HmCmWWSoCS+D6m1/5GoDD6nFFwrKO
	 A8jjU1WAbiun4viOhSCDBLTY7YrT7xPLFrf77M50=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: virtio-fs@lists.linux.dev,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Hanna Reitz <hreitz@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	qemu-block@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	Kevin Wolf <kwolf@redhat.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v2 1/4] vhost-user.rst: fix typo
Date: Wed, 11 Mar 2026 13:47:25 +0500
Message-Id: <20260311084728.751169-2-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260311084728.751169-1-dtalexundeer@yandex-team.ru>
References: <20260311084728.751169-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

