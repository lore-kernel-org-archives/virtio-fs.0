Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BA51B0414
	for <virtio-fs@lists.linux.dev>; Thu, 27 Mar 2025 06:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743057841; cv=none; b=EtxDhY6EAXKbelqz35dv8LxQ1IFVXOFi90Xe/WxTX9REAwA+JoVK6ForT+RI0RosyfQlt8V50Ij2CBch4NnSICMx1gsNSE0b74LU3lbliOrkLDq7SR98+R4OAJjkDC3MfWM2vFGE4BO93w0tak4BWIta1LyiZZFNtkkpT4SV1O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743057841; c=relaxed/simple;
	bh=jfjpJ9Fx8PjfE4D0M4EsD6nCm6tXwnLjZnQnMscUJU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r65CoV5lcdg8eubAsryrPLkNt+M2ynb6aZ0NXXRg1FLeK9u0dtHRRuvGM9VEUKvC1RaPu7AnBvjqY5UK34Hoe7o7Fvp0qRN2yvqLAfTePz0qmgBmFAtsyveZw9Q3C6j28uJhvxkxivlY03eXZIlBQe8fnlD70IFF2dDc8FyEyBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=vpyKIUrQ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="vpyKIUrQ"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-223f4c06e9fso11759375ad.1
        for <virtio-fs@lists.linux.dev>; Wed, 26 Mar 2025 23:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1743057837; x=1743662637; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+zfiR6YSWsh1kwihUZptaCkLfGMteo+gW0ow9r6wKY=;
        b=vpyKIUrQwulIwHvsqd2YV7E6EVSs81GzJzFMZ/Z5Hf3dYlDvmJH60qDIi5BxI3eShx
         X1EOw35I0TStN2CxrEI4s5jZTO6vwycc6S++0IAuJrhisFvxc01kWpEd+UQmOdyg9lqY
         5yLcBp7kLreFDtigoK1tH11bHUr7LlTBWBb2Tp97aaLuuQknOaXdRaRaeL75ZIiNLJM9
         AIi5XGAuDUWYZ1cFVUo3X3ieaVZZkfDvq7Hh9hM3HMuqoAQiCmPx+LQxFwB8hownDX7+
         IP0hOBAQzYiWphWDyiCZ6dpVCVsc3yjdctkGZ8VItNm1O3t3FRKhsY42xO+hAYliainy
         /r+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743057837; x=1743662637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C+zfiR6YSWsh1kwihUZptaCkLfGMteo+gW0ow9r6wKY=;
        b=Jq6ffP8MA+V0zv+4R7XpCkXpwhOb7mr2bo5VIjcluKKS1gRof+xhMu8pvGWZoWmzEE
         tNeyO+vVbg8WTUqBAEP34++yVrb9Eh+uz2rVTItQlobl0evszRWfpnsSPhGkKNht2UsR
         0p69XY7zSamzy5vPrfsPAYvcsdx167leRF+kXyxDrYgZtRM4D3KVTBjMcldnAWBNby7v
         Zo8SZrT3HqvFJ73QhxhpkU3UyUpxAAp60tV6mCKovpwyUtgXlobNhfmHdjdMpPsNavBt
         I1+a/uwEboWAwMmqxh3XY42YBYGJLfrJCx2g4VKmHJSQN/heKtOWBIS+P4+tTh99Ahn0
         GCzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmza0OLliw88PrGc8YQ2eAjYYFgl3StQHUcPTbOdomh5TKA0jvQa1pD94zNDv8p8wHOidsEO60IgQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwIoHN2p2/We1Lq9vukOkOAnyd5D8+R8w6AclFv6cfSFYQaAsC
	ys5o0IIJGtm1xOpGmK7mEATt4DVyFZJ2TGtIsCjPzXJkD+S29ilU/iIn8BnDe3k=
X-Gm-Gg: ASbGncv8+skmgw+Ew0dtN+9XQq12R1ljdiKSbkmXjtVhImTn5et4I0PjdTYYqcSlwow
	h4b35lab2Te0un+iPXrVwg5QG8JFpGJbA+RzZ7D5EAygA66L7rAOLYIRlu3tbjKqThO4dng21Cr
	xazRuSz0qppvM8Y7KgCybobiNy6MWjVrp+uUkM5fJ4RU3ZZtGlJONAl7qcqTp5TbX26bXjVMWT4
	qXnUR27tD3KkTJ9DjkB1e5o+bpI9/kMlrTHvnVNr2Kk65FBtRgrHLTGEF4SNF8Cq2jxCyTnb+IF
	3xggRkqcCmyY0ClRprtYwUVmfUOF5g4wn8bNDlfrhA==
X-Google-Smtp-Source: AGHT+IEieRCHW4TwTVVXc4ir3LRkvx9yWwzXIHRYWzATDJCO+YtsxOOyxsQ+3EIIOu/npBDkBI6Fog==
X-Received: by 2002:a17:902:dac8:b0:226:194f:48ef with SMTP id d9443c01a7336-227efb00eafmr95433845ad.13.1743057836599;
        Wed, 26 Mar 2025 23:43:56 -0700 (PDT)
Received: from fedora.smartx.com ([2001:df0:a640:1::4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4599fsm121983015ad.67.2025.03.26.23.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 23:43:56 -0700 (PDT)
From: Haoqian He <haoqian.he@smartx.com>
To: qemu-devel@nongnu.org,
	sgarzare@redhat.com,
	mst@redhat.com,
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
Subject: [PATCH v3 0/3] vhost: fix the IO error after live migration
Date: Thu, 27 Mar 2025 02:43:44 -0400
Message-ID: <20250327064348.3595732-1-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250314101535.1059308-1-haoqian.he@smartx.com>
References: <20250314101535.1059308-1-haoqian.he@smartx.com>
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
 hw/virtio/virtio.c                     | 23 +++++++++++------
 include/hw/virtio/vhost-scsi-common.h  |  2 +-
 include/hw/virtio/vhost-vsock-common.h |  2 +-
 include/hw/virtio/vhost.h              |  8 +++---
 include/hw/virtio/virtio.h             |  2 +-
 include/system/runstate.h              | 13 +++++++---
 include/system/vhost-user-backend.h    |  2 +-
 system/cpus.c                          |  8 ++++--
 system/runstate.c                      | 35 ++++++++++++++++++++++----
 34 files changed, 239 insertions(+), 142 deletions(-)

-- 
2.44.0

