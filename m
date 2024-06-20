Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5849A1B29BF
	for <virtio-fs@lists.linux.dev>; Thu, 20 Jun 2024 17:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906186; cv=none; b=NUTe3pw/Fs32eZjGtoIbzRM6weQlfb4C1/+JSgGpMgf0uRkA4xiO00m4jao5+nL1o8XHNl+se4QfF7uJqDUEMV5HPTiax6t4iRGvEBOgtLV0wPIdggLvABgYH2jnTeXLuKR0BGwXOdazj0eJKzfrLnLJRHjlPEJarB7HEyTCZKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906186; c=relaxed/simple;
	bh=HjjQfKmg9ckc9x8dlXUQwy9cVo5+aynutpx8VRUDQyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QME3i0qbJH8QOYJVdghjp9r3SnzfZQmCRu7QE9hip4+foXs62UHVVEfJ0E05FSOufqXynj/tC8AAhr5e7qF1JXCNZ0lnbYbhQLHo7Zz3G7WxbWhAC7DJu0gwtefBDm/IMADRigX25+rc1dsnTXqBSoYEcpaliudXrza3OVyu5Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YDGlbU9e; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YDGlbU9e"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KHBHgF030769;
	Thu, 20 Jun 2024 17:56:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=F5TLKDfjBB7mwqJGVlHMC/XnQgarvAemroewf5Vljas=; b=
	YDGlbU9ecsNW7Ez8sUw0v+6RMyWQGS/zuTzw65XqSFd9hDTvdj0tZF4HSXpG/X6F
	CkhaHxvhoJ8//1lKeskmzMpgK6nDgf65Ba+7uD0mYhCFabIpo906a33XIGInE/lf
	FXolYHkKW7smKKr8Er3UKVEz7cqtUkA4Io9Lz/QwnXOVd6fnjepouZMJCHPQukMg
	JOZBJ2qbWLvAS+OD41RYEhXWAvu2s6xxMe/Ui1/pMmb3ZR+acCXqEDGdGo8pzD+t
	Jggh/cyL9ByF6Bxw4Cxd19zqc6WcvleRJrlgz2qO+n4TqxNKcmIviSKYECz0xEhS
	dvAoS9kIQfrz+4D3I4zHlQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrkgr313-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:56:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KHDrcw012888;
	Thu, 20 Jun 2024 17:56:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrn3hnp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:56:20 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45KHuF0n018715;
	Thu, 20 Jun 2024 17:56:19 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-208-85.vpn.oracle.com [10.39.208.85])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3yvrn3hnjv-3;
	Thu, 20 Jun 2024 17:56:19 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v3 2/6] virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
Date: Thu, 20 Jun 2024 13:56:06 -0400
Message-ID: <20240620175612.2381019-3-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620175612.2381019-1-jonah.palmer@oracle.com>
References: <20240620175612.2381019-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_08,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406200129
X-Proofpoint-GUID: Hql_KFXDWPX99xTBHDBOfVxJaS5Dh1m1
X-Proofpoint-ORIG-GUID: Hql_KFXDWPX99xTBHDBOfVxJaS5Dh1m1

Add VIRTIO_F_IN_ORDER feature support in virtqueue_split_pop and
virtqueue_packed_pop.

VirtQueueElements popped from the available/descritpor ring are added to
the VirtQueue's used_elems array in-order and in the same fashion as
they would be added the used and descriptor rings, respectively.

This will allow us to keep track of the current order, what elements
have been written, as well as an element's essential data after being
processed.

Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 893a072c9d..9cbf75f021 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1630,6 +1630,12 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
         elem->in_sg[i] = iov[out_num + i];
     }
 
+    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
+        vq->used_elems[vq->last_avail_idx - 1].index = elem->index;
+        vq->used_elems[vq->last_avail_idx - 1].len = elem->len;
+        vq->used_elems[vq->last_avail_idx - 1].ndescs = elem->ndescs;
+    }
+
     vq->inuse++;
 
     trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
@@ -1758,6 +1764,13 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
 
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
2.43.0

