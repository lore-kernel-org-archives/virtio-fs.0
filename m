Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFD5420497
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 10:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785233447; cv=none; b=TV4TT16CMXCGUqeOeiUUUQp64n67RNsN3mqQ50+16c7BAcqiQVYRAnWcC1/LkkQLVL+RPM3sTc7pG91ka1wEXWFMZA3+22oHCmZosGu6a4T2dIdYtI/V9WTskAiJweBWcgsvb/n6UYQqdU47w+DcvJ21SP8gebwiyNYBUyA9Q8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785233447; c=relaxed/simple;
	bh=qPILhDXq0IyUvQxoR0J6s0JYOdYoNZbDxnSNNPZrQKU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=TR1kg0EUGr36Ti2QOO7PzqqnhQEcZBfJae17itw1PJOdf13/R/6AfCXoI8AVWCf9hduBXbnSbZA8H6TBzWIs4bv2KK2moMg+ESUUSsK41MtJIAydtMCYQvJLN2gMkjP4GneynDq9a+vqUpPC1dPRImisjp0izyGxoQy6W7ct9tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=HCsTU1hy; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="HCsTU1hy"
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (postfix) with ESMTPS id 078E3C099B;
	Tue, 28 Jul 2026 13:08:48 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:803e:400:f26c:359c:adc2:62a4])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp) with ESMTPSA id f8aui7IXWGk0-1Fvi2rr3;
	Tue, 28 Jul 2026 13:08:47 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785233327;
	bh=VJOSBKmCKxvKRC29yoO8w+LzhX0RhRe/2boYZWNRowQ=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=HCsTU1hyJ9ZjAsniS1het1LQbhVRMkWDZpqNuMtYjg92dCzqXQ/zBi7hg3FBbYKMP
	 DEgXvjfZ9fGEKKvmcglg4WHrp2PkmeTT95vp0cGKIp9pAyawumbxCVIVgXoisgDzxQ
	 BggKzUbpX7j8lEamvV+tl34m8QaDFjv4hw8rsG2Q=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Jason Wang <jasowang@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	qemu-block@nongnu.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtio-fs@lists.linux.dev,
	Kevin Wolf <kwolf@redhat.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v5 0/6] vhost-user-blk: add compatibility with older qemu versions
Date: Tue, 28 Jul 2026 15:08:35 +0500
Message-Id: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

This is v5 of the series previously sent as
"[PATCH v4 0/6] vhost-user-blk: fix inflight migration compatibility".

This series extends the vhost-user-blk inflight migration feature
introduced in QEMU 11.0 to address a runtime compatibility problem.

Currently, the inflight migration behaviour in vhost-user-blk is
controlled by VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT, which is
negotiated once at connection time. Once the feature is negotiated, the
back-end always uses suspend semantics on GET_VRING_BASE — there is no
way for the front-end to request normal drain behaviour on a per-call
basis without reconnecting. This makes it impossible to disable
inflight-migration at runtime, which is needed when, for example,
migrating a VM to an older QEMU version that does not support the
feature.

To solve this, the series introduces a new protocol message
VHOST_USER_GET_VRING_BASE_SKIP_DRAIN (id=45) guarded by a new protocol
feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN. The message is
semantically identical to GET_VRING_BASE but explicitly instructs the
back-end to suspend in-flight I/O immediately rather than draining it.
This gives the front-end explicit per-call control: GET_VRING_BASE for
normal operation, GET_VRING_BASE_SKIP_DRAIN during live migration.

In vhost-user-blk, GET_VRING_BASE_SKIP_DRAIN is sent only when
inflight-migration is enabled and the device is stopping due to live
migration (RUN_STATE_FINISH_MIGRATE). The inflight-migration property
is also made mutable so it can be toggled via qom-set at runtime without
reconnecting to the back-end.

Alexandr Moshkov (6):
  vhost-user: add skip_drain param to do_vhost_virtqueue_stop
  vhost-user: add GET_VRING_BASE_SKIP_DRAIN message
  vhost-user: use skip_drain with GET_VRING_BASE_SKIP_DRAIN message
  vhost-user-blk: make inflight-migration prop mutable
  vhost-user-blk: move inflight_needed higher
  vhost-user-blk: use GET_VRING_BASE_SKIP_DRAIN during inflight
    migration

 backends/cryptodev-vhost.c        |  2 +-
 backends/vhost-user.c             |  2 +-
 docs/interop/vhost-user.rst       | 88 +++++++++++++++++++------------
 hw/block/vhost-user-blk.c         | 43 ++++++++++++---
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
 16 files changed, 172 insertions(+), 75 deletions(-)

-- 
2.34.1

