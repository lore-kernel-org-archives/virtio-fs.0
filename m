Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008FE2BAEB
	for <virtio-fs@lists.linux.dev>; Mon, 20 May 2024 13:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716210065; cv=none; b=YQ/Jv+PzNKXu2o+TvAVtfgBftkZZmQ2jNeJraNBGJuYi/3fsSZnaEAMjGGZAb6f9Otz7E+QsJkPCPmU3hMxGHdTaPncs2NjGNvNWC2Rx/KlKA2caaYAsbgnXwT79eFf2bpyp+2GkpoQnzaaZEv41C6qNxW0t2a2/6wr4eDMuPqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716210065; c=relaxed/simple;
	bh=+wsLcPjyH0uVAJszxrBP4YIjb6lFccoOPrP46yLNzuo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=bAWaXlhyLbove8Uyit8ItM4T6oJsrHJeH+GMaTa7o67aHS+sOYNQSYqXw4zVYylwWdbbpic/SRWYJRTbJxr0N+TQGyMq9x4gLnfSDqCnS67sjIfUnEpM6NdmOZk3u/4pNg/tK4gVOnwoy4oG/SJeq/iNTds1fI/GmnA1UuMCct4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ffir1H8f; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ffir1H8f"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KAJv0T032226;
	Mon, 20 May 2024 13:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=QOzuxqjBuDWFh6NoQFgL4R4Za7AVQFlpxkOWW4Qp0oI=;
 b=ffir1H8fYgXn8U+cE5stG7dkk3u+fanXV91hP0UHc+y/Hv/nSivK5d+YNleNRq6ORhWJ
 5UuaXRbB3+jbUbyp+BJ1XULOa+G5jZhNzatLC5fZgppGQ0Jzbs5HBAnPirqThswZYfBH
 FNDki9TyPoWCZztasl6pai0SuBKLROhcQ00jk3qWJNhgsYsnbQR22r5YUQkfxbeILNEh
 RX1rtJly5i8wgvOkx+QffTfvevtQ0FAx3W4fjaD0Uk+Hm3LvaZXpLO1etufg+1VQEXN1
 nxpQkoNpWyDDTAJ+n+zQVEAElxGJfN4BYvN//TQhkeuSbIb37RkysdKTq6Mj8LISYmRl HA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jx2am83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 13:00:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44KB5m61004963;
	Mon, 20 May 2024 13:00:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js6brs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 13:00:52 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44KD0qPX028778;
	Mon, 20 May 2024 13:00:52 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-165-95.vpn.oracle.com [10.65.165.95])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y6js6brp8-1;
	Mon, 20 May 2024 13:00:52 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v2 0/6] virtio,vhost: Add VIRTIO_F_IN_ORDER support
Date: Mon, 20 May 2024 09:00:42 -0400
Message-Id: <20240520130048.1483177-1-jonah.palmer@oracle.com>
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
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-20_05,2024-05-17_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405200108
X-Proofpoint-GUID: PglEekM8m7Iep5oe24RNW_zqHWyX89am
X-Proofpoint-ORIG-GUID: PglEekM8m7Iep5oe24RNW_zqHWyX89am

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
depend on how frequently elements are completed out-of-order.

A VirtQueue whose device uses this feature will use its used_elems
VirtQueueElement array to hold used VirtQueueElements. The index that
used elements are placed in used_elems is the same index on the
used/descriptor ring that would satisfy the in-order requirement. In
other words, used elements are placed in their in-order locations on
used_elems and are only written to the used/descriptor ring once the
elements on used_elems are able to continue their expected order.

To differentiate between a "used" and "unused" element on the used_elems
array (a "used" element being an element that has returned from
processing and an "unused" element being an element that has not yet
been processed), we added a boolean 'in_order_filled' member to the
VirtQueueElement struct. This flag is set to true when the element comes
back from processing (virtqueue_ordered_fill) and then set back to false
once it's been written to the used/descriptor ring
(virtqueue_ordered_flush).

---
v2: Make 'in_order_filled' more descriptive.
    Change 'j' to more descriptive var name in virtqueue_split_pop.
    Use more definitive search conditional in virtqueue_ordered_fill.
    Avoid code duplication in virtqueue_ordered_flush.

v1: Move series from RFC to PATCH for submission.

Jonah Palmer (6):
  virtio: Add bool to VirtQueueElement
  virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
  virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER support
  virtio: virtqueue_ordered_flush - VIRTIO_F_IN_ORDER support
  vhost,vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
  virtio: Add VIRTIO_F_IN_ORDER property definition

 hw/block/vhost-user-blk.c    |   1 +
 hw/net/vhost_net.c           |   2 +
 hw/scsi/vhost-scsi.c         |   1 +
 hw/scsi/vhost-user-scsi.c    |   1 +
 hw/virtio/vhost-user-fs.c    |   1 +
 hw/virtio/vhost-user-vsock.c |   1 +
 hw/virtio/virtio.c           | 119 ++++++++++++++++++++++++++++++++++-
 include/hw/virtio/virtio.h   |   6 +-
 net/vhost-vdpa.c             |   1 +
 9 files changed, 129 insertions(+), 4 deletions(-)

-- 
2.39.3

