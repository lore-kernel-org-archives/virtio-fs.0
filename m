Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567516D50A
	for <virtio-fs@lists.linux.dev>; Fri,  1 Mar 2024 13:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709300631; cv=none; b=S6ZdvLAmCvFCh6EUvF+kreXKns4Mjx8dEuXsoPui3vbi6pBdpTYMHfH3VXWVBGeJNZJve0QtVCCp6G+sZQ82cmUqHxsk3UD0oEOD4TLiKpEKZm90H2NVuxc2cq1zgPJLCDZYX661cfMseJ6t80tJt3SmklPSOGH7aWXBu+2rpuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709300631; c=relaxed/simple;
	bh=3xlqIrmQ7Y4ImR8SZT2tWHUmDgUrDSGyd93HJPN3p2o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LlTEuQ+eQwDRR3f8KyHgD3R8a+cRdJiPpDzmEaSYLAY0QWvgUEBngX8C8lg/GXMHYRPSIV3cPxNMf+Ax5201u39wl6jd/I5mXgEG9dVCTg+hTjooILo4KO/jYF8VjmIMX1WWH1gVF1yA6OtdvC17iml7Fcex2TwbBEJ84o9Oyyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dqGR18j4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dqGR18j4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4219ENqX018244;
	Fri, 1 Mar 2024 13:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=y0aq9S1lE+cQUzIKGkMXtJt2IAiv3F5q9jt5OURo9Z8=;
 b=dqGR18j42KPwyeiGh59bpvciw7myuQo3qTkllMC4P/vVkc27Ht2ih4cl3+b40lUT6XeU
 LdxywXg4kDfAzy2Frgq4eAAFhhft6cCueFoe4ARqHMTnDplpfQEzbwr9ZAGCFJYq83tO
 KfX9bq/a0bHx8w2d3+vkmnJSZ7dEr2NUPgSSHY760gFhLmT7VSMrP9eMmmGNr1UqBKOx
 IiXyLu6TpfpUrpxydouvHdPrTB5b+MkhfzIm6YoSz/t+jnuy2tx8pVIHGYB3EM/5mcBd
 eklubMtdvyNrps/iZD4dB57gd58vwnoN9Pq1qYxUKU45z2R0g6lSLJPGlyZkW88JdShB 6Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf7ccrwsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 13:43:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 421D1Oa4009437;
	Fri, 1 Mar 2024 13:43:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wjrqmtrg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 13:43:41 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 421DhWAU026578;
	Fri, 1 Mar 2024 13:43:41 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-160-211.vpn.oracle.com [10.65.160.211])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wjrqmtr9m-7;
	Fri, 01 Mar 2024 13:43:40 +0000
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
Subject: [RFC 6/8] virtio-ccw: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
Date: Fri,  1 Mar 2024 08:43:28 -0500
Message-Id: <20240301134330.4191007-7-jonah.palmer@oracle.com>
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
X-Proofpoint-ORIG-GUID: 2p271CibnjvuBt7paDG8dzV2B62N_fQx
X-Proofpoint-GUID: 2p271CibnjvuBt7paDG8dzV2B62N_fQx

Prevent ioeventfd from being enabled/disabled when a virtio-ccw device
has negotiated the VIRTIO_F_NOTIFICATION_DATA transport feature.

Due to the ioeventfd not being able to carry the extra data associated
with this feature, the ioeventfd should be left in a disabled state for
emulated virtio-ccw devices using this feature.

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

