Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A493644BF
	for <virtio-fs@lists.linux.dev>; Tue, 24 Feb 2026 07:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771919568; cv=none; b=mpahYbEDKx3CJzBjilGqlHQtYO5XCsE7b8ovERq0skrLaaGDPX3BsKnXD1hmj95u2ucDFUbwi3T42+Eq7+Xsi8n4xDFGjGceAqCK8CeOqATFKVmvaxbF36hSVqnVVXRIu/gwggAzOolKppG5mLfo2FNF7nbysG8yKgp4egmbLd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771919568; c=relaxed/simple;
	bh=M+cSP91ZQtm8whSa43AFkZqFtqJYBkFHK1XxCXVXK7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a6s0dQs8dn3x05FgTDz/TyRt6E3ghBpNa/h6FfRL9NF8e94UILhtS0TcRkFktqgu/BpfcUal+sHZw9jPUdYOSg2xeBfEejxyjJltGRyxN7aRLgb7Cm9zb6bLJQUfWf294ORBZtiFls9x0syRL5jYpBGskyTSRwksACAJshc1qII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=DG95l+r2; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="DG95l+r2"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1e1e:0:640:c6a6:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id EA26D808DB;
	Tue, 24 Feb 2026 10:51:13 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:515::1:1d])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id uoat9O6Am8c0-79t5wvt0;
	Tue, 24 Feb 2026 10:51:13 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1771919473;
	bh=7BwEi0N5bhclfTU/Whp0ocf3J6F4S950hO77GBpR7Y8=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=DG95l+r2JowgIzTQm1X6kCMDqPVI6qiGYEem8D+IIuRqx3GVIfPlZbs7gLmghg8Zs
	 jr+vTRnrPfFEB37n4PbYmr+PbDBKl55f5KnC1GU6Uz2KrV/7AaDR/SJzUPuwJOukNP
	 lvBx7waYf8h+GE/auvKYF0/GDhDnr7Jz8DXd0k30=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Raphael Norwitz <rnorwitz@nvidia.com>,
	virtio-fs@lists.linux.dev,
	Milan Zamazal <mzamazal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	qemu-block@nongnu.org,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH 3/4] vhost-user: remove supports_inflight_migration
Date: Tue, 24 Feb 2026 12:50:54 +0500
Message-Id: <20260224075055.863068-4-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260224075055.863068-1-dtalexundeer@yandex-team.ru>
References: <20260224075055.863068-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now QEMU will always try to setup VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT protocol feature with backend.
This will allow to use skip_drain parameter on GET_VRING_BASE message.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/block/vhost-user-blk.c      | 1 -
 hw/virtio/vhost-user.c         | 3 +--
 include/hw/virtio/vhost-user.h | 1 -
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 7f2067d6cf..3421145f23 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -353,7 +353,6 @@ static int vhost_user_blk_connect(DeviceState *dev, Error **errp)
     vhost_dev_set_config_notifier(&s->dev, &blk_ops);
 
     s->vhost_user.supports_config = true;
-    s->vhost_user.supports_inflight_migration = s->inflight_migration;
     ret = vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
                          errp);
     if (ret < 0) {
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index bb8f8eab77..ed95ec7523 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -2225,8 +2225,7 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
             }
         }
 
-        if (!u->user->supports_inflight_migration ||
-            !virtio_has_feature(protocol_features,
+        if (!virtio_has_feature(protocol_features,
                                 VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
             protocol_features &= ~(1ULL <<
                                VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
index 53fe996686..c95bad5ddc 100644
--- a/include/hw/virtio/vhost-user.h
+++ b/include/hw/virtio/vhost-user.h
@@ -69,7 +69,6 @@ typedef struct VhostUserState {
     GPtrArray *notifiers;
     int memory_slots;
     bool supports_config;
-    bool supports_inflight_migration;
 } VhostUserState;
 
 /**
-- 
2.34.1

