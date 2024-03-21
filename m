Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C3B12B17E
	for <virtio-fs@lists.linux.dev>; Thu, 21 Mar 2024 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036654; cv=none; b=eUlm4oAbygU7osbZ0vm5BqU1CrfCtRJ8zDK79JhhwndfUp+f8dkKR8Yar81IdKdh566lOXVC7M/4q/YyEPsG5xv2Nwf28sBlPLmfYeeHCknuTQqDxahc7BMEqlqxAfJ1H+a1ZwnEiRCPHoujrvB4D7J00LDDGXLmsBrHWk9t/dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036654; c=relaxed/simple;
	bh=SLpl8V7dGf9lB4METDGXMURlwb+1vikgPLTv6kIPaMg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sAI98FFCRros4JadBhpiIRQI2FaksWRPywMS9tZX4M/7Ayhxy8nCAzdkcoQVP44zacQARxtvZ6qSye5XGvI0NqlI6M3sXqMJYXFfQphmj6FWNTm+B6I6dpF4cTpXTgOjPY249mUOLHzMzV3U/s+p1ckXmsIu/pUoXzCNsjl/mVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y01s6mKx; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y01s6mKx"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42LCmSm3021754;
	Thu, 21 Mar 2024 15:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=IHYGVRbf5620/FdghnuWWk7JhfS+SmHB1NqgpMb+lps=;
 b=Y01s6mKx/lizXSnMnRQZxTS4LDItAnY4/b0YtmH57xYWnwD/eN4AGXeYgfIjSZywIDNi
 DNXFSCcmUX2OwkbeqXEAGyIdtgqoX0Cwns/wedMrgWXtZZhWetR2h+tBFV+KEk6JZpHq
 +AoeGrpdENAvr/el0HgnyMuKME/iOn9IAwrjZDdXpwqAiQ7DzCtc0oiNJqypZzbWCBEh
 +sl1E/TGt/cwAROhB1UkkAnrGO8zmyfbaf0DCi4VOJ+0yPMh07CeQWuZIF/jg/TTsJZp
 uxfP0xAUR9PDpuhwTnBJ4lkP7JNB/amG2jQVz736ExyK67MBrfondkY0iN8GDebV8BL2 8g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww3fctxb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42LFGOHK005979;
	Thu, 21 Mar 2024 15:57:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1v9q1tb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:28 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42LFsWZS005094;
	Thu, 21 Mar 2024 15:57:28 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-211-118.vpn.oracle.com [10.39.211.118])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ww1v9q1p9-7;
	Thu, 21 Mar 2024 15:57:27 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC 6/8] vhost-svq: in-order handling
Date: Thu, 21 Mar 2024 11:57:15 -0400
Message-Id: <20240321155717.1392787-7-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: dWWzOBLhPjmtjmgecPifP6m095WJBN4S
X-Proofpoint-ORIG-GUID: dWWzOBLhPjmtjmgecPifP6m095WJBN4S

Implements in-order handling for vhost devices using shadow virtqueues.

Since vhost's shadow virtqueues utilize batching in their
vhost_svq_flush calls, the vhost device is responsible for calling
virtqueue_flush once it has completed its batching operation.

Note:
-----
It's unclear if this implementation is really necessary to "guarantee"
in-order handling since, by design, the vhost_svq_flush function puts
used VirtQueueElements in-order already.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/vhost-shadow-virtqueue.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index fc5f408f77..3c42adee87 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -493,11 +493,20 @@ static void vhost_svq_flush(VhostShadowVirtqueue *svq,
                 qemu_log_mask(LOG_GUEST_ERROR,
                          "More than %u used buffers obtained in a %u size SVQ",
                          i, svq->vring.num);
-                virtqueue_fill(vq, elem, len, i);
-                virtqueue_flush(vq, i);
+                if (virtio_vdev_has_feature(svq->vdev, VIRTIO_F_IN_ORDER)) {
+                    virtqueue_order_element(vq, elem, len, i, i);
+                } else {
+                    virtqueue_fill(vq, elem, len, i);
+                    virtqueue_flush(vq, i);
+                }
                 return;
             }
-            virtqueue_fill(vq, elem, len, i++);
+
+            if (virtio_vdev_has_feature(svq->vdev, VIRTIO_F_IN_ORDER)) {
+                virtqueue_order_element(vq, elem, len, i++, 0);
+            } else {
+                virtqueue_fill(vq, elem, len, i++);
+            }
         }
 
         virtqueue_flush(vq, i);
-- 
2.39.3

