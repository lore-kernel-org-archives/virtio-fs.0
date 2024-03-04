Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C95A7994A
	for <virtio-fs@lists.linux.dev>; Mon,  4 Mar 2024 19:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709581590; cv=none; b=rYqvz7SYzdPrkGQFABLh0QG14IoYTMvyyVSXeAFkbiOIXvn2YXys2mbjc5aD3XS9domvcDmYuO51oADI6VlSk9OU/QkKFLbFb/uhTxeWO8CQLxSZpRz62ddXO+JMgKJO5Wj+D9NBLZ1SML1WKgs/RYFrAKGzAnTgZijLJsTzB7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709581590; c=relaxed/simple;
	bh=5j5vW8Mb+qhLWcuwqUL5ZnJqOjxwLMN0mR24RnMjfYA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iEfwaS6jWFTRH90spgdlHiVL8C1+E6zAQ7voeEcpxfvdg2W4vyi2FGLNbtH2QXBkOwjBRI0bprugxi5k3A51pLjD1ofB6f9OlyJDfULG1Ya36ZV+/Azkgtxw6HZ56/kGtZjnEfcW1mvlRT86FMOcF2QISLowPROtLyBBj1z+cs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hxAmzIDu; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hxAmzIDu"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 424IxqbM032311;
	Mon, 4 Mar 2024 19:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=jglHBlmZ0KmZFBvl99lLam02zHjHqPLHsDjR3lhm5XQ=;
 b=hxAmzIDu080hVcLGcCfsLjsfUg2x2bGnnhFxLscAYP4uum8MGT5ALYkSEJ/lWi1d4O3/
 W3lruuyJDXztDOj1wCrRK2hQe/crJnwM2HO38wIf5sVlAY7f+B8vf154WLf0+f53t0XP
 ERmx6DBKI86ahEfbbpuNBAVQtgnbcF9+lD8SjiEDjKOyX19VkLTX3q/+ykemjF77nyyR
 vRgEoi852unwDDbFhiG4gWkhQfAxdg2Vnq8J3Duj/ffurTAcROP/mxgKZv4LExvR0kK8
 LsXkd04m0X7hMl2Bnvj0nKxL3oOUXks8MZ2LVqe6G5RGtOx0z3K1+8W84V8HfB3OF97o qQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkv0bcfan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 19:46:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 424JLesw019006;
	Mon, 4 Mar 2024 19:46:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wktj6agaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 19:46:21 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 424JkE46038523;
	Mon, 4 Mar 2024 19:46:20 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-196-188.vpn.oracle.com [10.39.196.188])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wktj6ag50-5;
	Mon, 04 Mar 2024 19:46:20 +0000
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
Subject: [PATCH v1 4/8] virtio-mmio: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
Date: Mon,  4 Mar 2024 14:46:08 -0500
Message-Id: <20240304194612.611660-5-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240304194612.611660-1-jonah.palmer@oracle.com>
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-04_15,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403040152
X-Proofpoint-ORIG-GUID: 1iUBpQksxHR9DVlyRPEMUdOYeqaeSf0b
X-Proofpoint-GUID: 1iUBpQksxHR9DVlyRPEMUdOYeqaeSf0b

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
index f99d5851a2..f42ed5c512 100644
--- a/hw/virtio/virtio-mmio.c
+++ b/hw/virtio/virtio-mmio.c
@@ -421,7 +421,8 @@ static void virtio_mmio_write(void *opaque, hwaddr offset, uint64_t value,
         virtio_update_irq(vdev);
         break;
     case VIRTIO_MMIO_STATUS:
-        if (!(value & VIRTIO_CONFIG_S_DRIVER_OK)) {
+        if (!(value & VIRTIO_CONFIG_S_DRIVER_OK) &&
+            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
             virtio_mmio_stop_ioeventfd(proxy);
         }
 
@@ -433,7 +434,8 @@ static void virtio_mmio_write(void *opaque, hwaddr offset, uint64_t value,
 
         virtio_set_status(vdev, value & 0xff);
 
-        if (value & VIRTIO_CONFIG_S_DRIVER_OK) {
+        if ((value & VIRTIO_CONFIG_S_DRIVER_OK) &&
+            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
             virtio_mmio_start_ioeventfd(proxy);
         }
 
-- 
2.39.3

