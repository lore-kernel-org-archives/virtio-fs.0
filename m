Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A2747F54
	for <virtio-fs@lists.linux.dev>; Fri, 15 Mar 2024 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710521774; cv=none; b=LC3+lrbYlF/IZ5VIzYhJG/L7EcK+FbkDBNTVKwrqLMxLT464fsMPCCmMmW77n1SCvwSjAT38ZRZeCxX+X5lt+3DzpLaRemq1q/+vZBk2QJM0A5e5TB1pxHKVvZVBhZ0z6yZKedRBM15Clgolx0KEylY8Ckl/cP6WA1H67v2IoT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710521774; c=relaxed/simple;
	bh=9COi4X6dgZ3WY87I9x6m4FEd6jSQQ8NRynak6loGpYs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=jVyS8ipWakZHKxsukXcZ8ek1mr14mk3sybthR0tWr3OlTVyng45fmpQelxD8+FfSohXv9shvZIyKwiaUxOmAJY8Jnqh9G0F468DGGBqmJmnil1eJ24YzeJems9PjP0T4fbVq5SM2bGqjtH62jet8XfD0mHWjUuIvXdebtNHJ+Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CSWqoKz6; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CSWqoKz6"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42FGWljV031318;
	Fri, 15 Mar 2024 16:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=3eHbAAIIQmEG5KvxGNSGBd9oTioylrZC7es/fv+Lq+k=;
 b=CSWqoKz6Ru49Qgm/R+I16oHcmh9orH6/m7vtEtVRmqO/JSpDLUBwZZegQPZPke5ZztpG
 Bmaa7ZDyRKYuTpTjTj7udnqNazbwHufmiSCdST7CS8fTfRN5rHbTzvJjvsWuGZehkOiM
 9SY0RkRJ0Xxax0m45w/eZa4JV4PHZvpnQfaNlswjF/TnnKzXV13cPAWzBbJG6V4fMZul
 STL/oo3sG/eXk4/UgLE9iHPWBJ18KVAiWPbxe9il/d/RkerJf4la1CMt4GnjQXVCBEpl
 MuVqmK2pOaaafAnmibxmduS3FuXF8zkfcClqrxGhc7VxkGptrUJIAIAHFpnVF9vDoKLZ EQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wvsxk01b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Mar 2024 16:56:04 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42FFkhqn033842;
	Fri, 15 Mar 2024 16:56:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7bw7jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Mar 2024 16:56:03 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42FGu2YO039399;
	Fri, 15 Mar 2024 16:56:02 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-65-177-130.vpn.oracle.com [10.65.177.130])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3wre7bw7fq-1;
	Fri, 15 Mar 2024 16:56:02 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com, raphael@enfabrica.net, kwolf@redhat.com,
        hreitz@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        farman@linux.ibm.com, thuth@redhat.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, cohuck@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, qemu-s390x@nongnu.org, leiyang@redhat.com,
        schalla@marvell.com, vattunuru@marvell.com, jerinj@marvell.com,
        dtatulea@nvidia.com, virtio-fs@lists.linux.dev
Subject: [PATCH v3 for 9.1 0/6] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
Date: Fri, 15 Mar 2024 12:55:51 -0400
Message-Id: <20240315165557.26942-1-jonah.palmer@oracle.com>
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
 definitions=2024-03-15_04,2024-03-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403150138
X-Proofpoint-GUID: 7ovHRep8jnaRjrKMKAvk1xKl9lGZnAT2
X-Proofpoint-ORIG-GUID: 7ovHRep8jnaRjrKMKAvk1xKl9lGZnAT2

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
extra provided by the driver, having both VIRTIO_F_NOTIFICATION_DATA
feature and ioeventfd enabled is a functional mismatch. The user must
explicitly disable ioeventfd for the device in the Qemu arguments when
using this feature, else the device will fail to complete realization.

For example, a device must explicitly enable notification_data as well
as disable ioeventfd:

    -device virtio-scsi-pci,...,ioeventfd=off,notification_data=on

A significant aspect of this effort has been to maintain compatibility
across different backends. As such, the feature is offered by backend
devices only when supported, with fallback mechanisms where backend
support is absent.

v3: Validate VQ idx via. virtio_queue_get_num() (pci, mmio, ccw)
    Rename virtio_queue_set_shadow_avail_data
    Only pass in upper 16 bits of 32-bit extra data (was redundant)
    Make notification compatibility check function static
    Drop tags on patches 1/6, 3/6, and 4/6

v2: Don't disable ioeventfd by default, user must disable it
    Drop tags on patch 2/6

Jonah Palmer (6):
  virtio/virtio-pci: Handle extra notification data
  virtio: Prevent creation of device using notification-data with ioeventfd
  virtio-mmio: Handle extra notification data
  virtio-ccw: Handle extra notification data
  vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost feature bits
  virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition

 hw/block/vhost-user-blk.c    |  1 +
 hw/net/vhost_net.c           |  2 ++
 hw/s390x/s390-virtio-ccw.c   | 17 +++++++++++----
 hw/scsi/vhost-scsi.c         |  1 +
 hw/scsi/vhost-user-scsi.c    |  1 +
 hw/virtio/vhost-user-fs.c    |  2 +-
 hw/virtio/vhost-user-vsock.c |  1 +
 hw/virtio/virtio-mmio.c      | 10 +++++++--
 hw/virtio/virtio-pci.c       | 11 +++++++---
 hw/virtio/virtio.c           | 40 ++++++++++++++++++++++++++++++++++++
 include/hw/virtio/virtio.h   |  6 +++++-
 net/vhost-vdpa.c             |  1 +
 12 files changed, 82 insertions(+), 11 deletions(-)

-- 
2.39.3

