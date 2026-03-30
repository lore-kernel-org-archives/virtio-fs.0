Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1176A38644E
	for <virtio-fs@lists.linux.dev>; Mon, 30 Mar 2026 09:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774864366; cv=none; b=avfJigi+PDpGuxXA7x2YiJvUyaTW8DaQ+EWJfFj1Xh8lzVa0LmMZnvLMzecpdTPDYC4eJX1syUEXgol2h++CGCyZgiaCOJ24l5/38pJqr9AjiZde1y1isFiJh3JjKg9wpMV3IQDRpHUHKzoY/tWcm4q3Bqo/US3G61jBihPBueU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774864366; c=relaxed/simple;
	bh=hm5brOrmuZkRtp00i5QeM/9y2io8QaT1J3R+RhHflvI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Tpz3XKafS9Dq8+PLMvzuQdpPnU0UJguCKNlRPSyjbeM20az1VcX9R5ORx6fXdtALwltY7JQb7nASGZVO3b/ZqZgK/NJ1ArnzVTKRwb1WqT25tYbxP+pP3S0JY1C7GGMNmq8rGzhLRmcWBJ6/4YmiZD9VKkKdPGvfwuuz/iMx3bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=rnSKKWF/; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="rnSKKWF/"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:3530:0:640:eca4:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 2C0E1C0159;
	Mon, 30 Mar 2026 12:52:34 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:78d::1:13])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id QqVNFG1Af4Y0-pZ3lppPK;
	Mon, 30 Mar 2026 12:52:33 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774864353;
	bh=1C8NOcIgMKyf0TAnc/Kx3aqOpisIbfms5084DDXyy/U=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=rnSKKWF/uXE9K7oj8AUMDP+10r6IbnkBKoMqWbkK5RPMfJpE+O8W7qc6pa+zGC49/
	 VYon0R3gOelvWs1nNNDqZPZd0lvK/wfB39y4TPDkDqzu4sKAYniE2v/XTMJGSp66Qz
	 paDsNmn3Wluz3CuKBbUaygTXN5gEuDHxemhNMy0s=
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
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v3 0/5] vhost-user-blk: fix compatibility with older qemu versions
Date: Mon, 30 Mar 2026 14:52:21 +0500
Message-Id: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2 -> v3:
- fix complile problems
- add assert check in do_vhost_virtio_stop
- make inflight-migration property mutable

v1 -> v2:
- reorganize commits: make refactor commits first, then core semantic change
- add additional pre_save check for inflight migration possibility

---

This is a small continuation of my series about inflight migration for vhost-user-blk.

This series is designed to solve the problem of compatibility with older versions of qemu, where this feature has not yet been introduced (for example, if we want to downgrade versions due to some problems).

In the current version for vhost-user-blk, this feature is enabled using the parameter and further migration of the inflight region will depend on whether the vhost-user has accepted the new protocol feature or not. This creates an inconvenient dependency, because there is no way to disable this feature without reconnecting to the backend.
This series slightly changes the semantics of the introduced protocol feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature adds a new parameter for GET_VRING_BASE message - skip_drain, which allows to control drain in-flight requests on the backend.

Thus, user can enable or disable inflight-migration param for vhost-user-blk to maintain compatibility with older versions of QEMU.

Alexandr Moshkov (5):
  vhost-user.rst: fix typo
  vhost-user-blk: make inflight-migration prop mutable
  vhost-user: add skip_drain param to do_vhost_virtqueue_stop
  vhost-user-blk: move inflight_needed higher
  vhost-user: add skip_drain param to GET_VRING_BASE

 backends/cryptodev-vhost.c     |  2 +-
 backends/vhost-user.c          |  2 +-
 docs/interop/vhost-user.rst    |  8 +++----
 hw/block/vhost-user-blk.c      | 43 +++++++++++++++++++++++++++-------
 hw/net/vhost_net.c             |  9 +++----
 hw/scsi/vhost-scsi-common.c    |  2 +-
 hw/virtio/vdpa-dev.c           |  2 +-
 hw/virtio/vhost-user-base.c    |  2 +-
 hw/virtio/vhost-user-fs.c      |  2 +-
 hw/virtio/vhost-user-scmi.c    |  2 +-
 hw/virtio/vhost-user.c         |  3 +--
 hw/virtio/vhost-vsock-common.c |  2 +-
 hw/virtio/vhost.c              | 29 ++++++++++++++++-------
 include/hw/virtio/vhost-user.h |  1 -
 include/hw/virtio/vhost.h      |  7 ++++--
 15 files changed, 76 insertions(+), 40 deletions(-)

-- 
2.34.1

