Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF7A62147
	for <virtio-fs@lists.linux.dev>; Mon,  4 Mar 2024 19:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709581587; cv=none; b=a2Mj/yyjmzElYyYYaebxEEtT6JwCuyi2rTatlaQ0e5jo+wfnxN/HwhXns7cuuB/5U10uk/ncJzTI61RSB1S2LfSMmdn5UKimwmw6i8+qB1CMrNM9zoeAyLnR1hpqPE45FaV86IGqbOLrR0Qpf7snQ8mdvA5LqxTw88oV1kIlCno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709581587; c=relaxed/simple;
	bh=0pk0c2mG6zS7NIALjb96ODoq6YZS9Q2loieBOtubSxE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=iisa8RvKo6WWyIovM0mO2td5/mmp1Cn6x7tkkETBWdpbi9zTKh2aVD3QrOsjIqjPsggEPL/G6Bh8tpPoeqdshlvlUErEtVKOH0G6lfwpQlwiQ6ctz5oYPOrYa5A6y8TR9XvdP1TugZd7rkHzpNVUt23YH3P5XJH7rrRR5BT8mO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V4fHAQpC; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V4fHAQpC"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 424IxqGd032304;
	Mon, 4 Mar 2024 19:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=tC9KBJfCvFe//nHt1DYEV1IOweBPPnQLAk60VlvmXW0=;
 b=V4fHAQpCxJcHTykuogMHv7PygJX2wG9D57T3kL+V7oXjvCy33bZ6bL9t9Ul/8ocyfHOc
 iVS41/GnoGtBsveJsDQHJmN0HrcHECI3G3xOQRcK/osSAfj0+cyNNPtpQswHVUN54stm
 iWC49QAOGEYO9Sd8LinhaBRgFYymef18bcPYFLZEaXhzniUQsr7Sh1scjA3ITvzvYmbi
 hfBzNgkh/1XPAj93wD5cGrxHG8K/Xg7/ZgDMXDqNAd1jC+l0yYCWLSpFmpVt/RbmCHiH
 onh7gnxv0Jj5/zyk/Q99TqNxG2FJYiUrBQ6jZ68udYspd1bzml4smWw87umy8uupjJ/q 5w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkv0bcfaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 19:46:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 424JIr71018962;
	Mon, 4 Mar 2024 19:46:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wktj6ag65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 19:46:15 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 424JkE3w038523;
	Mon, 4 Mar 2024 19:46:14 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-196-188.vpn.oracle.com [10.39.196.188])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wktj6ag50-1;
	Mon, 04 Mar 2024 19:46:14 +0000
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
Subject: [PATCH v1 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
Date: Mon,  4 Mar 2024 14:46:04 -0500
Message-Id: <20240304194612.611660-1-jonah.palmer@oracle.com>
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
 definitions=2024-03-04_15,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403040152
X-Proofpoint-ORIG-GUID: vRvhdcgJXi0OEMGyYLakIPJdyBVU4HHr
X-Proofpoint-GUID: vRvhdcgJXi0OEMGyYLakIPJdyBVU4HHr

The goal of these patches are to add support to a variety of virtio and
vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature. This
feature indicates that a driver will pass extra data (instead of just a
virtqueue's index) when notifying the corresponding device.

The data passed in by the driver when this feature is enabled varies in
format depending on if the device is using a split or packed virtqueue
layout:

 Split VQ
  - Upper 16 bits: shadow_avail_idx
  - Lower 16 bits: virtqueue index

 Packed VQ
  - Upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
  - Lower 16 bits: virtqueue index

Also, due to the limitations of ioeventfd not being able to carry the
extra provided by the driver, ioeventfd is left disabled for any devices
using this feature.

A significant aspect of this effort has been to maintain compatibility
across different backends. As such, the feature is offered by backend
devices only when supported, with fallback mechanisms where backend
support is absent.

Jonah Palmer (8):
  virtio/virtio-pci: Handle extra notification data
  virtio-pci: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
  virtio-mmio: Handle extra notification data
  virtio-mmio: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
  virtio-ccw: Handle extra notification data
  virtio-ccw: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
  vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost feature bits
  virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition

 hw/block/vhost-user-blk.c    |  1 +
 hw/net/vhost_net.c           |  2 ++
 hw/s390x/s390-virtio-ccw.c   | 16 ++++++++++++----
 hw/s390x/virtio-ccw.c        |  6 ++++--
 hw/scsi/vhost-scsi.c         |  1 +
 hw/scsi/vhost-user-scsi.c    |  1 +
 hw/virtio/vhost-user-fs.c    |  2 +-
 hw/virtio/vhost-user-vsock.c |  1 +
 hw/virtio/virtio-mmio.c      | 15 +++++++++++----
 hw/virtio/virtio-pci.c       | 16 +++++++++++-----
 hw/virtio/virtio.c           | 18 ++++++++++++++++++
 include/hw/virtio/virtio.h   |  5 ++++-
 net/vhost-vdpa.c             |  1 +
 13 files changed, 68 insertions(+), 17 deletions(-)

-- 
2.39.3

