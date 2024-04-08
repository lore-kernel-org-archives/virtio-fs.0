Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08241422A4
	for <virtio-fs@lists.linux.dev>; Mon,  8 Apr 2024 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712590476; cv=none; b=RrWbUgc0pAybX4RILU4Y/AcGjK/38qhptc1JkQWa655PNgNzzIu+uYMeffpybZXVx0gP+YujIpGJ6ZF1JeTFKASxU4u7GjUyZo6ZRNcXOIoMnyD0zCmUeHAoSWwJ3p4Qw6JDr1DEeudKjHgiCswdQCmM1+U31Q6v4MMcG/yIy6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712590476; c=relaxed/simple;
	bh=9gG6kLj13pyx+LPtCk6oUhACKFOcXB09CxcHkFop2aM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jlAsWhKZJGQVmEuqdH/VvlkNyrQuvwFl8yD6r48p5ipnOUAr8V7SUjV2vFJk2N2dQkI6VbU6X1JvOVDTgGumsUVaagOz6ippz8wlZ0ewO9axQHsaCbNfAqqAdA2lty7lw0Nke+VvXSDfik7BXO466fXLnakAYSmU7yLPbAbRBfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ipj/PZ3w; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ipj/PZ3w"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438ENqxa028719;
	Mon, 8 Apr 2024 15:34:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=XYRkQ3kyoUOhCM8Tp/MmT2rsc5+r6mX0RGkbovirnJM=;
 b=Ipj/PZ3wmwJrWQjAfKtM/f2TdtspacLdWGg/Uog1Lw6CTv8gHLLvS6pd9rwXc0LCKKy4
 O6Z6ON2CP45QDW7RurK6RBKNpUa18zArDSr+VPo8iQlOMgEXR+Fv/jTDAeYsaiU91xVw
 E/yFDzsqcKAhYD28b1rvrsRS3oe8PavcU7MYrwwiAfuAMUEiYvwnWhTs7WDRB6gNU8Jm
 EPfectdpVvF+uLzx5QGJC5QOs3pFWwfEWVaacfngu5r41iWQ3Rhe+jpS4byeQZjc9VYb
 4QzVB33Bi7ndR73JNsA2E7TbiuqoeL8ABsEejxYcR8Q/QRuHEkEheCul37+vR5PV65bD Cg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxedk1rm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:17 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438FJ1Z0032329;
	Mon, 8 Apr 2024 15:34:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu60dc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:16 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438FUlUw008521;
	Mon, 8 Apr 2024 15:34:16 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-195-157.vpn.oracle.com [10.39.195.157])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xavu60d7m-3;
	Mon, 08 Apr 2024 15:34:16 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v3 2/6] virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
Date: Mon,  8 Apr 2024 11:34:04 -0400
Message-Id: <20240408153408.3527586-3-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: hlv1tKxKCk15TNEl6kaAm9pZasse5Mfr
X-Proofpoint-ORIG-GUID: hlv1tKxKCk15TNEl6kaAm9pZasse5Mfr

Add VIRTIO_F_IN_ORDER feature support in virtqueue_split_pop and
virtqueue_packed_pop.

VirtQueueElements popped from the available/descritpor ring are added to
the VirtQueue's used_elems array in-order and in the same fashion as
they would be added the used and descriptor rings, respectively.

This will allow us to keep track of the current order, what elements
have been written, as well as an element's essential data after being
processed.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index fb6b4ccd83..3ad58100b2 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1497,7 +1497,7 @@ static void *virtqueue_alloc_element(size_t sz, unsigned out_num, unsigned in_nu
 
 static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
 {
-    unsigned int i, head, max;
+    unsigned int i, j, head, max;
     VRingMemoryRegionCaches *caches;
     MemoryRegionCache indirect_desc_cache;
     MemoryRegionCache *desc_cache;
@@ -1530,6 +1530,8 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
         goto done;
     }
 
+    j = vq->last_avail_idx;
+
     if (!virtqueue_get_head(vq, vq->last_avail_idx++, &head)) {
         goto done;
     }
@@ -1621,6 +1623,12 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
         elem->in_sg[i] = iov[out_num + i];
     }
 
+    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
+        vq->used_elems[j].index = elem->index;
+        vq->used_elems[j].len = elem->len;
+        vq->used_elems[j].ndescs = elem->ndescs;
+    }
+
     vq->inuse++;
 
     trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
@@ -1749,6 +1757,13 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
 
     elem->index = id;
     elem->ndescs = (desc_cache == &indirect_desc_cache) ? 1 : elem_entries;
+
+    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
+        vq->used_elems[vq->last_avail_idx].index = elem->index;
+        vq->used_elems[vq->last_avail_idx].len = elem->len;
+        vq->used_elems[vq->last_avail_idx].ndescs = elem->ndescs;
+    }
+
     vq->last_avail_idx += elem->ndescs;
     vq->inuse += elem->ndescs;
 
-- 
2.39.3

