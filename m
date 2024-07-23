Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43E33D6A
	for <virtio-fs@lists.linux.dev>; Tue, 23 Jul 2024 10:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721732264; cv=none; b=hQlQB/CNPSu4JaDmnK4YoBT6KEWulMCRDmpQtL83E75ck5lFdpbRw5sW1OgvbvlQqg0Aa9eGQF4VDj2fnCdQl+cw1V3fROErvriAezJH+1TidQ40g/GVWil2AGp9VqA3XuJUuNI2ojp3tTMLCgtYRoYeTfZ6kdPJ3eJgwflo4Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721732264; c=relaxed/simple;
	bh=mI/ApjuW6sUiw6mELgYc4rin6tatA1H8QcVVY7nngsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=L50VuYT5mkn5dHWTBz/M4PDKyDHWubs0y1FKG8begmgmi+RfsFsYKkQNalXrgv8IVbVWNOpDu8laQbIHtpWxqE7Dr7h9zGWsyo4pMbgZ2uEdAbOOMzI181JYcmMi48xgadd7Bc9Oj0sjQy8JmX73xo+ULpXcN5g4UEv9pCEn/JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NYKzc5dx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NYKzc5dx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721732260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q0Npoi3B/pjRdsmZv/oBnj6YQVo4m4QtFoQ2kZEEzmA=;
	b=NYKzc5dxG2a7cEuDM2XjkH1mMnm0m3ohXJq8wokK/KAtQIsEQBSAsc8LOa6gnntw11AhDg
	QaXtXojiUlhnGbyJQXuLkc7LhHb8qpidVzPoAVB71e5+wCj0XQm7KVJ6aBvMVklMdvQ1+F
	WYZ1BFLoqs6sn2ZhawRmF0/SeHngk3I=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-6TAqe6_fPiWrQ_BJVZydzg-1; Tue, 23 Jul 2024 06:57:39 -0400
X-MC-Unique: 6TAqe6_fPiWrQ_BJVZydzg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-58c537ae6c9so2887069a12.2
        for <virtio-fs@lists.linux.dev>; Tue, 23 Jul 2024 03:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721732258; x=1722337058;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q0Npoi3B/pjRdsmZv/oBnj6YQVo4m4QtFoQ2kZEEzmA=;
        b=gW19ijrzXzFUfsGd8G3hwoJ7QNknCHjL1on2/JgF3eKNxN4frSwcT+hywRqbwW4BWt
         GB6xzrc7wBSRsd5lnUpX/bl8c6TL9pNisARzT1Gn8lNgu9De9nJkIPcEbmwiRyp78hk0
         szI9wti+gi6Rgon1yxJ8dBQfDUg6qT84dMyQSK0j2OGnUt1rNPq9oEg3LmVnyPydzYC9
         EQwBxEzQCzAVNRbxq/BeDPOQP+IpnooIESz7SsF6FhUYLXs8CvgkJNgyRTVuSRi7bPDs
         7MDKxYepetPolWqkRt6C/sJ1n3xgCtushZyM/pXxqPx0GcIH+M7if2JdU0dU01Rvenzw
         CDqw==
X-Forwarded-Encrypted: i=1; AJvYcCVBL+RKEc76xbtaT7t5NEi98DWXfqj/H+8gYgieFQboQy1BgJE2rMFwtAYGIkR+L6BAVpje3+qWkbjTAW5Za6IQb+huKIZkzcwd
X-Gm-Message-State: AOJu0YxVBhp2e2SGSZoaEsCDHrRPLFbKtQ/mApyhVtbzbu7RMJlq94F0
	bnzD4jWKPcWtNDPWe7ejKo1HlH8EiSe1g5D7oJ/SW65NOIslmHhytnihTr/d3Bs9NQRDFRjEQsn
	aguDhomvOm9U9jrNKUireKc4BO8B3cUxi2E31A8d3rzYDCxLld+n/AJaJXg==
X-Received: by 2002:a05:6402:1d4c:b0:57c:78fb:1a32 with SMTP id 4fb4d7f45d1cf-5a479868705mr7207788a12.19.1721732258441;
        Tue, 23 Jul 2024 03:57:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiXAdByeISpuzV0J0R8F+5FeBI1tgARwVqnGDO/N30uEpPs6FmJ6G9oxSAqnIxOPEkqAF/7w==
X-Received: by 2002:a05:6402:1d4c:b0:57c:78fb:1a32 with SMTP id 4fb4d7f45d1cf-5a479868705mr7207750a12.19.1721732257899;
        Tue, 23 Jul 2024 03:57:37 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:440:9c9a:ffee:509d:1766:aa7f])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a30a4d6c17sm7385168a12.5.2024.07.23.03.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 03:57:37 -0700 (PDT)
Date: Tue, 23 Jul 2024 06:57:26 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jonah Palmer <jonah.palmer@oracle.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev
Subject: [PULL v2 26/61] vhost,vhost-user: Add VIRTIO_F_IN_ORDER to vhost
 feature bits
Message-ID: <c03213fdc9d7b680cc575cd1e725750702a10b09.1721731723.git.mst@redhat.com>
References: <cover.1721731723.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cover.1721731723.git.mst@redhat.com>
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

