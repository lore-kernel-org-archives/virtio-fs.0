Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04811192486
	for <virtio-fs@lists.linux.dev>; Wed, 10 Jul 2024 12:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720616149; cv=none; b=M1ut6LBwQrC/RagCo8n6l9TtGWEKiNh+ErEJXdd4VwRI7wVzK4HFgPc9kSUfNECqQxnkmlZZq4arTuudAG7nFrMJr+u9DsnukvevpbkG83t+UxYkJDdB02G4WJIJm5cZgcwDdCJTfP6Sv709jQNuOa0HXl/pRRjDgPhkyOJN72k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720616149; c=relaxed/simple;
	bh=6IY9uVi7wCTvjBD32A7Wg49wt5hogi+XqQn/yLumENQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZYlwiXL5pBZuWVjT6pv5cqmBB8tP2QnziG3tmFjf332jYkwZl/qcVE9T8j/kCuTRKEP5Nsgkd0jQ6dSpT1t3HktYz3md2pm03hWO/+UaCkqOWdBC16uNd5ED8TGaWpprpYuxNc1Qp4gnpTxmygf0hxQueXNY+EKycIX0IcFd0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Keq/JpI4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Keq/JpI4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A7fYYf019284;
	Wed, 10 Jul 2024 12:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=f
	axYFHwJb2yaYJiqFkSiCXUVLCZmiqpkmfPU+Sb8MCw=; b=Keq/JpI4f+6Yl3KVv
	wjgAXdePrBG6JFPgyy+KVZIomvuZIRk4ceH3UDFrsHRKuNDa7zJdpJRWpRgZ2WBM
	Fligfpd0Gan0Euu7kkHn2czn4ysZE5GBC8mB0A1sbwY7Mm3XvGKAAQBPrTNf3Aco
	2JV3pQVkYR+gvkkLaa3MTPVSQEJcnGhSB1LbSytRINbIruuJJi4PdjSiO3kdkIdT
	m8j3I5wK2U5aTjkdFBnc5HYj8rGw5ILWAZ2JjHS5pbCcSxoxamOaSt4/2jY1bZtC
	hZNXxK+7x6/NpekxyMsOH6eTLrr6QKmU1Sb4oEcd/T8yd/8dtVs632pNXsPuqgz0
	hh34Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wky77u7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 12:55:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46ABWOeP007459;
	Wed, 10 Jul 2024 12:55:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407tu4r0h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 12:55:30 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46ACtQtY015847;
	Wed, 10 Jul 2024 12:55:30 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-182-124.vpn.oracle.com [10.65.182.124])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407tu4r0e4-5;
	Wed, 10 Jul 2024 12:55:30 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v4 4/6] virtio: virtqueue_ordered_flush - VIRTIO_F_IN_ORDER support
Date: Wed, 10 Jul 2024 08:55:17 -0400
Message-ID: <20240710125522.4168043-5-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240710125522.4168043-1-jonah.palmer@oracle.com>
References: <20240710125522.4168043-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_08,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407100089
X-Proofpoint-ORIG-GUID: XQGfg-myqkeHFrq-n_D9AXFwd4EOlzh5
X-Proofpoint-GUID: XQGfg-myqkeHFrq-n_D9AXFwd4EOlzh5

Add VIRTIO_F_IN_ORDER feature support for the virtqueue_flush operation.

The goal of the virtqueue_ordered_flush operation when the
VIRTIO_F_IN_ORDER feature has been negotiated is to write elements to
the used/descriptor ring in-order and then update used_idx.

The function iterates through the VirtQueueElement used_elems array
in-order starting at vq->used_idx. If the element is valid (filled), the
element is written to the used/descriptor ring. This process continues
until we find an invalid (not filled) element.

For packed VQs, the first entry (at vq->used_idx) is written to the
descriptor ring last so the guest doesn't see any invalid descriptors.

If any elements were written, the used_idx is updated.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
Several fixes here for the split VQ case:
- Ensure all previous write operations to buffers are completed before
  updating the used_idx (via smp_wmb()).

- used_elems index 'i' should be incremented by the number of descriptors
  in the current element we just processed, not by the running total of
  descriptors already seen. This would've caused batched operations to
  miss ordered elements when looping through the used_elems array.

- Do not keep the VQ's used_idx bound between 0 and vring.num-1 when
  setting it via vring_used_idx_set().

  While the packed VQ case naturally keeps used_idx bound between 0 and
  vring.num-1, the split VQ case cannot. This is because used_idx is
  used to compare the current event index with the new and old used
  indices to decide if a notification is necessary (see
  virtio_split_should_notify()). This comparison expects used_idx to be
  between 0 and 65535, not 0 and vring.num-1.

 hw/virtio/virtio.c | 70 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 0000a7b41c..b419d8d6e7 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1023,6 +1023,72 @@ static void virtqueue_packed_flush(VirtQueue *vq, unsigned int count)
     }
 }
 
+static void virtqueue_ordered_flush(VirtQueue *vq)
+{
+    unsigned int i = vq->used_idx % vq->vring.num;
+    unsigned int ndescs = 0;
+    uint16_t old = vq->used_idx;
+    uint16_t new;
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
+    if (!vq->used_elems[i].in_order_filled) {
+        return;
+    }
+
+    /* Search for filled elements in-order */
+    while (vq->used_elems[i].in_order_filled) {
+        /*
+         * First entry for packed VQs is written last so the guest
+         * doesn't see invalid descriptors.
+         */
+        if (packed && i != vq->used_idx) {
+            virtqueue_packed_fill_desc(vq, &vq->used_elems[i], ndescs, false);
+        } else if (!packed) {
+            uelem.id = vq->used_elems[i].index;
+            uelem.len = vq->used_elems[i].len;
+            vring_used_write(vq, &uelem, i);
+        }
+
+        vq->used_elems[i].in_order_filled = false;
+        ndescs += vq->used_elems[i].ndescs;
+        i += vq->used_elems[i].ndescs;
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
+        /* Make sure buffer is written before we update index. */
+        smp_wmb();
+        new = old + ndescs;
+        vring_used_idx_set(vq, new);
+        if (unlikely((int16_t)(new - vq->signalled_used) < (uint16_t)(new - old))) {
+            vq->signalled_used_valid = false;
+        }
+    }
+    vq->inuse -= ndescs;
+}
+
 void virtqueue_flush(VirtQueue *vq, unsigned int count)
 {
     if (virtio_device_disabled(vq->vdev)) {
@@ -1030,7 +1096,9 @@ void virtqueue_flush(VirtQueue *vq, unsigned int count)
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
2.43.5

