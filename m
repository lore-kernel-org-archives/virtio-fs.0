Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A2286255
	for <virtio-fs@lists.linux.dev>; Thu, 21 Mar 2024 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036650; cv=none; b=ITEVuO0M477J/XjWa9bvrKWNrRHkhbmNSjCBi1t2ZgtbeHo+Aj7shkhfP6on5Iwa8DWoPoikR00xjTHAJEH8nNTWlg2JGRQwraIx7/Ln/jGcsc8bUR3NUjic22ZRCz5WfzLobUE1tYeVsdZKrYGTEo/AMSam2DKY7O/QvPtb0U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036650; c=relaxed/simple;
	bh=+YHU+RbXIOerWbrpY933okRsjIA/9kJ1PZHnxf2TPTc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oS8hyUu3AVWkMeiy9xS97SbIERat+Tmo7kbh5TcrQpM1UCNIi9Exvt9jdXuFpoqUj4r7dpTRwgUgtRRzJmVye62al7GIGgzqma9iAs1tKhtB0WBfb3ccGyYi92ZokQTbKrGifIqdp5mh9OFj6A/xPVTWumnvKhv88ihnO+2zON0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JTNt9gdI; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JTNt9gdI"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42LCmPBi018754;
	Thu, 21 Mar 2024 15:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=EanWoxyVK4VqjMMxpNhATkCLE/Y2tEWT0jc5jQ90JFo=;
 b=JTNt9gdI2wudAG6RhMTH1mCu82PrT95PRF99+NEJIz+kOfqLfToLkW0WgFwIKMvHCdoJ
 ZoCNpA2+FbIIDbJTfUm1PvJPyYIY4i8ks50YIktTCZ6oyuUZnsMVPKqZ3E4zw3bTfVlm
 JYgKNrsbxhW47fG+29T6d7aM8QAAZSao9bNJlz5kO8awbW1yRJaaW1M4+LBW+MCyL7jV
 S2D23nT8z38X+JfMVVqe+9ph8ubRCfNd9BI9aiBvK1pBU/7dQFU5z5vWTUE7wSIKBcD5
 eXfDd24EPIBxzQVFAjUs4eGy+iNwnG5wyQFwHx6crDY9t1BWFQ+pr8tQu9Akf7uN4NlP SA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww2732wse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42LEjWpx006128;
	Thu, 21 Mar 2024 15:57:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1v9q1qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:23 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42LFsWZI005094;
	Thu, 21 Mar 2024 15:57:22 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-211-118.vpn.oracle.com [10.39.211.118])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ww1v9q1p9-2;
	Thu, 21 Mar 2024 15:57:22 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC 1/8] virtio: Define InOrderVQElement
Date: Thu, 21 Mar 2024 11:57:10 -0400
Message-Id: <20240321155717.1392787-2-jonah.palmer@oracle.com>
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
X-Proofpoint-GUID: Fnpz2AYrQczKMMh6LyDqQQIlBhCwlXPy
X-Proofpoint-ORIG-GUID: Fnpz2AYrQczKMMh6LyDqQQIlBhCwlXPy

Define the InOrderVQElement structure for the VIRTIO_F_IN_ORDER
transport feature implementation.

The InOrderVQElement structure is used to encapsulate out-of-order
VirtQueueElement data that was processed by the host. This data
includes:
 - The processed VirtQueueElement (elem)
 - Length of data (len)
 - VirtQueueElement array index (idx)
 - Number of processed VirtQueueElements (count)

InOrderVQElements will be stored in a buffering mechanism until an
order can be achieved.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 include/hw/virtio/virtio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index b3c74a1bca..c8aa435a5e 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -77,6 +77,13 @@ typedef struct VirtQueueElement
     struct iovec *out_sg;
 } VirtQueueElement;
 
+typedef struct InOrderVQElement {
+    const VirtQueueElement *elem;
+    unsigned int len;
+    unsigned int idx;
+    unsigned int count;
+} InOrderVQElement;
+
 #define VIRTIO_QUEUE_MAX 1024
 
 #define VIRTIO_NO_VECTOR 0xffff
-- 
2.39.3

