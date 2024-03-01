Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACC16D1D8
	for <virtio-fs@lists.linux.dev>; Fri,  1 Mar 2024 13:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709300627; cv=none; b=d+mjuprfiKxu5GxJiwnITcq9dHvlBDy6+9jfCOlC8i0y6Ca3l0HFMf8adegAWx+TEPCKZ+/EdQ800uCwxRigXsWbwiwsv87e1rPTbOMJ8nQ2n+8rfAnxHOabf8qrPD77Jfx5VGQtEdsBeujNWgBuZwUxAz6PX4D0k/VcGbXykSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709300627; c=relaxed/simple;
	bh=QJrjjTVu2mx0hn4Cb7gDf/iiiZNqvTdyOi0sZnVEtjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hYZclCSq6cvnbpF2tZQB+oij0tKQyiKIjQ0Pvs1LPqHVwSPqPMmvIT+zA621T4i3Rx0euqcMlmsfaucAHdmKcq5A/Ae2O0TyTgJ90rB0ajREKkVhIje0p5F1plCgXMZ5wByfukbMjMqVcb+2xpRxOwvV78VYCOBGa8+1DiCNgnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IzsrzUj4; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IzsrzUj4"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4219Cgxq008866;
	Fri, 1 Mar 2024 13:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=YJCE5QKH769zOpMAk8sLNZG3G7yDrb7IR4KgiZTFWRQ=;
 b=IzsrzUj44gybyCr2teyvjpKfyYcFB8jQGmq1efI0fV3YJfQSVfXE7nDCTM2FuYf63T1n
 ZeBJ+jaJL/4X+WipoTyqQjb1NSxsSQfKpu/YG1celK6iZ9EoMybKmmkpl8hL/O31Juj3
 /pFywVLUbYlbmQlZLnNwNIG/ivBu4VmIA5ICXF6Wc0hK0+n6kh8kMFitUGWLrNKi5GMd
 PepINFB+KfrkDQe0itYKu9MKPGjWIyuPIwayqvvkbCThjYLQya1KLw2EqZHqSMPaL9gf
 rT87K8NdZxavoTfqzX7wwmY+W1M6NckC+vTeanwhwENxTXq2vDi0QkSwfXhDMTWD145M TQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf6ve8rcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 13:43:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 421C8Xix009723;
	Fri, 1 Mar 2024 13:43:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wjrqmtrc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 13:43:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 421DhWAM026578;
	Fri, 1 Mar 2024 13:43:35 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-160-211.vpn.oracle.com [10.65.160.211])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wjrqmtr9m-3;
	Fri, 01 Mar 2024 13:43:35 +0000
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
Subject: [RFC 2/8] virtio-pci: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
Date: Fri,  1 Mar 2024 08:43:24 -0500
Message-Id: <20240301134330.4191007-3-jonah.palmer@oracle.com>
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
X-Proofpoint-ORIG-GUID: bEMTRdtK5TMTQFef8TAicbmcbLd6UIIi
X-Proofpoint-GUID: bEMTRdtK5TMTQFef8TAicbmcbLd6UIIi

Prevent ioeventfd from being enabled/disabled when a virtio-pci
device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
feature.

Due to ioeventfd not being able to carry the extra data associated with
this feature, the ioeventfd should be left in a disabled state for
emulated virtio-pci devices using this feature.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio-pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index c7c577b177..fd9717a0f5 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -420,13 +420,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
         }
         break;
     case VIRTIO_PCI_STATUS:
-        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
+        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
+            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
             virtio_pci_stop_ioeventfd(proxy);
         }
 
         virtio_set_status(vdev, val & 0xFF);
 
-        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
+        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
+            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
             virtio_pci_start_ioeventfd(proxy);
         }
 
-- 
2.39.3

