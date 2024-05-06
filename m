Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2B0153BF9
	for <virtio-fs@lists.linux.dev>; Mon,  6 May 2024 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715007892; cv=none; b=AfYmBLujn+I4UM9NNgS243y5goOURnN/qlQlF+v9LgJRdsLvbe8J0UdpcD4qviesdF7VRJLEFOZYQPwwIYgcIXZwV+LbvYNP5udy9qSX0vDbWz1dhRcqD/4plJooiPQ3vFYdDVunOshisr+z5J1622nd189tvgcVBiUYEw1vywY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715007892; c=relaxed/simple;
	bh=gBdU2MwHCT5rqdNmSirQeuI+ChwnwarJbQ9ib6JbzmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r2gwwbufnCeDa1qvC6LgV+q/N20GwTGAu7aC2mlnCviMxw0xWge5tA9n/e0dyOg7zkIlgarYVUivE/AFqEAJz68Do8hER1Umb1iyMbBePnx0lilqPs0lBh8LUADBAZAh/gj+6MTG6rwtoQWa6ZFKiLWnQRkipdP/1HfoKiWKcUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RtQy3ono; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RtQy3ono"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446AmxuG018890;
	Mon, 6 May 2024 15:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=JTlGxDb6xDJEo+o+u4Np28OWcIj5g/p45UdJvevQps0=;
 b=RtQy3onojbM53hw2Xl0il/FQVFUNkeClgMWCID0qBm42mUjP0Ly/t0G1VpdbU/zF1F/J
 YKNzxMlFDHJTd830ZQ6pQiz+AzfiV0D3KIrtYsrKpJ2YH2cs4TvH00LcRfhtXzBmiVei
 vU6yh8rorvgosPy2KKodlhc/p/TCChC50QbVwSuBl4OrfhHk0edbDAfEuAPk6cF22gPr
 0UZOR2godRnDZ2Uey14Dt9bGiUl7bQRgylAs9cXpSgVyGkg8A1exKVbtPnpDXE/b3XHF
 PFzlahZB8/6ozCY23LQr+HJZjV3AEfNV9SNNrwpNknCWW2FEgwQ60y/T6T27HBnPBnje Ag== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwcmvat2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 15:04:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446EGYSf006886;
	Mon, 6 May 2024 15:04:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf6rwm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 15:04:44 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446F4ZlN002521;
	Mon, 6 May 2024 15:04:43 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-221-117.vpn.oracle.com [10.39.221.117])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf6rw8e-4;
	Mon, 06 May 2024 15:04:43 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH 3/6] virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER support
Date: Mon,  6 May 2024 11:04:25 -0400
Message-Id: <20240506150428.1203387-4-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: t397doJhVmJ7HnX7RFaIfYcZD1t6B1L4
X-Proofpoint-ORIG-GUID: t397doJhVmJ7HnX7RFaIfYcZD1t6B1L4

Add VIRTIO_F_IN_ORDER feature support for virtqueue_fill operations.

The goal of the virtqueue_fill operation when the VIRTIO_F_IN_ORDER
feature has been negotiated is to search for this now-used element,
set its length, and mark the element as filled in the VirtQueue's
used_elems array.

By marking the element as filled, it will indicate that this element is
ready to be flushed, so long as the element is in-order.

Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index e6eb1bb453..064046b5e2 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -873,6 +873,28 @@ static void virtqueue_packed_fill(VirtQueue *vq, const VirtQueueElement *elem,
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
@@ -923,7 +945,9 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueElement *elem,
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

