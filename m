Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13652657C6
	for <virtio-fs@lists.linux.dev>; Mon,  8 Apr 2024 15:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712590462; cv=none; b=dBRs7sGnHitfnvAF5aZgJx7+IVna54h83Bi/XSk5eQEcyx7licELeecUtxvUUZ/WOc9OzeaV1e1sK9rXIMr+JuI4eIntGTJeQCHTrN7KoTcShtcAGkd76i5XvDhJ1Ymz1trN2vnBDurzYVG9bwiCwuBqxorT2wtKoMhMJel8pZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712590462; c=relaxed/simple;
	bh=V30G+P/DX2oGtKoc70UzfoOu4m8kqW5f6h+ADzarbgY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=EgBxckanHomEHIVp4eF1zI8J1qBF6IxN9m85S5CwEfiYxm0RR1frahUslsQNvgRBSBk+oGYWTkBq71wR3Mhg41bPls6/WXGIi3px5fy+3P9gsXzPuSa8f6YLo4OF07iVItlz5ikC/PZA4l7yZncNZnrmT//HRFD8Bd9SYfflQpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z0GVYM4r; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z0GVYM4r"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438ENpK3028684;
	Mon, 8 Apr 2024 15:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=wq+RPiTU34lFqZpRyuCQ8ihuDcRmjdTl1wKWOJ7u78o=;
 b=Z0GVYM4rCLc8zDpoTRNzyOC8gD6IS+J9gnNt9/y82rjk2rhZVl+Vn8vkZanq9wtxUjgG
 Q0R9oSdL7wwlaEidYCmv7FX5Ki//Bl2Qg8Q1WCAD8wRwzXuylzG61JcBnCEmPeMdDa1Z
 UkjzF7euC0Thadyg3Rvn9QPvMFQqlTkQJ6qEO38wCBbg63D+BPSi3K8jL3B289FmRKUF
 aO3gx83qlyU7jFS62ycgjo8tNbSkGpB8F6u+8wb4EP2kLHUDuXjdR1F9b40LHOgNqNcT
 jKQSNQXTaTLcnPgZ1ztVq0UmeMdDYsfKkfXHBuB2Z3/rHyaOf6AR2mmKD9kr3B4zjO+r sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxedk1rg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438EERVU032367;
	Mon, 8 Apr 2024 15:34:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu60d96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 15:34:12 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438FUlUs008521;
	Mon, 8 Apr 2024 15:34:11 GMT
Received: from jonah-ol8.us.oracle.com (dhcp-10-39-195-157.vpn.oracle.com [10.39.195.157])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xavu60d7m-1;
	Mon, 08 Apr 2024 15:34:11 +0000
From: Jonah Palmer <jonah.palmer@oracle.com>
To: qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        jonah.palmer@oracle.com
Subject: [RFC v3 0/6] virtio,vhost: Add VIRTIO_F_IN_ORDER support
Date: Mon,  8 Apr 2024 11:34:02 -0400
Message-Id: <20240408153408.3527586-1-jonah.palmer@oracle.com>
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
 definitions=2024-04-08_13,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080120
X-Proofpoint-GUID: 4RGuGxbM7OJUdWz0sBufCy3B8jndYM2I
X-Proofpoint-ORIG-GUID: 4RGuGxbM7OJUdWz0sBufCy3B8jndYM2I

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
array (a "used" element being an element that has returned from
processing and an "unused" element being an element that has not yet
been processed), we added a boolean 'filled' member to the
VirtQueueElement struct. This flag is set to true when the element comes
back from processing (virtqueue_ordered_fill) and then set back to false
once it's been written to the used/descriptor ring
(virtqueue_ordered_flush).

---
v3: Add elements to used_elems during virtqueue_split/packed_pop
    Replace current_seq_idx usage with vq->last_avail_idx
    Remove used_seq_idx, leverage used_idx and last_avail_idx for
    searching used_elems
    Remove seq_idx in VirtQueueElement
    Add boolean to VirtQueueElement to signal element status
    Add virtqueue_ordered_fill/flush functions for ordering

v2: Use a VirtQueue's used_elems array as a buffer mechanism

v1: Implement custom GLib GHashTable as a buffer mechanism

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
 hw/virtio/virtio.c           | 118 ++++++++++++++++++++++++++++++++++-
 include/hw/virtio/virtio.h   |   5 +-
 net/vhost-vdpa.c             |   1 +
 9 files changed, 127 insertions(+), 4 deletions(-)

-- 
2.39.3

