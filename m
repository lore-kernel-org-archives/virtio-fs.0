Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55E112BE85
	for <virtio-fs@lists.linux.dev>; Thu, 21 Mar 2024 15:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036657; cv=none; b=g6uEH3QVgweG2wBtDnsq1aWslKMWg2y7+KMh1t58lL0UGtqpbk9lxHFQ7uyrI+75wA5wfCW6+Dk7e9X7UfXwug6xVppS8ghkmaREt41LPHUxWSIbCs0t86fOEI3Fw1fYN5vu5+/lKoJfaqUPkrfcW50K094FQ6/PgBEFRm8vp0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036657; c=relaxed/simple;
	bh=Xqej0An8leBxQ9qr/uUoLL5w72S2aXoqh6OjxQuHqrg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hs9/97LoXkDKMeG6lKakO1AyD6HDnzzLIRahAzLMEpwI70axWullg6O6GGq7M0bWFCVC2+jcXrHWVuZBt53/fM2vddRKp8eLNsERTJQFadWkSlcBh37RoHIX0mplnzAdpXpUOAuBFz0bXJ3pnWxAMszUckh0Q6uI0V8bx+VBUe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bdiosN7Y; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bdiosN7Y"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42LCmOn8011468;
	Thu, 21 Mar 2024 15:57:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=kHHLzNZpzFwG0begk9NZBoke/5eS3mm7ATo9SrgfNeA=;
 b=bdiosN7YLlRn9aaU5ng/Tx6/1uCbfP7ALACL+3riiuaXP6NGc/fJ4Ug0/e59xzl+MdCY
 DLzbXqYCEi19gJTbPG/+rN9VQMufSpfXEt92k41NSSzfXIUKM/yTJJAjnKnDXSgSa2Qa
 qmgMe1dKpj8FJXMlfJ0siSiZThZyECXpZy8wG95HWgAJaUzfR9mymdhrz5fzPAh6Uwmj
 ZzJALVho7AKvo6NRNlJit9c5W8LXtkZOsusNJLBH26Fm9s74EY5uEDBYaOrmos/iajNO
 Qgf/VB+MMgs8ARxQcfhBXTPvMkjOPwJrCq7/m66aIkK8d9R25iGXGEIFXMSxvzfCrB1p 9Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww31ttvmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42LFbqJj006204;
	Thu, 21 Mar 2024 15:57:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1v9q1ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:30 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42LFsWZW005094;
	Thu, 21 Mar 2024 15:57:30 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-211-118.vpn.oracle.com [10.39.211.118])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ww1v9q1p9-9;
	Thu, 21 Mar 2024 15:57:30 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC 8/8] virtio: Add VIRTIO_F_IN_ORDER property definition
Date: Thu, 21 Mar 2024 11:57:17 -0400
Message-Id: <20240321155717.1392787-9-jonah.palmer@oracle.com>
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
X-Proofpoint-ORIG-GUID: GAiVoORW16prOmtoWjJW2Ik_KZbKLRX-
X-Proofpoint-GUID: GAiVoORW16prOmtoWjJW2Ik_KZbKLRX-

Extend the virtio device property definitions to include the
VIRTIO_F_IN_ORDER feature.

The default state of this feature is disabled, allowing it to be
explicitly enabled where it's supported.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 include/hw/virtio/virtio.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index eeeda397a9..ffd78830a3 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -400,7 +400,9 @@ typedef struct VirtIORNGConf VirtIORNGConf;
     DEFINE_PROP_BIT64("packed", _state, _field, \
                       VIRTIO_F_RING_PACKED, false), \
     DEFINE_PROP_BIT64("queue_reset", _state, _field, \
-                      VIRTIO_F_RING_RESET, true)
+                      VIRTIO_F_RING_RESET, true), \
+    DEFINE_PROP_BIT64("in_order", _state, _field, \
+                      VIRTIO_F_IN_ORDER, false)
 
 hwaddr virtio_queue_get_desc_addr(VirtIODevice *vdev, int n);
 bool virtio_queue_enabled_legacy(VirtIODevice *vdev, int n);
-- 
2.39.3

