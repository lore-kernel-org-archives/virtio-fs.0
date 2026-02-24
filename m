Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0098F364EB6
	for <virtio-fs@lists.linux.dev>; Tue, 24 Feb 2026 07:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771919593; cv=none; b=V3lK88jxYlAyKx6LVM90Ed15G+VQQbMtU3dEfknFL0rxDKgh+VhKA2uHQfy6yi3bNtP22TsKk2cwROzRqgBFNKVGmU5teG/zpJK+Rmt9N4ObaRb6iU4H2eDVX/aOM0Tdojnd8WQxBej7XS4by5ekDfjDKnp5yl5FFmjrjw5CoBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771919593; c=relaxed/simple;
	bh=2TC4jdn0OysJEQ/duGEJ0K2smWOwsUHwutB5OQ/wxQM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lS5SeQ8T4+SbQqFITWICF4kJXh1mBD1zvP+Fd5Uf2qPG21TLttVFITRIiztLSSP6WCTdTyQO1Qrwyi8mTLcU3OgdSR14dmh0ASRRs6XCmorubfuZYKnsxok41w2oLPJjVH5bBtEcX5shbvqpjAQDnd3VDK8QkoXZrgL9WadKWjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=vME65Mnx; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="vME65Mnx"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1e1e:0:640:c6a6:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 20B6E80C6B;
	Tue, 24 Feb 2026 10:51:05 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:515::1:1d])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id uoat9O6Am8c0-MXFLhXTQ;
	Tue, 24 Feb 2026 10:51:04 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1771919464;
	bh=i6hS/8iYe2gFCgfPXNEGfPg7PpWZzPYMO5TSY+voERg=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=vME65MnxKjTqAzL/Fy+742o9BEQrtkAS7zwjX8cDJtRnh2tLC0Q4N4WZ86x5tJTXE
	 8Ix9j23YTERLs7pkBW7ArPe7VEBCUdXDTZ3RudFotsZqRReaPbYQ8qiAM5pEpMLfc2
	 K+V7z9P8RJe9ScIp1+Gu3xGpthEIocxE2nVJhUQM=
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
Subject: [PATCH 0/4] vhost-user-blk: fix compatibility with older qemu versions
Date: Tue, 24 Feb 2026 12:50:51 +0500
Message-Id: <20260224075055.863068-1-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a small continuation of my series about inflight migration for vhost-user-blk.

This series is designed to solve the problem of compatibility with older versions of qemu, where this feature has not yet been introduced (for example, if we want to downgrade versions due to some problems).

In the current version for vhost-user-blk, this feature is enabled using the parameter and further migration of the inflight region will depend on whether the vhost-user has accepted the new protocol feature or not. This creates an inconvenient dependency, because there is no way to disable this feature without reconnecting to the backend.
This series slightly changes the semantics of the introduced protocol feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature adds a new parameter for GET_VRING_BASE message - skip_drain, which allows to control drain in-flight requests on the backend.

Thus, user can enable or disable inflight-migration param for vhost-user-blk to maintain compatibility with older versions of QEMU.

Alexandr Moshkov (4):
  vhost-user.rst: fix typo
  vhost-user: add skip_drain param to GET_VRING_BASE
  vhost-user: remove supports_inflight_migration
  vhost-user-blk: make inflight migration throught skip_drain

 backends/cryptodev-vhost.c     |  2 +-
 backends/vhost-user.c          |  2 +-
 docs/interop/vhost-user.rst    |  5 +++--
 hw/block/vhost-user-blk.c      | 26 ++++++++++++++------------
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
 15 files changed, 51 insertions(+), 40 deletions(-)

-- 
2.34.1

