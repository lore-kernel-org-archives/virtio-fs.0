Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164317A70E
	for <virtio-fs@lists.linux.dev>; Mon,  4 Mar 2024 19:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709581592; cv=none; b=vGYhjEe0oNmi7/MzbQ/HlEueb/3Ueb0tja7XIzve/Jm0ELdpbaCqkQz0MBxK5kwjB0peiyAvG87UsmAk1UlYFUhvH8A7kt8wtgcTmQtN3ENk/SFYSFV41EE6gwueT4zSoGgSuyoW1jwqNPE1ilyYtu9FgomHj1kevZNhazrJpL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709581592; c=relaxed/simple;
	bh=4YkSJAhDahm/E2Vx0NgtsaG9JWhvaCbryHf6O17LrIg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DOrBVhcDR5OOHE2Kn6CCnarwSqDCwsoUQTQI/9FXO/aEUZ79t+isIe/3BqynsxWrBxvnyXzuIrfXmNaYJ3ZnZZVaJWBJrQpMLabF+Fk50dH8YbD/B9m+ucq33xB9zy0z7tgccTfvTBKjv155RzeBA7noI2PGacVRv8FfGn83Hmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nIep78jk; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nIep78jk"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 424IxPx3031757;
	Mon, 4 Mar 2024 19:46:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=vo+WKV8MbQsrraREtNwMhTK5ldGUsUpxzAUuyWTmxR0=;
 b=nIep78jkuKQc4BI0nOSnTk/ZsmA0+SlWVLJ4O48RWf1iEI47Kmb/uTzL0Sl3ZUWTIS43
 Wtf7AgHV808nLgSM7DauPkWK2jsGhktrqpmuAW+AxyPfcNmST5+sJzviENRMh6sCsB9X
 igKIOBIpA7jG6c/UoHH6Y4U0CGsiG+joTt/NBoPqdKRZ0fMc1RY9DvtPlcmTqR1evoGO
 3El/MElIFVxKVS9W8/uVPyz6K1XxEXvUYgqpbC9cgvYE+d/10Z6WWBolI9xsZ7x4ILSg
 b2ixUuPPy5gzWXqC/zgJWs6ro60okEwZxs8gQ+YHkwj6znJ8iP7RNXoNc0Sa09HZrkNc vw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkthecmun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 19:46:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 424JZhDW019056;
	Mon, 4 Mar 2024 19:46:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wktj6agd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 19:46:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 424JkE4A038523;
	Mon, 4 Mar 2024 19:46:23 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-196-188.vpn.oracle.com [10.39.196.188])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wktj6ag50-7;
	Mon, 04 Mar 2024 19:46:23 +0000
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
Subject: [PATCH v1 6/8] virtio-ccw: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
Date: Mon,  4 Mar 2024 14:46:10 -0500
Message-Id: <20240304194612.611660-7-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240304194612.611660-1-jonah.palmer@oracle.com>
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-04_15,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403040152
X-Proofpoint-ORIG-GUID: LBnr6GJBu_KScHSE82TyjDoNEH_nSzuI
X-Proofpoint-GUID: LBnr6GJBu_KScHSE82TyjDoNEH_nSzuI

Prevent ioeventfd from being enabled/disabled when a virtio-ccw device
has negotiated the VIRTIO_F_NOTIFICATION_DATA transport feature.

Due to the ioeventfd not being able to carry the extra data associated
with this feature, the ioeventfd should be left in a disabled state for
emulated virtio-ccw devices using this feature.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/s390x/virtio-ccw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/hw/s390x/virtio-ccw.c b/hw/s390x/virtio-ccw.c
index b4676909dd..936ba78fda 100644
--- a/hw/s390x/virtio-ccw.c
+++ b/hw/s390x/virtio-ccw.c
@@ -530,14 +530,16 @@ static int virtio_ccw_cb(SubchDev *sch, CCW1 ccw)
             if (ret) {
                 break;
             }
-            if (!(status & VIRTIO_CONFIG_S_DRIVER_OK)) {
+            if (!(status & VIRTIO_CONFIG_S_DRIVER_OK) &&
+                !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
                 virtio_ccw_stop_ioeventfd(dev);
             }
             if (virtio_set_status(vdev, status) == 0) {
                 if (vdev->status == 0) {
                     virtio_ccw_reset_virtio(dev);
                 }
-                if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
+                if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
+                    !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
                     virtio_ccw_start_ioeventfd(dev);
                 }
                 sch->curr_status.scsw.count = ccw.count - sizeof(status);
-- 
2.39.3

