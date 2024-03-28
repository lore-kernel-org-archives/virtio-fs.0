Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5060D1384AD
	for <virtio-fs@lists.linux.dev>; Thu, 28 Mar 2024 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711642936; cv=none; b=N7fQwAMor5HJfQCkxk8kFwF+kPe7hdUVe6pO7XLL4VoMl6m2l1OYkS+rJwD12/37pn2wS2mcZrSFGnXhNvDMfqvEGaDeb89KizAMsgin2gU1KjtheS/LZFIjjVuw+l7aX5YLK2Q/g0fGwRmqJj9yIyYagTJfn0VEhneKKU7V1rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711642936; c=relaxed/simple;
	bh=vXebcZ456eZEJIgH5YMW3cgbO+Rs5t4RzF4si9Bq8u4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K9d10TWyQPGpnVVZ8sahaMw4G5JXmSLwnFDcuQ7+yEULCsS1eTtXRRkemW4Se2GvOCz8uk0U+PZdZII2h9F+/e7vkAMi/+CBZ753XKoqXV51+ti+esrLJDndgrgqplonwavwZVXBsEBk2iuOBJ+T3+PEeWZjtIpyalE3nxKPemM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ku/SXYP5; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ku/SXYP5"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42SFOrIh015505;
	Thu, 28 Mar 2024 16:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=Lw0nJnb3HAsgTV+5C1hLep7WC/u74bJmes3myuB1IwE=;
 b=ku/SXYP5LuBlMU1SvrYjuu54BzfR/zXLM7mLFof3TL3rlTM2hl59YukVo5MRoe2o1pXZ
 JTPeawBmOG9HblLSFMx0DOvVe+4rNn0i88sJTlP7uppnxPRpRsVbW6YN5lQUz1dLF5B8
 q3K3e+HQCnwbnC6ZroVZB7at/9oCZoKY1ubgvHko5DhCCSGRr2EPLt3klw4NVQkByb8N
 36H7rcn3JI5vwWQvOIF7oyqkX5TwlvCPRpns809M7whz3YCHIk99HQ5COxWkV6MEVFVj
 6i1D6f7rGwiKDz2YpemK3VsXnXRw4MvRDXg+ibbZJDaMKPgBj1X69/LARFyCaDk+5PnC /Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1nv4a2pn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 16:22:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42SEwKhr015043;
	Thu, 28 Mar 2024 16:22:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhgfggj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 16:22:08 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42SGM5Zx010492;
	Thu, 28 Mar 2024 16:22:08 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-220-183.vpn.oracle.com [10.39.220.183])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3x1nhgfgcy-3;
	Thu, 28 Mar 2024 16:22:08 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v2 2/5] virtio: In-order support for split VQs
Date: Thu, 28 Mar 2024 12:22:00 -0400
Message-Id: <20240328162203.3775114-3-jonah.palmer@oracle.com>
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
X-Proofpoint-ORIG-GUID: nppdPIFbTzmLh9H_ehYtfI2vc6hghKlk
X-Proofpoint-GUID: nppdPIFbTzmLh9H_ehYtfI2vc6hghKlk

Implements VIRTIO_F_IN_ORDER feature support for virtio devices using
the split virtqueue layout.

For a virtio device that has negotiated the VIRTIO_F_IN_ORDER feature
whose virtqueues use a split virtqueue layout, it's essential that
used VirtQueueElements are written to the used ring in-order.

For devices that use this in-order feature, its VirtQueue's used_elems
array is used to hold processed VirtQueueElements until they can be
presented to the driver in-order.

In the split virtqueue case, we check to see if the element was the next
expected element to be written to the used ring. If it's not, nothing
get written to the used ring and we're done. If it is, the element is
written to the used ring and then we check to see if the next expected
element continues the order. This process is repeated until we're unable
to continue the order.

If no elements were written to the used ring, no update to the used
ring's index is needed.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 50 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 069d96df99..19d3d43816 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -856,16 +856,38 @@ static void virtqueue_split_fill(VirtQueue *vq, const VirtQueueElement *elem,
                     unsigned int len, unsigned int idx)
 {
     VRingUsedElem uelem;
+    uint16_t uelem_idx;
 
     if (unlikely(!vq->vring.used)) {
         return;
     }
 
-    idx = (idx + vq->used_idx) % vq->vring.num;
+    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
+        /* Write element(s) to used ring if they're in-order */
+        while (true) {
+            uelem_idx = vq->used_seq_idx % vq->vring.num;
 
-    uelem.id = elem->index;
-    uelem.len = len;
-    vring_used_write(vq, &uelem, idx);
+            /* Stop if element has been used */
+            if (vq->used_elems[uelem_idx].in_num +
+                vq->used_elems[uelem_idx].out_num <= 0) {
+                break;
+            }
+            uelem.id = vq->used_elems[uelem_idx].index;
+            uelem.len = vq->used_elems[uelem_idx].len;
+            vring_used_write(vq, &uelem, uelem_idx);
+
+            /* Mark this element as used */
+            vq->used_elems[uelem_idx].in_num = 0;
+            vq->used_elems[uelem_idx].out_num = 0;
+            vq->used_seq_idx++;
+        }
+    } else {
+        idx = (idx + vq->used_idx) % vq->vring.num;
+
+        uelem.id = elem->index;
+        uelem.len = len;
+        vring_used_write(vq, &uelem, idx);
+    }
 }
 
 static void virtqueue_packed_fill(VirtQueue *vq, const VirtQueueElement *elem,
@@ -918,6 +940,8 @@ static void virtqueue_packed_fill_desc(VirtQueue *vq,
 void virtqueue_fill(VirtQueue *vq, const VirtQueueElement *elem,
                     unsigned int len, unsigned int idx)
 {
+    uint16_t seq_idx;
+
     trace_virtqueue_fill(vq, elem, len, idx);
 
     virtqueue_unmap_sg(vq, elem, len);
@@ -926,6 +950,16 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueElement *elem,
         return;
     }
 
+    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
+        seq_idx = elem->seq_idx % vq->vring.num;
+
+        vq->used_elems[seq_idx].index = elem->index;
+        vq->used_elems[seq_idx].len = elem->len;
+        vq->used_elems[seq_idx].ndescs = elem->ndescs;
+        vq->used_elems[seq_idx].in_num = elem->in_num;
+        vq->used_elems[seq_idx].out_num = elem->out_num;
+    }
+
     if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
         virtqueue_packed_fill(vq, elem, len, idx);
     } else {
@@ -944,6 +978,14 @@ static void virtqueue_split_flush(VirtQueue *vq, unsigned int count)
 
     /* Make sure buffer is written before we update index. */
     smp_wmb();
+    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
+        count = (vq->used_seq_idx - vq->used_idx) % vq->vring.num;
+
+        /* No in-order elements were written, nothing to update */
+        if (!count) {
+            return;
+        }
+    }
     trace_virtqueue_flush(vq, count);
     old = vq->used_idx;
     new = old + count;
-- 
2.39.3

