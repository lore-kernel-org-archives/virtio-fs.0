Date: Wed, 2 Feb 2022 11:55:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=ZvZ3/bYahGFKALj+fwBTkdayjGWkADtJvL0lYQ/9FUk=; b=3
	U/mSxAtV4iq0mSbCJpKlZxorfLJPdcJwJuDf4B/QNEJX8nOXxaSQz75R9JtCNNWr
	3jC/El7kPCIixIMxNk2Zgt8u6D3I486yCjZe56bg14EPJlesR6lv9gotB4MyHDls
	FBemKVe5ONn+NqbvWxtzZS+7vUxW18ExbNx1HDRBe9qIXHO0IYkoDyEmkuHBuhDO
	fBe6af7HDJ/hfL6VGci9Aq0MkTWVRu9gj+7/kehAPAylC89HD5hO4VeQg6gQ5Dhu
	xoucc7q4ud60swJ8JvEOkUWAR9wBsf85GNSqSh23nZ5sVXOpa7hcVxx/L7TXgn8V
	Gh05qD8Z0NZNvNzOpbi3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=ZvZ3/bYahGFKALj+fwBTkdayjGWkA
	DtJvL0lYQ/9FUk=; b=an+YyOjEqhiHxtMmo1dL9DyzH4pvKi8plySOalKjI57AT
	onB18zMbkFAxBIo/YDmnt0/nEaiYdVbVPjMboTpo4e0WAIbSjM79IUmZAqQWRZvk
	OX/bT1eNkSRLo3zwgb/ssvcOP7FDbRzU7ADHkaabs9FJzpzhp7c8zxSvUsmSleDz
	3Qe0xVmEWUKJHkf61w0N7DBYmH4ZZMolpB7JR9yPLCvROoj4BwiutUPO4UUK0bBW
	xxPv3xMGeW9lPLvlKyk9OANSIbxy/8juNg5ldlvwCpzCuqYPcpA/hwoJ9W6bQRDd
	rrxwkKVeemTqMoNC7WV9uXVed9O3RPego7NFVFrUQ==
From: virtiofs-bot@sinrega.org
Message-Id: <17952.122020211552601215@us-mta-433.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: process_queue_pool: Only acquire
	the VringMutex lock once
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Previously, the worker task in `process_queue_pool()` called
up to 3 functions on `worker_vring` where each function is a
wrapper that first locks the mutex.  This is unneccessary
congestion.  We fix this by locking the mutex once.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/87

