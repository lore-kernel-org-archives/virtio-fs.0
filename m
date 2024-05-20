Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C841311A8
	for <virtio-fs@lists.linux.dev>; Mon, 20 May 2024 13:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716210065; cv=none; b=TY70qjg+8hUqpFgBBxeW3tSjHJLwTRwZQEmK0IiIYY1PfsPmH5NxaGlNsTVj/cejOS8TEjiNVxNqbBY1LLlKBmM0aMS0JvR/DjMOvQjqK83mpyMZwG8P9IR8+kTcuFheM3FdDY71O/VARgTwW+J9eTbsQu8Cqeb2o/E336pczHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716210065; c=relaxed/simple;
	bh=iGxWntaWF9Ef7woNxlOH/a2UMUqgGniiJfcNfSdxaNM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YtvI1FSAn6GhrVe+FU67+DZja3UDkd5A9rt8+do2OIJpfy8/nlAOV25j4ayEX65iLRWA6iCBdoRAWWSafaNlsjfpxxP3MRdq8ahQaMHWkoaBf+CPYhKtx3Wi06X15f1jEmD9zk9aoirAseivCMgmMskOjntscvDQYgoib7aJJ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Plt7dA0+; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Plt7dA0+"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KAcL80017650;
	Mon, 20 May 2024 13:00:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=htxtr7UJu39xd0+/H2o5SGOgICpJ+C/4TbtakjZK5VI=;
 b=Plt7dA0+SHiP3V2FtcDSTb04/w11jGJpe6Ki+N7aqvriI4/f7Hrb/63FdIwKiH+Dcy7j
 6llWsm6own1bwr8J3POBkzy2ZrwbuOJxZDxbqAzR3hqd9Wbm3vGoK0DXAWv6JI7QgtfQ
 rK648W0jFFkXKs8Xqns4es8LV/xNfNXMgHDrr7xqUxG9tRFesBZ0VxigNrsls/BElXIW
 Y4L3x6AWxKPmew0FiJ52CdyimkHYQ9kXis0zvfIBMXhkdf+b+KmyBWU7+w+n0r7aqSD2
 butoyK9jl43kJ2kjRPLdop9W2GAXPNbU72EHAddG2ATOadIsWKIAxOm4MD6al3VDRY1x FA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6mvv2j84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 13:00:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44KBXtVi004961;
	Mon, 20 May 2024 13:00:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js6brv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 13:00:55 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44KD0qPZ028778;
	Mon, 20 May 2024 13:00:55 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-165-95.vpn.oracle.com [10.65.165.95])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y6js6brp8-2;
	Mon, 20 May 2024 13:00:55 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v2 1/6] virtio: Add bool to VirtQueueElement
Date: Mon, 20 May 2024 09:00:43 -0400
Message-Id: <20240520130048.1483177-2-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240520130048.1483177-1-jonah.palmer@oracle.com>
References: <20240520130048.1483177-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-20_05,2024-05-17_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405200108
X-Proofpoint-ORIG-GUID: 8anU9-aXMoqz74QXHvZvnyaOWSzALUB6
X-Proofpoint-GUID: 8anU9-aXMoqz74QXHvZvnyaOWSzALUB6

Add the boolean 'in_order_filled' member to the VirtQueueElement structure.
The use of this boolean will signify whether the element has been processed
and is ready to be flushed (so long as the element is in-order). This
boolean is used to support the VIRTIO_F_IN_ORDER feature.

Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 include/hw/virtio/virtio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 7d5ffdc145..88e70c1ae1 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -69,6 +69,8 @@ typedef struct VirtQueueElement
     unsigned int ndescs;
     unsigned int out_num;
     unsigned int in_num;
+    /* Element has been processed (VIRTIO_F_IN_ORDER) */
+    bool in_order_filled;
     hwaddr *in_addr;
     hwaddr *out_addr;
     struct iovec *in_sg;
-- 
2.39.3

