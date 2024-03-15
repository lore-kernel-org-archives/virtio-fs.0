Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB441E4A1
	for <virtio-fs@lists.linux.dev>; Fri, 15 Mar 2024 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710521782; cv=none; b=fVeNx/p6iCRmwJtHOY1bU6ReK2jrhSYKF3qsW1QQlsaT52BsKvhyUidLc+IaXUu8pWhax4N5FzvjCLgXp3OYSXfJw8LuXer+6xBXrVP52OMuwHz4ekEMWNhwCW88SbJ4AaYOJkB0D8AMFvqNLgG46sjlyLofoFWvD3KuZ9sgcBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710521782; c=relaxed/simple;
	bh=5gNkN/ZVve2alnWmMeRI7Ryxmp/hqac233d5lfIsLLA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PA7Ya8L8iUBfn2w23oKNWseNAOSmHngpppznO9SKEmulUatgYdczQ9aYkWSNMkxelv5+omfftp4rJi/dhRLkiBU/QEP/qPrYsI1R8IIaBFVo/yjqCpHOAT0FkeoYemoutgsTxwZ7C79atzYHl39MJ9PGnlwyhIZMkaWEnAMzfDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aNBNhCrr; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aNBNhCrr"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42FGThns025773;
	Fri, 15 Mar 2024 16:56:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=sR1crN2CzKAFAWgclT2WvEqQdvGRuw/q1764CLLmtBA=;
 b=aNBNhCrrJVfcXlgELlYKUSh5DMe+eNcmFxGI9O2rUn4bQza9UaGhm/Cmnjmhi7/hLYIw
 K0mpC0g8HX/YcHTWU1oPmJGDQKKEK9i9Uh5HmOb6QFaZ1vQnBjVR9kptSwvMwUytg9BZ
 +SfPzX5CNtG1B8eOyAMHzrVnTjoED6DvNA5bRIBQXjt0fxJf8Hojfx/TZ1Kiqpzuqnsb
 3p2SaHuAtzl1rKVnVWPkyGm4sxFhyVjh3aMZEClaNztqIAhdZP5jXXCY5K1arp8Rs3XI
 VjaVkmKEMPglOrM1ZQ4MaBENRFCUw7QjhOdAoELeRuKBP3ehOVBr6L8mavPGWJMtSC4x Cw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wvswbg1gf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Mar 2024 16:56:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42FFfW87033837;
	Fri, 15 Mar 2024 16:56:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7bw7qk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Mar 2024 16:56:11 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42FGu2YS039399;
	Fri, 15 Mar 2024 16:56:10 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-177-130.vpn.oracle.com [10.65.177.130])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3wre7bw7fq-3;
	Fri, 15 Mar 2024 16:56:10 +0000
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
Subject: [PATCH v3 for 9.1 2/6] virtio: Prevent creation of device using notification-data with ioeventfd
Date: Fri, 15 Mar 2024 12:55:53 -0400
Message-Id: <20240315165557.26942-3-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: r_CuvngZvy7hwv8JQSY7SmuPtD9DjpEW
X-Proofpoint-ORIG-GUID: r_CuvngZvy7hwv8JQSY7SmuPtD9DjpEW

Prevent the realization of a virtio device that attempts to use the
VIRTIO_F_NOTIFICATION_DATA transport feature without disabling
ioeventfd.

Due to ioeventfd not being able to carry the extra data associated with
this feature, having both enabled is a functional mismatch and therefore
Qemu should not continue the device's realization process.

Although the device does not yet know if the feature will be
successfully negotiated, many devices using this feature wont actually
work without this extra data and would fail FEATURES_OK anyway.

If ioeventfd is able to work with the extra notification data in the
future, this compatibility check can be removed.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 hw/virtio/virtio.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 463426ca92..f9cb8d1e5c 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -2971,6 +2971,20 @@ int virtio_set_features(VirtIODevice *vdev, uint64_t val)
     return ret;
 }
 
+static void virtio_device_check_notification_compatibility(VirtIODevice *vdev,
+                                                           Error **errp)
+{
+    VirtioBusState *bus = VIRTIO_BUS(qdev_get_parent_bus(DEVICE(vdev)));
+    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(bus);
+    DeviceState *proxy = DEVICE(BUS(bus)->parent);
+
+    if (virtio_host_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA) &&
+        k->ioeventfd_enabled(proxy)) {
+        error_setg(errp,
+                   "notification_data=on without ioeventfd=off is not supported");
+    }
+}
+
 size_t virtio_get_config_size(const VirtIOConfigSizeParams *params,
                               uint64_t host_features)
 {
@@ -3731,6 +3745,14 @@ static void virtio_device_realize(DeviceState *dev, Error **errp)
         }
     }
 
+    /* Devices should not use both ioeventfd and notification data feature */
+    virtio_device_check_notification_compatibility(vdev, &err);
+    if (err != NULL) {
+        error_propagate(errp, err);
+        vdc->unrealize(dev);
+        return;
+    }
+
     virtio_bus_device_plugged(vdev, &err);
     if (err != NULL) {
         error_propagate(errp, err);
-- 
2.39.3

