Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC2413440A
	for <virtio-fs@lists.linux.dev>; Mon, 20 May 2024 13:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716210065; cv=none; b=LENkg5j6YPI7Gzze3Sd//IiRF1hfCAV/+aBSUsMLhvKc5Xu3O3LLJn4bDmS3BnveDc8D9whlbfoOIUtqjS3wuwf722b7vLeygVxeF5qyikbgBRincBKMzvegkujvi+0K86LtpzUSioKkF2DFwlU3UiAb1qL0mvRKUGV4Bn3NBMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716210065; c=relaxed/simple;
	bh=8XnuuNLI6UY5yzUVio24bzrDUh1XAV6rPaRFzvy+LoM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gfrRNwHOaBoukNIm+pvUCQefqmdGaNvjP9yxXYbhB6fefgosA6lwdlyjIGH7XZt7+p1PlCT4j/4zyby1DIAmg+pQfM/AURcqHtAAvqJXXW0KdU4XrXFAwngcxnOWXOBtq1MGez55dlIBUnFe5w8MujgtqE1R1dwwstTAyDjeJaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nOjc90V7; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nOjc90V7"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KCemBf022542;
	Mon, 20 May 2024 13:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=H2lQ+KzoBIHeiWEgLekhuUKoIgyL7JtqBKnyTf2oklA=;
 b=nOjc90V7kGdstCPiJt5rKBsGUymhrJiEHTuKckgcNL9l3YLPCgfv1bY3S8pvLLJJJlH5
 oLeoMH5dQnxFatqXAlU2cPvoHy8FazMmcEc6Nj39cMsZxI1O0BCBL8Z9aExc4ALYhVj/
 tNDei0b2+0tyGmv0IILpurZzSOgC1uYq3yazYTdNZZ5zmYJi2abGs9vmdFOFLlc/PcCi
 qxLE8DT3bZylEvQ80FpjjmEFB0wj0NW8zZRFYGFciupa2WGFd+LsnOcRnpY/qeyrbjno
 U2NcZfipUmX1NgnjIYPa8J+AZMY2e7fiZLXsFgRpr9bZsnETw1EABgahQokd1IwEG1Wu 8w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6k8d2jb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 13:00:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44KBT5NO005029;
	Mon, 20 May 2024 13:00:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js6bs0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 13:00:58 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44KD0qPb028778;
	Mon, 20 May 2024 13:00:58 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-165-95.vpn.oracle.com [10.65.165.95])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y6js6brp8-3;
	Mon, 20 May 2024 13:00:57 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v2 2/6] virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
Date: Mon, 20 May 2024 09:00:44 -0400
Message-Id: <20240520130048.1483177-3-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: 5Oljbn0A-EKc0zjGg89jJOFHjL5388Q1
X-Proofpoint-ORIG-GUID: 5Oljbn0A-EKc0zjGg89jJOFHjL5388Q1

Add VIRTIO_F_IN_ORDER feature support in virtqueue_split_pop and
virtqueue_packed_pop.

VirtQueueElements popped from the available/descritpor ring are added to
the VirtQueue's used_elems array in-order and in the same fashion as
they would be added the used and descriptor rings, respectively.

This will allow us to keep track of the current order, what elements
have been written, as well as an element's essential data after being
processed.

Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 893a072c9d..7456d61bc8 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1506,7 +1506,7 @@ static void *virtqueue_alloc_element(size_t sz, unsigned out_num, unsigned in_nu
 
 static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
 {
-    unsigned int i, head, max;
+    unsigned int i, head, max, prev_avail_idx;
     VRingMemoryRegionCaches *caches;
     MemoryRegionCache indirect_desc_cache;
     MemoryRegionCache *desc_cache;
@@ -1539,6 +1539,8 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
         goto done;
     }
 
+    prev_avail_idx = vq->last_avail_idx;
+
     if (!virtqueue_get_head(vq, vq->last_avail_idx++, &head)) {
         goto done;
     }
@@ -1630,6 +1632,12 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
         elem->in_sg[i] = iov[out_num + i];
     }
 
+    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
+        vq->used_elems[prev_avail_idx].index = elem->index;
+        vq->used_elems[prev_avail_idx].len = elem->len;
+        vq->used_elems[prev_avail_idx].ndescs = elem->ndescs;
+    }
+
     vq->inuse++;
 
     trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
@@ -1758,6 +1766,13 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
 
     elem->index = id;
     elem->ndescs = (desc_cache == &indirect_desc_cache) ? 1 : elem_entries;
+
+    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
+        vq->used_elems[vq->last_avail_idx].index = elem->index;
+        vq->used_elems[vq->last_avail_idx].len = elem->len;
+        vq->used_elems[vq->last_avail_idx].ndescs = elem->ndescs;
+    }
+
     vq->last_avail_idx += elem->ndescs;
     vq->inuse += elem->ndescs;
 
-- 
2.39.3

