Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DCC38330A
	for <virtio-fs@lists.linux.dev>; Thu, 30 Jul 2026 20:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785445145; cv=none; b=Qx1g26BXdcuSl2b0VmeoXgPFrKy9xL4y/0lw7FprGJsPkoJ2EnmV1cowjaonQwNu/ckYFZ+H/9c0nz+qs6WEbjc/YATKZJDV0hdzU7HkPB5kK6AJAMNkh1E9+ixuc7ASYcTagUGCuCLxcQNDEzF/1b8RFZu40UIZw99C2lKuAYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785445145; c=relaxed/simple;
	bh=sAvc5906prS5xfY2y4AqGJhvoeTN+FYX5BSs8F6Q3A0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P4tL4uSOWgjQrqG4i1ttOQxzvkLLm+2EpQva/bH4AIV5zQdjFWC40GkQDVgkYNl3ZyCmKN55hnJlylBnDHkuf191smyRfsdf7hnzmQnLcyh7TLWpI18B+nQIxLMhvSmGOuZ/g33CS7QofezP2/MBH4xAraxGZ3FuF5AXgeOIVKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eEhKxn0M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eEhKxn0M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785445141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dvMbqFBMdJmguuzweYRYmvsczOglGPjEuS3sINzhzJg=;
	b=eEhKxn0MJ3XQk7GoJHg7yRU7saX6L5zvRxreiWwIwgSMapF0nTY5ePjNVf9IcfWkSjZb2K
	j9+0YYlRFV6zHE3iH5ZEjp7Ja8HixixToVmubPWbd2smGQToQ39hTXyuBHLVsztCBVWT2s
	/xT85ZMHlVvrXPXkmJlzV3N9AqKCobc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-195-wYQ_TpcDMP65IHuyeXC74g-1; Thu,
 30 Jul 2026 16:58:56 -0400
X-MC-Unique: wYQ_TpcDMP65IHuyeXC74g-1
X-Mimecast-MFC-AGG-ID: wYQ_TpcDMP65IHuyeXC74g_1785445132
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3CE118004A9;
	Thu, 30 Jul 2026 20:58:50 +0000 (UTC)
Received: from localhost (unknown [10.2.16.217])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 786621800480;
	Thu, 30 Jul 2026 20:58:47 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	virtio-fs@lists.linux.dev,
	Hanna Reitz <hreitz@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Christian Schoenebeck <qemu_oss@crudebyte.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Dorjoy Chowdhury <dorjoychy111@gmail.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	qemu-block@nongnu.org,
	Greg Kurz <groug@kaod.org>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Eric Auger <eric.auger@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Amit Shah <amit@kernel.org>
Subject: [PATCH v2 0/2] virtio: fix virtio_add_queue() queue size Coverity issue
Date: Thu, 30 Jul 2026 16:58:44 -0400
Message-ID: <20260730205846.19479-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: k1hmDLrn1AWlJSVCxQcnX8YalKXrN8mPhsTjIfqat5U_1785445132
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

v2:
- Deal with x-override-queue-size, the root cause for the Coverity issue
  [Peter]

virtio_add_queue() uses int rather than unsigned int for the virtqueue size. It
also fails to validate the x-override-queue-size qdev property. Refactor the
code to solve these issues.

Patch 2 adds an Error **errp argument to virtio_add_queue() and changes all
callers to pass &error_abort. This solution requires many code changes, but
it's a step in the direction of propagating errors and that should be the
long-term goal.

Stefan Hajnoczi (2):
  virtio: make virtio_add_queue() queue_size an unsigned int
  virtio: use Error for queue size validation in virtio_add_queue()

 include/hw/virtio/virtio.h     |  4 ++--
 hw/9pfs/virtio-9p-device.c     |  2 +-
 hw/audio/virtio-snd.c          |  8 +++----
 hw/block/vhost-user-blk.c      |  3 ++-
 hw/block/virtio-blk.c          |  3 ++-
 hw/char/virtio-serial-bus.c    | 14 ++++++------
 hw/display/virtio-gpu-base.c   |  8 +++----
 hw/input/virtio-input.c        |  6 ++++--
 hw/net/virtio-net.c            | 15 ++++++++-----
 hw/scsi/virtio-scsi.c          |  9 +++++---
 hw/virtio/vdpa-dev.c           |  3 ++-
 hw/virtio/vhost-user-base.c    |  3 ++-
 hw/virtio/vhost-user-fs.c      |  8 +++++--
 hw/virtio/vhost-user-scmi.c    |  6 ++++--
 hw/virtio/vhost-vsock-common.c |  9 +++++---
 hw/virtio/virtio-balloon.c     | 15 ++++++++-----
 hw/virtio/virtio-crypto.c      |  6 ++++--
 hw/virtio/virtio-iommu.c       |  6 ++++--
 hw/virtio/virtio-mem.c         |  3 ++-
 hw/virtio/virtio-nsm.c         |  2 +-
 hw/virtio/virtio-pmem.c        |  2 +-
 hw/virtio/virtio-rng.c         |  2 +-
 hw/virtio/virtio-rtc.c         |  3 ++-
 hw/virtio/virtio.c             | 39 +++++++++++++++++++++++++++++-----
 24 files changed, 122 insertions(+), 57 deletions(-)

-- 
2.55.0

