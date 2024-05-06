Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC313154448
	for <virtio-fs@lists.linux.dev>; Mon,  6 May 2024 15:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715007888; cv=none; b=fxZApVi8SY9dI04+TeAxUT9w00+KvTmQezOLDY7bjIEIGOFiZqUCTP7GoqfCBNE4z0IKWC/mGk04+npLTsFZkdQAUJOxg0kxYsJktiaJlxW5vcEV16WW7JkhNy30KVe2mHHnpjIDM+N8VokVRzwe5EkUBYRMFgyzuCxGpumCgig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715007888; c=relaxed/simple;
	bh=if9/+ZOlLlnifr5OS3PuWII5DUHpaf8eR1m/PwqEYbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A/H62G20UZQVeY5Q086J9Mhjmvzai1mUIjomIy55/Qy+Zq7s5RuDyJFQWtUuRBfIjGAMTZkaY967gJifizLy62NPOPPc/LtTgrxVY/4BSaEqKew9yU6JfP0w4Fm+k0lwwbVn+11AOGNkh9jBI6uKVPJ5IG2kd13vxsMsmJ4Fdwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kIi0LkSo; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kIi0LkSo"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446AnARK031879;
	Mon, 6 May 2024 15:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=XK8FpfVa3AtG1crGS3Ap2YXMGsjEuRPSdPZw6tCz1sY=;
 b=kIi0LkSoCMo/vDIFkyHYC1Oz5j3GgKe5VOtHZCdmmgGM3pfJoj19L4l/I09Mk62BXLpY
 wnF7irNsSp/OZCIHolPiBLxSVQXTPC+Zhjhihj+kdvDurscsOMNvjvOcR7tUR1aoGdu0
 8DlFNON0Wzl8WWfYXRN6vm/iXpvuQrDzOMLFLZgQXGd7hn5EIDZFpP73bIet+3Xcp+hW
 O10APPcZmtM+vXrpoqJiQzh4TXvv22WRxZXHovuZ0XhvNg9LYgcJ5sVDetSo41ovMmih
 JWu2fkvLlXPn2ugOTaw1FQLzSAA4MmCS96tgZxIA+vpSxJJU1tqTK8kOsveXcFpl9q4l Yg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbt52txy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 15:04:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446DmJWt006938;
	Mon, 6 May 2024 15:04:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf6rwfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 15:04:39 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446F4ZlJ002521;
	Mon, 6 May 2024 15:04:38 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-221-117.vpn.oracle.com [10.39.221.117])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf6rw8e-2;
	Mon, 06 May 2024 15:04:38 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH 1/6] virtio: Add bool to VirtQueueElement
Date: Mon,  6 May 2024 11:04:23 -0400
Message-Id: <20240506150428.1203387-2-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240506150428.1203387-1-jonah.palmer@oracle.com>
References: <20240506150428.1203387-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_09,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060104
X-Proofpoint-GUID: 88Sq-Vmd6BqG5eTpR8_8CMs2FPj2uMju
X-Proofpoint-ORIG-GUID: 88Sq-Vmd6BqG5eTpR8_8CMs2FPj2uMju

Add the boolean 'filled' member to the VirtQueueElement structure. The
use of this boolean will signify if the element has been written to the
used / descriptor ring or not. This boolean is used to support the
VIRTIO_F_IN_ORDER feature.

Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 include/hw/virtio/virtio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 7d5ffdc145..9ed9c3763c 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -69,6 +69,7 @@ typedef struct VirtQueueElement
     unsigned int ndescs;
     unsigned int out_num;
     unsigned int in_num;
+    bool filled;
     hwaddr *in_addr;
     hwaddr *out_addr;
     struct iovec *in_sg;
-- 
2.39.3

