Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06A53B47F3
	for <virtio-fs@lists.linux.dev>; Wed, 11 Mar 2026 08:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773219104; cv=none; b=oKxyX3TkgUovktw2WTxc/V1GnJhevmfxOn4mhrrCSMW+UDfpVspAM3wShqt/Omr2Xf0Zs95UgU36q/1qXdSM7a8rzJPvC+B3/LztVCxedDWAPjwZqxulHOPfkLK7XcWc41p5Mr2Azb0lnb/lOMkLjGw7lZL9ujVd17ov2/vaQmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773219104; c=relaxed/simple;
	bh=/+DonntVuTmuAIC6e+N0cr+s4xns+07aSm+3ks44CmE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E/vsgcbmbzU08KqqPIxaaZjalCxea6ofz/wt6M+KK5aZ2vSHkQ0puzKnf85SO1r/KJV8NWPZBiq8g80eKQ6fa//01KWZSQA7lt61klexewkguz/bNsyIpGKwLA9PHmW0HPEeqaZ7BkNPv3pCAEUcA88h/hZ7jTcxo+3UHxf9FJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=Ukrmt6S8; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="Ukrmt6S8"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:bf1f:0:640:c739:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 888B380671;
	Wed, 11 Mar 2026 11:47:39 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:b38::1:12])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TlBqj00AleA0-OzzEFIFD;
	Wed, 11 Mar 2026 11:47:38 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1773218858;
	bh=hDn0FL7ev6HdJsCNipC46uM4ZKoHr3DcNqYal9cwGfg=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=Ukrmt6S85BEPohbMCO66fpjDhM9ttYXh7veqXvOun/FNEA2/G/3CA9WZZYY/vQ62r
	 ykQvILaTeiDNeVof1RWiLVw2LbEjWX0zhLtj0JsNUMtgvr2d9tvj6hoJMa/f3Vb3Ju
	 zqju/FTmdECrDDPDHZZlKHPZhceFpOTNWKCi+EBg=
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
Subject: [PATCH v2 0/4] vhost-user-blk: fix compatibility with older qemu versions
Date: Wed, 11 Mar 2026 13:47:24 +0500
Message-Id: <20260311084728.751169-1-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1 -> v2:
- reorganize commits: make refactor commits first, then core semantic change
- add additional pre_save check for inflight migration possibility

---

This is a small continuation of my series about inflight migration for vhost-user-blk.

This series is designed to solve the problem of compatibility with older versions of qemu, where this feature has not yet been introduced (for example, if we want to downgrade versions due to some problems).

In the current version for vhost-user-blk, this feature is enabled using the parameter and further migration of the inflight region will depend on whether the vhost-user has accepted the new protocol feature or not. This creates an inconvenient dependency, because there is no way to disable this feature without reconnecting to the backend.
This series slightly changes the semantics of the introduced protocol feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature adds a new parameter for GET_VRING_BASE message - skip_drain, which allows to control drain in-flight requests on the backend.

Thus, user can enable or disable inflight-migration param for vhost-user-blk to maintain compatibility with older versions of QEMU.

Alexandr Moshkov (4):
  vhost-user.rst: fix typo
  vhost-user: add skip_drain param to do_vhost_virtqueue_stop
  vhost-user-blk: move inflight_needed higher
  vhost-user: add skip_drain param to GET_VRING_BASE

 backends/cryptodev-vhost.c     |  2 +-
 backends/vhost-user.c          |  2 +-
 docs/interop/vhost-user.rst    |  8 +++-----
 hw/block/vhost-user-blk.c      | 32 +++++++++++++++++++++++++-------
 hw/net/vhost_net.c             |  9 +++++----
 hw/scsi/vhost-scsi-common.c    |  2 +-
 hw/virtio/vdpa-dev.c           |  2 +-
 hw/virtio/vhost-user-base.c    |  2 +-
 hw/virtio/vhost-user-fs.c      |  2 +-
 hw/virtio/vhost-user-scmi.c    |  2 +-
 hw/virtio/vhost-user.c         |  3 +--
 hw/virtio/vhost-vsock-common.c |  2 +-
 hw/virtio/vhost.c              | 24 +++++++++++++++---------
 include/hw/virtio/vhost-user.h |  1 -
 include/hw/virtio/vhost.h      |  7 +++++--
 15 files changed, 62 insertions(+), 38 deletions(-)

-- 
2.34.1

