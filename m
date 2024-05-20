Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E59113440A
	for <virtio-fs@lists.linux.dev>; Mon, 20 May 2024 13:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716210067; cv=none; b=IYCnTg3ogHZAyEoRYy5jE6X3t2eOd5fwTnxnV7B4ilISubuQZm8g5C1sADkYfowvJOg9TRI6hKeskkXFLohStrK8je/T8IidHQhcJyc44GSRL2VWzCCEj/m/ejiwlgMjpE24K4tBleph+qRvfq0xkWRadz1HirnpSJaj47mKjIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716210067; c=relaxed/simple;
	bh=k/65O+AXUdnBM9dMbn8lXL8xa9UpPsaaVd7pYFZ+6Mo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OhMI0L54iNjdl9dIG/SBfh7AEY5iHCtZv1BZZnteQO92njctyfDTyjhRwgWXkBXpzpMZMcmHZqtLp/FqWeTPeXsSW++wBynkcUL7wsILO87BoXPQ9R1YCstg6zec0LTISDLB0cggyhtBS5ZKsN9jYC3JAu1f5DY7Hq24O3p21N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FQjYPJgG; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FQjYPJgG"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KCemBg022542;
	Mon, 20 May 2024 13:01:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=uZmWbODzMl7rkotI4E8oqlDfQFUwuxdRub4HNKppZ0A=;
 b=FQjYPJgGy1D/geafNMQLKkNqu8H2uTNdLgmQemv65PIOMKWiXSuiydRCke4ipcFGna5g
 IUctO5xMRWOhixbaN1mrMc5Qs8W640D7T8ZrRaPlvio9eiddMJq6vRpN4ivbUtn3sHLY
 wi2sP4ltlndUuND6UXF/rhU2nbc6uS4mWrZdbtgaF1ZnHgTK1vWVUizbnX7vmLsYTgh1
 KJj+wA61osPcpC7t+HATtnuOKbevzidVEgHhKLJG9acXT1Su/72nrymDwweYKTwBEeDS
 6TH00tGcmKGdExbljdl7SY1zFMKKMXrwpBsDjBish5suoXuiivg5HJ1yprfidLzMSHFh PQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6k8d2jb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 13:01:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44KCeaft005024;
	Mon, 20 May 2024 13:01:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js6bs2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 13:01:01 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44KD0qPd028778;
	Mon, 20 May 2024 13:01:00 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-165-95.vpn.oracle.com [10.65.165.95])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y6js6brp8-4;
	Mon, 20 May 2024 13:01:00 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v2 3/6] virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER support
Date: Mon, 20 May 2024 09:00:45 -0400
Message-Id: <20240520130048.1483177-4-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240520130048.1483177-1-jonah.palmer@oracle.com>
References: <20240520130048.1483177-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-20_05,2024-05-17_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405200108
X-Proofpoint-GUID: Osur1_rTqDi76lII32o60TL246mpBbN2
X-Proofpoint-ORIG-GUID: Osur1_rTqDi76lII32o60TL246mpBbN2

Add VIRTIO_F_IN_ORDER feature support for the virtqueue_fill operation.

The goal of the virtqueue_ordered_fill operation when the
VIRTIO_F_IN_ORDER feature has been negotiated is to search for this
now-used element, set its length, and mark the element as filled in
the VirtQueue's used_elems array.

By marking the element as filled, it will indicate that this element has
been processed and is ready to be flushed, so long as the element is
in-order.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 7456d61bc8..01b6b32460 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -873,6 +873,38 @@ static void virtqueue_packed_fill(VirtQueue *vq, const VirtQueueElement *elem,
     vq->used_elems[idx].ndescs = elem->ndescs;
 }
 
+static void virtqueue_ordered_fill(VirtQueue *vq, const VirtQueueElement *elem,
+                                   unsigned int len)
+{
+    unsigned int i, steps, max_steps;
+
+    i = vq->used_idx;
+    steps = 0;
+    /*
+     * We shouldn't need to increase 'i' by more than the distance
+     * between used_idx and last_avail_idx.
+     */
+    max_steps = (vq->last_avail_idx + vq->vring.num - vq->used_idx)
+                % vq->vring.num;
+
+    /* Search for element in vq->used_elems */
+    while (steps <= max_steps) {
+        /* Found element, set length and mark as filled */
+        if (vq->used_elems[i].index == elem->index) {
+            vq->used_elems[i].len = len;
+            vq->used_elems[i].in_order_filled = true;
+            break;
+        }
+
+        i += vq->used_elems[i].ndescs;
+        steps += vq->used_elems[i].ndescs;
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
@@ -923,7 +955,9 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueElement *elem,
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

