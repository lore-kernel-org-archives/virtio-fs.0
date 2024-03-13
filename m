Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF293F9D8
	for <virtio-fs@lists.linux.dev>; Wed, 13 Mar 2024 11:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710330882; cv=none; b=u3GNnQJZQcl0mP003SrJTJAW0B8diz0FqLsi8+FZ5PACFN8dsrPJoVWKs1u32CYEq0vQq/6N2o3Z0ShBPSGoRnDvKCdNkA0qZXO7nLTVOc9+mJVxfgLjKdmT7MgkKpuUu9QC9KbxbBgdThse/5VBGMC5kIOsBPVEVIWyMkeCipo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710330882; c=relaxed/simple;
	bh=gVWeRq5tgS3QXoEg7Lfs+ZXXcMPO6PIj4ukr06KdTbg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXpFBKZfIBCiKMVrHHXzB/vPhTemdOcHuS4FiNIAHPojasPT0IHiRxvc8YDO0w3ajRMIEFUxm5FmuSNqvAC6G17jeuom/zVUipzIU+Jtdqo1KsqCSUDwVjkmZ/wBpMqZUYCHfTUtRWFmBWhrMDeAwIOXMIbY4Pu2PMy4hkJkvK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L349oD0+; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L349oD0+"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42D8hf6V019449;
	Wed, 13 Mar 2024 11:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=3Dw2InhaZuLFR8zyQl27/TJvsByG908bC7ll/3elZwI=;
 b=L349oD0+iiVNeRxmQRU9WQMHaBspnBI1MiN+h5bb9XBppGwZWg7nInbayGeUW6p3ENSU
 vrxLKxhP4e5bmM+dNGciHZYMmBwoVffhoA4Up6hPSb30Nfjw+5bbr+qTc/yLLV5aJM6B
 Ya1V+00ApVLZGogDCS4WJU3ZjcqyvXKD8T7xsHD55q48CUJF+shHS+PEtT2v+XRPPRfh
 Zl3gpHIpPZcdavcx/MTB3dFNcKYBUTCd1HwNVDVa262XZotJ5kJan5kkOrOOHgTcb/fG
 HUeYe4hQTnu6etqPbRyUQV3/Ww/IONGgbY08XHMK9gq3X4cweiL+j7GSoeBpS2x6aMkn zA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrej40u28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 11:54:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42DBrpju028511;
	Wed, 13 Mar 2024 11:54:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre78pejh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 11:54:28 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42DBsMLf035677;
	Wed, 13 Mar 2024 11:54:27 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-201-251.vpn.oracle.com [10.39.201.251])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wre78peed-4;
	Wed, 13 Mar 2024 11:54:27 +0000
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
Subject: [PATCH v2 3/6] virtio-mmio: Handle extra notification data
Date: Wed, 13 Mar 2024 07:54:09 -0400
Message-Id: <20240313115412.3334962-4-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240313115412.3334962-1-jonah.palmer@oracle.com>
References: <20240313115412.3334962-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-13_07,2024-03-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403130089
X-Proofpoint-GUID: YY4_RBbexvOJotcGe9LKlj9PftuugqOz
X-Proofpoint-ORIG-GUID: YY4_RBbexvOJotcGe9LKlj9PftuugqOz

Add support to virtio-mmio devices for handling the extra data sent from
the driver to the device when the VIRTIO_F_NOTIFICATION_DATA transport
feature has been negotiated.

The extra data that's passed to the virtio-mmio device when this feature
is enabled varies depending on the device's virtqueue layout.

The data passed to the virtio-mmio device is in the same format as the
data passed to virtio-pci devices.

Tested-by: Lei Yang <leiyang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio-mmio.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
index 22f9fbcf5a..f99d5851a2 100644
--- a/hw/virtio/virtio-mmio.c
+++ b/hw/virtio/virtio-mmio.c
@@ -248,6 +248,7 @@ static void virtio_mmio_write(void *opaque, hwaddr offset, uint64_t value,
 {
     VirtIOMMIOProxy *proxy = (VirtIOMMIOProxy *)opaque;
     VirtIODevice *vdev = virtio_bus_get_device(&proxy->bus);
+    uint16_t vq_idx;
 
     trace_virtio_mmio_write_offset(offset, value);
 
@@ -407,8 +408,12 @@ static void virtio_mmio_write(void *opaque, hwaddr offset, uint64_t value,
         }
         break;
     case VIRTIO_MMIO_QUEUE_NOTIFY:
-        if (value < VIRTIO_QUEUE_MAX) {
-            virtio_queue_notify(vdev, value);
+        vq_idx = value;
+        if (vq_idx < VIRTIO_QUEUE_MAX) {
+            if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
+                virtio_queue_set_shadow_avail_data(vdev, value);
+            }
+            virtio_queue_notify(vdev, vq_idx);
         }
         break;
     case VIRTIO_MMIO_INTERRUPT_ACK:
-- 
2.39.3

