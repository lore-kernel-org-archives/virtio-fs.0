Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1C1411D0
	for <virtio-fs@lists.linux.dev>; Mon,  8 Apr 2024 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712590485; cv=none; b=fPUbPH9IfnpXBcAHhVQdKQvUIXJ7ZQAfjiSeVqqIE3kgxdQOv8R7qfLZj8EevNL6PURMXqnCi0xuU2FARzwkeiZzh084EHFf1iN3YBxaUBdZ8j2jUczRJuSA0lI5kz7NiTkne16RW1xIGCA/pL6jCTcQTBWmBn/v+9i5a+T3PmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712590485; c=relaxed/simple;
	bh=IQ0KsBpOGyxGpLMn9MLdvK6vno77/vO1iSzV3Sdxk9E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XjhzGGXAjRMcbI1mZdD1BDSHoYXsQD8C14+Pea+ZmEpl+J/BVNlcxjZpGu3OyC2SRcno0p8lLvL1I7p6hcexKpWit0kdyaJwA2sYF4ecubGa8/CK1SDPHtFv5bz994ZuAmQE2u0R+UO84ewxSOtEiIsvve1OL+vgEPZF5gAYcEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V7Cd6iXd; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V7Cd6iXd"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438ENwrY014631;
	Mon, 8 Apr 2024 15:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=2anHYm4YrsDyprFeqE6snborl7f1ZCSTS1qZP4wR4Kw=;
 b=V7Cd6iXdKoevlIWAsrOTlm6QsOF0KcPaIa4J2MllgBhrbvpwSqUMzOsF+0r1gEwZiVk7
 PfL8B3MO+MlUDF89oWNBteZ4nPBultVH4Tnu3X3AHQtO4vUf2Dh2hBh6Ly/AI05Lvx0E
 iZiQQuiCnlx3TJ+TT9zcRB5v8GIqps2+drIxayVih3Q/rxUj1mZ7TtEvq48YMI0QQRJb
 GeFFwlOgxf97lPV433CLhlIhbA48DL96MUkCZXO3HlIe97ylPOr41Vx3uG+D3cTsba0X
 LVf+8NrPfj6H9N2B1k1/0t+xfhiFO3Z16ymcVgfkdLejoh9E4uWaDh91Cps7IlVZhk85 Lg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xavtf31mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:22 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438FRrQ1032535;
	Mon, 8 Apr 2024 15:34:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu60dfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:21 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438FUlV2008521;
	Mon, 8 Apr 2024 15:34:20 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-195-157.vpn.oracle.com [10.39.195.157])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xavu60d7m-5;
	Mon, 08 Apr 2024 15:34:20 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v3 4/6] virtio: virtqueue_ordered_flush - VIRTIO_F_IN_ORDER support
Date: Mon,  8 Apr 2024 11:34:06 -0400
Message-Id: <20240408153408.3527586-5-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: q_EBODycqLhvjW8DxcBl_Tsaji4N8m7t
X-Proofpoint-ORIG-GUID: q_EBODycqLhvjW8DxcBl_Tsaji4N8m7t

Add VIRTIO_F_IN_ORDER feature support for virtqueue_flush operations.

The goal of the virtqueue_flush operation when the VIRTIO_F_IN_ORDER
feature has been negotiated is to write elements to the used/descriptor
ring in-order and then update used_idx.

The function iterates through the VirtQueueElement used_elems array
in-order starting at vq->used_idx. If the element is valid (filled), the
element is written to the used/descriptor ring. This process continues
until we find an invalid (not filled) element.

If any elements were written, the used_idx is updated.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 75 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 0730f26f74..13451d0cae 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -997,6 +997,77 @@ static void virtqueue_packed_flush(VirtQueue *vq, unsigned int count)
     }
 }
 
+static void virtqueue_ordered_flush(VirtQueue *vq)
+{
+    unsigned int i = vq->used_idx;
+    unsigned int ndescs = 0;
+    uint16_t old = vq->used_idx;
+    bool packed;
+    VRingUsedElem uelem;
+
+    packed = virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED);
+
+    if (packed) {
+        if (unlikely(!vq->vring.desc)) {
+            return;
+        }
+    } else if (unlikely(!vq->vring.used)) {
+        return;
+    }
+
+    /* First expected in-order element isn't ready, nothing to do */
+    if (!vq->used_elems[i].filled) {
+        return;
+    }
+
+    /* Write first expected in-order element to used ring (split VQs) */
+    if (!packed) {
+        uelem.id = vq->used_elems[i].index;
+        uelem.len = vq->used_elems[i].len;
+        vring_used_write(vq, &uelem, i);
+    }
+
+    ndescs += vq->used_elems[i].ndescs;
+    i += ndescs;
+    if (i >= vq->vring.num) {
+        i -= vq->vring.num;
+    }
+
+    /* Search for more filled elements in-order */
+    while (vq->used_elems[i].filled) {
+        if (packed) {
+            virtqueue_packed_fill_desc(vq, &vq->used_elems[i], ndescs, false);
+        } else {
+            uelem.id = vq->used_elems[i].index;
+            uelem.len = vq->used_elems[i].len;
+            vring_used_write(vq, &uelem, i);
+        }
+
+        vq->used_elems[i].filled = false;
+        ndescs += vq->used_elems[i].ndescs;
+        i += ndescs;
+        if (i >= vq->vring.num) {
+            i -= vq->vring.num;
+        }
+    }
+
+    if (packed) {
+        virtqueue_packed_fill_desc(vq, &vq->used_elems[vq->used_idx], 0, true);
+        vq->used_idx += ndescs;
+        if (vq->used_idx >= vq->vring.num) {
+            vq->used_idx -= vq->vring.num;
+            vq->used_wrap_counter ^= 1;
+            vq->signalled_used_valid = false;
+        }
+    } else {
+        vring_used_idx_set(vq, i);
+        if (unlikely((int16_t)(i - vq->signalled_used) < (uint16_t)(i - old))) {
+            vq->signalled_used_valid = false;
+        }
+    }
+    vq->inuse -= ndescs;
+}
+
 void virtqueue_flush(VirtQueue *vq, unsigned int count)
 {
     if (virtio_device_disabled(vq->vdev)) {
@@ -1004,7 +1075,9 @@ void virtqueue_flush(VirtQueue *vq, unsigned int count)
         return;
     }
 
-    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
+    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
+        virtqueue_ordered_flush(vq);
+    } else if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
         virtqueue_packed_flush(vq, count);
     } else {
         virtqueue_split_flush(vq, count);
-- 
2.39.3

