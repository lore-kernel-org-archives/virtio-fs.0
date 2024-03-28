Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B426132810
	for <virtio-fs@lists.linux.dev>; Thu, 28 Mar 2024 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711642941; cv=none; b=jOIhX+WkmptDzlHL9erieyTWIo1U7aXrDBQoiaaJ2EEry+N488+0ZAJoJINZacCPJFK+CDJPj510+nncFq5epGalX4N4mLblkDsg0yezLjDDZGQ0rQQNquvmANTlBoTqsN3A4polMDfNbY12+KMkplNEe24SmI0CPZXSpaowK20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711642941; c=relaxed/simple;
	bh=nIvsSPnKgAnMpEv0V+EJQQ41/YodH05GMB3QPAO50jg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fUxoIaxRRFAPNr01ClF8mA9A2kDTeG3HCpjQvg/FQeFXDThqvewN5tUQc/5NxwwAq6ikRZLPXtVRcewsJ3ccoYbnT/qjJqiZVwPaAvvyj982QIceAUG0H6qr/41t2/YUk1flYjPu114jpupPAYIPeCAKdZP8AeJWipr17vYen0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PeEXh6VP; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PeEXh6VP"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42SFP3Gj009598;
	Thu, 28 Mar 2024 16:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=t+MOBr6NcxD2+45PzNWIRJWhFZkAKFOHgU3aasbwS2Q=;
 b=PeEXh6VPCBq5F3IObjBRiYRY8OhsqKH9MqkWsnSSQbUyLzawWN1d0kAoYNZXISEQ87d/
 nCjKVcacYvftWcoL4aV3bpUlumYuoWvoqsZnZIts4vILCuThfbV1Zy4Y5SNgzVF+xwhP
 I62Qz1mS7q0EKXWnPCgmFRRFv750fXXSgVPykwC3kDngFgWOFTroa7knSm7SPQeIw8RS
 eSZjiJvukKcEldeVf9stki0t8GxnMsi1pi217wcHC8XiHniB2idgr6RTFuJp5kppRVcw
 jlkQEIQevR/3o8Clh9eK8ZKwSivrn0D95F+wBOGCd9fHE3SMK37z4OR9uow2BvFwx1yk qA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9h0jtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 16:22:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42SGG4FM015182;
	Thu, 28 Mar 2024 16:22:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhgfgfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 16:22:07 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42SGM5Zv010492;
	Thu, 28 Mar 2024 16:22:07 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-220-183.vpn.oracle.com [10.39.220.183])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3x1nhgfgcy-2;
	Thu, 28 Mar 2024 16:22:07 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v2 1/5] virtio: Initialize sequence variables
Date: Thu, 28 Mar 2024 12:21:59 -0400
Message-Id: <20240328162203.3775114-2-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: yIwmXhld4fui8KBKq2wn5XuC7ZmmavOX
X-Proofpoint-ORIG-GUID: yIwmXhld4fui8KBKq2wn5XuC7ZmmavOX

Initialize sequence variables for VirtQueue and VirtQueueElement
structures. A VirtQueue's sequence variables are initialized when a
VirtQueue is being created or reset. A VirtQueueElement's sequence
variable is initialized when a VirtQueueElement is being initialized.
These variables will be used to support the VIRTIO_F_IN_ORDER feature.

A VirtQueue's used_seq_idx represents the next expected index in a
sequence of VirtQueueElements to be processed (put on the used ring).
The next VirtQueueElement added to the used ring must match this
sequence number before additional elements can be safely added to the
used ring. It's also particularly useful for helping find the number of
new elements added to the used ring.

A VirtQueue's current_seq_idx represents the current sequence index.
This value is essentially a counter where the value is assigned to a new
VirtQueueElement and then incremented. Given its uint16_t type, this
sequence number can be between 0 and 65,535.

A VirtQueueElement's seq_idx represents the sequence number assigned to
the VirtQueueElement when it was created. This value must match with the
VirtQueue's used_seq_idx before the element can be put on the used ring
by the device.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c         | 18 ++++++++++++++++++
 include/hw/virtio/virtio.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index fb6b4ccd83..069d96df99 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -132,6 +132,10 @@ struct VirtQueue
     uint16_t used_idx;
     bool used_wrap_counter;
 
+    /* In-Order sequence indices */
+    uint16_t used_seq_idx;
+    uint16_t current_seq_idx;
+
     /* Last used index value we have signalled on */
     uint16_t signalled_used;
 
@@ -1621,6 +1625,11 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
         elem->in_sg[i] = iov[out_num + i];
     }
 
+    /* Assign sequence index for in-order processing */
+    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
+        elem->seq_idx = vq->current_seq_idx++;
+    }
+
     vq->inuse++;
 
     trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
@@ -1760,6 +1769,11 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
     vq->shadow_avail_idx = vq->last_avail_idx;
     vq->shadow_avail_wrap_counter = vq->last_avail_wrap_counter;
 
+    /* Assign sequence index for in-order processing */
+    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
+        elem->seq_idx = vq->current_seq_idx++;
+    }
+
     trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
 done:
     address_space_cache_destroy(&indirect_desc_cache);
@@ -2087,6 +2101,8 @@ static void __virtio_queue_reset(VirtIODevice *vdev, uint32_t i)
     vdev->vq[i].notification = true;
     vdev->vq[i].vring.num = vdev->vq[i].vring.num_default;
     vdev->vq[i].inuse = 0;
+    vdev->vq[i].used_seq_idx = 0;
+    vdev->vq[i].current_seq_idx = 0;
     virtio_virtqueue_reset_region_cache(&vdev->vq[i]);
 }
 
@@ -2334,6 +2350,8 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
     vdev->vq[i].vring.align = VIRTIO_PCI_VRING_ALIGN;
     vdev->vq[i].handle_output = handle_output;
     vdev->vq[i].used_elems = g_new0(VirtQueueElement, queue_size);
+    vdev->vq[i].used_seq_idx = 0;
+    vdev->vq[i].current_seq_idx = 0;
 
     return &vdev->vq[i];
 }
diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index b3c74a1bca..910b2a3427 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -75,6 +75,7 @@ typedef struct VirtQueueElement
     hwaddr *out_addr;
     struct iovec *in_sg;
     struct iovec *out_sg;
+    uint16_t seq_idx;
 } VirtQueueElement;
 
 #define VIRTIO_QUEUE_MAX 1024
-- 
2.39.3

