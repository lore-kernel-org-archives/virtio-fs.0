Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C703F9E8
	for <virtio-fs@lists.linux.dev>; Wed, 13 Mar 2024 11:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710330898; cv=none; b=aZTWvxdpPyGcOcax8lnwSK4PAUm95Y+0Lyrep6FRxWTztqkwjiJIWYbOH5n5mubfMS+L7NC1xhzjNJeg4gvDb+js9Y77f0EWSa31qxXmf34aVLO0vgIYB7g3Z5/qldAisdXgemCGlyWuAvmSUnwEjEnrYcwQUGbYaOmVUgVWvHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710330898; c=relaxed/simple;
	bh=tGFR0cPeCM+y9Ew9WQB4eM6I2OuSxhBk4w7YXz3Q94g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UC+E1pgAwvh3FurC/rkh9UWCgJ0QWYANZrilwL9Up6VC+Zx8YEbJR/VasYwqeJru8mPhrN9CL64ctVZ2q1zavUcCl/nkp/vNL0ujBVdL+3ynVuG0ZqSvcQciVpTrCoBPdM/nhv1Kxd25QFd+1CDRl/fUKDAGkmzRuWz9lOEQfT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=as4hq7PM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="as4hq7PM"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42D8hujL026182;
	Wed, 13 Mar 2024 11:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=HqPyfwcQ2lB/oNBKBHMpT4OFfacUPTTZLXA2EpsRmuA=;
 b=as4hq7PMb2zAf4aTIxqGlxjMgKFxNqvunHwOIjFtAYnx4RNQhZn8b7eVz7VsztfC1A9q
 7gKTtM19kOYKB7xBAKeQhq3vHb+3EynDhE01yBYQINIKeg0BHkdLxRsBRIu/7aLB2tTU
 Y9d5ITLEZFPaax9H04o0sCa+sZjpbN2dfrHONlPRisN5vqmf9n4WkMxNoOqhDBCmHXqD
 oQbqz2AMUsgspphIJVFiP7SVt/k1kEhurC0fWwHN278Yd5572v3DUtF3KviOwrLYE5Qk
 4sjvlA+J2xceaG7CEC7cjT7XYISPmAPL4pnAgdmRcGbezO3eG8ceNX0pQcwLsuZfHofX qQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrfcugtnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 11:54:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42DB7iIG028530;
	Wed, 13 Mar 2024 11:54:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre78peky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 11:54:33 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42DBsMLl035677;
	Wed, 13 Mar 2024 11:54:32 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-201-251.vpn.oracle.com [10.39.201.251])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wre78peed-7;
	Wed, 13 Mar 2024 11:54:32 +0000
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
Subject: [PATCH v2 6/6] virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition
Date: Wed, 13 Mar 2024 07:54:12 -0400
Message-Id: <20240313115412.3334962-7-jonah.palmer@oracle.com>
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
X-Proofpoint-ORIG-GUID: dePHz2xRINpsiO0rP4jx9wsf-5yeV4GT
X-Proofpoint-GUID: dePHz2xRINpsiO0rP4jx9wsf-5yeV4GT

Extend the virtio device property definitions to include the
VIRTIO_F_NOTIFICATION_DATA feature.

The default state of this feature is disabled, allowing it to be
explicitly enabled where it's supported.

Tested-by: Lei Yang <leiyang@redhat.com>
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 include/hw/virtio/virtio.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index e0325d84d0..bc54c5e037 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -371,7 +371,9 @@ typedef struct VirtIORNGConf VirtIORNGConf;
     DEFINE_PROP_BIT64("packed", _state, _field, \
                       VIRTIO_F_RING_PACKED, false), \
     DEFINE_PROP_BIT64("queue_reset", _state, _field, \
-                      VIRTIO_F_RING_RESET, true)
+                      VIRTIO_F_RING_RESET, true), \
+    DEFINE_PROP_BIT64("notification_data", _state, _field, \
+                      VIRTIO_F_NOTIFICATION_DATA, false)
 
 hwaddr virtio_queue_get_desc_addr(VirtIODevice *vdev, int n);
 bool virtio_queue_enabled_legacy(VirtIODevice *vdev, int n);
-- 
2.39.3

