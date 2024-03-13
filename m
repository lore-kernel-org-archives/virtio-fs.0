Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACDA3EA72
	for <virtio-fs@lists.linux.dev>; Wed, 13 Mar 2024 11:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710330879; cv=none; b=mlGX/ZnR71wbyGdGucjOirjm0HhWyV29B3QCeZ4Uum3Sl7jvnwDa4C5HdPuFvEr9Pj9xqOgj1e9IYCb9Bl6XpPlr0x2wOOfKPxw8sETZLlzMOsUCX7r0BRgPg6KrByTWCqRYaMDKjjbjw2SOqiKYorKe3VciJYcbPGFgQ0ZiHHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710330879; c=relaxed/simple;
	bh=23eAwxAQFGTMXDUsiosByh0rqIOwWaxFF1oRqhjrk5A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=MR8hFVTP5W5VT+6sJxyD6mu1GD3pAM23dqg0w7KCTayKkv1iBc5Jlm57EY/uvcXtPFJaQal4Malpr+7zEv9q2bn0QxSxkBGOwa67v8LSx0xnT6OvRO6k1kellokp5D2OTZBJTN1bojryJKURT5E2O+YsOZpigKTan45O36gadJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KfddV/AO; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KfddV/AO"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42D8huc7026177;
	Wed, 13 Mar 2024 11:54:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=x425CgQCm9IuNpTGSsVZd6PQEQeKNKoKzHdBNeiQBqc=;
 b=KfddV/AOMRw3ljK12R4ixYb4FjtK2GGjtDqw0CBJWxUk0l60vgdT42EmWOT1ozvnO1EI
 +L1GgCjrQLYa8l6nXYivt9U0hYkhygOlRShus/2JVRNcniR1XfCMh+Wuwj2FELPwRAGZ
 vgphsmniJMA3bXuEZxz9jieF29yZR7YoDWc3bNDHPtbDR40ZUx7MiRJOJ3xI8ldLV6xL
 fvVoKAFzYk5bK7T6xPrJm6oaJhUfP4pn66uN8zM0exDS4TXRlncojXE6tdmq7XCzmlql
 sCnODcc/rgT9tu82hu0ShIVuzASZE9KI4TT31+nTCCN5teF8RFP79jbzMMpxAfMp2SHL JQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrfcugtnd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 11:54:24 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42DAx8gE028547;
	Wed, 13 Mar 2024 11:54:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre78pegm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 11:54:23 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42DBsMLZ035677;
	Wed, 13 Mar 2024 11:54:22 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-201-251.vpn.oracle.com [10.39.201.251])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wre78peed-1;
	Wed, 13 Mar 2024 11:54:22 +0000
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
Subject: [PATCH v2 0/6] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
Date: Wed, 13 Mar 2024 07:54:06 -0400
Message-Id: <20240313115412.3334962-1-jonah.palmer@oracle.com>
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
 definitions=2024-03-13_07,2024-03-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403130089
X-Proofpoint-ORIG-GUID: mmZDxwsr6SzFkLr4NHN-DhuXNwTyA1-4
X-Proofpoint-GUID: mmZDxwsr6SzFkLr4NHN-DhuXNwTyA1-4

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
 hw/s390x/s390-virtio-ccw.c   | 16 +++++++++++----
 hw/scsi/vhost-scsi.c         |  1 +
 hw/scsi/vhost-user-scsi.c    |  1 +
 hw/virtio/vhost-user-fs.c    |  2 +-
 hw/virtio/vhost-user-vsock.c |  1 +
 hw/virtio/virtio-mmio.c      |  9 ++++++--
 hw/virtio/virtio-pci.c       | 10 ++++++---
 hw/virtio/virtio.c           | 40 ++++++++++++++++++++++++++++++++++++
 include/hw/virtio/virtio.h   |  7 ++++++-
 net/vhost-vdpa.c             |  1 +
 12 files changed, 80 insertions(+), 11 deletions(-)

-- 
2.39.3

