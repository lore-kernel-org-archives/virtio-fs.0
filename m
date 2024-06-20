Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587661B0115
	for <virtio-fs@lists.linux.dev>; Thu, 20 Jun 2024 17:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906183; cv=none; b=D59jJjgF1sTk3mgJp5J+oMVGMlPuWbJlvBai1+lR41GZSJ6byAg8XqFGvOfMFfAirXf0JD7ROK0bYwri8MGUZLaL8JgfnjazaBr4OfTAvFbJGMV271ITdOX0Jf2Qkm7CP7AyGuYxj4AhNmdALs3yIWPweOJL/hJ8N+HYrQdQaqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906183; c=relaxed/simple;
	bh=A8XGX2jyQuH73Aehi5GX/8F/Gn3I9p94TxcStdI+eos=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SSKPptwU+2nt5p0/oqE8viwoi+lWd9T9dIcCJ8GxruOb24VI4j4zH7y7PW5jRZMdFNR7Hpbay758VvpHi5XJePEAPvXk9xEh6WrRxn5HjEJH1cggwvLPdhsIYBeHiEXOqZbngbA/6VyjK7Q+bcbapKQQbx7fE+HgM5Uy7FZZgoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D+keCqmh; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D+keCqmh"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KHBAYY009912;
	Thu, 20 Jun 2024 17:56:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; s=corp-2023-11-20; bh=YQkk3SKNFQ8rPU
	IVGzZzlUOOkawBjc7vEf30FebmMOw=; b=D+keCqmhSSfaWzvYH1dOzULiIPFw6I
	gTq/JZxkaFeSg7P2J6UvfaUvGfvNFhOfm9xsEXor+mQ1HubBL3ZDnjEg1YFhn+K7
	HTX605oXD+UHKbsty73Xp/cHjGfkdWaeHF+paVWun9WWfSu3vwa4wlxQ/x4R1jGI
	nBVSCTkGqIaMWpIclLThdcgO83kI4oyfRYrY79IHJzsXtbhjdngahEixfNqv0RNH
	5xBmSQafcQmy7biD1WBBxQ7r0H18xMFVZEgAi2K9W0oooG2rqG9MexxHNliCaXz5
	mcAqu6kJdIpAPCpvRzrnhcUuLWYJi6I0RdJ3r5cHGtEpumo+zDTWpoUA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrkj02y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:56:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KHDu7D013027;
	Thu, 20 Jun 2024 17:56:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrn3hnky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:56:16 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45KHuF0j018715;
	Thu, 20 Jun 2024 17:56:15 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-208-85.vpn.oracle.com [10.39.208.85])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3yvrn3hnjv-1;
	Thu, 20 Jun 2024 17:56:15 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v3 0/6] virtio,vhost: Add VIRTIO_F_IN_ORDER support
Date: Thu, 20 Jun 2024 13:56:04 -0400
Message-ID: <20240620175612.2381019-1-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.43.0
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
X-Proofpoint-GUID: wcuZ_XVhzDSB30S_Ob4sAMTrh2ppF17k
X-Proofpoint-ORIG-GUID: wcuZ_XVhzDSB30S_Ob4sAMTrh2ppF17k

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

Testing:
========
Testing was done using the dpdk-testpmd application on both the host and
guest using the following configurations. Traffic was generated between
the host and guest after running 'start tx_first' on both the host and
guest dpdk-testpmd applications. Results are below after traffic was
generated for several seconds.

Relevant Qemu args:
-------------------
-chardev socket,id=char1,path=/tmp/vhost-user1,server=off
-chardev socket,id=char2,path=/tmp/vhost-user2,server=off
-netdev type=vhost-user,id=net1,chardev=char1,vhostforce=on,queues=1
-netdev type=vhost-user,id=net2,chardev=char2,vhostforce=on,queues=1
-device virtio-net-pci,in_order=true,packed=true,netdev=net1,
        mac=56:48:4f:53:54:00,mq=on,vectors=4,rx_queue_size=256
-device virtio-net-pci,in_order=true,packed=true,netdev=net2,
        mac=56:48:4f:53:54:01,mq=on,vectors=4,rx_queue_size=256

Host dpdk-testpmd command:
--------------------------
dpdk-testpmd -l 0,2,3,4,5 --socket-mem=1024 -n 4
    --vdev 'net_vhost0,iface=/tmp/vhost-user1'
    --vdev 'net_vhost1,iface=/tmp/vhost-user2' --
    --portmask=f -i --rxq=1 --txq=1 --nb-cores=4 --forward-mode=io

Guest dpdk-testpmd command:
---------------------------
dpdk-testpmd -l 0,1 -a 0000:00:02.0 -a 0000:00:03.0 -- --portmask=3
    --rxq=1 --txq=1 --nb-cores=1 --forward-mode=io -i

Results:
--------
+++++++++++++++ Accumulated forward statistics for all ports+++++++++++++++
RX-packets: 79067488       RX-dropped: 0             RX-total: 79067488
TX-packets: 79067552       TX-dropped: 0             TX-total: 79067552
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

---
v3: Drop Tested-by tags until patches are re-tested.
    Replace 'prev_avail_idx' with 'vq->last_avail_idx - 1' in
    virtqueue_split_pop.
    Remove redundant '+vq->vring.num' in 'max_steps' calculation in
    virtqueue_ordered_fill.
    Add test results to CV.

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
 hw/virtio/virtio.c           | 123 ++++++++++++++++++++++++++++++++++-
 include/hw/virtio/virtio.h   |   6 +-
 net/vhost-vdpa.c             |   1 +
 9 files changed, 134 insertions(+), 3 deletions(-)

-- 
2.43.0

