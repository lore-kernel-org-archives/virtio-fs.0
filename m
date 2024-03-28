Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274321386A5
	for <virtio-fs@lists.linux.dev>; Thu, 28 Mar 2024 16:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711642937; cv=none; b=AG5SxP/W6EXO76fgUeHrNhpCXEhJuhxYLdoChV0wz8OwnDnTJF0rkXHLMlMIpIy/akZpgst2VCx9WNQgsNA7gkyQlUmDiLPK1A+QGNvFBojY1ngyRdNJ5JuH/Qmv2u2znjYjhKHWNy+nQD2Qy0vtz65DQKiVlbfcZrmQE2uLbSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711642937; c=relaxed/simple;
	bh=vhS0Vtuk9sdFsOF92RNBSc14QF/KUa9JxHZc/5+pvH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BsYVkefd035hjK+PecDZuLxGB66OqDL1HH+nKJQFuLGTDxv0A4ePet+WspC4HDRLvbuvcfhMMKHtmQ2WmL34PYwoH705OoHFVDrJf3a00n5Ifdd3CaWHeTaiKe4U5psQd0KbMwGXMX8FsuRQN4UUlfaF+RvRdd2d404I34iU95A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RKgVt1mL; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RKgVt1mL"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42SFOwnp009851;
	Thu, 28 Mar 2024 16:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=Oy5nFN0etsJJPGxpWCIMafxrPnNst3dVL5vKPOpE5qg=;
 b=RKgVt1mLZ4UZumfv/UHz0fd+O5U+jbduo8efFtGExWI3VQz1qU0eTdPK9Jkyncsfg9hi
 GYAmG1/d7gJamSdl1W36GkgGqyUAMW9EcoV8ubRP5wSwG4tt4t8YrXSqXdu/aJPWEva+
 rPJ5AgJ0HLg627bcDIqP/yFqLO+KDuBuU4Fgtvb4vmCD/80xmFJIn2rBuXnS9tZWxo8+
 fZd7ZIf2sJChOn10M46GsQRlMz+fmVtduA7jum/uGF/ZXpu3SguWMJimpR4/HXR4zR60
 1ryzefN5xTfFmg05sMK5tdoQQPZsKX5hqNa37Rg6FfnQL54vSc+1JOqjC0a1F4WW1ua6 wg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2f6h8w75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 16:22:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42SG2jwR015085;
	Thu, 28 Mar 2024 16:22:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhgfgj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 16:22:09 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42SGM5a1010492;
	Thu, 28 Mar 2024 16:22:09 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-220-183.vpn.oracle.com [10.39.220.183])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3x1nhgfgcy-4;
	Thu, 28 Mar 2024 16:22:09 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v2 3/5] virtio: In-order support for packed VQs
Date: Thu, 28 Mar 2024 12:22:01 -0400
Message-Id: <20240328162203.3775114-4-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240328162203.3775114-1-jonah.palmer@oracle.com>
References: <20240328162203.3775114-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-28_15,2024-03-28_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403280111
X-Proofpoint-GUID: k7Vubl2-zRR0a3m-VmYP5KX2AJ3YbW-E
X-Proofpoint-ORIG-GUID: k7Vubl2-zRR0a3m-VmYP5KX2AJ3YbW-E

Implements VIRTIO_F_IN_ORDER feature support for virtio devices using
the packed virtqueue layout.

For a virtio device that has negotiated the VIRTIO_F_IN_ORDER feature
whose virtqueues use a packed virtqueue layout, it's essential that used
VirtQueueElements are written to the descriptor ring in-order.

In the packed virtqueue case, since we already write to the virtqueue's
used_elems array at the start of virtqueue_fill, we don't need to call
virtqueue_packed_fill. Furthermore, due to change in behavior of the
used_elems array and not knowing how many unused in-order elements
exist, separate logic is required for the flushing operation of packed
virtqueues.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 50 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 19d3d43816..dc2eabd18b 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -960,7 +960,8 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueElement *elem,
         vq->used_elems[seq_idx].out_num = elem->out_num;
     }
 
-    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
+    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED) &&
+        !virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
         virtqueue_packed_fill(vq, elem, len, idx);
     } else {
         virtqueue_split_fill(vq, elem, len, idx);
@@ -997,18 +998,53 @@ static void virtqueue_split_flush(VirtQueue *vq, unsigned int count)
 
 static void virtqueue_packed_flush(VirtQueue *vq, unsigned int count)
 {
-    unsigned int i, ndescs = 0;
+    unsigned int i, j, uelem_idx, ndescs = 0;
 
     if (unlikely(!vq->vring.desc)) {
         return;
     }
 
-    for (i = 1; i < count; i++) {
-        virtqueue_packed_fill_desc(vq, &vq->used_elems[i], i, false);
-        ndescs += vq->used_elems[i].ndescs;
+    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
+        /* First expected element is used, nothing to do */
+        if (vq->used_elems[vq->used_idx].in_num +
+            vq->used_elems[vq->used_idx].out_num <= 0) {
+            return;
+        }
+
+        j = vq->used_idx;
+
+        for (i = j + 1; ; i++) {
+            uelem_idx = i % vq->vring.num;
+
+            /* Stop if element has been used */
+            if (vq->used_elems[uelem_idx].in_num +
+                vq->used_elems[uelem_idx].out_num <= 0) {
+                break;
+            }
+
+            virtqueue_packed_fill_desc(vq, &vq->used_elems[uelem_idx],
+                                       uelem_idx, false);
+            ndescs += vq->used_elems[uelem_idx].ndescs;
+
+            /* Mark this element as used */
+            vq->used_elems[uelem_idx].in_num = 0;
+            vq->used_elems[uelem_idx].out_num = 0;
+        }
+
+        /* Mark first expected element as used */
+        vq->used_elems[vq->used_idx].in_num = 0;
+        vq->used_elems[vq->used_idx].out_num = 0;
+    } else {
+        j = 0;
+
+        for (i = 1; i < count; i++) {
+            virtqueue_packed_fill_desc(vq, &vq->used_elems[i], i, false);
+            ndescs += vq->used_elems[i].ndescs;
+        }
     }
-    virtqueue_packed_fill_desc(vq, &vq->used_elems[0], 0, true);
-    ndescs += vq->used_elems[0].ndescs;
+
+    virtqueue_packed_fill_desc(vq, &vq->used_elems[j], j, true);
+    ndescs += vq->used_elems[j].ndescs;
 
     vq->inuse -= ndescs;
     vq->used_idx += ndescs;
-- 
2.39.3

