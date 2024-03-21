Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8458E1E534
	for <virtio-fs@lists.linux.dev>; Thu, 21 Mar 2024 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036655; cv=none; b=rxJLex1Z2EovXE/k0aIROGFaFyvfZJo7bwRniWbdBE12/V68or6Ff3eO06n4ML1TZIXniB6bGQoe3JYl7ktGa5PRP8cvbJdEtEGTAmgsk7faGfwGFCml1kTGVk17ziDzfKQzciA2fE2sz+SxRRECp0oMThhoS3go6WGBwh1y0P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036655; c=relaxed/simple;
	bh=oK1q1UhsYULsQgGxsVgp9ybdjXplZ2Elkt+t/6V42tc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PnwPEm/tJWuiOUz2gYkdAFuEUk1gQvDKFScPJXTZk1VaFzC1PpPP5byLTK7GStHdEmziOOnDc+VyFS8KUnQ+r2WuPB0BKHfLcjLujq3yyjgjqvlZf/NpfEg6FWaEdM4ememNSaRhmwV+YjtzdSVZzszJ7eAge7d2jBPJorgN/CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y0iWGVny; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y0iWGVny"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42LCmNvw019770;
	Thu, 21 Mar 2024 15:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=0RgSlsTyJanzxmqU381z1Axh2X0OQKN7rdlzlu7v0Js=;
 b=Y0iWGVnyARJO2fz4CDWtBhIjDjMtX1840Lp9hImTfTe48KY+JA2bYIe0yQKGN4JHFjrX
 +1cYm/SX2rdpuJD242NmFnVIyKvozfBNJxAkhOWIIuosEbkNqbdMCgCNJVXVZsy1IH3z
 uiQP2lE4zAM0hefTNQJhc31AB9QbQh79p3lrWRflJu6tyBjFI68XQSZSw5+KSanS3pUT
 nisQlwVHV6i8tVpXabQ+f9Pcyt6Avogbcn+LRO8TvF6WE3/oeEjQatOhBAEOOLjyEHyz
 aApR/MEXkUQcZoqeUA2Rmw3/x5y61PjJgJ2f2ABAuRXwdL6EGqGqhnGMVu/mFmc1DhMb pQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww1udjrbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42LFZ6ka006215;
	Thu, 21 Mar 2024 15:57:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1v9q1s0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42LFsWZM005094;
	Thu, 21 Mar 2024 15:57:24 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-211-118.vpn.oracle.com [10.39.211.118])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ww1v9q1p9-4;
	Thu, 21 Mar 2024 15:57:24 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC 3/8] virtio: Define order variables
Date: Thu, 21 Mar 2024 11:57:12 -0400
Message-Id: <20240321155717.1392787-4-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240321155717.1392787-1-jonah.palmer@oracle.com>
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-21_10,2024-03-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403210115
X-Proofpoint-GUID: ZhbczsySTRt-976NfNnGQkwi8BxwXLr0
X-Proofpoint-ORIG-GUID: ZhbczsySTRt-976NfNnGQkwi8BxwXLr0

Define order variables for their use in a VirtQueue's in-order hash
table. Also initialize current_order variables to 0 when creating or
resetting a VirtQueue. These variables are used when the device has
negotiated the VIRTIO_F_IN_ORDER transport feature.

A VirtQueue's current_order_idx represents the next expected index in
the sequence of VirtQueueElements to be processed (put on the used
ring). The next VirtQueueElement to be processed must match this
sequence number before additional elements can be safely added to the
used ring.

A VirtQueue's current_order_key is essentially a counter whose value is
saved as a key in a VirtQueueElement. After the value has been assigned
to the VirtQueueElement, the counter is incremented. All
VirtQueueElements being used by the device are assigned a key value and
the sequence at which they're assigned must be preserved when the device
puts these elements on the used ring.

A VirtQueueElement's order_key is value of a VirtQueue's
current_order_key at the time of the VirtQueueElement's creation. This
value must match with the VirtQueue's current_order_idx before it's able
to be put on the used ring by the device.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c         | 6 ++++++
 include/hw/virtio/virtio.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index d2afeeb59a..40124545d6 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -155,6 +155,8 @@ struct VirtQueue
 
     /* In-Order */
     GHashTable *in_order_ht;
+    uint16_t current_order_idx;
+    uint16_t current_order_key;
 };
 
 const char *virtio_device_names[] = {
@@ -2103,6 +2105,8 @@ static void __virtio_queue_reset(VirtIODevice *vdev, uint32_t i)
     if (vdev->vq[i].in_order_ht != NULL) {
         g_hash_table_remove_all(vdev->vq[i].in_order_ht);
     }
+    vdev->vq[i].current_order_idx = 0;
+    vdev->vq[i].current_order_key = 0;
     virtio_virtqueue_reset_region_cache(&vdev->vq[i]);
 }
 
@@ -2357,6 +2361,8 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
             g_hash_table_new_full(g_direct_hash, g_direct_equal, NULL,
                                   free_in_order_vq_element);
     }
+    vdev->vq[i].current_order_idx = 0;
+    vdev->vq[i].current_order_key = 0;
 
     return &vdev->vq[i];
 }
diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index c8aa435a5e..f83d7e1fee 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -75,6 +75,7 @@ typedef struct VirtQueueElement
     hwaddr *out_addr;
     struct iovec *in_sg;
     struct iovec *out_sg;
+    uint16_t order_key;
 } VirtQueueElement;
 
 typedef struct InOrderVQElement {
-- 
2.39.3

