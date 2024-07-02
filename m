Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A0C3770D
	for <virtio-fs@lists.linux.dev>; Tue,  2 Jul 2024 14:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719929254; cv=none; b=eVHzeAlf3ShtSZnYJWyrNyBoyOkPV6pULd0Fu2K+n7WrHBGMWGGgjmmlJBbsoeGnFaykDpPnKnUuDnaBZIFyQ4q7fw7Sn3Tjac1lCs6F+feXNHriZ8anvyXEBwbbqU6SfsgVUmaOLvswRCf1R8kLAIjFfVNPe3KjJhdJFGUzHwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719929254; c=relaxed/simple;
	bh=hTnxxAgOv71dKBe2Z05pTi3xTuo2fFU4FAWeQFXISn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=bY6NyrP+ci0IKt8cy2lr0cJhGIySiP2QIKotMpEh+Lvjn3DrxoN6I8LtwGo0sLGVof1sWrqLYohKrByVY65qaD8xKcUxgR+KOrdX9vxp26zkwSi1kg9hEK42PXn6n57seFjB8OyIxcKbhdAViuIH+vcDb1PjQSAp2DFJ/6IUOlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L9xTQ28f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L9xTQ28f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719929251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCCVtvSfvqBAUBpNFi/zb/m65iBLwl7XEHTViiftxcE=;
	b=L9xTQ28f7xMRiHhJK8gzQP5hKK1uZf0x3Jafc21pRz6y3y6RzAHaHbEUviviaG9PTUct6q
	y7nHVrwjiSkYqdaIT3+68TMudYgqr8jiHjb7RejicyZr9msMMiau9LJEZGjLv9ntDN+Cbx
	V3BYjxWgtZQjl5j6j/zTN+P5LJMnNc8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-JMQz_alwOGK1-_f6PQS0Lg-1; Tue, 02 Jul 2024 10:07:25 -0400
X-MC-Unique: JMQz_alwOGK1-_f6PQS0Lg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-363542774e1so4484410f8f.2
        for <virtio-fs@lists.linux.dev>; Tue, 02 Jul 2024 07:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719929244; x=1720534044;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OCCVtvSfvqBAUBpNFi/zb/m65iBLwl7XEHTViiftxcE=;
        b=Q40K8WvpCY6p4iI3pUy1lyGtuXVw8hzNlxSbsVTBQZAM4u1514JPjtAAsDPFfwQmgI
         V61CqC6OZWOG/bK5FKeHYENnTrHMvcDjmocd+TJxt0TC8JbvS5OV0VqKaRqJ4zvNfTla
         n0KfQqrW7gPoR7H4Rd5FQqKSx/kwJ06OvwX9ZLATIBgAk8Hs2fJaTP7r31Ir3zYFbY7E
         IGmuBckGHOmeVX898sunsWFEB3y8I4PdM0XArCmfXy0FigyvBtAL4A+GiqFkDakCUjRK
         FT2rvx12m53eXF1VWwtwofPJy/WrsIT1NIEtLSpJAXJTsFzW4FtRd1e7CDwn7MI8NDFI
         Cc3A==
X-Forwarded-Encrypted: i=1; AJvYcCU0Zr3jphi7FZQrn/X83h3ecSmKKJsQ+rhwhMo40BZYlI91/i4NAE0svQjjmC1oPSiGSS5yZ5G6J5Ck4Sk+Tbil9hniXe05Bn2X
X-Gm-Message-State: AOJu0Yxrd/eQYopBr8EuEAC6WdqQB/JNdBLFvGYUkYFaMz2Cn/nKvo7P
	vSdd0H9ljE6zwHKLXuRkdFmOYv5Yxk99RI62CfRsdFjL75pk4t1PrnB5L3JiohTGt84F0TOChc0
	stii5GKdfefvf922q4we1QDsAxHnMkDFZ+0PQEU6LsIv9CDG4rqkqAStokg==
X-Received: by 2002:adf:a381:0:b0:366:f34d:d0b7 with SMTP id ffacd0b85a97d-367756bb806mr7373695f8f.29.1719929244347;
        Tue, 02 Jul 2024 07:07:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUI4bM55YqPJYK0Ha8aEnXWd8xVDASX3XaOoSllRi7/BUeVM6uH00B7hv5HZIsY2c/gPfHDw==
X-Received: by 2002:adf:a381:0:b0:366:f34d:d0b7 with SMTP id ffacd0b85a97d-367756bb806mr7373666f8f.29.1719929243818;
        Tue, 02 Jul 2024 07:07:23 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f5:eadd:8c31:db01:9d01:7604])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3675a0cd6b4sm13274976f8f.17.2024.07.02.07.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 07:07:23 -0700 (PDT)
Date: Tue, 2 Jul 2024 10:07:20 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jonah Palmer <jonah.palmer@oracle.com>,
	Lei Yang <leiyang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Srujana Challa <schalla@marvell.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev
Subject: [PULL 08/91] vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to
 vhost feature bits
Message-ID: <b937fa896321fb7b6d7f2205edb5490e0e5d6c69.1719929191.git.mst@redhat.com>
References: <cover.1719929191.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cover.1719929191.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

From: Jonah Palmer <jonah.palmer@oracle.com>

Add support for the VIRTIO_F_NOTIFICATION_DATA feature across a variety
of vhost devices.

The inclusion of VIRTIO_F_NOTIFICATION_DATA in the feature bits arrays
for these devices ensures that the backend is capable of offering and
providing support for this feature, and that it can be disabled if the
backend does not support it.

Tested-by: Lei Yang <leiyang@redhat.com>
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
Message-Id: <20240315165557.26942-6-jonah.palmer@oracle.com>
Acked-by: Srujana Challa <schalla@marvell.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 hw/block/vhost-user-blk.c    | 1 +
 hw/net/vhost_net.c           | 2 ++
 hw/scsi/vhost-scsi.c         | 1 +
 hw/scsi/vhost-user-scsi.c    | 1 +
 hw/virtio/vhost-user-fs.c    | 2 +-
 hw/virtio/vhost-user-vsock.c | 1 +
 net/vhost-vdpa.c             | 1 +
 7 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 9e6bbc6950..bc2677dbef 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -51,6 +51,7 @@ static const int user_feature_bits[] = {
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_NOTIFICATION_DATA,
     VHOST_INVALID_FEATURE_BIT
 };
 
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index fd1a93701a..18898afe81 100644
--- a/hw/net/vhost_net.c
+++ b/hw/net/vhost_net.c
@@ -48,6 +48,7 @@ static const int kernel_feature_bits[] = {
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_NOTIFICATION_DATA,
     VIRTIO_NET_F_HASH_REPORT,
     VHOST_INVALID_FEATURE_BIT
 };
@@ -55,6 +56,7 @@ static const int kernel_feature_bits[] = {
 /* Features supported by others. */
 static const int user_feature_bits[] = {
     VIRTIO_F_NOTIFY_ON_EMPTY,
+    VIRTIO_F_NOTIFICATION_DATA,
     VIRTIO_RING_F_INDIRECT_DESC,
     VIRTIO_RING_F_EVENT_IDX,
 
diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index ae26bc19a4..3d5fe0994d 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -38,6 +38,7 @@ static const int kernel_feature_bits[] = {
     VIRTIO_RING_F_EVENT_IDX,
     VIRTIO_SCSI_F_HOTPLUG,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_NOTIFICATION_DATA,
     VHOST_INVALID_FEATURE_BIT
 };
 
diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
index a63b1f4948..0b050805a8 100644
--- a/hw/scsi/vhost-user-scsi.c
+++ b/hw/scsi/vhost-user-scsi.c
@@ -36,6 +36,7 @@ static const int user_feature_bits[] = {
     VIRTIO_RING_F_EVENT_IDX,
     VIRTIO_SCSI_F_HOTPLUG,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_NOTIFICATION_DATA,
     VHOST_INVALID_FEATURE_BIT
 };
 
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index cca2cd41be..ae48cc1c96 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -33,7 +33,7 @@ static const int user_feature_bits[] = {
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_RESET,
-
+    VIRTIO_F_NOTIFICATION_DATA,
     VHOST_INVALID_FEATURE_BIT
 };
 
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 9431b9792c..802b44a07d 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -21,6 +21,7 @@ static const int user_feature_bits[] = {
     VIRTIO_RING_F_INDIRECT_DESC,
     VIRTIO_RING_F_EVENT_IDX,
     VIRTIO_F_NOTIFY_ON_EMPTY,
+    VIRTIO_F_NOTIFICATION_DATA,
     VHOST_INVALID_FEATURE_BIT
 };
 
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index eda714d1a4..daa38428c5 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -62,6 +62,7 @@ const int vdpa_feature_bits[] = {
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_RING_RESET,
     VIRTIO_F_VERSION_1,
+    VIRTIO_F_NOTIFICATION_DATA,
     VIRTIO_NET_F_CSUM,
     VIRTIO_NET_F_CTRL_GUEST_OFFLOADS,
     VIRTIO_NET_F_CTRL_MAC_ADDR,
-- 
MST

