Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB44340A7D
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845846; cv=none; b=kLU6F62t6XMKJrRbShl1+ud1zOJaIe4LwsJwqYEEuiZZTfSGkNd12SBYfJPnPXyFwfAuJZOAsct1MLe/iS6lkGCtRkiquT6bhy2RH9/JBMbJIad0BeoDm4xsvDyMMaXX3n3FtSCiGE+PojY+S/2LOthdpOm2pUPfd055P691BH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845846; c=relaxed/simple;
	bh=ddgAjFSnPTuZOk/CnCc8q0BCfZctEpGERxTbUBmFodA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ARJ9lzycfgCcnxJJOn8t8mxjraV3Dp0CDHsond4dIlghUsbs6COM734XmZBHkNgSWrJRtEGhJRD9bcAgzdVWHzL7CYwbewhs0VdLY/EIqyokXtr33/UjPYJHy4JWGzWgYf+TumKLbhydNjPZBZx2LL05U1Dtk6o9AWrCD6RXqK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ss+Tt4wB; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ss+Tt4wB"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-81eaf3709b4so10862757b3.0
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845843; x=1785450643; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZwwFtlsTkLCj0bPHuaj+IVaPS9QFlGYFzEPwRm95wEg=;
        b=Ss+Tt4wBwuknRRfrbjWQ80yc8zVtitIAYV4o4JTimTytsjvg0ZAtBONC+R/KbAcS+f
         zV8/PlP217XMjsJayLxBR0G7Bz3HpK35ea9iRpCf781qOEUkwUTtXhCU+uQW5/LPYmSI
         XNn5uVFb40kIokAPjSAiCbLumrDpGmkfuB+2mZy0qF0d6CSwQ2hzi/FAJ36s2NbkhVVO
         KzDN3NHUy9DgYIWKHgD9tjGLm6AF9cxJ/6YXPZIYFg/2MnuBWCIOSfc/htkbCP0OIGJn
         B0C/Tsy8fy7O78YviDtjsj6fyKa28lvP1Y4LztxQwLz88w5Wu7cm3GkwRIOItvcg4tQt
         qNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845843; x=1785450643;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZwwFtlsTkLCj0bPHuaj+IVaPS9QFlGYFzEPwRm95wEg=;
        b=EdtP1CJyOrYw50NTomozNpiIW2Q6s3J4VTfXnZQQiQjzkQAPpwlmWIHwiUUXVUoRn1
         BljHentFpDYsRh9n89TESqvrilWZf+X8KyJXUwc4Ztf9d6H18pGiAAe28JR0W6FKXfwP
         JrzH/4sJWMmM8u19wVX/ju/0EOyavWd28VyJjHBN14OLGUn2owBOpsmbdThcD0Xc/xIo
         ZV3OCnoR+o8g3ZYIDcppmQOAdPL4WhEw/OksASUGYVns4S/lOH2b56QQRLK6cjU4FzR+
         bT+BTVU5mM+mtUg4r1WZxfVcSySB9PH/BHCOwsHIf4m4UYaQtgoxkHENGH3EkpGqs4T2
         Vv2g==
X-Forwarded-Encrypted: i=1; AHgh+RqtmWBrSJrEUIidSceMoB99UL8XQrD7rUP5yZRYI8udi2C8uxWt8Y2W9xT6ChhoZEaA7gVjp3oAIBg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/N5MQkyQlby+Ayr4sDymrBOmxSAPhL+cHgP3IXoIex4Ly/rMW
	IVwyiz6OG0mGhLOQDzgH9+CXgCnRuNgur3NJxsOvuAdmaved/ZgGDmsK
X-Gm-Gg: AR+sD11rxUJGK4psifz3XQB2SZrFfaf1y8bO/SdNqKENw1KZJ8tjQixoMAjvsth9r/G
	5VgaQRtCabzm8AF0VzsAPraX+yd5MvqwqgVibUnjFazenazr5f5VR56sl5lteuPcGjo/p35J+NV
	NZEOhcmwNsh+4asLNGzFw6jwiA7plIjYQv6C38mAk459BK5sqoryp0T9joyO+fpNHS8uR4r28MH
	/af3KZMAoyH4seovUtBlPfEFZjwCYXZWpyIzvOtmtqziWZHbhfhTpwxMvcIuItcRZ4t2uVSH/Dt
	4cxyRsdjvncXWIDIILNa47aKP1IaeJ0f91u8ZUE/KNP0OI5SUZkmFLJeiN18yb4/8VXLbCaEwk7
	tOP6pk3n8+QCDOqmhTeh9cX2rtwTYi3soc47t1Y7qd4fOSpVfR5oib641hMvfdIfqiGaFPNtS4c
	9f45FEnQol0sUj9vlk3g==
X-Received: by 2002:a05:690c:6b81:b0:81e:c7d8:3e24 with SMTP id 00721157ae682-81f4c3199b2mr13908547b3.59.1784845843189;
        Thu, 23 Jul 2026 15:30:43 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:30:42 -0700 (PDT)
From: ConKite <connorkite@gmail.com>
Subject: [PATCH RFC 00/15] vhost-user: isolated memory
Date: Thu, 23 Jul 2026 15:29:59 -0700
Message-Id: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOeVYmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDMwMT3bKM/OIS3VKgNt3M4vycxJLUFN3c1Nz8okpdA3OD1BQTC2Pj1FR
 zJaABBUWpaZkVYMOjlYLcnJVia2sB4BUbcXEAAAA=
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 =?utf-8?q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>, 
 Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
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
 Connor Kite <connorkite@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=4339;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=ddgAjFSnPTuZOk/CnCc8q0BCfZctEpGERxTbUBmFodA=;
 b=HYOx56uw3p6shzza3KTLUGqJpj9p8IbuHf0Vd1SsXTmo+4VKfOarGBaF4JWGVr05kM1l7BIPK
 LLKgX/XJYbIBWNm3xqJ8lzwltA+rRPJsBxMlV+LlPIFkO+FSCjAC3E2
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

Note: This project is currently in a partially functional state. For
example, in testing vhost-user-input and a keyboard, keystrokes may
register correctly or be double counted depending on the combination
of backend daemon and guest OS used. However, the desire is to make
this work public at this stage for comment on the overall
approach.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
ConKite (2):
      vhost-user: Consolidate chardev property definitions
      vhost-user: Add memory-isolation qdev property to vhost-user devices

Connor Kite (13):
      backends/cryptodev-vhost-user: add memory isolation bool
      net/vhost-user: add memory isolation
      vhost-user: add memory_isolation to VhostUserState
      util/iova-tree: g_tree_foreach wrapper
      hw/virtio: iova_tree_foreach wrapper
      hw/virtio/vhost-shadow-virtqueue: used handler
      hw/virtio/vhost-shadow-virtqueue: specified vring placement
      hw/virtio/vhost-shadow-virtqueue: range boundary in translation
      hw/virtio/vhost-user: create isolation region
      hw/virtio/vhost-user: send isolation regions to device
      hw/virtio/vhost-user: add shadow virtqueues and eventfd intercepts
      hw/virtio/vhost-user: handle data movement with shadow vqs
      hw/virtio/vhost-user: shadow vq cleanup

 backends/cryptodev-vhost-user.c      |  24 +-
 backends/vhost-user.c                |   4 +-
 hw/block/vhost-user-blk.c            |   4 +-
 hw/display/vhost-user-gpu.c          |   4 +-
 hw/scsi/vhost-user-scsi.c            |   4 +-
 hw/virtio/vhost-iova-tree.c          |  15 ++
 hw/virtio/vhost-iova-tree.h          |   3 +
 hw/virtio/vhost-shadow-virtqueue.c   |  30 ++-
 hw/virtio/vhost-shadow-virtqueue.h   |  17 ++
 hw/virtio/vhost-stub.c               |   3 +-
 hw/virtio/vhost-user-base.c          |  13 +-
 hw/virtio/vhost-user-fs.c            |   4 +-
 hw/virtio/vhost-user-gpio.c          |   4 -
 hw/virtio/vhost-user-i2c.c           |   5 -
 hw/virtio/vhost-user-input.c         |   5 -
 hw/virtio/vhost-user-rng.c           |   5 -
 hw/virtio/vhost-user-rtc.c           |   4 -
 hw/virtio/vhost-user-scmi.c          |   4 +-
 hw/virtio/vhost-user-snd.c           |   1 -
 hw/virtio/vhost-user-spi.c           |   5 -
 hw/virtio/vhost-user-test-device.c   |   1 -
 hw/virtio/vhost-user-vsock.c         |   4 +-
 hw/virtio/vhost-user.c               | 441 ++++++++++++++++++++++++++++++++++-
 include/hw/virtio/vhost-user-base.h  |   1 +
 include/hw/virtio/vhost-user-blk.h   |   1 +
 include/hw/virtio/vhost-user-fs.h    |   1 +
 include/hw/virtio/vhost-user-scmi.h  |   1 +
 include/hw/virtio/vhost-user-vsock.h |   1 +
 include/hw/virtio/vhost-user.h       |   6 +-
 include/hw/virtio/virtio-gpu.h       |   1 +
 include/hw/virtio/virtio-scsi.h      |   1 +
 include/qemu/iova-tree.h             |  13 ++
 include/system/vhost-user-backend.h  |   3 +-
 net/passt.c                          |  16 +-
 net/vhost-user.c                     |  11 +-
 qapi/net.json                        |  15 +-
 qapi/qom.json                        |   6 +-
 util/iova-tree.c                     |   5 +
 38 files changed, 622 insertions(+), 64 deletions(-)
---
base-commit: 006a22cb26998998385b104db1ff9466ef2f3153
change-id: 20260604-vhost-user-isolated-memory-070ed4833ee7

Best regards,
-- 
Connor Kite <connorkite@gmail.com>

