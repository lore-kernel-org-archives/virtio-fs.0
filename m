Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8387927FB05
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 07:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785742167; cv=none; b=QGXvx5Mm34llric7FYu3ZowH0EXzruGhrAZFaW8Aqz7CTqhryfxEG4bFjBuv9OQCMIBJCozqs7/C8glmQOuGdNCVYruqrPWR11wkpXvyh8sY5oOtVQbqk4nCdY+qxA43KpjEEIgAzSb5QuXKYLrdoGZRNyd72rO61/GpJuijRjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785742167; c=relaxed/simple;
	bh=zlCW6/xJuqPVfNBypuL/cf2xLqNZ265ini2pCqvZTeo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WeNNPAkjm/IqGJx72DoUWaTi6PrqGoG8ABGV0gC3/atTtSqVCkNP5C+mZGGQy7qs2r+q7vk7vkAeSJ/epjF0yOI1GuCA6yYwlpeFkZktAp62z4BLcTb4s2XZN9/ZX9CipGVPy/NteSrxssZ5r9iVrQv1kcCablAFNN0GC0hnI1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=DXMifX0X; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="DXMifX0X"
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:65a0:0:640:e1de:0])
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id 25DDD806DC;
	Mon, 03 Aug 2026 10:29:14 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:a53::1:f])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp) with ESMTPSA id rSdSxZ08oGk0-sKfWIuR8;
	Mon, 03 Aug 2026 10:29:13 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785742153;
	bh=4bPvWX8Bl6sQAkGXhxfZM9mm5a/Z0JCU18UzmbNVPus=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=DXMifX0X2DmWt4LT6R3nMngUZT13Z4yR4taSr33wTu8bEHeTDcXvQfg3E+fKroQ+W
	 15GGUmxWfJu3DEudKFdMlw/E0HKNli26DXufo9xRNBkx2T+eCk14iORwjFdqgGmoDY
	 ikBseB8YIuoCvDBGHwDJxRfy7kawiHkmcbNxp0R4=
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
Subject: [PATCH v6 0/6] vhost-user-blk: allow toggling inflight-migration at runtime
Date: Mon,  3 Aug 2026 12:28:47 +0500
Message-Id: <20260803072853.2920007-1-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v5 -> v6:
- block changing inflight-migration property while VM is not running
- remove checking runstate in vhost_user_blk_stop() since it's not necessary
- updated cover letter: changed subject and description to focus on
  runtime toggling of inflight-migration rather than cross-version
  migration compatibility

v4 -> v5:
- introduce protocol feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN
  to guard the new message, instead of reusing the existing
  VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INLIFGHT. Update docs.
- improved commit messages.

v3 -> v4:
- add new protocol message GET_VRING_BASE_SKIP_DRAIN instead of parameter to GET_VRING_BASE message. This new message can be send instead of GET_VRING_BASE, allowing back-end to suspend inflight I/O immediately instead of waiting and completing them.
- rebase to newer master

v2 -> v3:
- fix complile problems
- add assert check in do_vhost_virtio_stop
- make inflight-migration property mutable

v1 -> v2:
- reorganize commits: make refactor commits first, then core semantic change
- add additional pre_save check for inflight migration possibility

---

This is v6 of the series previously sent as:
"[PATCH v5 0/6] vhost-user-blk: add compatibility with older qemu versions"

This series allows the inflight-migration property of vhost-user-blk to
be toggled at runtime via qom-set without restarting the VM or
reconnecting to the back-end.

Currently, the inflight migration behaviour is controlled by
VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT, which is negotiated once
at connection time. Once negotiated, the back-end always uses suspend
semantics on GET_VRING_BASE -- there is no way for the front-end to
request normal drain behaviour on a per-call basis. This makes it
impossible to disable inflight-migration at runtime.

To solve this, the series introduces a new protocol message
VHOST_USER_GET_VRING_BASE_SKIP_DRAIN (id=45) guarded by a new protocol
feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN. The message
instructs the back-end to suspend in-flight I/O immediately rather than
draining it. This gives the front-end explicit per-call control:
GET_VRING_BASE for normal drain, GET_VRING_BASE_SKIP_DRAIN when
inflight-migration is enabled.

In vhost-user-blk, GET_VRING_BASE_SKIP_DRAIN is sent whenever
inflight-migration is on. The inflight-migration
property can only be changed while the VM is running, so its value at
stop time reliably reflects the user's intent.

Alexandr Moshkov (6):
  vhost-user: add skip_drain param to do_vhost_virtqueue_stop
  vhost-user: add GET_VRING_BASE_SKIP_DRAIN message
  vhost-user: use skip_drain with GET_VRING_BASE_SKIP_DRAIN message
  vhost-user-blk: make inflight-migration prop mutable on running vm
  vhost-user-blk: move inflight_needed higher
  vhost-user-blk: use GET_VRING_BASE_SKIP_DRAIN when inflight-migration
    is on

 backends/cryptodev-vhost.c        |  2 +-
 backends/vhost-user.c             |  2 +-
 docs/interop/vhost-user.rst       | 88 +++++++++++++++++++------------
 hw/block/vhost-user-blk.c         | 60 ++++++++++++++++++---
 hw/net/vhost_net.c                |  9 ++--
 hw/scsi/vhost-scsi-common.c       |  2 +-
 hw/virtio/vdpa-dev.c              |  2 +-
 hw/virtio/vhost-user-base.c       |  2 +-
 hw/virtio/vhost-user-fs.c         |  2 +-
 hw/virtio/vhost-user-scmi.c       |  2 +-
 hw/virtio/vhost-user.c            | 47 ++++++++++++++---
 hw/virtio/vhost-vsock-common.c    |  2 +-
 hw/virtio/vhost.c                 | 34 ++++++++----
 include/hw/virtio/vhost-backend.h |  1 +
 include/hw/virtio/vhost-user.h    |  2 +-
 include/hw/virtio/vhost.h         |  7 ++-
 16 files changed, 189 insertions(+), 75 deletions(-)

-- 
2.34.1

