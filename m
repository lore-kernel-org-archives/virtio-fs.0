Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856BA192465
	for <virtio-fs@lists.linux.dev>; Wed, 10 Jul 2024 12:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720616148; cv=none; b=gX3DmsNcJfY5Et4F5+lBCRL1sK/m6Ah+y1l0DDa9i+eT4kL3R49EEzCT8xT83YB1kOLugRSNnEYM5e0isnIgzIu0NRicACbosNveEUAvVMguoAP+aAJuhZF8WgN0FNBfC1BGpVa8P9XFl570l2HhfXryGlSOpRPPTgsxtpBud/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720616148; c=relaxed/simple;
	bh=HMvUJAE6g+9hd/qsnAt9YZX3m8Nbu5ExxahHLZogWyg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qhLqfveD08eEh+mreAtS6i2kCVZ6GyGm9/lGUL7qFhhbP6DfP3BSb+LMV8LLfNH/xzKyYxs3RIQ6OYTcZ0o48ZwVckYcV+oZ3NNXciCtD78zXMrUXwUCIwU0dsrs2xTrAb4/GSqDF7eetZnrD99T/MeMsQ5HA0S5O5iUyy3+Uto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hCqsEKLy; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hCqsEKLy"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A7flY4019840;
	Wed, 10 Jul 2024 12:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; s=corp-2023-11-20; bh=Dpc8EAcQmF17Xv
	QbL9I1afl2rJAABoP+mFOTTv5lIiU=; b=hCqsEKLyaZrADZ3YtpPJ58s3z4XHdb
	dAVkxVNzZ0c84+niDW83JQzEacnfAqecqHwKLIFS+SLiaypk9l21orCq1YktOZqE
	Q9148FxKwjKT24mzAjTY3avufxN1YILyn4BWQ4r1QzCgV3CF0nzBq4/8snzqENba
	rNXYyR3JPafIS8AnKMZ253ttXbXfQuEIJVCKdXkYyP3x4Qc+wd2Vps+aoAUksH8W
	vdDUqYn/Ck6TKENbxDNQtO8qhw8wZ9KE/D88EQs7vkzinTDEf97Z0CgDYUJ9vJBh
	YRbw2Bhsz0zCF4npJfc1eYK4hn+XRzBg4zyVkX4JnKxJUvMZMtvI7zdA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wky77u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 12:55:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AC1Mde007576;
	Wed, 10 Jul 2024 12:55:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407tu4r0eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 12:55:26 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46ACtQtQ015847;
	Wed, 10 Jul 2024 12:55:26 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-182-124.vpn.oracle.com [10.65.182.124])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407tu4r0e4-1;
	Wed, 10 Jul 2024 12:55:26 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [PATCH v4 0/6] virtio,vhost: Add VIRTIO_F_IN_ORDER support
Date: Wed, 10 Jul 2024 08:55:13 -0400
Message-ID: <20240710125522.4168043-1-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.43.5
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
 definitions=2024-07-10_08,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407100089
X-Proofpoint-ORIG-GUID: 3zGY0WiWutCxMMLv2hPPXBgQv46s3lMj
X-Proofpoint-GUID: 3zGY0WiWutCxMMLv2hPPXBgQv46s3lMj

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

Testing was done using the dpdk-testpmd application on the guest under
the following configurations. A bridge and two TAP devices were
configured on the host to create a loopback environment where packets
transmitted from one interface can be received on the other, and vice
versa. After starting the dpdk-testpmd application on the guest, the
testpmd command 'start tx_first' was executed to begin network traffic.
Traffic was simulated for 30s before executing the 'stop' command.

Relevant Qemu args:
-------------------
Note: both 'packed=true' and 'packed=false' were tested.

-netdev tap,id=net1,vhost=off,ifname=tap1
-netdev tap,id=net2,vhost=off,ifname=tap2
-device virtio-net-pci,in_order=true,packed=true,netdev=net1,addr=0x2
-device virtio-net-pci,in_order=true,packed=true,netdev=net2,addr=0x3

Loopback environment on host:
-----------------------------
BRIDGE=virbrDPDK
ip link add name $BRIDGE type bridge
ip link set dev $BRIDGE up
ip link add dev tap1 type tap
ip link set dev tap1 up
ip link set dev tap1 master $BRIDGE
ip link add dev tap2 type tap
ip link set dev tap2 up
ip link set dev tap2 master $BRIDGE

dpdk-testpmd command (guest):
-----------------------------
dpdk-testpmd -l 0-3 -n 4 -a 0000:00:02.0 -a 0000:00:03.0 -- -i
--port-topology=chained --forward-mode=io --stats-period 1 --burst=1

Results:
--------
After running 'start tx_first' and then 'stop' after 30 seconds in
the testpmd commandline:

split-VQ in-order:

---------------------- Forward statistics for port 0  ---------------
RX-packets: 408154         RX-dropped: 0             RX-total: 408154
TX-packets: 408174         TX-dropped: 0             TX-total: 408174
---------------------------------------------------------------------

---------------------- Forward statistics for port 1  ---------------
RX-packets: 408173         RX-dropped: 0             RX-total: 408173
TX-packets: 408155         TX-dropped: 0             TX-total: 408155
---------------------------------------------------------------------

+++++++++++++++ Accumulated forward statistics for all ports+++++++++
RX-packets: 816327         RX-dropped: 0             RX-total: 816327
TX-packets: 816329         TX-dropped: 0             TX-total: 816329
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

packed-VQ in-order:

---------------------- Forward statistics for port 0  ---------------
RX-packets: 414808         RX-dropped: 0             RX-total: 414808
TX-packets: 414822         TX-dropped: 0             TX-total: 414822
---------------------------------------------------------------------

---------------------- Forward statistics for port 1  ---------------
RX-packets: 414821         RX-dropped: 0             RX-total: 414821
TX-packets: 414809         TX-dropped: 0             TX-total: 414809
---------------------------------------------------------------------

+++++++++++++++ Accumulated forward statistics for all ports+++++++++
RX-packets: 829629         RX-dropped: 0             RX-total: 829629
TX-packets: 829631         TX-dropped: 0             TX-total: 829631
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

---
v4: Prevent used_elems overflow in virtqueue_split_pop.
    Don't keep used_idx bound between 0 and vring.num-1 for split VQs.
    Fix incrementing used_elems index 'i' in virtqueue_ordered_flush.
    Ensure all previous write ops to buffers are completed before
    updating the used_idx (via smp_wmb()).
    Use virtio-net instead of vhost-user devices for testing.

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
 hw/virtio/virtio.c           | 130 ++++++++++++++++++++++++++++++++++-
 include/hw/virtio/virtio.h   |   6 +-
 net/vhost-vdpa.c             |   1 +
 9 files changed, 140 insertions(+), 4 deletions(-)

-- 
2.43.5

