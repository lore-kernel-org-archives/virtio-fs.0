Date: Mon, 7 Feb 2022 10:45:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=5dqMUoqHq757q4GPtpuWN1mTLGsx53XUwgXYjnorNXA=; b=M
	GtQLuVbTK4yOqPSGivs3MfzaJ4siNmhLpsYOckkCtFtYvXCy2jhsj1DmGL0QTuLE
	jrs5kow42HPIBSyu/1FtDpNE5OADdvRnKIFVUQ8ZV87A18sIpYqBSaiRgaTwMjuP
	cSLDtjtDeZ78hj/Akg1++mNtG1Uq/4OdgXYUggQME5SEVCjJ4nWRjaaTQm66Ynn4
	/faCBv2LD2yEPL2Jt2DImNtW4ZD4miIZjaYYekWKYdKMWHk8CU9ZvqTc+QMf/8nI
	WZ0H3ycXPTpeV4OZ688u248ty9xit+UHLS7gWm2k1zm/5YYV5Ae6SLctahkjXdB9
	TCGF8wgeoUuO5GULPPLHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=5dqMUoqHq757q4GPtpuWN1mTLGsx5
	3XUwgXYjnorNXA=; b=Vjm87rD+ue7LwGmZRDYUvv4uGiSn+xb/4/loi9U50iw60
	t1fVo7Zy0wdF0fyrY2cOlJU0ZVuuA3jKLnztRkQAQWAE2FD64VjiarvQ4/0nasFY
	jURXdACag7JiB/auEWdQRtO5cuhyG5fGPqlgBsrfsswiswVetOlOrXm96U4zAJ6D
	10zlobYxdJtG/FTAjQuWfWdXwJBCPhVZEzA9sOAStVkrq6cOyMyqARS5W0NjGIB9
	2Aoq/cD4CLrfyUmcUomcnpFhlIB+gZ9ordlN5saqtrj4DTBuOMSwJPjbhE/qlT3I
	aPmbfCzvN/pWE6dLX5a0BK3nEj1W1e0Nu9bkhSdSg==
From: virtiofs-bot@sinrega.org
Message-Id: <44142.122020710450700501@us-mta-562.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: passthrough: Fix InodeData
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

Previously, the `InodeData` reference counting could increment the
refcount from 0 to 1. See #25. We fix this by using a CAS loop.

Closes: #25

Also, in `forget_one()`, we change the ordering of decrementing the
refcount to `Ordering::Relaxed`, because the refcount itself doesn't
protect any data. Furthermore, the old ordering `Ordering::Release`
doesn't make any sense because there's no side-effect that could
potentially get reordered to after the decrement.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/82

