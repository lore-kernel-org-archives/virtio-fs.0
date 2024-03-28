Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505D61384AC
	for <virtio-fs@lists.linux.dev>; Thu, 28 Mar 2024 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711642936; cv=none; b=DeyhqOFO8AVDEQcm+ByqdPjhDhEBgZ3JdnA+eIy6/YAh5ISQqwGWnI89OFnBLn+0LERDIJ29wN/vKprpeNPoGHTgUb6acifw9QOnb7ViCg59BtEFc4TL+6NSgIARdL0MReAeFaQ7YUdepv38+LupUK6Ml29AbzNz1fW/aMD02pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711642936; c=relaxed/simple;
	bh=dRTT/s82kgz3TYQuHU7AppZsVOBwt5dGJEynyLAaDHM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=WXFGWewI3ARlbYRupEK6pU04R5Jk32+PPHTro0WwTJyAe0ynp5mj3d4kTefwEdZpIflRSxIyq7LTeGhZcXFUFWxbBrGsX8RvmNGLOXcdSUUcGH0P0OFAWRF5pLHIrRMEG9kBhkObIgk9Raa31DZh4MUy/dZ8Qbms10AxIFGaN/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MK1EBmFG; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MK1EBmFG"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42SFOwcE009866;
	Thu, 28 Mar 2024 16:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=PgEtuWKMOUAvpM9xrdSt8xuzu3LnYbEms/QbyUK+T28=;
 b=MK1EBmFGjrV62z1+838I4sD49qc0WCvrjH2OCguvtVAFMvJuE3JrCkx/6UPyGBg7/rwi
 XdXBBpUAjEBENtdd/cJnUVzHw3DeIXjBO7BfdMqEY8TQuFRHLSkGSSCP2Bn4cVYhRnXa
 bxklnRICgg7Bugg8ocWpMxUA8m3b17hBlSM/a6sV+zL+U7E6JOVfuKUZHNNkj5NL601v
 xpC8R6ld4TjyYYnciFlmUQT+CwCrlv1alRctSwOelWAZxAakwXrOuZ94bBcDFYMVNptm
 0idhd8CySiF/LRkPMobVrTXIvejHXh+4x4LyZq/zBbgUAawiLAib2kxFrVUwWiQyxY4Y Sw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2f6h8w73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 16:22:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42SGJgS4015057;
	Thu, 28 Mar 2024 16:22:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhgfgej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 16:22:06 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42SGM5Zt010492;
	Thu, 28 Mar 2024 16:22:05 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-220-183.vpn.oracle.com [10.39.220.183])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3x1nhgfgcy-1;
	Thu, 28 Mar 2024 16:22:05 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v2 0/5] virtio,vhost: Add VIRTIO_F_IN_ORDER support
Date: Thu, 28 Mar 2024 12:21:58 -0400
Message-Id: <20240328162203.3775114-1-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
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
 definitions=2024-03-28_15,2024-03-28_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403280111
X-Proofpoint-GUID: oucljQ9tiMwiadp9WyAlYB9IjQY3RhJR
X-Proofpoint-ORIG-GUID: oucljQ9tiMwiadp9WyAlYB9IjQY3RhJR

The goal of these patches is to add support to a variety of virtio and
vhost devices for the VIRTIO_F_IN_ORDER transport feature. This feature
indicates that all buffers are used by the device in the same order in
which they were made available by the driver.

These patches attempt to implement a generalized, non-device-specific
solution to support this feature.

The core feature behind this solution is a buffer mechanism in the form
of a VirtQueue's used_elems VirtQueueElement array. This allows devices
who always use buffers in-order by default to have a minimal overhead
impact. Devices that may not always use buffers in-order likely will
experience a performance hit. How large that performance hit is will
depend on how frequent elements are completed out-of-order.

A VirtQueue whose device who uses this feature will use its used_elems
VirtQueueElement array to hold used VirtQueueElements. The index that
used elements are placed in used_elems is the same index on the
used/descriptor ring that would satisfy the in-order requirement. In
other words, used elements are placed in their in-order locations on
used_elems and are only written to the used/descriptor ring once the
elements on used_elems are able to continue their expected order.

To differentiate between a "used" and "unused" element on the used_elems
array (a "used" element being an element that was already written to the
used/descriptor ring and an "unused" element being an element that
wasn't), we use an element's in_num and out_num values. If the sum of
these two values is greater than 0, the element is considered unused. If
the sum is 0, then the element is considered used and invalid. When we
find an order and write the element to the used/descriptor ring, we set
these two values to 0 to indicate that it's been used.

---
v2: Use a VirtQueue's used_elems array as a buffer mechanism

v1: Implement custom GLib GHashTable as a buffer mechanism

Jonah Palmer (5):
  virtio: Initialize sequence variables
  virtio: In-order support for split VQs
  virtio: In-order support for packed VQs
  vhost,vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
  virtio: Add VIRTIO_F_IN_ORDER property definition

 hw/block/vhost-user-blk.c    |   1 +
 hw/net/vhost_net.c           |   2 +
 hw/scsi/vhost-scsi.c         |   1 +
 hw/scsi/vhost-user-scsi.c    |   1 +
 hw/virtio/vhost-user-fs.c    |   1 +
 hw/virtio/vhost-user-vsock.c |   1 +
 hw/virtio/virtio.c           | 118 +++++++++++++++++++++++++++++++----
 include/hw/virtio/virtio.h   |   5 +-
 net/vhost-vdpa.c             |   1 +
 9 files changed, 119 insertions(+), 12 deletions(-)

-- 
2.39.3

