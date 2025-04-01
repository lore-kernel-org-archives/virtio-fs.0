Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8E8381A3
	for <virtio-fs@lists.linux.dev>; Tue,  1 Apr 2025 15:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743520714; cv=none; b=Y3iUuoga9NUnKY2OjGyCpbhb2FQ5v+k8S/9SvfvBwx4uu5ip2sHf/Jp4aSSo7rXGMNrIQAHbEWeqVaj25pk3s35jf7N2cJoZ6z3LuRfsTOHtVGw8ovAuwoZVT0vFdQgSTXV0QB4CPxI1wCwEAr/FB0HoWMUIGQlI1N9A6iLFato=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743520714; c=relaxed/simple;
	bh=79QxIAiYWbMGua6nBPPOHjJw5QO1w60sB/1e5+TnogU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfdtHRLt2AgFLW4xCXJnYNEYBbZ/2CW8PCeEYxSs7yHICIaE2CuDB4PFzXtG0qyVNlYaHvVMRf6YmTYjxhcHtRCpLFnwC1+LftQbGBpVhJSz1c6vy2IxEcXisg2PEgUFoKjNv8jJWy+8n+IlZeUQNLze8m/1sLp6+f15iCH0kjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=LnqAtF+D; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="LnqAtF+D"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22622ddcc35so36257465ad.2
        for <virtio-fs@lists.linux.dev>; Tue, 01 Apr 2025 08:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1743520710; x=1744125510; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ovSzhMp4DABOfKsIdmvqMUGiFV0+sG/fv+dA7kJuTo8=;
        b=LnqAtF+DNPuK+Ntp6OyDsh5IPDsh+awLGHIYO5vKgBk6RV6BvmufIzSRR+2qDg1sAr
         J8eloeFjyWJgY04znZL8XlZvEyb4D8s/M/cxnjUeAfPlDZzLaYMHI9K3w010JkWeYbFe
         D8U6dvF7iKlwmFWT1BWvgtiwpNhK6/jcLg+gmN7DZWdcI2HzghmRLlRckw65tCORF32P
         Ls5e9+CFyP9U4dM0zCsIjzNLfWZ2hJlaPcoI3TcjRlHgr+DC2fQH/7zgaFig8APUKccQ
         y10YrS9yboUgZHgNpT8l0Qt4+CwcQpcvYqInPTOdlWACYPGa3c3KbJU9Tx9AcVJ0NML5
         8PsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743520710; x=1744125510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ovSzhMp4DABOfKsIdmvqMUGiFV0+sG/fv+dA7kJuTo8=;
        b=YvgfWoMjuMIftAyOsvkP1gm9RHNv1ZE8S3XQgeEIvPZ1ZtcIc6TsHMOJbiPcqepZoz
         CWsn7vdi8YSHyrQiglocpA8GvWZcfdDKY/9AzZkWdbx1cU0l6nI5ldXlhXE1FDfS5EM3
         wZAf9VhIk24nv/EAasve36QnxP15jqU1VjzJ8arwUJapYZ/Ltu9WHUaTEZqU8BUnSxdP
         k6O1DLdhIM6RSOxRKWSiKXC7kvzLmY2HFyhYzcJ0ax2c95PqHwX7SJUvYRo94XOowjU+
         2jlGkm7gpVnmT3xipprUifpub2bpBc5qYwXBwnpIZdWWKqPycUZoA3dpA6MExdmggU7S
         VI4Q==
X-Forwarded-Encrypted: i=1; AJvYcCX7SfUqhniJuULDxggPqMreEKSsMMgJ0XKdV0SvKUFYnpfQizzs7dI43AxlK+YYybPKR9HfvyE1CxY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVPG8qVfsTZBI1aCFbKyPu67qFEyUfN7RNq8puvxq8gNf1lW0M
	LDPK2p8vOI2KLdbAT8pZHMGz7Aigi/50ZjMOAzOR8KZK4iZKJoFVth/TWd0eDCU=
X-Gm-Gg: ASbGncvdg6jEoXuny4ZCg0QBPBrL2/ZEq625Ju8rWf+bs0mERve5i1poK0Q71qA1aOK
	cSZvxoKqhE3woNWfmnVF7XQcRp8n337fP8cbTmNk++UAtFWPRVVxkKpLiD5+RiLvRqXkPbBarnk
	GKGxptM+3ithMJHmbMK//FoupGfbiZXGXXb00TivoXsXuBTfy6cUWONuTJcHwz/dJMbWJ1ldB7k
	j9wn9GI30FC/Ohnc4GrMo9nsLvPYwLDKLmEMcueYpYtvBkuD/U+k4ylanw1ecZWpLdkYIiODhAc
	DA7s+UO/VqNGb/rLI6FqU1eo0k+c+9c=
X-Google-Smtp-Source: AGHT+IFFYki8X3Y8/rj0kDpcNOEsUXZVQm84B9BuMdr0KhiMxdmiAnI1Msp7yenmFaTzBAQj6QrEcQ==
X-Received: by 2002:a17:902:da84:b0:21f:1549:a55a with SMTP id d9443c01a7336-2292f942cbfmr201169085ad.1.1743520709922;
        Tue, 01 Apr 2025 08:18:29 -0700 (PDT)
Received: from fedora.smartx.com ([2001:df0:a640:1::4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2291eee029bsm90172195ad.62.2025.04.01.08.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 08:18:29 -0700 (PDT)
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
Subject: [PATCH v4 0/3] vhost: fix the IO error after live migration
Date: Tue,  1 Apr 2025 11:18:14 -0400
Message-ID: <20250401151819.1526461-1-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250327064348.3595732-1-haoqian.he@smartx.com>
References: <20250327064348.3595732-1-haoqian.he@smartx.com>
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
 34 files changed, 240 insertions(+), 141 deletions(-)

-- 
2.44.0

