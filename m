Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90D430648
	for <virtio-fs@lists.linux.dev>; Wed, 13 Mar 2024 11:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710330878; cv=none; b=Ykssh2B1Y6lxyLTBO6KhMBqFBlLOxo2jMm9wolSkQdCE2vYuYQFdEHZP46YUh4EdceA6IJ4l8cj8fDiOK7x2x14LxeNTj+UWio+H8ywH55deqz0kI3uOjfd4qTGy//0qD2yGSFubHuCnIyY6NwRnrWghKunKheSWdq4Dp5lxVN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710330878; c=relaxed/simple;
	bh=N/1p3AnkgKQqNeGDXOsjoBUL+xA9uuLfLy9CQbYoXiM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n1zeXJ4d3aFBxcg+yTuI6rgqhVWdd841oR3TC9MPtuz6pRSHViOT5HAXX45QoggT06T+QnjLZgdqhzm73gKtflVeFwMxuknqAJKT4ZDQ4MsbZW/tdA/BGSmCBTkDj3BS3TEe8foDjP8iMIK2PTYjfLnqFPjD10UIMeqhK+tT9fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A3YfGJZT; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A3YfGJZT"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42D8hf6W019449;
	Wed, 13 Mar 2024 11:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=GwgG0TlnuH60D7eYVRfGoFmyfV85hwQmxpUebEvO+p8=;
 b=A3YfGJZT/eLFi7MwgUFCqzPZdcOAHsHr9PQbBjccvPoogn24hua6Ht2jW+ynuvG5U0h1
 GDKJHHt6KR6Ny4NUvOS0oJwBj6MsRuaxj+011qTbTDdTqUFrQzHf9IFee0D0TCbuLET1
 5Lo99rvyHwnhYl51Tjh1rd6OuLiEbkTXjKUTJl8q9yY4+PSoJPWTNQ7CuhERNhGWb5FA
 seRtrdP0/1QBM5MFZ6HU3cysC9jrCb0xTIDlMVpCR4iNHuAB4t+nXSGHXzXWEgdNNOBy
 v6YZsLT70zv8dqTSE4BMlYYvHwDlwUe0PuxDka52uiITkWgnwkk6Et0eKfYP7Gl/wNTr OA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrej40u29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 11:54:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42DB3uA0028601;
	Wed, 13 Mar 2024 11:54:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre78pek4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 11:54:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42DBsMLh035677;
	Wed, 13 Mar 2024 11:54:29 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-201-251.vpn.oracle.com [10.39.201.251])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wre78peed-5;
	Wed, 13 Mar 2024 11:54:29 +0000
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
Subject: [PATCH v2 4/6] virtio-ccw: Handle extra notification data
Date: Wed, 13 Mar 2024 07:54:10 -0400
Message-Id: <20240313115412.3334962-5-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240313115412.3334962-1-jonah.palmer@oracle.com>
References: <20240313115412.3334962-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-13_07,2024-03-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403130089
X-Proofpoint-GUID: Y7Qb_3RDelyYiR254eLElqUMlHZI28YZ
X-Proofpoint-ORIG-GUID: Y7Qb_3RDelyYiR254eLElqUMlHZI28YZ

Add support to virtio-ccw devices for handling the extra data sent from
the driver to the device when the VIRTIO_F_NOTIFICATION_DATA transport
feature has been negotiated.

The extra data that's passed to the virtio-ccw device when this feature
is enabled varies depending on the device's virtqueue layout.

That data passed to the virtio-ccw device is in the same format as the
data passed to virtio-pci devices.

Tested-by: Lei Yang <leiyang@redhat.com>
Acked-by: Eric Farman <farman@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/s390x/s390-virtio-ccw.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index b1dcb3857f..7631e4aa41 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -140,9 +140,11 @@ static void subsystem_reset(void)
 static int virtio_ccw_hcall_notify(const uint64_t *args)
 {
     uint64_t subch_id = args[0];
-    uint64_t queue = args[1];
+    uint64_t data = args[1];
     SubchDev *sch;
+    VirtIODevice *vdev;
     int cssid, ssid, schid, m;
+    uint16_t vq_idx = data;
 
     if (ioinst_disassemble_sch_ident(subch_id, &m, &cssid, &ssid, &schid)) {
         return -EINVAL;
@@ -151,12 +153,18 @@ static int virtio_ccw_hcall_notify(const uint64_t *args)
     if (!sch || !css_subch_visible(sch)) {
         return -EINVAL;
     }
-    if (queue >= VIRTIO_QUEUE_MAX) {
+
+    if (vq_idx >= VIRTIO_QUEUE_MAX) {
         return -EINVAL;
     }
-    virtio_queue_notify(virtio_ccw_get_vdev(sch), queue);
-    return 0;
 
+    vdev = virtio_ccw_get_vdev(sch);
+    if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
+        virtio_queue_set_shadow_avail_data(vdev, data);
+    }
+
+    virtio_queue_notify(vdev, vq_idx);
+    return 0;
 }
 
 static int virtio_ccw_hcall_early_printk(const uint64_t *args)
-- 
2.39.3

