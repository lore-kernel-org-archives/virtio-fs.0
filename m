Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0318126F0A
	for <virtio-fs@lists.linux.dev>; Mon,  8 Apr 2024 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712590463; cv=none; b=FLdbjf9B3aXL6xnjvhuxySVqiqmvrkewbg9+vWcl4jFjxBMuRD4k9sfdeWU/HYxSdxx7cCHA85eRseQLB838x1Cmv/aoNHTEBwuowiNP15YYwsUQQ1n5glHO5cRsTjPVSXZtPy+kG+dLW9U6Med33GY70/2x9B8CL9gIB5hMuj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712590463; c=relaxed/simple;
	bh=JEK9Mf36nNLeyhu09lahs9ad1MOZcn80qA6GRTSO6hU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o9DVchSZhPHdKc6iNMN68xhbpN15IjjXloInwydrF5R022dh+kaxKcqoOvG3pBvbsb5Il/JtRTtCBBVIIClLgnWxB5jucaj2c/yDicdvQxHT92K572NHmgV7L4zuetDI1e1G3fQvvkhpfa9aSMPjT7v5dfkcCVwQJujIrIQOjoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YpIdkTDg; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YpIdkTDg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438ENpoX028680;
	Mon, 8 Apr 2024 15:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=fxTG5H+k9GuEV1QiH20UEngvezOU2CY6pKWF9qduMa8=;
 b=YpIdkTDg30RKAtWQmF6/TyC52wPJGVkbgBJ/GvteDF7dGmKcY881GwJjhhLLal9TYzYa
 yGGyjsMMi19N+9LuJOiI84R506C0jv8Sx/I7bjWhzqmOtYj17Kjuya8f1NrVB+dl9o3/
 FBeuILL035v5sCqH5+VDOw+cTLGSjd+DGCbjh1QvT+KR0Ahg1b8K2VFzss1OuabD6I6G
 a50foKxJCQHFp5RI/00WSaE9uF/9FXxD/tQGNX2VzQgsm3Bmpy/YZtxR3euqnNdojKPO
 cxi04045MfKbbx4sTbKJtB2vX3H0Vjkf0KLiUO5wjypQ0BDIPyOyehy2XT7thq9FNKAD EQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxedk1rk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438ESwuF032371;
	Mon, 8 Apr 2024 15:34:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu60dau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:14 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438FUlUu008521;
	Mon, 8 Apr 2024 15:34:13 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-195-157.vpn.oracle.com [10.39.195.157])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xavu60d7m-2;
	Mon, 08 Apr 2024 15:34:13 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v3 1/6] virtio: Add bool to VirtQueueElement
Date: Mon,  8 Apr 2024 11:34:03 -0400
Message-Id: <20240408153408.3527586-2-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240408153408.3527586-1-jonah.palmer@oracle.com>
References: <20240408153408.3527586-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_13,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080120
X-Proofpoint-GUID: k8vp9plj5_NjByBtSI8kFoZ1z8-8OjcA
X-Proofpoint-ORIG-GUID: k8vp9plj5_NjByBtSI8kFoZ1z8-8OjcA

Add the boolean 'filled' member to the VirtQueueElement structure. The
use of this boolean will signify if the element has been written to the
used / descriptor ring or not. This boolean is used to support the
VIRTIO_F_IN_ORDER feature.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 include/hw/virtio/virtio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index b3c74a1bca..9034719f1d 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -71,6 +71,7 @@ typedef struct VirtQueueElement
     unsigned int ndescs;
     unsigned int out_num;
     unsigned int in_num;
+    bool filled;
     hwaddr *in_addr;
     hwaddr *out_addr;
     struct iovec *in_sg;
-- 
2.39.3

