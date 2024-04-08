Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818E6140E5C
	for <virtio-fs@lists.linux.dev>; Mon,  8 Apr 2024 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712590482; cv=none; b=JU2OQFoeQKM8HgtXn/gWmhktjW8HRxHJNIkoAdMD++L0flqg1VEcS9f1uwkwwU4nM5c7LbX/xGHC0rDfAhwZC47M3atcIYuWuFKJPHq2y/uTP7sFU+tNRd99CSvLek/TtfUDUBQMGf9tJjGPMEMtITX5mknV3X+Q64bk9n5upS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712590482; c=relaxed/simple;
	bh=VG2gOZULsgccUoUrfm6e2O6tfmbYZE1xEE/ZyOb7vKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=byPTMMUnvfIon8W3spoJ9Nmj4RTJg4lss91pWhvnlLNOMOerGGrWvNV6W6tJQdWYJUgLY85t4alRG0/x+8jbS+nbLPFTk0DAuw0/di+gyJyBb542sfyjenO2FVPmNHhMkPAPCuk0ufydvkhQhPHev5shReJio5YmF44i7np3Jw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HWdSj7jM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HWdSj7jM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438ENwV6014629;
	Mon, 8 Apr 2024 15:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=f29pbPDScm2dsH2p1VNwuN6r8JoPYGFvgZMG1tr/H1A=;
 b=HWdSj7jMPuY3ocomOWjIn3rJZthYyAZRhHKnt8ayUy+TQj0j7AIy5PfsbuV7kEVoN3L5
 CPBZc97kI2QKCZS1nmmR0tZjFzmDavblxCGuRjTDwh23N/RpXrz8TMGmbzmanDljnZgP
 +oHfn8wbWUpQDB+hXjP6LoS2Bk8PWTLfuwanpxQqTU4OgGBCP1kU8npX1A1YOritd93w
 UROfsycikrkdyk4dmEZ8N0Ls3FMA/xnUr3cLMZmLfGGexK6C30+PLPAFcddPRdcaic1i
 E+VyeveOUbNH4E9M3KBSTwWcbtg1Rh5v3dFdTh+4Lx+HCGgpzG7z0e1lmeJ23Ei8do2k cg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xavtf31mv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438FUGOE032401;
	Mon, 8 Apr 2024 15:34:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu60dj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:25 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438FUlV6008521;
	Mon, 8 Apr 2024 15:34:24 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-195-157.vpn.oracle.com [10.39.195.157])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xavu60d7m-7;
	Mon, 08 Apr 2024 15:34:24 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v3 6/6] virtio: Add VIRTIO_F_IN_ORDER property definition
Date: Mon,  8 Apr 2024 11:34:08 -0400
Message-Id: <20240408153408.3527586-7-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240408153408.3527586-1-jonah.palmer@oracle.com>
References: <20240408153408.3527586-1-jonah.palmer@oracle.com>
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
 definitions=2024-04-08_13,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080120
X-Proofpoint-GUID: RB0E5jbPopzzLIiexArsoIZr8oIpNFML
X-Proofpoint-ORIG-GUID: RB0E5jbPopzzLIiexArsoIZr8oIpNFML

Extend the virtio device property definitions to include the
VIRTIO_F_IN_ORDER feature.

The default state of this feature is disabled, allowing it to be
explicitly enabled where it's supported.

Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 include/hw/virtio/virtio.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 9034719f1d..43ea738e65 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -385,7 +385,9 @@ typedef struct VirtIORNGConf VirtIORNGConf;
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

