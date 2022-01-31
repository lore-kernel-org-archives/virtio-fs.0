Date: Mon, 31 Jan 2022 03:52:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=5dqMUoqHq757q4GPtpuWN1mTLGsx53XUwgXYjnorNXA=; b=r
	3mhY9DQfVsw2B5O2uC0JDXrUcaRrYFs2Au0v/xPvcoTWrRzlbfPp4WuBmtJxuilP
	81rsJXEmSDkMuA78xVVFhUNhkO3J6tUxsHrZmVFdGLOpTnsvDgco5K+y/h+YP720
	fp9bd8l/zq7ZdIBdlXmIPbXFntfKs6YHjM1HA/ZQzM5sIKmryub04SECBkXilQXX
	wNNrXiFFMs4YnuUPue/aker3H9w17rctGTZhNfw8korklWUE9iusD1+q61eNDkQQ
	Utl5ysNLChX8OOpQRaqzh01enwr+se4AO0j8/o859cqp42Dqwd5sMEe8vnUUcYyY
	C3l87vEp+1KdTI2D/dG0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=5dqMUoqHq757q4GPtpuWN1mTLGsx5
	3XUwgXYjnorNXA=; b=KJOT7k2paKBwcC827Qjm8xKzHR8Y+Xb0SPIDV5SQSr9kR
	cAN67u6VODRwzvnE2LD67FC44IzC/1Ey+68by2Dg7RdzcfHec2KtjVylXSEF3JnU
	yVv5HvSV2JD6PWOPkq/VORIP0qkuDtI6dniyMSdfqxk83AcB6EieZfp1j53MupwO
	doXiOY7aOVDXkPZEPw7wjqwEgsvSadiK16MA2lB1oyTsjwJkCNUlzKIekmWBeWcn
	QGdPFRPw4OCJ9WLRNs14E7fwuTUYadrpS+8eTVdhYSbwX99WfS70U/KrCbW4dduH
	sMCj/pDmJxK/POjwHToDUT4tJEAWnMRWMS/rcEJLw==
From: virtiofs-bot@sinrega.org
Message-Id: <49949.122013103523301294@us-mta-580.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: passthrough: Fix InodeData
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

