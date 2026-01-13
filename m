Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0350538944C
	for <virtio-fs@lists.linux.dev>; Tue, 13 Jan 2026 09:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768298325; cv=none; b=oCHbbGjHcJ4wliXpl2266pjvIY8lwiS4EZxHDuYeh/W3riRobRywPF9B2dV2PRgrTlcmhTg5VamX8ceWZkk5v2tVKzwF+d2pEBFOOkjLA7WYiSGdsztKCO1N1+e0/fw8S6M2SNStedvMIK+1JJFEorWuWOrgts/xAcO44mQR/RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768298325; c=relaxed/simple;
	bh=LhLfNGBcZOCC0hPGOFWS/12nCnquWsQ3TGMiPr+oFsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hlA0tWN3i/3aM3I3NmomzyD2btgh4lVhWDGwjGqqHKNdy7j1MeogRxxt0ZiuepiF9tfN6iP0dBUskmd0eOCucAnMNgJlRVuz+QrVfOrXNnIoMNb9v1MZVV7GJLNrUp8L0aFmV7o2qugWYMRvOpcLzwSIgJRaO/5xzGrKK4hEHD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=l5fagdeU; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="l5fagdeU"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 55FFC80877;
	Tue, 13 Jan 2026 12:58:37 +0300 (MSK)
Received: from dtalexundeer-nx.yandex.net (unknown [2a02:6bf:803e:400:93c4:8e38:1f90:3c73])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id KwPsag5AAiE0-WyAPVCn2;
	Tue, 13 Jan 2026 12:58:36 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768298316;
	bh=ZAd/Fxgvks8ojlWBXFbKSd9KMAVUVGhazsRwe+yiqKM=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=l5fagdeUYR347duZfpZOPSakcHnQ7gVyl0wLf2zqBWuKA57wqBht+MLEdsNYPSu7B
	 Kq1vwIeE6EyurIpZ2dvHT5YhZZ6KgSfq7CpLtPWBy8w0SjarSdCgxyT35Vbmhu4qX7
	 diG8Y3wWOuNVnlkw2rPx/jzpOLjReifCFKKrAokY=
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
Subject: [PATCH v6 1/5] vhost-user.rst: specify vhost-user back-end action on GET_VRING_BASE
Date: Tue, 13 Jan 2026 14:58:11 +0500
Message-Id: <20260113095813.134810-2-dtalexundeer@yandex-team.ru>
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

