Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6F51E534
	for <virtio-fs@lists.linux.dev>; Thu, 21 Mar 2024 15:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036649; cv=none; b=iS2jHDCBB2ZTrBpxpqMnzkZe63U3D4PV0bTRqZ4w7VYh2Yep+YS2C73xXlEXtF54x5sRcYLc+YP5FTmfGkXReyphVuerJnSna2TgVv4elaEC09DEq3m6VcZ75PSr4lFvzFgd9lZutL8ukg7rHUfSV4NQiM3S0DJZ7OVO1VU+FcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036649; c=relaxed/simple;
	bh=8UK0xwfs+rBp0uVcLYsPKu13Q9aOq6pdjn7USLWNmg8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eJY+ITx0WxvBDtsU5Aed7W+WTOhpnNjy5w69arZbP46EtSCqo1Ft3pzZvjY+sAALoH2jop9bhxhBBgZPAoxW+p669rstjpTTTnxQRBRcYDP73XTMKgqMu2UswJ1qNFmG5rA4z2c8F7JFOCgP3ZJJkR8ENjgP+KQbxQNsEKpTpqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OUXw4QXJ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OUXw4QXJ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42LCmPmV021726;
	Thu, 21 Mar 2024 15:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=eDsizIPGYiy966xPXRlaRZRemBx6U1D6B6FItJHc13w=;
 b=OUXw4QXJmEZjG08HNVBEGtUfrL+oElR/Nvouu/3H0yLeH+ZtdbIno4FhvVrO104jj0Ix
 e+1XZlW5K0rZMHTWR7HXPvqgTml7Yr/5oZXxqy4u3cAeLsyc6v5ZY29XGuCQkGWWwdM2
 jUxgqt7RSgOvtxfIkC19PLQirgGuc/wW7FFev4YtDFNeamyimG4OalkFoA3hId/lkHQv
 /pGmFDdaCwwQltq8AZIniim8vpMATNlssmHpE7EjrzBiGkEIubMLjw8Rhn/ojqZ9bkzF
 PJKeyCAfi2pFnMeMiGXqptVtepWWKRV4BWQufzQGAxZFeRk2MNVlT3JKNEm1lssNuhaQ aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww3fctxav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42LFmIIR006145;
	Thu, 21 Mar 2024 15:57:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1v9q1pw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 15:57:20 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42LFsWZG005094;
	Thu, 21 Mar 2024 15:57:20 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-211-118.vpn.oracle.com [10.39.211.118])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ww1v9q1p9-1;
	Thu, 21 Mar 2024 15:57:20 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC 0/8] virtio,vhost: Add VIRTIO_F_IN_ORDER support
Date: Thu, 21 Mar 2024 11:57:09 -0400
Message-Id: <20240321155717.1392787-1-jonah.palmer@oracle.com>
X-Mailer: git-send-email 2.39.3
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=779
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403210115
X-Proofpoint-GUID: Ktwzq-xo3oJtWjDUhIukWYhmu8EO91D8
X-Proofpoint-ORIG-GUID: Ktwzq-xo3oJtWjDUhIukWYhmu8EO91D8

The goal of these patches is to add support to a variety of virtio and
vhost devices for the VIRTIO_F_IN_ORDER transport feature. This feature
indicates that all buffers are used by the device in the same order in
which they were made available by the driver.

These patches attempt to implement a generalized, non-device-specific
solution to support this feature.

The core feature behind this solution is a buffer mechanism in the form
of GLib's GHashTable. The decision behind using a hash table was to
leverage their ability for quick lookup, insertion, and removal
operations. Given that our keys are simply numbers of an ordered
sequence, a hash table seemed like the best choice for a buffer
mechanism.

---------------------

The strategy behind this implementation is as follows:

We know that buffers that are popped from the available ring and enqueued
for further processing will always done in the same order in which they
were made available by the driver. Given this, we can note their order
by assigning the resulting VirtQueueElement a key. This key is a number
in a sequence that represents the order in which they were popped from
the available ring, relative to the other VirtQueueElements.

For example, given 3 "elements" that were popped from the available
ring, we assign a key value to them which represents their order (elem0
is popped first, then elem1, then lastly elem2):

     elem2   --  elem1   --  elem0   ---> Enqueue for processing
    (key: 2)    (key: 1)    (key: 0)

Then these elements are enqueued for further processing by the host.

While most devices will return these completed elements in the same
order in which they were enqueued, some devices may not (e.g.
virtio-blk). To guarantee that these elements are put on the used ring
in the same order in which they were enqueued, we can use a buffering
mechanism that keeps track of the next expected sequence number of an
element.

In other words, if the completed element does not have a key value that
matches the next expected sequence number, then we know this element is
not in-order and we must stash it away in a hash table until an order
can be made. The element's key value is used as the key for placing it
in the hash table.

If the completed element has a key value that matches the next expected
sequence number, then we know this element is in-order and we can push
it on the used ring. Then we increment the next expected sequence number
and check if the hash table contains an element at this key location.

If so, we retrieve this element, push it to the used ring, delete the
key-value pair from the hash table, increment the next expected sequence
number, and check the hash table again for an element at this new key
location. This process is repeated until we're unable to find an element
in the hash table to continue the order.

So, for example, say the 3 elements we enqueued were completed in the
following order: elem1, elem2, elem0. The next expected sequence number
is 0:

    exp-seq-num = 0:

     elem1   --> elem1.key == exp-seq-num ? --> No, stash it
    (key: 1)                                         |
                                                     |
                                                     v
                                               ================
                                               |key: 1 - elem1|
                                               ================
    ---------------------
    exp-seq-num = 0:

     elem2   --> elem2.key == exp-seq-num ? --> No, stash it
    (key: 2)                                         |
                                                     |
                                                     v
                                               ================
                                               |key: 1 - elem1|
                                               |--------------|
                                               |key: 2 - elem2|
                                               ================
    ---------------------
    exp-seq-num = 0:

     elem0   --> elem0.key == exp-seq-num ? --> Yes, push to used ring
    (key: 0)

    exp-seq-num = 1:

    lookup(table, exp-seq-num) != NULL ? --> Yes, push to used ring,
                                             remove elem from table
                                                     |
                                                     v
                                               ================
                                               |key: 2 - elem2|
                                               ================

    exp-seq-num = 2:

    lookup(table, exp-seq-num) != NULL ? --> Yes, push to used ring,
                                             remove elem from table
                                                     |
                                                     v
                                               ================
                                               |   *empty*    |
                                               ================

    exp-seq-num = 3:

    lookup(table, exp-seq-num) != NULL ? --> No, done
    ---------------------

Jonah Palmer (8):
  virtio: Define InOrderVQElement
  virtio: Create/destroy/reset VirtQueue In-Order hash table
  virtio: Define order variables
  virtio: Implement in-order handling for virtio devices
  virtio-net: in-order handling
  vhost-svq: in-order handling
  vhost/vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
  virtio: Add VIRTIO_F_IN_ORDER property definition

 hw/block/vhost-user-blk.c          |   1 +
 hw/net/vhost_net.c                 |   2 +
 hw/net/virtio-net.c                |   6 +-
 hw/scsi/vhost-scsi.c               |   1 +
 hw/scsi/vhost-user-scsi.c          |   1 +
 hw/virtio/vhost-shadow-virtqueue.c |  15 ++++-
 hw/virtio/vhost-user-fs.c          |   1 +
 hw/virtio/vhost-user-vsock.c       |   1 +
 hw/virtio/virtio.c                 | 103 ++++++++++++++++++++++++++++-
 include/hw/virtio/virtio.h         |  20 +++++-
 net/vhost-vdpa.c                   |   1 +
 11 files changed, 145 insertions(+), 7 deletions(-)

-- 
2.39.3

