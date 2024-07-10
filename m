Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38A21922D6
	for <virtio-fs@lists.linux.dev>; Wed, 10 Jul 2024 12:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720616146; cv=none; b=QgU9x8614YNvf6Un74iXUoMe1zVqvkY1qs/9+7t9GtLner1F/+dRh5+ba1KVNxwdchmwygdX3FkBVXBQQ3kaq1jq4c4Z/xONCU4D1tmcDtfPEPjidbd4SA9+j4TZ49NDOKcLkqc4U2JrPjR87ibhZ4cyre7MVe6exQ1YJvx4snU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720616146; c=relaxed/simple;
	bh=R4ZIRB/KdPhRbiPJLfjo8Yi/3jwc5rTSFwtdXckllGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m7Tw/trFzZ+5hvGrq3d6JhsVFL+POC09Ok8Z6niFsGwBGw0w+0X0up12p4LQFlWzznIxDQxEu5Qeu1HecwlwSDccnC25r5kL+EOfSS3Br+BXN6Cul22yofLEwqZKwXz+pZFiWCj3CZ3K1TCbLIAS7GrM8A0vJfMr3WhlRlquYHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wbml9bzT; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wbml9bzT"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A7fU0x003976;
	Wed, 10 Jul 2024 12:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=4B0ZLeT+O0j62jwB+bn8Y9mfVjebkJnVE/Qt647hnFs=; b=
	Wbml9bzTbAlY8KP27pR1u+aCLDuOg9sfnSv8cy5IxcKBzMB5nyMhp0v4ED6UbkKA
	+WXe/k4TsHLi4HLQCV5wwpxseK3uYIkwMw/sr3TJXPsCxYEvNv5xDirZ+dlK3GS4
	C+A8xrYTfKel479QzqOCh9y60lOx34htoa3SiyA2EnaZt51xUO19i+e1/whgbrb5
	7dJYgRPJJ+0lfNPi+Ji5lHd+3Oh+2fZEKLaDYdubx2VgA2wZbiv/QDmToiqlOy+g
	MOqsUe2vDIZZMzzW6vpDM0SP0BiUlaC08AZrFxCdVclN6R3Q+iaGWcXNns9hfFvj
	9IQZuwhwwfv1zo97CIpRSA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406xfsq6d7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 12:55:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46ABUSpG007882;
	Wed, 10 Jul 2024 12:55:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407tu4r0g1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 12:55:28 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46ACtQtU015847;
	Wed, 10 Jul 2024 12:55:28 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-182-124.vpn.oracle.com [10.65.182.124])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407tu4r0e4-3;
	Wed, 10 Jul 2024 12:55:28 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v4 2/6] virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
Date: Wed, 10 Jul 2024 08:55:15 -0400
Message-ID: <20240710125522.4168043-3-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240710125522.4168043-1-jonah.palmer@oracle.com>
References: <20240710125522.4168043-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_08,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407100089
X-Proofpoint-ORIG-GUID: HGtkVSppUvPiLra5Ak29BJcRZXm34QMi
X-Proofpoint-GUID: HGtkVSppUvPiLra5Ak29BJcRZXm34QMi

Add VIRTIO_F_IN_ORDER feature support in virtqueue_split_pop and
virtqueue_packed_pop.

VirtQueueElements popped from the available/descritpor ring are added to
the VirtQueue's used_elems array in-order and in the same fashion as
they would be added the used and descriptor rings, respectively.

This will allow us to keep track of the current order, what elements
have been written, as well as an element's essential data after being
processed.

Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
last_avail_idx can grow well beyond vring.num, so for this reason we
need to keep the index bound between 0 and vring.num-1 for the split VQ
case.

 hw/virtio/virtio.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 583a224163..98eb601b09 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1505,7 +1505,7 @@ static void *virtqueue_alloc_element(size_t sz, unsigned out_num, unsigned in_nu
 
 static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
 {
-    unsigned int i, head, max;
+    unsigned int i, head, max, idx;
     VRingMemoryRegionCaches *caches;
     MemoryRegionCache indirect_desc_cache;
     MemoryRegionCache *desc_cache;
@@ -1629,6 +1629,13 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
         elem->in_sg[i] = iov[out_num + i];
     }
 
+    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
+        idx = (vq->last_avail_idx - 1) % vq->vring.num;
+        vq->used_elems[idx].index = elem->index;
+        vq->used_elems[idx].len = elem->len;
+        vq->used_elems[idx].ndescs = elem->ndescs;
+    }
+
     vq->inuse++;
 
     trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
@@ -1762,6 +1769,13 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
 
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
2.43.5

