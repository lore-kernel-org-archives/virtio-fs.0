Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F279D6EB45
	for <virtio-fs@lists.linux.dev>; Fri,  1 Mar 2024 13:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709300628; cv=none; b=WZbhqZVrksLrnW2NeFpeLWItkiuOJIsE/CEuXxLUih30KWgv8GaKHAx/vJFG+Nvn2scDIsh4kBGZQy1m08rMT5MHymzXLyxiLSkMY6n1I4VVMlRe2tF6ISD4LLmPwM1AxjFqMYmGAKPTKsctVMaINYVBR0/Tior3YoxBHUHAXPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709300628; c=relaxed/simple;
	bh=wVH8HGgctQyjeo5JictLrauG5Rg29GYXK9QDVssMguM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eD5CoVeVby55ToRsI0XjUPETaxF4GU0ASwX3v38qLfQRKuQhhbFI3reTEpp5sxxnr4wvZWUYya7YIBKVHtFG7UQb0ZlxLWZf2FgM+8qUEE5VYckKy3op82M0bHQhgq7Y7yaDHVf4BnmmN9dfcjQS/IVUWlf4lwByZa393zt+oB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WL0p0doH; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WL0p0doH"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42198usA012317;
	Fri, 1 Mar 2024 13:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=+yib/Zj3rSXJ1hKbXY1gPDcB2uxuzIu3Eyv0AgFx4+0=;
 b=WL0p0doH3CRMR1U0iyYXtNtPy0M6metfdQpU0LJjZzm+RJzfHOPrrqh2kWAk1CoVFOsQ
 pP9V91nm2z3PggTKrozaRqGVD4FnbufgUWDdLrM62gO0uabxYv65IpS01s55O97/Z9Gv
 jg2GJZsanksXTLiggot0AWyXRB/Bj4QsqL0HdTFzOQGpNIClI7aO0RquGsJB3hoCgY0w
 IkNpIj6PPB/dkJPjKKgSweV9CfJ6k3p3qu+uKFlRXoenQ5poshaqiH2N2qivT+IXnqGt
 rMnIlsTIhk0q08cpVrGnOXcPxME38GqpwBD8pgMCTxITRR610WlwoTOelYi4+oJLEpbN DQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8gds5kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 13:43:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 421CwuK4009384;
	Fri, 1 Mar 2024 13:43:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wjrqmtre6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 13:43:39 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 421DhWAQ026578;
	Fri, 1 Mar 2024 13:43:38 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-160-211.vpn.oracle.com [10.65.160.211])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wjrqmtr9m-5;
	Fri, 01 Mar 2024 13:43:38 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com, raphael@enfabrica.net, kwolf@redhat.com,
        hreitz@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        farman@linux.ibm.com, thuth@redhat.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, cohuck@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, qemu-s390x@nongnu.org,
        virtio-fs@lists.linux.dev
Subject: [RFC 4/8] virtio-mmio: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
Date: Fri,  1 Mar 2024 08:43:26 -0500
Message-Id: <20240301134330.4191007-5-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240301134330.4191007-1-jonah.palmer@oracle.com>
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-01_13,2024-03-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403010114
X-Proofpoint-ORIG-GUID: wAQDAHZ40iGWB_ja4NigNc5az8y-vd-z
X-Proofpoint-GUID: wAQDAHZ40iGWB_ja4NigNc5az8y-vd-z

Prevent ioeventfd from being enabled/disabled when a virtio-mmio device
has negotiated the VIRTIO_F_NOTIFICATION_DATA transport feature.

Due to ioeventfd not being able to carry the extra data associated with
this feature, the ioeventfd should be left in a disabled state for
emulated virtio-mmio devices using this feature.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio-mmio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
index 2bac77460e..fc780a03b2 100644
--- a/hw/virtio/virtio-mmio.c
+++ b/hw/virtio/virtio-mmio.c
@@ -424,7 +424,8 @@ static void virtio_mmio_write(void *opaque, hwaddr offset, uint64_t value,
         virtio_update_irq(vdev);
         break;
     case VIRTIO_MMIO_STATUS:
-        if (!(value & VIRTIO_CONFIG_S_DRIVER_OK)) {
+        if (!(value & VIRTIO_CONFIG_S_DRIVER_OK) &&
+            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
             virtio_mmio_stop_ioeventfd(proxy);
         }
 
@@ -436,7 +437,8 @@ static void virtio_mmio_write(void *opaque, hwaddr offset, uint64_t value,
 
         virtio_set_status(vdev, value & 0xff);
 
-        if (value & VIRTIO_CONFIG_S_DRIVER_OK) {
+        if ((value & VIRTIO_CONFIG_S_DRIVER_OK) &&
+            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
             virtio_mmio_start_ioeventfd(proxy);
         }
 
-- 
2.39.3

