Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B11747AF66
	for <virtio-fs@lists.linux.dev>; Thu,  2 Jul 2026 09:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782983551; cv=none; b=DoiDGBWfbWBtA0wb4RtvhvoM+uW2yPXPDtK+Q4ZVP0w3263WBQy58uF0mKe+dln/xDR+QBv9CVpECKu4sMWYqEshImJW16zPzpKnojhI5habrEbP5UBU88g5nm5h9n0oCl5XEe/ntalsM3c771Yjg0d6YsUdEK14q9WyRbqq7IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782983551; c=relaxed/simple;
	bh=dalYp94mUMbCr3nIZ3MqFEeWVnZIg6B6XfaMWAsWZac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YmohlcFAK4/AkIdQMy07m2+DN4qEzBTNdHIEVKHYdDDPrOASk5Ra/NtmGeu7Y7tUoBh1V+1o8v6Ha9N6/R9SG1aQaqbbZaqkYOWEKmLE3FhnXGxLn175gYVrJQvOhKUE71jcyL07lNGdEWhvxssAfG35GguuJ7WIGvls3RihgZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=kR8koIWE; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="kR8koIWE"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 66ACE8084B;
	Thu, 02 Jul 2026 12:10:51 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:43d::1:15])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp) with ESMTPSA id NAc7BT0aDa60-g6KUmnfz;
	Thu, 02 Jul 2026 12:10:50 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1782983450;
	bh=uTZ9LXbpWQ6ixQ7qul3NsO5E4bnqrWQ0h3AsjNHW+qA=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=kR8koIWEgXMlXXyoznK2l4DzPoIZEhELHK+qGDTtkt6xcUqUl2KLCy7GWu5mB6wG3
	 REA7uIMPawWXBBUi5hC62SkRV/7TtcgrwiBjrg90jzbA1cUBwGdO8EcRzthQrEOZCP
	 t8Qu3l61/X5aqFA9GU32XR9AvAXRIcQVBHD48ygw=
Authentication-Results: mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowangio@gmail.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	virtio-fs@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	qemu-block@nongnu.org,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v4 3/6] vhost-user: use skip_drain with GET_VRING_BASE_SKIP_DRAIN message
Date: Thu,  2 Jul 2026 14:10:20 +0500
Message-Id: <20260702091023.3306378-4-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260702091023.3306378-1-dtalexundeer@yandex-team.ru>
References: <20260702091023.3306378-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/virtio/vhost.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 2a62550222..c09796de66 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1518,7 +1518,11 @@ static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
     }
 
     if (!force) {
-        r = dev->vhost_ops->vhost_get_vring_base(dev, &state);
+        if (!skip_drain) {
+            r = dev->vhost_ops->vhost_get_vring_base(dev, &state);
+        } else {
+            r = dev->vhost_ops->vhost_get_vring_base_skip_drain(dev, &state);
+        }
         if (r < 0) {
             VHOST_OPS_DEBUG(r, "vhost VQ %u ring restore failed: %d", idx, r);
         }
-- 
2.34.1

