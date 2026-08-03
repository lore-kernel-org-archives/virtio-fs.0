Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6908D3A7F55
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 07:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785742170; cv=none; b=lNea1VilGpJXOWuk045brYMtnP3ysi2lOwtlQwj1YUrz1YRPaxYt09vwZLWw4C0Jr6nQxX2g7V4g6H2MV5BVMSIrcTld41optuliPa0nfVMjp2TqZ8NilvfFp+gxgHXHc2xHfmvNkxiSw2MYf39t/YDGLql0dXjRvgd2NvS5xd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785742170; c=relaxed/simple;
	bh=pTGXWoofkaJ/INZ2mbcpCjp+ISRIhI7UbFd/YKl5iiY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dl68XGp5tNHACFLtRg9nvwqJNK2lXa73zBYgKO2nifBpeARMGvqbSHN2l5Pucd9VIlStKQRfNbj+Y1L6gR8+p5xsRwJPwoME/+LjvVmNpFrirNmbrKOvnCD+3fK8f7LqKPfYHF+rM4FzgOlmwf7S3KqFv/lHyb56izUVunyphpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=U3EvXVcd; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="U3EvXVcd"
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:65a0:0:640:e1de:0])
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id E1B4A80D87;
	Mon, 03 Aug 2026 10:29:19 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:a53::1:f])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp) with ESMTPSA id rSdSxZ08oGk0-SMShGnnU;
	Mon, 03 Aug 2026 10:29:19 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785742159;
	bh=PfoLHGcOutgg0hQy+Phc11/k5TDb5rZJ1aU6PrMxzJE=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=U3EvXVcdrWgdge0M+ffIllYAF6K2vCyVtBlrQWBor34dhHeTJ1xhY3JNKRg2nDR10
	 pvBWOySljTxmYyC5MuWWeLqIbD/vdCdV0+tZmpJUlSYCEeLx68CwIiNvdteUHnU2r1
	 owl42v5qhjBsnvRWi3FWl9HG1uw9mTqWzzVXrrE0=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Jason Wang <jasowangio@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Milan Zamazal <mzamazal@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-block@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	virtio-fs@lists.linux.dev,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v6 3/6] vhost-user: use skip_drain with GET_VRING_BASE_SKIP_DRAIN message
Date: Mon,  3 Aug 2026 12:28:50 +0500
Message-Id: <20260803072853.2920007-4-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260803072853.2920007-1-dtalexundeer@yandex-team.ru>
References: <20260803072853.2920007-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wire up the skip_drain parameter introduced in the previous commit to
the new GET_VRING_BASE_SKIP_DRAIN message. When skip_drain is set,
send GET_VRING_BASE_SKIP_DRAIN instead of GET_VRING_BASE, instructing
the back-end to suspend in-flight I/O immediately.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/virtio/vhost.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 2c7f464d55..bd079f9080 100644
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

