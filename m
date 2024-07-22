Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984023234
	for <virtio-fs@lists.linux.dev>; Mon, 22 Jul 2024 00:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721607472; cv=none; b=XFDWKwiUaG7w20mzJc44OSZhbyYEGGdeYg+jGg3EQpp3uCYv4IoiqLb1+S0C2gycBk2txmvbw+7uLqBgOAfvUQmbAGjfsRgJ0aurcR028i0vKSrMEff4CTD1+MggLodNWCOEjLHZMY/vAkgP9bz/NgTsHJXVG/Q0EAZlwm2qZUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721607472; c=relaxed/simple;
	bh=mI/ApjuW6sUiw6mELgYc4rin6tatA1H8QcVVY7nngsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=I4kGNkoUFqa86l13+oRebn1M7VvS6O8ZnB1Sii+jpIgvdSHM6HUi232xBdBC9iyawfY0mT9VGzxu6jdbXeOT41kVU2uw+X5MGXqxGzYUJckF+LnhDydGOAjUjdJqAy3lCPP3ZZmiBxaf8VNEef6ibf2SGGvgfc9uWu5aO4K9Bq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U+XL+wpQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U+XL+wpQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721607469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q0Npoi3B/pjRdsmZv/oBnj6YQVo4m4QtFoQ2kZEEzmA=;
	b=U+XL+wpQtORFVIUGEc4fnR3PejxXgdXdwnZj3fw4up/rmM1fmBFax8UnKD8P3RLVRkUZYl
	DUOpb1/npfWh7xOKWnQvY2XQyVH0NKU8+q7Z2ZCq9s8N7zBDf8RlUD/LAS/gXIvLjrieEL
	VKQoVMk1VZnc6X06hm6CbK0FrH7M124=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-W2Vtpr_AOkqVLCiH7Ww2JQ-1; Sun, 21 Jul 2024 20:17:48 -0400
X-MC-Unique: W2Vtpr_AOkqVLCiH7Ww2JQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-36863648335so2230013f8f.0
        for <virtio-fs@lists.linux.dev>; Sun, 21 Jul 2024 17:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721607467; x=1722212267;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q0Npoi3B/pjRdsmZv/oBnj6YQVo4m4QtFoQ2kZEEzmA=;
        b=QemmkLjoL7zCMDR2NNHbEIgxlwqHc9N1hahCy1ej4vvhC4U7jKmcgjwjshXO9NiCFA
         x2zEYm26YrZ5hN3YBQFb9Ti8gUy43ohdl3EgeGAyggRZ+GNjbNzJcn7Ki4FZ6h9icVVT
         V3o0l0OjlOUbIb6hzmu9mbHfQNDEgsAYZtys9IFlc5lpmz7l1S+iL9557CKdpHKVRF9x
         kRdTdEeKDWz5RqpTPSNL0kdy+QKGHqybRX09OLk4kIJISZV8mk4FNqQ2ULRl+hnkbIwO
         JIGj3sCfQ3gzp5U5MO/pX25xZI3TB7C/UHPqSjUXS1/2rbWC35j4iLKfRtpY3m5O0UJC
         qDuA==
X-Forwarded-Encrypted: i=1; AJvYcCXJc60OvxaxFdNqdNRWMWEGSCpPfbllErGJJrjX6QKMQlA+8ZsHVdkl/MoIfdZZ9pzspMUMo/0VaBMqZlEOlnhBIGrWFrRhLYL6
X-Gm-Message-State: AOJu0YzYTVqen/RfFmuxY7So0PNYgYQCrkT+HMoIkGZ+P5vfhzxbZFLc
	q3AU3vO8QkURgs4V0tIDvSFjn3QpDaGghYoCbCkzrbPXu83FlOvLt9bI7zsK+2SKtblp+AxXEoJ
	qGFczHD2xRfl4TuHETwUM7cI9aiCWy29MVKYe2Es85XK6Is0/VA9Ia1RvLg==
X-Received: by 2002:a05:6000:2c5:b0:367:340e:d6e6 with SMTP id ffacd0b85a97d-369bae6b60fmr3663969f8f.41.1721607466706;
        Sun, 21 Jul 2024 17:17:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyCGS6cMtVG4huKFXj5jl7hY2dhn1IKxyz+6NWtnQ2nMWq5dn/i/i8MurQn4yijHcgSgejLQ==
X-Received: by 2002:a05:6000:2c5:b0:367:340e:d6e6 with SMTP id ffacd0b85a97d-369bae6b60fmr3663962f8f.41.1721607466210;
        Sun, 21 Jul 2024 17:17:46 -0700 (PDT)
Received: from redhat.com (mob-5-90-113-158.net.vodafone.it. [5.90.113.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-368787ed5adsm6960164f8f.109.2024.07.21.17.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 17:17:45 -0700 (PDT)
Date: Sun, 21 Jul 2024 20:17:43 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jonah Palmer <jonah.palmer@oracle.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev
Subject: [PULL 26/63] vhost,vhost-user: Add VIRTIO_F_IN_ORDER to vhost
 feature bits
Message-ID: <c03213fdc9d7b680cc575cd1e725750702a10b09.1721607331.git.mst@redhat.com>
References: <cover.1721607331.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cover.1721607331.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

From: Jonah Palmer <jonah.palmer@oracle.com>

Add support for the VIRTIO_F_IN_ORDER feature across a variety of vhost
devices.

The inclusion of VIRTIO_F_IN_ORDER in the feature bits arrays for these
devices ensures that the backend is capable of offering and providing
support for this feature, and that it can be disabled if the backend
does not support it.

Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
Message-Id: <20240710125522.4168043-6-jonah.palmer@oracle.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 hw/block/vhost-user-blk.c    | 1 +
 hw/net/vhost_net.c           | 2 ++
 hw/scsi/vhost-scsi.c         | 1 +
 hw/scsi/vhost-user-scsi.c    | 1 +
 hw/virtio/vhost-user-fs.c    | 1 +
 hw/virtio/vhost-user-vsock.c | 1 +
 net/vhost-vdpa.c             | 1 +
 7 files changed, 8 insertions(+)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index fdbc30b9ce..5b7f46bbb0 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -51,6 +51,7 @@ static const int user_feature_bits[] = {
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_F_NOTIFICATION_DATA,
     VHOST_INVALID_FEATURE_BIT
 };
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index 18898afe81..a788e6937e 100644
--- a/hw/net/vhost_net.c
+++ b/hw/net/vhost_net.c
@@ -48,6 +48,7 @@ static const int kernel_feature_bits[] = {
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_F_NOTIFICATION_DATA,
     VIRTIO_NET_F_HASH_REPORT,
     VHOST_INVALID_FEATURE_BIT
@@ -78,6 +79,7 @@ static const int user_feature_bits[] = {
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_NET_F_RSS,
     VIRTIO_NET_F_HASH_REPORT,
     VIRTIO_NET_F_GUEST_USO4,
diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index 3d5fe0994d..49cff2a0cb 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -38,6 +38,7 @@ static const int kernel_feature_bits[] = {
     VIRTIO_RING_F_EVENT_IDX,
     VIRTIO_SCSI_F_HOTPLUG,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_F_NOTIFICATION_DATA,
     VHOST_INVALID_FEATURE_BIT
 };
diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
index cc91ade525..55e4be5b34 100644
--- a/hw/scsi/vhost-user-scsi.c
+++ b/hw/scsi/vhost-user-scsi.c
@@ -36,6 +36,7 @@ static const int user_feature_bits[] = {
     VIRTIO_RING_F_EVENT_IDX,
     VIRTIO_SCSI_F_HOTPLUG,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_F_NOTIFICATION_DATA,
     VHOST_INVALID_FEATURE_BIT
 };
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index ae48cc1c96..32ee7f496d 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -33,6 +33,7 @@ static const int user_feature_bits[] = {
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_F_NOTIFICATION_DATA,
     VHOST_INVALID_FEATURE_BIT
 };
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 802b44a07d..da3b0e0229 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -21,6 +21,7 @@ static const int user_feature_bits[] = {
     VIRTIO_RING_F_INDIRECT_DESC,
     VIRTIO_RING_F_EVENT_IDX,
     VIRTIO_F_NOTIFY_ON_EMPTY,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_F_NOTIFICATION_DATA,
     VHOST_INVALID_FEATURE_BIT
 };
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index daa38428c5..03457ead66 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -62,6 +62,7 @@ const int vdpa_feature_bits[] = {
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_RING_RESET,
     VIRTIO_F_VERSION_1,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_F_NOTIFICATION_DATA,
     VIRTIO_NET_F_CSUM,
     VIRTIO_NET_F_CTRL_GUEST_OFFLOADS,
-- 
MST

