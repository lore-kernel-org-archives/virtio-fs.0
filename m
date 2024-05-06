Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB540154C05
	for <virtio-fs@lists.linux.dev>; Mon,  6 May 2024 15:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715007890; cv=none; b=qfQqqSYp3TyT7IQH3uYfMCb8ac4YPN5GjHMxpxZDOlcGpaUICYb0QiO3T8HfggKHOCQTZ+AKAS4pxVfqwp0OHsCf+4EOOwu/exX12KLWCvJt2rN0gKjND6yPwqVF6ahNLURYLfkJYool6nG4FIEdev0I/EIeaaRo+KTe1od/yUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715007890; c=relaxed/simple;
	bh=MpZN0X32NDxLUPV5prBK0xcdCMtOL31MkktFkA7fof4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ofKJJbHtSiL1k5VCsumErOhaMVH2B203alEz0WZXkk+HEOHKrFYIUH9XVObx6kZwvPdscr0l+HGOsGoECLPF/w9O5/WdWjDGdhhEWuHRWqBzjl0DxoXyWt0BPz98QlmEo5B2CDgztuiMsEvLPpElPpzI5rnOIf3F0FVGG6jYGko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LZVJbChr; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LZVJbChr"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446AnBn0031893;
	Mon, 6 May 2024 15:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=LWjbGscupnTTl7SaGvk7rGF8ER7++IAlDB75F8Famo4=;
 b=LZVJbChrjpO4DHGGw1jsOvM9Qylld3kjL5lTdqq3snlWiFmVh3tJ8gl+hYe5k0GW1rjJ
 K4hKQr6utXzl+G/A9OiVziOlwvsxRfWdg05dhFdhZgprfPexXV6g0a3fb7Rc7rX3LQdi
 xcmTEYLaL2+tcPb4I/BM7IsjPQMJ2bKxM6/DwMwmRz6L+FKrCgyohVCQjE5iyXlapoWv
 VlS19qrk/6LzTEmsIIwTwj59cXDy5b+lpM9Zg+PFD1eMyH0zxl5E1pytTdj4EGATy34y
 RQQ60hGR3WUqZ6VXEDntHxjtylWxLAVPU8odrSu8tnUZlP2/8F4o1tU9/OyTs3moyQts dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbt52ty8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 15:04:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446DmJWv006938;
	Mon, 6 May 2024 15:04:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf6rwhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 15:04:41 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446F4ZlL002521;
	Mon, 6 May 2024 15:04:41 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-221-117.vpn.oracle.com [10.39.221.117])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf6rw8e-3;
	Mon, 06 May 2024 15:04:40 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH 2/6] virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
Date: Mon,  6 May 2024 11:04:24 -0400
Message-Id: <20240506150428.1203387-3-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240506150428.1203387-1-jonah.palmer@oracle.com>
References: <20240506150428.1203387-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_09,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060104
X-Proofpoint-GUID: oYqQiqa3vHMRANC54IwcfVPKxMxhhijg
X-Proofpoint-ORIG-GUID: oYqQiqa3vHMRANC54IwcfVPKxMxhhijg

Add VIRTIO_F_IN_ORDER feature support in virtqueue_split_pop and
virtqueue_packed_pop.

VirtQueueElements popped from the available/descritpor ring are added to
the VirtQueue's used_elems array in-order and in the same fashion as
they would be added the used and descriptor rings, respectively.

This will allow us to keep track of the current order, what elements
have been written, as well as an element's essential data after being
processed.

Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 893a072c9d..e6eb1bb453 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1506,7 +1506,7 @@ static void *virtqueue_alloc_element(size_t sz, unsigned out_num, unsigned in_nu
 
 static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
 {
-    unsigned int i, head, max;
+    unsigned int i, j, head, max;
     VRingMemoryRegionCaches *caches;
     MemoryRegionCache indirect_desc_cache;
     MemoryRegionCache *desc_cache;
@@ -1539,6 +1539,8 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
         goto done;
     }
 
+    j = vq->last_avail_idx;
+
     if (!virtqueue_get_head(vq, vq->last_avail_idx++, &head)) {
         goto done;
     }
@@ -1630,6 +1632,12 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
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
@@ -1758,6 +1766,13 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
 
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

