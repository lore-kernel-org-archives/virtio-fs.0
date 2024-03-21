Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BAF12B17B
	for <virtio-fs@lists.linux.dev>; Thu, 21 Mar 2024 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036654; cv=none; b=GtASywyAAa4PD5LLTsf2jSiZaj4tN6EELkqlMmKSjdnlzDjlR3L7cSpc3cLAJ72xgwzVJc/y/qS7jphaiF6AVcju5cNpryfedeiPSGmrTcUk1DbivLWtwCTb9CLvO1+m5dYZbzii8YhUjN5ELy8H+voFVFl4Y5gaNazwMvBSOAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036654; c=relaxed/simple;
	bh=07/qDS1AeIXYTnEJeTl7rccQ35M//WXR5A1zQFY9iC0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M/D7IZL5B4Mx8P1oJm4eIUR7MQqtFi8n0wnnK3xXE2EeNR/d9g04F5OKJTRq5Lu8Xzg4gfBQccQzkebb3W1+g5dvrg20LzSlR0h+BWXDy0iwasGQTaG+opP9/TI2p7so1OubCn7xknEiGkXqxfwRmS+gwxZKjiugbqvYmkAfouk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OPs+0iRO; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OPs+0iRO"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42LCmR8M019819;
	Thu, 21 Mar 2024 15:57:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=C5cfPqclQmEI1p44dvfQN4gtBbzXWqK+9bQ8ubInWk4=;
 b=OPs+0iROHCSP0X1cccabf+8b8OCrlQ1Iti8XrqBvRRi7sE18lak4Hi0Mv1hr08UQXAWM
 XdTw0+QhiVMUPIRparAgfNl4YW36QMwQOJtPCFC9o768KXVwIx8aZrdvLJ2bY1zPeoyg
 zRcQ5MCXFTJC+Yu4qnYPifRv+RpttnHTxfpSdV4WhmyuMpdg3hwjb9Z3bAs96bPHIb0k
 mH3WQgmpT6jbI/PRNnXyljyUHckqXs8QDXyoT6GpLFQ/9V5dr6jC39r1/WPBfBZyQMJQ
 vV7Pb44TkfQ0ifvFOew6fQEGpI551ST5p2kZVFT19b/GKnv3Q08t1eCTVAuDpnbEg+QR 5Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww1udjrbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42LF8fiV006144;
	Thu, 21 Mar 2024 15:57:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1v9q1ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:27 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42LFsWZQ005094;
	Thu, 21 Mar 2024 15:57:27 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-211-118.vpn.oracle.com [10.39.211.118])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ww1v9q1p9-6;
	Thu, 21 Mar 2024 15:57:27 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC 5/8] virtio-net: in-order handling
Date: Thu, 21 Mar 2024 11:57:14 -0400
Message-Id: <20240321155717.1392787-6-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: _kPmQFJpMWiUWmn-sbvlklxr5k2dQPtH
X-Proofpoint-ORIG-GUID: _kPmQFJpMWiUWmn-sbvlklxr5k2dQPtH

Implements in-order handling for the virtio-net device.

Since virtio-net utilizes batching for its Rx VirtQueue, the device is
responsible for calling virtqueue_flush once it has completed its
batching operation.

Note:
-----
It's unclear if this implementation is really necessary to "guarantee"
that used VirtQueueElements are put on the used ring in-order since, by
design, virtio-net already does this with its Rx VirtQueue.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/net/virtio-net.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index 9959f1932b..b0375f7e5e 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -2069,7 +2069,11 @@ static ssize_t virtio_net_receive_rcu(NetClientState *nc, const uint8_t *buf,
 
     for (j = 0; j < i; j++) {
         /* signal other side */
-        virtqueue_fill(q->rx_vq, elems[j], lens[j], j);
+        if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
+            virtqueue_order_element(q->rx_vq, elems[j], lens[j], j, 0);
+        } else {
+            virtqueue_fill(q->rx_vq, elems[j], lens[j], j);
+        }
         g_free(elems[j]);
     }
 
-- 
2.39.3

