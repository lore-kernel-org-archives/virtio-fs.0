Date: Mon, 24 Jan 2022 13:46:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=TUkH2oVsCbM6in/c280VDgnlRZvJj+b85rkpK63A8oM=; b=z
	YtcH6/0UDLQH9KWVxHnSZq5IaeUrYmCnLp7KbkHhYdrFcMl638PQETxICZnF0BDR
	sw8tAUMW/yuUTr0/cEX2NsN9WR2axZj/+xHiosaBJpRDg+1Xx/tc9HR6vanbVCr+
	Z3/utD5F5rndWIoZoQkWfJ8DuJjCECwzl7fp66iVKBkMaidYzfOwUXlrKcrmTMqp
	+ebQB6yyX4n/lgJBTpKkbiE0q8779ebbXXvCokJZyaKyrnEYwuu9rWMrSFkAHeac
	R4FPoiNp5kef1D3XsegNn5wFVi3Jdx4eBvyrm4c97uylzNRiSd7Svq9uYLd2LnAM
	JVrNfpHxAGqCH8605J8bQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=TUkH2oVsCbM6in/c280VDgnlRZvJj
	+b85rkpK63A8oM=; b=bI8wUMm35/wEINWt8RSl7x3WtOqSo5SeyJeac62p/wgcM
	XEBVItF2Q+pb+QZOTGYBWzK4r6JQOr284JSU/L1Gbxi51huIeSo9OjFCQbhRz9Zp
	ptJ7cEUyLSxQcfx6t+C9OxpBPn1xA/V7hhayNvq13LkivitIehoyj2IkPcvY4EPq
	kSN4YESuRABZqPilm252hdASWDFyajZD6FEuIOkKDFPWFR/DmZWuE6IXUYhVhb9G
	qlvtQwRIX4oUUKyRBxuAPkq3YIC30x5q9brKI7jbftJQaScgWPSr0HvKyuWkitPd
	xRJ04+PFp514Lruia3LmiF93rfvlZTuWq1VIucB2g==
From: virtiofs-bot@sinrega.org
Message-Id: <71103.122012413465301433@us-mta-275.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR closed: mount_fd: Use RAII for MountFd
	reference counting
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This commit moves `MountFd` and `MountFds` into a separate module
and introduces a new type `MountFdRef` that is a strong reference
to a `MountFd`.  `MountFdRef` uses RAII in order to correctly
mutate the refcount of the referenced `MountFd`.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/70

