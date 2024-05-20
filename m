Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE9713440A
	for <virtio-fs@lists.linux.dev>; Mon, 20 May 2024 13:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716210070; cv=none; b=Dz79lMwk66a0/jQW/3X8LYPvNqulgpEwehGYmSr6rgELzq8sR3DSs1Skx3tJ07Z5yVwWGmFZkJU5grrAB26o7PZR74+u+nkrqghpizqDQbM3nM+FFQ6iZdoDX5PFyEyBbf+dUop8RldoXkd5FaoHKw5J6XN4N/7eVeJ2OyYluQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716210070; c=relaxed/simple;
	bh=0TvRA6kAochr/VlsN3P8hsnxkBVkBdxYyYTCuyPv8yc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BsyxFVoWKczU1N+q/ciZ73qqRkw/iVZUJ5/xrPdfj2BVeX4UY1VMNlXwpjA1Vs2hI3HbKLO63xTPKxUjnVG6iLqaqgpwhPTgQ4/6pKPN46hROdia4to+yAhIRnH6M6H2qw0iwkxsG+4eO3RB+ZqdbTMAqh5XOLgWtH7168SXZws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k4cQFezr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k4cQFezr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KAcL84017650;
	Mon, 20 May 2024 13:01:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=KFLrIYBaobLhkmLeIO3dUM6NOsXZgDQubg5LDdYtKZI=;
 b=k4cQFezr+ykKsIwgofWgCTK+rHly723clx9UddyqeehCMSPEpH7+O5SjN19S2h8BSPEc
 +MHsrt/TQtCoGjK0wVQA+790Ei5EYtz889GxHLyHKeTjDRyJjgS6mHblMud8KPa/df0x
 uCd4kW+H+Q8xNNaEOLTMvNxVxSenFbXyvWkLyRRGPPm4Vkvl6ZNJvrb823B6TZVmT9Qx
 YsVyymWQti85kHCfbEqYtpRBuwGtHXpTiX1ChmGaQHeV2MEOEsRYmyDWSeUMxNfzMKUh
 64spD2Ylq8dmHHu3QNzRQUxl6N/78TEFqgrCsfEEr99PbBaJuIviKowNKY/zq+B306w6 MQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6mvv2j8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 13:01:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44KBrUbG005020;
	Mon, 20 May 2024 13:01:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js6bs4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 13:01:03 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44KD0qPf028778;
	Mon, 20 May 2024 13:01:02 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-165-95.vpn.oracle.com [10.65.165.95])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y6js6brp8-5;
	Mon, 20 May 2024 13:01:02 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v2 4/6] virtio: virtqueue_ordered_flush - VIRTIO_F_IN_ORDER support
Date: Mon, 20 May 2024 09:00:46 -0400
Message-Id: <20240520130048.1483177-5-jonah.palmer@oracle.com>
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
X-Proofpoint-ORIG-GUID: Nt_TopKGGWkcNc-JnZOxU4imi9pbZz62
X-Proofpoint-GUID: Nt_TopKGGWkcNc-JnZOxU4imi9pbZz62

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
 hw/virtio/virtio.c | 66 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 01b6b32460..39b91beece 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1016,6 +1016,68 @@ static void virtqueue_packed_flush(VirtQueue *vq, unsigned int count)
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
@@ -1023,7 +1085,9 @@ void virtqueue_flush(VirtQueue *vq, unsigned int count)
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

