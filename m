Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03661B29D0
	for <virtio-fs@lists.linux.dev>; Thu, 20 Jun 2024 17:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906184; cv=none; b=c8uxnncq8dpYwZ0ZdDmv1CRCVYXIML8k0EvRodB3tTDzBSARohtS0jMZf1+TnSLDcikIrIjqbx29xZPnBSvoVEz5M+kvQUyEaRxAZN3h7/z+x1NzGGUnekCxhxzL02D0WahDw7Wun/5t08BbVv1tfd4VbHEDs2TywVMs3aawr7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906184; c=relaxed/simple;
	bh=In8HIDwCQ/IeOd+IvnBaFGerd233TPIbqJod/nwLekY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gOhgoMfFAXXWRqEPiA3DrZBhIYGDSPaQ7iiR9N643iqOA1rAb0l2K7c93XzmlFo9QxUPKFvVcaScwC+fghkKZlTp9/6RARJ7frO+itlGw/i36iqOzWYq+nfnHCQ3OGmCWW4MRruTgFLv7CXnT6HnVcN4vyuN3bXCBhVYCQO0hd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BQc9up/h; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BQc9up/h"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KHBE9N009932;
	Thu, 20 Jun 2024 17:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=Ruoq4mzFtSbpITTmSuf/2nbMLCt4aZZ3QgcDa2FBjtc=; b=
	BQc9up/hh3/K57luO/1Ub0Hct7k7V9UZBCUaqV0PzAhVZi86/x73ig3htHxOkEyw
	M89oTBuGlYmWo9YCRoNGpIKo+DTcZnG5Vyj2uS1STSdeaUwEsfd3r6Qw4UUxQDwb
	1UlYOLs1CbmsjXbNBj2F9hpQPqfnUwKY+wIYvyxA5qUnBn4KSlsavrIu9xO3tbig
	W8CCtTzrw4YEp8MQ8faKm9VLIwE/hQlPpqnJXoJrKqK8qlW/TlmX1ziM19k05s3L
	gmrwd8woenLSrHvXB8+NjMj+aARaFVCqjpqFMwUscgnFE4QsvMjPIkR3Y9Tor5Uu
	uhObv3slimRmSfGQ32qGRw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrkj02y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:56:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KHDq1M012839;
	Thu, 20 Jun 2024 17:56:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrn3hnn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:56:18 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45KHuF0l018715;
	Thu, 20 Jun 2024 17:56:17 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-208-85.vpn.oracle.com [10.39.208.85])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3yvrn3hnjv-2;
	Thu, 20 Jun 2024 17:56:17 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v3 1/6] virtio: Add bool to VirtQueueElement
Date: Thu, 20 Jun 2024 13:56:05 -0400
Message-ID: <20240620175612.2381019-2-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620175612.2381019-1-jonah.palmer@oracle.com>
References: <20240620175612.2381019-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_08,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406200129
X-Proofpoint-GUID: zFwlHnY2873VGJ9rNFVhRZcfwD2YJc4B
X-Proofpoint-ORIG-GUID: zFwlHnY2873VGJ9rNFVhRZcfwD2YJc4B

Add the boolean 'in_order_filled' member to the VirtQueueElement structure.
The use of this boolean will signify whether the element has been processed
and is ready to be flushed (so long as the element is in-order). This
boolean is used to support the VIRTIO_F_IN_ORDER feature.

Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
---
 include/hw/virtio/virtio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 7d5ffdc145..88e70c1ae1 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -69,6 +69,8 @@ typedef struct VirtQueueElement
     unsigned int ndescs;
     unsigned int out_num;
     unsigned int in_num;
+    /* Element has been processed (VIRTIO_F_IN_ORDER) */
+    bool in_order_filled;
     hwaddr *in_addr;
     hwaddr *out_addr;
     struct iovec *in_sg;
-- 
2.43.0

