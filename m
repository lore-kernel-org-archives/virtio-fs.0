Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1237D1494CA
	for <virtio-fs@lists.linux.dev>; Tue,  4 Jun 2024 19:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717527999; cv=none; b=e1tKV7yK+EyuqwhZItoEi32GBk6BLwY9FNeryopy2NOhNEL/bjnREMcrX4c5ncN5HMRBGddbWsd8knkuygaxuPTEORQXPT2zFmJDuBSoFWDTMncaEnJBJvbkJ88EWoJFClSccvXwefqOKxAxw1uXT9HVf5Ecwb9qWngf4KqSYwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717527999; c=relaxed/simple;
	bh=hTnxxAgOv71dKBe2Z05pTi3xTuo2fFU4FAWeQFXISn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ODNJDV9VlIFdqjnaeAajKBk66BOl4fRVnGeaNyMbaTPGwHZCd7zx2i2iEF3UfDVEuVqew9C3CburMrFWEtDq5wJ5tiYyQ+vo7xNt0OycjpfT4+sGsB7TtAfhPeCsxz7ZmEWZUo/3vl3jcAhMOvALx4YvAGkgcTzOf3mkdkC25ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c7hAk2HE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c7hAk2HE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717527996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCCVtvSfvqBAUBpNFi/zb/m65iBLwl7XEHTViiftxcE=;
	b=c7hAk2HEwlGyghTALHp7ytXyy2nnv+mEhbjvPNcr3OpI82ruEU9oCLfHg0ZmtQt4NdfD9N
	ZKNUChb/wsqpgUU5N4sR/ZcZ57RuH6/JrsHjmhcd8UrU1WXy6OvK8b9C2ZYHnvGGyHHwJp
	V//39dGKCbcpOYYhZkrB4tMKP7yq0Ko=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-E6vkprqfMwO8VyjV-XKbvw-1; Tue, 04 Jun 2024 15:06:35 -0400
X-MC-Unique: E6vkprqfMwO8VyjV-XKbvw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35e0f445846so3150534f8f.0
        for <virtio-fs@lists.linux.dev>; Tue, 04 Jun 2024 12:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717527994; x=1718132794;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OCCVtvSfvqBAUBpNFi/zb/m65iBLwl7XEHTViiftxcE=;
        b=m9GDDsCmBBPDcbyoq+dWKnzXtjLe5ljkNzEC9qd+g0T9btTrk78QhQxHoG1nbgX1Nr
         GiltdmBiybNlq07vaRHQbjuK4+8jW5ZCuN/a1kJKtIMiWjIgZTO6eAhAR+QNMvas+RWG
         JL6P1JwWPh/vV8+qsZ1nHBEnRiXNsAEfVNZAVfwNOR05NXzZGGPo23EoPlU41EyUsbIG
         1bkMLy8+5cEYkikK5NMQHKlL7AoCeaZaAR57AN6o+JxTJ6Vhqan7i+f/Wi7GjbA03SOK
         XYOFwAuowo+alEqmY/TIcOrRor38byB+89KSXjkYW/f3xQM8I6PghiETeXaUnkQS8OJd
         IpDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLu3v+5GeXGkuVXjFDtJHAtCYhlyf5oY0J8GJcymO2Iz1SkVBagmHogvMECWCMZV4oJQswsaLcq2nJpiwXRNfh5LRCfv3OuSS9
X-Gm-Message-State: AOJu0YxLSvlE7Fc7HeAGiFrpVgGq4qshZ7DYiV5wB+wkiyUGq/TN7yI5
	a5MzF/whpZWCNvzbFvb4RixjTEagELjDrgxpLJp9JkVgZIi4bqESkmAKGqb4RxAk0R+ozwmlOmw
	uqW5t8LbFw3TGcDx0ErPDZhl3XCkPRoCyRcL1tTyUsmNlnUs4uU5bQzvhMg==
X-Received: by 2002:a5d:66cf:0:b0:35e:5be5:fbb with SMTP id ffacd0b85a97d-35e8ef8ec1bmr213097f8f.67.1717527993784;
        Tue, 04 Jun 2024 12:06:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlxcGzgfMyv1oXCA/eCPMq7OxdfCxVeK3UxTeT30HVafbwgGv3cusaR71zAWthsSz/YFutNA==
X-Received: by 2002:a5d:66cf:0:b0:35e:5be5:fbb with SMTP id ffacd0b85a97d-35e8ef8ec1bmr213075f8f.67.1717527993350;
        Tue, 04 Jun 2024 12:06:33 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:552:cf5c:2b13:215c:b9df:f231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd04c0e84sm12415306f8f.13.2024.06.04.12.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 12:06:32 -0700 (PDT)
Date: Tue, 4 Jun 2024 15:06:29 -0400
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
Subject: [PULL 09/46] vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to
 vhost feature bits
Message-ID: <bb0ba79492dc7c1d1b2ef3e2389060ed259e646a.1717527933.git.mst@redhat.com>
References: <cover.1717527933.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cover.1717527933.git.mst@redhat.com>
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

