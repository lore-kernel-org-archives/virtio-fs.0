Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C880F46B91
	for <virtio-fs@lists.linux.dev>; Fri, 15 Mar 2024 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710521779; cv=none; b=bkjtrtkyU20BUvlkv89RIRHSmU/YIcPo2nF5YZAQRYd79k793R4/OSXrWuZbld9+vu4VqfqUNNzdAai64ftjl/6dKxKos4d/KhFEFiTCAnR2coTb3cgIaPUru4TQe/S/2r0atTdmZJImcCEqI+GXnG7dtdWsrV226oH9xYVL2s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710521779; c=relaxed/simple;
	bh=q/Yc5k+RzItCrMvKG01+z0Lh2bvG/T6XGIV8tzmUo5o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=obu3a8wAYtWuX+9g9VUvETqIsRDynkGMf0c2QTA3A+L3G1HaTKbednjMXMo5czm5rq2zLDeqHBgZbA80GhAFSjHMuvOWs2/G/JFZHOkmRRHrpjVhIR+zWVAXNN9QdnnVSfpJCu9qLHOQ6WXVl2HNXjlTc7t8OK5SpqlynP/k+6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fl62rq1r; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fl62rq1r"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42FGWsk7023964;
	Fri, 15 Mar 2024 16:56:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=j7weDARqbnaPZ+NpopRduEohkW8wiXoUF0ueJc51V/0=;
 b=fl62rq1r6ntpluu/3UlXrQjN9CrGJsNljHbYnfAbaiTA1f8hCOZMX3sAg+Zey6unKrGh
 Ynjp8dSpB0QxfxqkdlTjPCpvs6Wk5PT26ME5vc/U7fPLvtgjImlAsuXvIts0kYckaaK4
 np/iD8h64upE+mQy4+6NQmV4+Zt0JBu1qQY2EEL1CTqqJUijqNWn1eiALAnnbdxPshtF
 3qlQtY1aVheJ/0DyH8SaTX13H4WOxSH6cDvIBH18wNRHMqfXJpcoeAjsrjiN7E7duy9A
 9toxDL550ZzOswUDfleArPJvfuJzRmd7LkWIkZu8bXVV/9McMFf2A8XA1UIJ9t/+Mc9D DA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wvsxh815u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Mar 2024 16:56:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42FFLv1D033763;
	Fri, 15 Mar 2024 16:56:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7bw7ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Mar 2024 16:56:07 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42FGu2YQ039399;
	Fri, 15 Mar 2024 16:56:06 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-177-130.vpn.oracle.com [10.65.177.130])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3wre7bw7fq-2;
	Fri, 15 Mar 2024 16:56:06 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com, raphael@enfabrica.net, kwolf@redhat.com,
        hreitz@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        farman@linux.ibm.com, thuth@redhat.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, cohuck@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, qemu-s390x@nongnu.org, leiyang@redhat.com,
        schalla@marvell.com, vattunuru@marvell.com, jerinj@marvell.com,
        dtatulea@nvidia.com, virtio-fs@lists.linux.dev
Subject: [PATCH v3 for 9.1 1/6] virtio/virtio-pci: Handle extra notification data
Date: Fri, 15 Mar 2024 12:55:52 -0400
Message-Id: <20240315165557.26942-2-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240315165557.26942-1-jonah.palmer@oracle.com>
References: <20240315165557.26942-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-15_04,2024-03-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403150138
X-Proofpoint-ORIG-GUID: znWpf0FVVu5PHiLWzEMAV_Yy6amXt9Lq
X-Proofpoint-GUID: znWpf0FVVu5PHiLWzEMAV_Yy6amXt9Lq

Add support to virtio-pci devices for handling the extra data sent
from the driver to the device when the VIRTIO_F_NOTIFICATION_DATA
transport feature has been negotiated.

The extra data that's passed to the virtio-pci device when this
feature is enabled varies depending on the device's virtqueue
layout.

In a split virtqueue layout, this data includes:
 - upper 16 bits: shadow_avail_idx
 - lower 16 bits: virtqueue index

In a packed virtqueue layout, this data includes:
 - upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
 - lower 16 bits: virtqueue index

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio-pci.c     | 11 ++++++++---
 hw/virtio/virtio.c         | 18 ++++++++++++++++++
 include/hw/virtio/virtio.h |  2 ++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index cb6940fc0e..f3e0a08f53 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -384,7 +384,7 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
 {
     VirtIOPCIProxy *proxy = opaque;
     VirtIODevice *vdev = virtio_bus_get_device(&proxy->bus);
-    uint16_t vector;
+    uint16_t vector, vq_idx;
     hwaddr pa;
 
     switch (addr) {
@@ -408,8 +408,13 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
             vdev->queue_sel = val;
         break;
     case VIRTIO_PCI_QUEUE_NOTIFY:
-        if (val < VIRTIO_QUEUE_MAX) {
-            virtio_queue_notify(vdev, val);
+        vq_idx = val;
+        if (vq_idx < VIRTIO_QUEUE_MAX && virtio_queue_get_num(vdev, vq_idx)) {
+            if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
+                virtio_queue_set_shadow_avail_idx(virtio_get_queue(vdev, vq_idx),
+                                                  val >> 16);
+            }
+            virtio_queue_notify(vdev, vq_idx);
         }
         break;
     case VIRTIO_PCI_STATUS:
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index d229755eae..463426ca92 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -2255,6 +2255,24 @@ void virtio_queue_set_align(VirtIODevice *vdev, int n, int align)
     }
 }
 
+void virtio_queue_set_shadow_avail_idx(VirtQueue *vq, uint16_t shadow_avail_idx)
+{
+    if (!vq->vring.desc) {
+        return;
+    }
+
+    /*
+     * 16-bit data for packed VQs include 1-bit wrap counter and
+     * 15-bit shadow_avail_idx.
+     */
+    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
+        vq->shadow_avail_wrap_counter = (shadow_avail_idx >> 15) & 0x1;
+        vq->shadow_avail_idx = shadow_avail_idx & 0x7FFF;
+    } else {
+        vq->shadow_avail_idx = shadow_avail_idx;
+    }
+}
+
 static void virtio_queue_notify_vq(VirtQueue *vq)
 {
     if (vq->vring.desc && vq->handle_output) {
diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index c8f72850bc..cdd4f86b61 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -306,6 +306,8 @@ int virtio_queue_ready(VirtQueue *vq);
 
 int virtio_queue_empty(VirtQueue *vq);
 
+void virtio_queue_set_shadow_avail_idx(VirtQueue *vq, uint16_t idx);
+
 /* Host binding interface.  */
 
 uint32_t virtio_config_readb(VirtIODevice *vdev, uint32_t addr);
-- 
2.39.3

