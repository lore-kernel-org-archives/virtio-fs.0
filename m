Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D273161302
	for <virtio-fs@lists.linux.dev>; Wed, 16 Apr 2025 02:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744771662; cv=none; b=OUrlnn8FSMjhe4KT4nR8BCduaayZncTI1SYdfsLqL3KpeX0lZwawtRYLbbltR2ztKConPXnk45vtcylCKQ9AJXCgbt5Ipwm09BHobxonAiWb6M4/1wFyAT9ueF4s0rcXEjLbCcnktpZJ+QmCwcJYIgBqV/tkF9zU0dH5Q+Gn7oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744771662; c=relaxed/simple;
	bh=kdJDOd/XgYE/JBzs8DYyDhU/EYQpkHLHKo2Aa4O2zSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FD71GJDuPinzS2lkW6kbsTKUrkPAsyWGJYpWwnUaw44oDkcDzFvL5EcEGCz2imjmlT7Tbb7gPLhiSIe2ivmFfN8oNRfCFhp7y4zARluozPTr9aTEIVeEb/ePqGq9R4to7Grw4K3NbryRQSzc1IaCR/nhr9C26/SLFsOyEkHaqlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=SXxsLcFQ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="SXxsLcFQ"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-73bf1cef6ceso2983940b3a.0
        for <virtio-fs@lists.linux.dev>; Tue, 15 Apr 2025 19:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1744771658; x=1745376458; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRX5DWX1J5odec4kJXVIOK1ovAUrij3fW9QCY2FCljA=;
        b=SXxsLcFQgfL3jNRsLC2VEHlKwQeX1mWcFD/NstV32+V1XqNGycQhhlyiccMGYV65DD
         vXPV6FDQq53f20pXdgds1zV/xbIVABVXduqVxoNZh3EggQN70aZeKMKQTnDhD5nqi3UK
         Ve1E6LIP8cHCiJi7P7n/ycY/qblVhFrksvHTpUmJy6rEgZwu1RUE6Thq/004AbnwfaZM
         Ruobux7/X9qqppulXR8gpml7UntIYi+swHpQKTgzfbUYRZrn+/Bthf1zwie8GC3BT6Nn
         KB3j40/QmT5dyGSdmBjMhXGlDXg2nXKDnnaG2tP+/a5nu/7Enp6m64nFLjlEpOHt4I8Q
         jVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744771658; x=1745376458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iRX5DWX1J5odec4kJXVIOK1ovAUrij3fW9QCY2FCljA=;
        b=hNeEy/9/KljhI8FnnrQvxgr6ZH96UoCyvRaPZfYslgB4BfDnoEP1nlwpwHHnKvjK1K
         erodHOE12a2Q/y7lz65kQghMpgWsdQBcjui1ek6zYE5ikGmdSWBNQVlHhRm0Py4zkrsz
         w4opGRQi2fdzlU3hLqBhGZi2Nal9RrVYKzK+hxGJ7cwcNbHCn4uEaLuj/8fddYL/Hwox
         rIW/5BLO7XiBX1srWK82uu4HxZsE1icmors0Ed9jTy3qx1EGi1oaKTwu5KxWuWnuVSwV
         PR97GYNerfkLK+cpE7wPt+fIYlR6AvUlNiNAfRc4TxXDYNE/g2hI96rEoY2/Fde8UdaE
         WOYg==
X-Forwarded-Encrypted: i=1; AJvYcCW+iaqKytQ+zlertgWPwAJnAjSjfOyuZEwzgzfRxlsLXjdyfo0PbKiDrC1wtB+z6m26OknP6AKUnEU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzTZSIhhR+QsvQipsLozhvhLIf9N3z8aA6n03MlHWMmYIlQHf7
	9kAh0c4oV8taCMe4xXcRiWyTbjXL95RAxBNIN0GPyzxuzgDSNC5IOVd21Z2OFJk=
X-Gm-Gg: ASbGncvvOar00qTFrcZf4F3UQAOpOP57U1Tfhg18TbdnZCZEApW9Cs2rP970zEXCYfe
	39L5dORpGtxL9XCLvh1Kxp94JcS4NG57S1iJk9AFuB/SLKqAkUA+EGvEQTUBW5gusgDUXTALkCz
	oEdfepj+4+4pMoMEelV9pHjhOhLqZn82+3FteGll6KLqsmArFxFLPUzW6e7St6DKYV6Ok434m+H
	LpyX5bKS+cEheysoibfvrUPfZLnqd/PKAEBZPjPE5aQne1R9sHkhA79zhAr5VLxO6+8+X1nnIky
	0zI+m8w9XE6pRAQ7q3Tu82cyABgT
X-Google-Smtp-Source: AGHT+IFQ3Ao/ER1izLhaTk7KQcVPXoZa8L+TTx/4F/2fO2nY6jvI66RFkQ8vXvNkel22p+27sLcSxw==
X-Received: by 2002:a05:6a00:4ac6:b0:736:9f20:a175 with SMTP id d2e1a72fcca58-73c266b5fecmr186298b3a.2.1744771658087;
        Tue, 15 Apr 2025 19:47:38 -0700 (PDT)
Received: from fedora.smartx.com ([2001:df0:a640:1::4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd230e305sm9624958b3a.140.2025.04.15.19.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 19:47:37 -0700 (PDT)
From: Haoqian He <haoqian.he@smartx.com>
To: qemu-devel@nongnu.org,
	mst@redhat.com,
	sgarzare@redhat.com,
	raphael@enfabrica.net
Cc: fengli@smartx.com,
	yuhua@smartx.com,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Amit Shah <amit@kernel.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	mzamazal@redhat.com (reviewer:vhost-user-scmi),
	David Hildenbrand <david@redhat.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-block@nongnu.org (open list:Block layer core),
	virtio-fs@lists.linux.dev (open list:virtiofs)
Subject: [PATCH v5 0/3] vhost: fix the IO error after live migration
Date: Tue, 15 Apr 2025 22:47:25 -0400
Message-ID: <20250416024729.3289157-1-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250401151819.1526461-1-haoqian.he@smartx.com>
References: <20250401151819.1526461-1-haoqian.he@smartx.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At the end of the VM live migration, the vhost device will be stopped.
Currently, if the vhost-user backend crashes, vhost device's set_status()
would not return failure, live migration won't perceive the disconnection
with the backend. After the live migration is successful, the stale inflight
IO will be submitted to the migration target host, which may be leading to
the IO error.

The following patch series fixes the issue by making the live migration
aware of the loss of connection with the vhost-user backend and aborting
the live migration.

---
  v1 ... v2
    1. Fix some grammar issues in commit message.
    2. Remove assert in vhost_scsi_common_stop and return error upwards.

  v2 ... v3
    1. Added more detailed comments and commit message.
    2. Change the newly added type name and parameter name.
    3. Remove set_status_ext, change the return type of set_status to int.

  v3 ... v4
    1. Call set_status() only if the function pointer is not NULL in the
       3rd patch.
    2. Add the more detailed commit messages for the 3rd patch.

  v4 ... v5
    1. Fix code style issues in patch v4.
    2. Rebased on master.

Haoqian He (3):
  system/runstate: add VM state change cb with return value
  vhost: return failure if stop virtqueue failed in vhost_dev_stop
  vhost-user: return failure if backend crash when live migration

 backends/vhost-user.c                  | 20 +++++++--------
 hw/block/vhost-user-blk.c              | 27 +++++++++++---------
 hw/block/virtio-blk.c                  |  7 +++---
 hw/char/virtio-serial-bus.c            |  3 ++-
 hw/core/vm-change-state-handler.c      | 18 ++++++++-----
 hw/display/vhost-user-gpu.c            | 12 ++++++---
 hw/input/virtio-input.c                |  3 ++-
 hw/net/virtio-net.c                    |  3 ++-
 hw/scsi/scsi-bus.c                     |  2 +-
 hw/scsi/vhost-scsi-common.c            | 13 +++++-----
 hw/scsi/vhost-scsi.c                   |  5 ++--
 hw/scsi/vhost-user-scsi.c              | 18 +++++++------
 hw/vfio/migration.c                    |  2 +-
 hw/virtio/vdpa-dev.c                   |  5 ++--
 hw/virtio/vhost-user-base.c            | 23 ++++++++++-------
 hw/virtio/vhost-user-fs.c              | 23 ++++++++++-------
 hw/virtio/vhost-user-scmi.c            | 27 ++++++++++++--------
 hw/virtio/vhost-user-vsock.c           | 15 +++++++----
 hw/virtio/vhost-vsock-common.c         | 12 ++++-----
 hw/virtio/vhost-vsock.c                | 11 ++++----
 hw/virtio/vhost.c                      | 23 +++++++++--------
 hw/virtio/virtio-balloon.c             |  3 ++-
 hw/virtio/virtio-crypto.c              |  3 ++-
 hw/virtio/virtio-iommu.c               |  3 ++-
 hw/virtio/virtio-rng.c                 |  5 ++--
 hw/virtio/virtio.c                     | 22 ++++++++++------
 include/hw/virtio/vhost-scsi-common.h  |  2 +-
 include/hw/virtio/vhost-vsock-common.h |  2 +-
 include/hw/virtio/vhost.h              |  8 +++---
 include/hw/virtio/virtio.h             |  2 +-
 include/system/runstate.h              | 13 +++++++---
 include/system/vhost-user-backend.h    |  2 +-
 system/cpus.c                          |  8 ++++--
 system/runstate.c                      | 35 ++++++++++++++++++++++----
 34 files changed, 239 insertions(+), 141 deletions(-)

-- 
2.44.0

