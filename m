Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891F7154436
	for <virtio-fs@lists.linux.dev>; Mon,  6 May 2024 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715007894; cv=none; b=j87mxXT32F7vA1htVqrSMge8nN8rXkT+ZG5NqYHUrQVGOcGsuKUJszaCrho9nEHhLBzp7eaChFQQioEUwCQtQ64UiaFw2QBXMqto3iRl0DXCNWiprqkLolTiLQYpCR6MYc/+ZEUAakoQ4xBYYg4zoQucg+HmhP1pMAMorZX+L1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715007894; c=relaxed/simple;
	bh=lsxJ0lXzSklDaoAika0Jg8pwLle+LtQETV52MlHgjak=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PCcOhUBZ76BaXyOmLHsLqz3AEfncVqTr2UxzXR0TK/bucyJyCfaDmt1NdpkgTh53Q5KoGJ/nFovtk3g1CglXkyzQSmJjLdDrY/aCjSmA/KsnmQgzPASf61zfljqupU70cIok7LRdH7BDQlN6IDK0LL7yTc8zL+DGXYfVOm0YuEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lNxpt+qM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lNxpt+qM"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446AmxpD018880;
	Mon, 6 May 2024 15:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=JeRPLc8Nz0JpIpjv/pdvoKN/oEGM1EJVi+w7A1bLScI=;
 b=lNxpt+qMGpt/+2xTx2mJcSxD180pO/OXbONIEWVyDp1qGrMd/3mB3L8HnNwcIynhaF9u
 sboFKaYnbJEeRlO1ZdzWM6JdHmdzyc+9yE6w9qMNJyBGR3Z15ZQf1WRMRfd1tPNOVKKq
 wToMBT+k0ePfTlEJcQR9bHGYbcNsIUg6lvmAPIua6uRD/Jx626iABKbVjWbr4ZIrioeB
 ZxYwXvMwVduk8vt0MrEJMsX7wm9Ft12OvxF0vGK5iY424UYo7Y0xgs/L5cBtHBR35XzS
 4p++PkryEhl2LW6IeQurb+ZCkKjGCwIt/9t72IeRmqqleUGC+qgdhKiJ420KZJ8U5sDs pA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwcmvat39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 15:04:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446DpmYE007085;
	Mon, 6 May 2024 15:04:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf6rwp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 15:04:46 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446F4ZlP002521;
	Mon, 6 May 2024 15:04:46 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-221-117.vpn.oracle.com [10.39.221.117])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf6rw8e-5;
	Mon, 06 May 2024 15:04:45 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH 4/6] virtio: virtqueue_ordered_flush - VIRTIO_F_IN_ORDER support
Date: Mon,  6 May 2024 11:04:26 -0400
Message-Id: <20240506150428.1203387-5-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: zSDxhcaeIeqhsOS9SJn9R3BfoZw3itIK
X-Proofpoint-ORIG-GUID: zSDxhcaeIeqhsOS9SJn9R3BfoZw3itIK

Add VIRTIO_F_IN_ORDER feature support for virtqueue_flush operations.

The goal of the virtqueue_flush operation when the VIRTIO_F_IN_ORDER
feature has been negotiated is to write elements to the used/descriptor
ring in-order and then update used_idx.

The function iterates through the VirtQueueElement used_elems array
in-order starting at vq->used_idx. If the element is valid (filled), the
element is written to the used/descriptor ring. This process continues
until we find an invalid (not filled) element.

If any elements were written, the used_idx is updated.

Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 75 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 064046b5e2..0efed2c88e 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1006,6 +1006,77 @@ static void virtqueue_packed_flush(VirtQueue *vq, unsigned int count)
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
@@ -1013,7 +1084,9 @@ void virtqueue_flush(VirtQueue *vq, unsigned int count)
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

