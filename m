Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED0B329E44
	for <virtio-fs@lists.linux.dev>; Thu, 15 Jan 2026 08:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768464705; cv=none; b=jySKVlKEPNLVeLHpeGWilecPGgYog7UzBCG5exjZrqEJvbwymOTGZacOOHj3xK1ueQ9E8SY2nvOu0uziBjv0ikYeK+H1lS02FoR6+qZyLRjANYh9kv2OQJ1eaVqJlVhs+zJQKD4L5jyafhyWsPoejyQFG4r4LsOmXOO0TYU5tZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768464705; c=relaxed/simple;
	bh=W16Um6zVhSnqkJJG6VY1Fda1IMvsN7ruqpCJHM9r3ZY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Yp4KdeESMtNLqXlDuI+QXfTAmy64xxNpybqy8OlSfCLMhgQ+ddMb4EiP47ZoVjO0MEkIqnZWF16cdJw5V8jGiOQRMt18bBXT3YEB9rh9MM0tPEDtyO77Mw62hQj1G62Splj53lqIXg3xqUru9veaDNosVNLdWWPDAhWkVIsKgBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=tS0yvPw/; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="tS0yvPw/"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:5c05:0:640:ff67:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id A27F0807B0;
	Thu, 15 Jan 2026 11:11:33 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:973::1:c])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id PBQgfR0Ar8c0-rqS8OuJn;
	Thu, 15 Jan 2026 11:11:32 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768464692;
	bh=ITju4s7IbE3ErvSG4Q7Cogdx0QIGX67IG3vQQkq4xhE=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=tS0yvPw/KHbOEQp7X3iJaLXfysqWTnhP8lsKwcIBynw5K3FFaVTQnyoPazPIhjtZk
	 xXVWtzqyLOeRwNT9kv9spWGkJ7HNMrVn4ZdlhLPbyaxD3XA3ttnqGditXzfsLRwmuF
	 2r71ecvDhrbePmEM6y45rE67Xr9la6THhmPvyk+M=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
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
Subject: [PATCH v7 0/5] support inflight migration
Date: Thu, 15 Jan 2026 13:10:59 +0500
Message-Id: <20260115081103.655749-1-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v7:
- remove dependencies from Vladimir's patches, so now this patch
  independent
- move VMSTATE_VHOST_INFLIGHT_REGION macro definition to upper commit
- fix in vhost-user.c virtio_has_features() missed argument

v6:
- fix documentation about new protocol feature
- add check to ensure that inflight buffer subsection has been successfully loaded
- disable support for the new feature if in-flight or inflight migration is not supported.

v5:
Make protocol feature flag instead of GET_VRING_BASE msg parameter,
so all changes in other devices is no longer needed.
Now back-end may set this feature for QEMU. This feature must be set
with in-flight migration parameter in vhost-user-blk.

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

This can be avoided if QEMU migrates the inflight region in
vhost-user-blk.
Thus, during the qemu migration, with protocol feature flag the vhost-user
back-end can immediately stop vrings, so all in-flight requests will be
migrated to another host.

At first, I tried to implement migration for all vhost-user devices that support inflight at once,
but this would require a lot of changes both in vhost-user-blk (to transfer it to the base class) and
in the vhost-user-base base class (inflight implementation and remodeling + a large refactor).

Therefore, for now I decided to leave this idea for later and
implement the migration of the inflight region first for vhost-user-blk.

Alexandr Moshkov (5):
  vhost-user.rst: specify vhost-user back-end action on GET_VRING_BASE
  vhost-user: introduce protocol feature for skip drain on
    GET_VRING_BASE
  vmstate: introduce VMSTATE_VBUFFER_UINT64
  vhost: add vmstate for inflight region with inner buffer
  vhost-user-blk: support inter-host inflight migration

 docs/interop/vhost-user.rst        | 56 ++++++++++++++++++-----------
 hw/block/vhost-user-blk.c          | 27 ++++++++++++++
 hw/virtio/vhost-user.c             |  7 ++++
 hw/virtio/vhost.c                  | 57 ++++++++++++++++++++++++++++++
 include/hw/virtio/vhost-user-blk.h |  1 +
 include/hw/virtio/vhost-user.h     |  2 ++
 include/hw/virtio/vhost.h          |  6 ++++
 include/migration/vmstate.h        | 10 ++++++
 8 files changed, 146 insertions(+), 20 deletions(-)

-- 
2.34.1

