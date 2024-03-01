Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3956E60C
	for <virtio-fs@lists.linux.dev>; Fri,  1 Mar 2024 13:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709300628; cv=none; b=G1eduuJTRI87hIAzIpsxeztDwwAKOgcfEx6pxak8bVtc1BCE3lRHcCKwRm5tcyIS8kL0DVTlI8x7z/JFb6XDpaENjJEGdJtlg2GhdsBWG9w5eKJnlj5w19rFmUaNw2jxbuzY5IpQpLJ14sBSubSjRQwdP+ORXmItz+mA7gIBPew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709300628; c=relaxed/simple;
	bh=wfzqq/NSK7uTYTgNwR0Rm+p/mhKOmvdaYJXVlM//S6o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cA9mEfy1Bwk03ndcqBjZkOWgUqVp1P8dAjuCFcG14A3t3AwEPFqiWK/vUo1fWp+1e0abGYKvl4OLfV7pO+5TII4yznGGk82B9flPkZATjHyBRE8InCHwLs6q3DgkHkK5xJ1bnl0QeAhoBPtNKrBNp5TriY8WF8tSaKnT4+rzXMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OpNGK58W; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OpNGK58W"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42194h43008252;
	Fri, 1 Mar 2024 13:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=31MebaJvp72AKBEkEumWQRA9IcrmJO/cdo3sXTMK9X8=;
 b=OpNGK58W3L9ltpQn4Jz2mu+cvX0myaJM5G0LKA0qbSpUAoR0QlQtQAM3Yyw66mdc2pAT
 w9pIYulZ42co3PMTN4c5D4XEBRKhRaQAIM7gTZJL/LfKsQBWiwtFy5GeoU+p4ZzwgGoQ
 iwgrVI8YVJ03LI66SCsmDGlF10mKBVUJYPGEA5fZTcZ45rejqLoeBmJHehEoQI5cftHV
 eigcCQt9PgU6TIxZnqv1iE0Qmv5Fhnih++l1+JabGqF5WbdFryfaLPdwIQuduq+gkk3v
 crbhXVhkCi1ShzAL13cbsrK0e/GC5BoD+ibMXSVmoNJRRaKI1ypAN/Db58+f4KqmFGVi rA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf90vgw9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 13:43:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 421BrKQp009391;
	Fri, 1 Mar 2024 13:43:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wjrqmtrd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 13:43:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 421DhWAO026578;
	Fri, 1 Mar 2024 13:43:37 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-160-211.vpn.oracle.com [10.65.160.211])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wjrqmtr9m-4;
	Fri, 01 Mar 2024 13:43:36 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com, raphael@enfabrica.net, kwolf@redhat.com,
        hreitz@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        farman@linux.ibm.com, thuth@redhat.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, cohuck@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, qemu-s390x@nongnu.org,
        virtio-fs@lists.linux.dev
Subject: [RFC 3/8] virtio-mmio: Handle extra notification data
Date: Fri,  1 Mar 2024 08:43:25 -0500
Message-Id: <20240301134330.4191007-4-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240301134330.4191007-1-jonah.palmer@oracle.com>
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-01_13,2024-03-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403010114
X-Proofpoint-GUID: i9q_6TtIHurdUt5Q0ESFychCO9IUGOY-
X-Proofpoint-ORIG-GUID: i9q_6TtIHurdUt5Q0ESFychCO9IUGOY-

Add support to virtio-mmio devices for handling the extra data sent from
the driver to the device when the VIRTIO_F_NOTIFICATION_DATA transport
feature has been negotiated.

The extra data that's passed to the virtio-mmio device when this feature
is enabled varies depending on the device's virtqueue layout.

The data passed to the virtio-mmio device is in the same format as the
data passed to virtio-pci devices.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio-mmio.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
index 22f9fbcf5a..2bac77460e 100644
--- a/hw/virtio/virtio-mmio.c
+++ b/hw/virtio/virtio-mmio.c
@@ -248,6 +248,7 @@ static void virtio_mmio_write(void *opaque, hwaddr offset, uint64_t value,
 {
     VirtIOMMIOProxy *proxy = (VirtIOMMIOProxy *)opaque;
     VirtIODevice *vdev = virtio_bus_get_device(&proxy->bus);
+    uint16_t vq_idx;
 
     trace_virtio_mmio_write_offset(offset, value);
 
@@ -407,8 +408,15 @@ static void virtio_mmio_write(void *opaque, hwaddr offset, uint64_t value,
         }
         break;
     case VIRTIO_MMIO_QUEUE_NOTIFY:
-        if (value < VIRTIO_QUEUE_MAX) {
-            virtio_queue_notify(vdev, value);
+        if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
+            vq_idx = value & 0xFFFF;
+            virtio_set_notification_data(vdev, vq_idx, value);
+        } else {
+            vq_idx = value;
+        }
+
+        if (vq_idx < VIRTIO_QUEUE_MAX) {
+            virtio_queue_notify(vdev, vq_idx);
         }
         break;
     case VIRTIO_MMIO_INTERRUPT_ACK:
-- 
2.39.3

