Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7233D126F0A
	for <virtio-fs@lists.linux.dev>; Mon,  8 Apr 2024 15:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712590467; cv=none; b=BdcqJ5jn/Tt8Mb2n2kxhbiMyEkeyQ8CXmwGeJDbbcFkDrrIsnp/ZQSG+FPJfROM1BLkyp/7FZFUTlL96chMAfz0oc6fYfDVsjxRvIWAG1Rpd0aL/y8miOcYZ5XGVa5H1fZJHes0z0LZJrbA4MWvcUsPBb3sFdE/rCbtRm+ei9PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712590467; c=relaxed/simple;
	bh=JChmGN8ypOqg7g2UzrKX8dtHIxWTrNT+lcMhmSY1Qv4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WeF7v4Zz0E6vwpea5liAoj+oiExufFt8biNuZhk7PasJkFEhBljihyxvIcfhvSHuTBBjUROuNnQxY2EKFCeLiCRFIN664ACgTOm7Ce73x3dZ2f824iONpFwwSK4U7pDNJ9Vxoig/UnfcQ3C0sXmw+JEoOwvWoFeB+7kf8v20WNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G0JVYDBX; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G0JVYDBX"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438ENwOe027269;
	Mon, 8 Apr 2024 15:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=hqZDBT6khwb4SZoBPhPhcAKg3Samj7WhUu/ZWIeOnuc=;
 b=G0JVYDBXVFji6IiXFxAFJItTmQLDGP6NV8m63DZbyGtZSU9P6BRivYuc6aAgBz139sqm
 S9chMnq5gs9Um7Lx/vMUQBVc6VnVvsEtABaHhBn2S0xdLOLngpp1W8EuMx1dO+/gAhG2
 ocuNTpRtCG/+JRJ6fpqi4XHy8/rRjDIQgdQa9qdRubkozaVmDLN4lfOsbQbz4CgU+AWx
 a6XPko7jkJqpi18j/gR6wc0k37zSOnKUvCDgyAKzuRIPI/ngbFhjfdIZGXMLxGp+nucG
 THp9t1XHMCniHf6SMgYk2xPyq3z3lJo3KP1gw5Ud5JS6JmHXiV38JGTKPvSrDqul0yi9 2A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaw6431hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438FCQHX032536;
	Mon, 8 Apr 2024 15:34:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu60ddu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:18 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438FUlV0008521;
	Mon, 8 Apr 2024 15:34:18 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-195-157.vpn.oracle.com [10.39.195.157])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xavu60d7m-4;
	Mon, 08 Apr 2024 15:34:18 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v3 3/6] virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER support
Date: Mon,  8 Apr 2024 11:34:05 -0400
Message-Id: <20240408153408.3527586-4-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: hIllOrDlZrhLoe_0OiMojFJuidtOFML1
X-Proofpoint-ORIG-GUID: hIllOrDlZrhLoe_0OiMojFJuidtOFML1

Add VIRTIO_F_IN_ORDER feature support for virtqueue_fill operations.

The goal of the virtqueue_fill operation when the VIRTIO_F_IN_ORDER
feature has been negotiated is to search for this now-used element,
set its length, and mark the element as filled in the VirtQueue's
used_elems array.

By marking the element as filled, it will indicate that this element is
ready to be flushed, so long as the element is in-order.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 3ad58100b2..0730f26f74 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -872,6 +872,28 @@ static void virtqueue_packed_fill(VirtQueue *vq, const VirtQueueElement *elem,
     vq->used_elems[idx].ndescs = elem->ndescs;
 }
 
+static void virtqueue_ordered_fill(VirtQueue *vq, const VirtQueueElement *elem,
+                                   unsigned int len)
+{
+    unsigned int i = vq->used_idx;
+
+    /* Search for element in vq->used_elems */
+    while (i != vq->last_avail_idx) {
+        /* Found element, set length and mark as filled */
+        if (vq->used_elems[i].index == elem->index) {
+            vq->used_elems[i].len = len;
+            vq->used_elems[i].filled = true;
+            break;
+        }
+
+        i += vq->used_elems[i].ndescs;
+
+        if (i >= vq->vring.num) {
+            i -= vq->vring.num;
+        }
+    }
+}
+
 static void virtqueue_packed_fill_desc(VirtQueue *vq,
                                        const VirtQueueElement *elem,
                                        unsigned int idx,
@@ -922,7 +944,9 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueElement *elem,
         return;
     }
 
-    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
+    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
+        virtqueue_ordered_fill(vq, elem, len);
+    } else if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
         virtqueue_packed_fill(vq, elem, len, idx);
     } else {
         virtqueue_split_fill(vq, elem, len, idx);
-- 
2.39.3

