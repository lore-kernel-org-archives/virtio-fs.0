Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B8F3C871E
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029942; cv=none; b=UlnEhv7JSuJdcE/WbmpBShskfpUKnctBnLJK/GHQOmL7s0VSfWXOi2LpzESHKt3E3rZ/KLkF3YB7DlWmDnNy4SEny7XNY14iUcPhIsYgrrenTvopHstZuKdFn2900E0lxJPkvYYyrXh4z8+BGNUgnM3MBuBbNNWFnKO1z1yxOUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029942; c=relaxed/simple;
	bh=mw/NOsJAc5c3oTLsgT3HVoifVskWtAB9BaIpmPIXu1M=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=TVsFvC43Avh9ptrdEu1HqRqxb0zHd7vs1qoKt52sd7I0veBS76oGD1bGgvBSS9EaPFS7KhER5poQH03mQLt7UTz25dLK5j3PPdf/jHYZ7MVH+Kh5JX3sCyAkFCqiroTsBSOhlXsyz78bTsgeyCsE2lhPyk0rx/Im2CmFiD/0XaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QsZ9eTZf; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QsZ9eTZf"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84faf87d19dso4480523b3a.3
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029939; x=1787634739; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eYeq9bPe6CWbjsZmFOByTII3fv+JYv7PgXnda9ah0pM=;
        b=QsZ9eTZfV46zK7OtlnVnXh6hUS3QOueKGPp2RS5ORkBdvANZsGJoJTSgpiGce3UD2j
         tb8aDVBtSot/lJ1l8CuGWHizeXl+AsX3MV8FIjWokyGywIopJaBBQCVqf+yPTsk8W5Vr
         jtXFUsqSTRFLdHUIY9SaIhLBWGY5Tdvz8uVe7vD/v2c6yjc9d4f+AmERKB7zkpMKFY/U
         zQKJWJGM/QJtVbZUXzk3k8l9sBXRe20Yewm+YIJda5DiG6cUrXnsaugmzrxFU4NvU/4j
         FEakeM7uzzONVaBDPXZso8VE1dLXkcvQmcqbvduGA489sTITYe7SXVIfXtlB6dHBTO5t
         8Zkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029939; x=1787634739;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eYeq9bPe6CWbjsZmFOByTII3fv+JYv7PgXnda9ah0pM=;
        b=Gdy8LClA6hm5ugju98+jf70XaMqpiE3Osrd7GSBzFmM8+4m7ohTcGu/eaBuObZqzv9
         LdS1iw3tk9c4PkUG21zWSDjFaBbM8Oao0eb89xaoPyEcTJ57cN1ljxlsZD2h4Am+CMhp
         CrMV49f2sYwVZvg4f+d/vUEUkgi0HDaK8HQ87WrnnDIYDLeMhraPRgvh2HUStouGLJTj
         0Exvcoo8KTfteAUzLOj8eodExHw8Nladw3z73aErYJgobQA2eRSZdDt3io7Nztv0kzWx
         QvM2JnmHg+cwNE+mFkvZAzjJ1rD6Jj+lV+lFU3i4EPOqpQq0gviTisYKVgbaeXFMDVKT
         zxEQ==
X-Forwarded-Encrypted: i=1; AHgh+RpDor3U6HX/TyiFTw2z3PZKTxL/gYdg45fZDAEVP7WZ44dAHquPajYraolPZxCr/xDUtQiUxukvXf8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaNYJEkgyAUviLpsUHl70Xellj2SSUYEZCuMUjVoHN4C8XKo9F
	qFT0zXjrUElbjVRFfkikup9LIEFVaEBA/JDma/yb7OMKKahIgkle9umt
X-Gm-Gg: AR+sD13QyzmxNl1bY9gNRXzRrdAFgaT+zXgC4fG02xUmiKdCM6Ju38Y1Z6Kl5nKKPQw
	iDKh+9Max90oGTvq85POEAxge/KCfs9NLhiST6ycgnz1e4oGpvFj4vHHQCsRVbEA9/nLSdhlzBa
	3YNvh4Dho7Aexjf6Kg9uOTVk9t/DPZyu8QY26pOWbZa6h0wV1Yt5K8286ZUIVqFbsU1F9pM+NfK
	Kvf+35Qd0XyYSSQgd3lC+UBwby1NvNZpZdEPD+Kh9GXC3AHFDITDK1VMjDCXR7hBQJ7Ieu8KNcl
	4he1Y7zSrf5ks6JNLkuMsoclnXoSyhPoIv7jo0arkcnJptgwFknVNZrF1HcPPkbvoN9H3D5JRFp
	IdKrOsNaFRGezC5GJ6dBRzp/EcuqFB/e2H35D4nvw0zG2NQAo9WRLnDM7eHjjWCAahUbsKIjLpl
	LGlx+eilxc5MU0JHf2JdSRq4ekXPT3NHFXaCGBALeGC0XIse/wkeHbGXoIHvPWGnivww==
X-Received: by 2002:a05:6a00:4f91:b0:84f:37c1:f887 with SMTP id d2e1a72fcca58-84fddfdf5b0mr29235781b3a.12.1787029939441;
        Mon, 17 Aug 2026 22:12:19 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:18 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Subject: [PATCH RFC v2 00/13] vhost-user: isolated memory
Date: Mon, 17 Aug 2026 22:12:15 -0700
Message-Id: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAK/pg2oC/32NSwqDMBCGryKz7pSYiNGuhEIP0G1x4WOqA8aUx
 IYW8e4NOUCX/+v7d/DkmDxcsh0cBfZs1yjkKYNh7taJkMeoQQpZilIUGGbrN3zHGbK3S7fRiIa
 MdV8UWtBYVEoRaYiAl6MnfxL8AffbFdpozuy3WE6HIU9RYmup/rFDjgLLvtZDoWrqZdVMpuPlP
 FgD7XEcP7xLo0DJAAAA
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 =?utf-8?q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
 Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, 
 Hanna Reitz <hreitz@redhat.com>, 
 =?utf-8?q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
 zhenwei pi <zhenwei.pi@linux.dev>, 
 =?utf-8?q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>, 
 Connor Kite <connorkite@gmail.com>, 
 20260817233147.2867623-1-connorkite@gmail.com
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=9629;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=mw/NOsJAc5c3oTLsgT3HVoifVskWtAB9BaIpmPIXu1M=;
 b=6dagyY53uaZiuyJbepRPFr0QSnVBXkRD7WRmxIoBDFSgXL13glQEHSPvbZdCwiKqm1ySTY3a8
 LsvNRUiocxmAIhYpC3IP7HwrC3pwQrCIgsbBTxqCaxSLDec/1a/1+WR
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

This patch series implements a memory isolation mode in vhost-user. The
purpose of this mode is to provide the option of additional security by
eliminating direct access of guest memory by vhost-user devices.
At a high level this works by:

1. Adding qdev and qapi properties required to enable isolation mode for
   various devices.
2. Allocating an isolation memory region in an anonymous file and mapping it
   to host memory.  This isolation region will hold the bounce buffers and
   vrings necessary to move data.
3. Using a vhost-iova-tree to allocate and track the mapping between
   guest regions and their corresponding bounce buffers in the isolation
   memory.
4. Creating shadow virtqueues to intercept request notifications.  As
   kick and call events are received by an svq, it copies buffer
   contents and descriptors between isolation and guest memory before
   notifying the backend or guest.   

Note: This project is currently in a partially functional state.
While the overall method will stay the same, the implementation
is planned to move up into vhost to simplify some elements of
initializing and using the shadow virtqueues.
However, the desire is to make this work public at this stage
for comment on the overall approach.

To: qemu-devel@nongnu.org
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: Alex Bennée <alex.bennee@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Cc: Raphael Norwitz <rnorwitz@nvidia.com>
Cc: Kevin Wolf <kwolf@redhat.com>
Cc: Hanna Reitz <hreitz@redhat.com>
Cc: Marc-André Lureau <marcandre.lureau@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Fam Zheng <fam@euphon.net>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Milan Zamazal <mzamazal@redhat.com>
Cc: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc: qemu-block@nongnu.org
Cc: virtio-fs@lists.linux.dev
Cc: Gonglei (Arei) <arei.gonglei@huawei.com>
Cc: zhenwei pi <zhenwei.pi@linux.dev>
Cc: Daniel P. Berrangé <berrange@redhat.com>
Cc: Eric Blake <eblake@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>
Cc: Jason Wang <jasowangio@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Alyssa Ross <hi@alyssa.is>
Cc: Demi Marie Obenour <demiobenour@gmail.com>
Signed-off-by: Connor Kite <connorkite@gmail.com>

Based-on: 20260817233147.2867623-1-connorkite@gmail.com
---
Changelog:
V2:
Series:
- Updates to svq address translation moved to a different patch series.
  Link: https://lore.kernel.org/qemu-devel/20260817233147.2867623-1-connorkite@gmail.com 
- The "shadow vq cleanup" has been merged into the earlier patch
  handling svq setup.
- Link to v1: https://lore.kernel.org/qemu-devel/20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com

Individual Patches:
vhost-user: Consolidate chardev property definitions
- Patch author updated from ConKite to Connor Kite

util/iova-tree: g_tree_foreach wrapper
- Added clarification comments about the function passed to
  iova_tree_foreach

hw/virtio: iova_tree_foreach wrapper
- Corrected comment about GTraverseFUnc end condition

hw/virtio/vhost-shadow-virtqueue: used callback
- Changed name of "used_handler" to "used_callback"
- Added handling if callback returns with error value
- Comments added clarifying callback return values

hw/virtio/vhost-shadow-virtqueue: specified vring placement
- Formatting improvements
- Change hwaddr to void * for pointers to host memory
- Bounds checking added when allocating vrings

vhost-user: add memory_isolation to VhostUserState
- Updated net_passt_vhost_user_init signature that is active when
  !defined(CONFIG_VHOST_USER)
- Comment updates for clarity

hw/virtio/vhost-user: create isolation region
- Formatting fixes
- Many comments added
- Read-after-zeroing bug fixed in cleanup_isolation_regions
- User-after-free bug in init_isolation_regions fixed by removing
  duplicate calls, and consolidating those steps in
  cleanup_isolation_regions
- Data unique to isolation mode consolidated in IsolationModeCtx struct
- Vring memory size calculations now only done via an API exposed by
  vhost-shadow-virtqueue
- Isolation region memfd file given a unique name
- Iova-tree IOVA space now starts at 0 + page_size to avoid exposing
  qemu addresses
- buffer_regions array moved changed from GArray to dynamically
  allocated array of predetermined size.  Avoids GArray formatting
  ugliness

  Note: Devicies implemented with multiple vhost threads, like
  virtio-net, are not currently supported.  Work is still required to
  update the vring allocation code to run only for vq_index=0 and
  propagate to the other vhost-user instances.

hw/virtio/vhost-user: send isolation regions to device
- Formatting improvements
- Vring region combined with contiguous buffer region in IOVA space to
  avoid wasting one of the available region slots that can be sent to
  the back-end
- Traversal callback for filling out msg regions renamed to
  vhost_user_fill_msg_reg_from_tree and simplified
- Check added if postcopy is in use as it is not currently supported

hw/virtio/vhost-user: add shadow virtqueues and eventfd intercepts
- Vring mapping now occurs during the vhost_user_set_mem_tables call,
  which means that vring addresses can be sent to the backend when
  expected by vhost
- The svq's device-facing event notifiers are now cleaned up in case of
  error or reset
- Bounds checking on vq index added in various locations
- SVQ cleanup code added

hw/virtio/vhost-user: handle data movement with shadow vqs
- Removed unecessary changes to elements during handling
- Fixed incorrect memcpy of used buffers in reverse direction
- Formatting improvements
- Bounds and error checking to handle mapping failures or buffers with
  invalid ranges
- Add error if isolation mode is used while IOMMU is active
- Add error if isolation mode is used with packed vrings

vhost-user: Add memory-isolation qdev property to vhost-user devices
- Patch moved to end of patch series
- Fixed overlong lines

backends/cryptodev-vhost-user: add memory isolation bool
- Fixed style in qapi and added "since" field
- Clarification added to comments
- The memory_isolation bool can no longer be set in vhost-cryptodev once
  initialization finishes

net/vhost-user: add memory isolation
- Moved to the back of the patch series
- Dead code removed by hard-coding memory_isolation args to vhost_user_init

---
Connor Kite (13):
      vhost-user: Consolidate chardev property definitions
      util/iova-tree: g_tree_foreach wrapper
      hw/virtio: iova_tree_foreach wrapper
      hw/virtio/vhost-shadow-virtqueue: used callback
      hw/virtio/vhost-shadow-virtqueue: specified vring placement
      vhost-user: add memory_isolation to VhostUserState
      hw/virtio/vhost-user: create isolation region
      hw/virtio/vhost-user: send isolation regions to device
      hw/virtio/vhost-user: add shadow virtqueues and eventfd intercepts
      hw/virtio/vhost-user: handle data movement with shadow vqs
      vhost-user: Add memory-isolation qdev property to vhost-user devices
      backends/cryptodev-vhost-user: add memory isolation bool
      net/vhost-user: add memory isolation

 backends/cryptodev-vhost-user.c      |  28 +-
 backends/vhost-user.c                |   4 +-
 hw/block/vhost-user-blk.c            |   4 +-
 hw/display/vhost-user-gpu.c          |   4 +-
 hw/scsi/vhost-user-scsi.c            |   5 +-
 hw/virtio/vhost-iova-tree.c          |  15 +
 hw/virtio/vhost-iova-tree.h          |   2 +
 hw/virtio/vhost-shadow-virtqueue.c   |  80 ++++-
 hw/virtio/vhost-shadow-virtqueue.h   |  25 +-
 hw/virtio/vhost-stub.c               |   3 +-
 hw/virtio/vhost-user-base.c          |  14 +-
 hw/virtio/vhost-user-fs.c            |   5 +-
 hw/virtio/vhost-user-gpio.c          |   4 -
 hw/virtio/vhost-user-i2c.c           |   5 -
 hw/virtio/vhost-user-input.c         |   5 -
 hw/virtio/vhost-user-rng.c           |   5 -
 hw/virtio/vhost-user-rtc.c           |   4 -
 hw/virtio/vhost-user-scmi.c          |   5 +-
 hw/virtio/vhost-user-snd.c           |   1 -
 hw/virtio/vhost-user-spi.c           |   5 -
 hw/virtio/vhost-user-test-device.c   |   1 -
 hw/virtio/vhost-user-vsock.c         |   5 +-
 hw/virtio/vhost-user.c               | 657 ++++++++++++++++++++++++++++++++++-
 include/hw/virtio/vhost-user-base.h  |   1 +
 include/hw/virtio/vhost-user-blk.h   |   1 +
 include/hw/virtio/vhost-user-fs.h    |   1 +
 include/hw/virtio/vhost-user-scmi.h  |   1 +
 include/hw/virtio/vhost-user-vsock.h |   1 +
 include/hw/virtio/vhost-user.h       |   6 +-
 include/hw/virtio/virtio-gpu.h       |   1 +
 include/hw/virtio/virtio-scsi.h      |   1 +
 include/qemu/iova-tree.h             |  21 ++
 include/system/vhost-user-backend.h  |   3 +-
 net/passt.c                          |  19 +-
 net/vhost-user.c                     |  11 +-
 qapi/net.json                        |  16 +-
 qapi/qom.json                        |   8 +-
 util/iova-tree.c                     |   5 +
 38 files changed, 903 insertions(+), 79 deletions(-)
---
base-commit: 88aac004fb1bef50277d8484f4aeacf2e8cb9e38
change-id: 20260604-vhost-user-isolated-memory-070ed4833ee7

Best regards,
-- 
Connor Kite <connorkite@gmail.com>

