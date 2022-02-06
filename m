Date: Sun, 6 Feb 2022 08:51:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=Tc38Rw6xVmeMGna8kd5IS9I9MJ+gqzhWszlkdpqFOtM=; b=p
	KughbDUR7OAKY+A/P6i4wTKz5LrPKqwO+rwTAVXlAhvceMXPGqmyNlPvKtoVsJc9
	czoPcU0mOHN/ltisKwyoALz9B6S79SyF844cIi+bgY5fALOkViEx4+WO9cHSBG3P
	7MCUTP+lvqe68R+P4jRV4b6dptp12hHsshL+fUb8yLGq6CiiWsg4gcSRTuF8LVH1
	EKd1YfXVbvkbFl9g1S202kcrDV0Yyu1JjL2YPo9++J+RIBPkysVZok8Gq77ynHER
	hAU3I4k6Sf84yC7eBv+zf9FDBxGxOnknONhUGBylPmQyULUwx6RWLdrNuPHTi2MD
	7pWTJe7Iv9jCnXfx2yC9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=Tc38Rw6xVmeMGna8kd5IS9I9MJ+gq
	zhWszlkdpqFOtM=; b=UrgC9XocdQ+nzNnyV/q+i2Z4O44lqnF6xye8b6lCha349
	b0eLScm7uU1ri4KfT6B4W9Ka3GZlTntd29zHQDcOtSWYbTl4k8AUybbuKSY8GrP7
	11ToKeQ+ZETp+saec5R8bz2HvsQ7Ib6XUij++JyK4dYvJXmFnxXGG+v/POiibH0w
	DrtW7RWosQv026qwT4usaDwnAITDX3DubJ9jNTlfrPd6ubI5udbyfObxitCV9B4R
	r2aFxy1KCwIXLejxG+JoaE08eXb1zTmuwFwCbTJxbKsLx2+QqYzxyF8A0PElnoFD
	G1B3mMPvdby/L5QA3tw9T44zjzjmw2jo4sxZbQ3Mw==
From: virtiofs-bot@sinrega.org
Message-Id: <36598.122020608511000145@us-mta-127.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: vhost_user_backend: Remove
	unnecessary Mutex
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The `VhostUserFsThread<F>` doesn't need to be wrapped in a `Mutex`,
because every write operation has an exclusive reference, anyway.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/89

