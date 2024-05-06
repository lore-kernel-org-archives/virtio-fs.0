Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AA415445D
	for <virtio-fs@lists.linux.dev>; Mon,  6 May 2024 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715007901; cv=none; b=r5CdfzT6YFmCrJELBEV/5SIFdSPcH8F5iZsvhTVHNCJChxZKwidKTQktOvxluseVEH+QLsgMLM3A7+pQPbgZRv/o5jdbnxUQkgcWyQseT28qRFh2+Jj9LAnoPuGELeur8GXNMhbMfnFC9tGuFav8nCwNznOkjF4Xg1aSd419dcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715007901; c=relaxed/simple;
	bh=6kX75hY/dqAFPErdJPUw89KFOEOw+AWSSVcpUiJY6z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YanGMZHQtIbWiQ+HvsyvyrswJn7zp0toZ1gNOS8Zmucrq/qwNT3k7DQ4QiCs4RmypCJl7K5Odoh+FGX8gPIVsqNpNc5mU32a5W456yLua+FCM/jZngxLxW5ft9D/+7RJQ/dikG6gPrA/Cu0T3KvXWCdUhRbOHO+B4B54GSBX54g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dkJGaV4S; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dkJGaV4S"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446An3Em009250;
	Mon, 6 May 2024 15:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=f3wiEf6Vioc/85QwQtwyo5y3LFK0hoVlrmwPwiKOddE=;
 b=dkJGaV4SKFnLikMoZFqQFEIxOYtVM9fa6Ig7PWIui+lw95D+elJj2Ok6YmE2Lj/NAcsv
 PmDj/YNFitSD3yJR9rx/u04B5e8Ny7XiaJ1cPi0IQXgYnH47XjeCjmMDRr2EtXXapk3/
 sh+9dx09pxFcuPCld3eMHWi1DHgNhbCiieqyWFoZ4/HWAcKHmjjjmCSINQ29rQ9+7DSD
 2rQuBIcEgdqcQ1H2y60b7IsoXHcbyWLIj32AvbbVHjj7HKb/+K4O4aRmwDP+UDnDtAW5
 N6RC4mCT07kIveWK4pp7eIdP5IaBvpFkAIp3kiBMqn5K/+n8DsTRRwgm67lpAqBs1xRW fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbeettg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 15:04:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446DhZBY006927;
	Mon, 6 May 2024 15:04:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf6rwsm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 15:04:51 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446F4ZlT002521;
	Mon, 6 May 2024 15:04:50 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-221-117.vpn.oracle.com [10.39.221.117])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf6rw8e-7;
	Mon, 06 May 2024 15:04:50 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH 6/6] virtio: Add VIRTIO_F_IN_ORDER property definition
Date: Mon,  6 May 2024 11:04:28 -0400
Message-Id: <20240506150428.1203387-7-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240506150428.1203387-1-jonah.palmer@oracle.com>
References: <20240506150428.1203387-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_09,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060104
X-Proofpoint-GUID: eaSJjcWsNY5gItq1t-QUPGQwcdPUPaF7
X-Proofpoint-ORIG-GUID: eaSJjcWsNY5gItq1t-QUPGQwcdPUPaF7

Extend the virtio device property definitions to include the
VIRTIO_F_IN_ORDER feature.

The default state of this feature is disabled, allowing it to be
explicitly enabled where it's supported.

Tested-by: Lei Yang <leiyang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 include/hw/virtio/virtio.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 9ed9c3763c..30c23400e3 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -370,7 +370,9 @@ typedef struct VirtIORNGConf VirtIORNGConf;
     DEFINE_PROP_BIT64("packed", _state, _field, \
                       VIRTIO_F_RING_PACKED, false), \
     DEFINE_PROP_BIT64("queue_reset", _state, _field, \
-                      VIRTIO_F_RING_RESET, true)
+                      VIRTIO_F_RING_RESET, true), \
+    DEFINE_PROP_BIT64("in_order", _state, _field, \
+                      VIRTIO_F_IN_ORDER, false)
 
 hwaddr virtio_queue_get_desc_addr(VirtIODevice *vdev, int n);
 bool virtio_queue_enabled_legacy(VirtIODevice *vdev, int n);
-- 
2.39.3

