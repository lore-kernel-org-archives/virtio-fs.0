Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274961386A8
	for <virtio-fs@lists.linux.dev>; Thu, 28 Mar 2024 16:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711642938; cv=none; b=P6ybfQrEuaQPvDohBl3v4A2OHcx4O/ZAskQrryQQbpK2OQ8kmeQfAxnXwtCx2DiQ/jnU6GLADFuSO4sDqpG0pb8vLTmnauPgJDMfLqI9nmF4trASW7Zi6zBOzG9KVm0UaPJzcmWoJkrj6HDWKzLJoiH7tzRyaZPsaXSmMXGmju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711642938; c=relaxed/simple;
	bh=NWR6VrxCG0A80Z/1cgGSNneSL8lDfiFgePCZgslDuu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=udSyN3YL1vHizkI03mqFKI1+8I5ur4UeXFJVyE8y6X9BMyivNvi8rZ8+8dx2AeilOfKA8CKRc6SYoeuBfpfWZG0A38Mu4ztr+1Oq8jXInQqSZSVhLRdtnVX9FxWucIuSd6+58d0eahOvpi9OtzZ2hnAnINrfMaZTvFJO6OBGCyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O5+rkGoe; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O5+rkGoe"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42SFOjHv000733;
	Thu, 28 Mar 2024 16:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=NCxxLo4RlxRydMdSCKc3FePLGo3S5WU5DOyvQHDa3kg=;
 b=O5+rkGoeZLNWH313Xt8I/2mBLzm1oYLP8ygLT7xJDWIIw+nEI3zXcR7t9DuJilF2lx/G
 MB5LoY/DxU6HalxTGOYlAsKvTBQ0AYRZVkFdX87MiH2rLTYp+mkjBALjCnHQY5MZiS61
 DoHCjF+MH5GgAMuHZJNMaxtM+PicALZ+DYOjvIj6Uko9LjXoQzesRPLS79F08HEopaiq
 WttlTo1Xg9gXTijLw4pVPpjLqwiNXbytH1o/wpmC+9QIJriavkKCkefwxMgyjW9lsq6x
 8D+CNesuVx7kWdJ+H+/xHYyNJq/bkPOTHkLd3Z2APuricSXQna87t2ugde1zh/rgvrY5 vQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x4cxy3jc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 16:22:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42SG6uJk015089;
	Thu, 28 Mar 2024 16:22:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhgfgkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 16:22:11 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42SGM5a3010492;
	Thu, 28 Mar 2024 16:22:10 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-220-183.vpn.oracle.com [10.39.220.183])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3x1nhgfgcy-5;
	Thu, 28 Mar 2024 16:22:10 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v2 4/5] vhost,vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
Date: Thu, 28 Mar 2024 12:22:02 -0400
Message-Id: <20240328162203.3775114-5-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240328162203.3775114-1-jonah.palmer@oracle.com>
References: <20240328162203.3775114-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-28_15,2024-03-28_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403280111
X-Proofpoint-ORIG-GUID: GBAbzjABFBmkmS9YtKLnshBMZm8A-t79
X-Proofpoint-GUID: GBAbzjABFBmkmS9YtKLnshBMZm8A-t79

Add support for the VIRTIO_F_IN_ORDER feature across a variety of vhost
devices.

The inclusion of VIRTIO_F_IN_ORDER in the feature bits arrays for these
devices ensures that the backend is capable of offering and providing
support for this feature, and that it can be disabled if the backend
does not support it.

Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
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
index 6a856ad51a..d176ed857e 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -51,6 +51,7 @@ static const int user_feature_bits[] = {
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VHOST_INVALID_FEATURE_BIT
 };
 
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index fd1a93701a..eb0b1c06e5 100644
--- a/hw/net/vhost_net.c
+++ b/hw/net/vhost_net.c
@@ -48,6 +48,7 @@ static const int kernel_feature_bits[] = {
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_NET_F_HASH_REPORT,
     VHOST_INVALID_FEATURE_BIT
 };
@@ -76,6 +77,7 @@ static const int user_feature_bits[] = {
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_NET_F_RSS,
     VIRTIO_NET_F_HASH_REPORT,
     VIRTIO_NET_F_GUEST_USO4,
diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index ae26bc19a4..40e7630191 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -38,6 +38,7 @@ static const int kernel_feature_bits[] = {
     VIRTIO_RING_F_EVENT_IDX,
     VIRTIO_SCSI_F_HOTPLUG,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VHOST_INVALID_FEATURE_BIT
 };
 
diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
index a63b1f4948..1d59951ab7 100644
--- a/hw/scsi/vhost-user-scsi.c
+++ b/hw/scsi/vhost-user-scsi.c
@@ -36,6 +36,7 @@ static const int user_feature_bits[] = {
     VIRTIO_RING_F_EVENT_IDX,
     VIRTIO_SCSI_F_HOTPLUG,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
     VHOST_INVALID_FEATURE_BIT
 };
 
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index cca2cd41be..9243dbb128 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -33,6 +33,7 @@ static const int user_feature_bits[] = {
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_IOMMU_PLATFORM,
     VIRTIO_F_RING_RESET,
+    VIRTIO_F_IN_ORDER,
 
     VHOST_INVALID_FEATURE_BIT
 };
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 9431b9792c..cc7e4e47b4 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -21,6 +21,7 @@ static const int user_feature_bits[] = {
     VIRTIO_RING_F_INDIRECT_DESC,
     VIRTIO_RING_F_EVENT_IDX,
     VIRTIO_F_NOTIFY_ON_EMPTY,
+    VIRTIO_F_IN_ORDER,
     VHOST_INVALID_FEATURE_BIT
 };
 
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 85e73dd6a7..ed3185acfa 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -62,6 +62,7 @@ const int vdpa_feature_bits[] = {
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_RING_RESET,
     VIRTIO_F_VERSION_1,
+    VIRTIO_F_IN_ORDER,
     VIRTIO_NET_F_CSUM,
     VIRTIO_NET_F_CTRL_GUEST_OFFLOADS,
     VIRTIO_NET_F_CTRL_MAC_ADDR,
-- 
2.39.3

