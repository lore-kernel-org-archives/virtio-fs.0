Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7A42853E9
	for <virtio-fs@lists.linux.dev>; Mon, 29 Dec 2025 10:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767003811; cv=none; b=RX4fADf1AnSXrX+Sd0FtD+3fCQLk2jOKkFD57DTD56Mpp7Ml0kcyyVb2rpbhebg8E0HFiDj9m6Sp8G2Q3LZPOrPa28fmgJ7oU9njqV1N6g/JZvQLhrMw81U+dlDSuFh5wTnLAEMDhuf6OHk6ez5kTOADAzV/nf6SehO/j9SFof4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767003811; c=relaxed/simple;
	bh=zu1SZYITQg4pT69+1aOkf87DoOCel7pohX8k8SKkMYo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gm6AS08o7g8UvkzDwV/Dk7m46EdzLWKAaEApAlRql3Y7vAgct8V2qVdcvDRqy2Aswh9Y/Lz/mDF8uCpBh7s98VHMj2HgmD+7k/c4S/C656r/d/fELdI0cRod1vC4jZN3xdOWtEuEtLLElCX/bXEQT/0+w82V6W9o1XYB8UhelrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=KvxC5hEe; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="KvxC5hEe"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:7394:0:640:5a8a:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 3FFE4C0152;
	Mon, 29 Dec 2025 13:21:27 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:b4e::1:2a])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id HLeDGC1Ck0U0-06SCcH0s;
	Mon, 29 Dec 2025 13:21:26 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1767003686;
	bh=zbCwiuKgRpdBLAolg7uqTgrx8P1d8EC4jK69Wezuu54=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=KvxC5hEeyL/zIeUkIec+rFEFdfSWCWfvLn16iX2GUzecRgIe3Dsg4yia5RLTeKHlH
	 IjiN9qzRf+whbythTtyRmC0bkNnBuSkiVKZt5n8nASmqACE0Udy/uukrV18YfY3rm0
	 Bf1y7PyO3q61Sx+MPsXASRGr+ahMxYj6SIU4yi2I=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
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
Subject: [PATCH v4 0/5] support inflight migration
Date: Mon, 29 Dec 2025 15:21:03 +0500
Message-Id: <20251229102107.1291790-1-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4:
While testing inflight migration, I notices a problem with the fact that
GET_VRING_BASE is needed during migration, so the back-end stops
dirtying pages and synchronizes `last_avail` counter with QEMU. So after
migration in-flight I/O requests will be looks like resubmited on destination vm.

However, in new logic, we no longer need to wait for in-flight requests
to be complete at GET_VRING_BASE message. So support new parameter
`should_drain` in the GET_VRING_BASE to allow back-end stop vrings
immediately without waiting for in-flight I/O requests to complete.

Also:
- modify vhost-user rst
- refactor on vhost-user-blk.c, now `should_drain` is based on
  device parameter `inflight-migration`

v3:
- use pre_load_errp instead of pre_load in vhost.c
- change vhost-user-blk property to
  "skip-get-vring-base-inflight-migration"
- refactor vhost-user-blk.c, by moving vhost_user_blk_inflight_needed() higher

v2:
- rewrite migration using VMSD instead of qemufile API
- add vhost-user-blk parameter instead of migration capability

I don't know if VMSD was used cleanly in migration implementation, so
feel free for comments.

Based on Vladimir's work:
[PATCH v2 00/25] vhost-user-blk: live-backend local migration
  which was based on:
    - [PATCH v4 0/7] chardev: postpone connect
      (which in turn is based on [PATCH 0/2] remove deprecated 'reconnect' options)
    - [PATCH v3 00/23] vhost refactoring and fixes
    - [PATCH v8 14/19] migration: introduce .pre_incoming() vmsd handler

Based-on: <20250924133309.334631-1-vsementsov@yandex-team.ru>
Based-on: <20251015212051.1156334-1-vsementsov@yandex-team.ru>
Based-on: <20251015145808.1112843-1-vsementsov@yandex-team.ru>
Based-on: <20251015132136.1083972-15-vsementsov@yandex-team.ru>
Based-on: <20251016114104.1384675-1-vsementsov@yandex-team.ru>

---

Hi!

During inter-host migration, waiting for disk requests to be drained
in the vhost-user backend can incur significant downtime.

This can be avoided if QEMU migrates the inflight region in vhost-user-blk.
Thus, during the qemu migration, the vhost-user backend can cancel all inflight requests and
then, after migration, they will be executed on another host.

At first, I tried to implement migration for all vhost-user devices that support inflight at once,
but this would require a lot of changes both in vhost-user-blk (to transfer it to the base class) and
in the vhost-user-base base class (inflight implementation and remodeling + a large refactor).

Therefore, for now I decided to leave this idea for later and
implement the migration of the inflight region first for vhost-user-blk.

Alexandr Moshkov (5):
  vhost-user.rst: specify vhost-user back-end action on GET_VRING_BASE
  vhost-user: introduce should_drain on GET_VRING_BASE
  vmstate: introduce VMSTATE_VBUFFER_UINT64
  vhost: add vmstate for inflight region with inner buffer
  vhost-user-blk: support inter-host inflight migration

 backends/cryptodev-vhost.c         |  2 +-
 backends/vhost-user.c              |  2 +-
 docs/interop/vhost-user.rst        |  8 +++-
 hw/block/vhost-user-blk.c          | 28 ++++++++++++-
 hw/net/vhost_net.c                 |  9 ++--
 hw/scsi/vhost-scsi-common.c        |  2 +-
 hw/virtio/vdpa-dev.c               |  2 +-
 hw/virtio/vhost-user-base.c        |  2 +-
 hw/virtio/vhost-user-fs.c          |  2 +-
 hw/virtio/vhost-user-scmi.c        |  2 +-
 hw/virtio/vhost-vsock-common.c     |  2 +-
 hw/virtio/vhost.c                  | 66 ++++++++++++++++++++++++++----
 include/hw/virtio/vhost-user-blk.h |  1 +
 include/hw/virtio/vhost.h          | 13 +++++-
 include/migration/vmstate.h        | 10 +++++
 15 files changed, 125 insertions(+), 26 deletions(-)

-- 
2.34.1

