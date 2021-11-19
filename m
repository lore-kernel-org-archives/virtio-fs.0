Date: Fri, 19 Nov 2021 06:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=xg5K6XE1taO5fAmCUukHngZ5kaA9N9yILUCnA
	TygCF0=; b=H2A3sA/lwIFf+nNRTvo8Qtu/gVtgBWaAN2yuNB2ORS7YtiuZTNAkp
	J9anMxIgNf26flBBYTIrWBEstDzhZkK7biRIsi0g2DizUmuVz/woD83tr5tsjiUE
	aH4Gy4PwC4beSNi2q3dLYs6WTI2frdHuk2PChJeEUDLhAft/lQUeeVHVxeIyFqqN
	npiVKI4UMKu9CoMH5emXWFaO1lincW/i3YRmebrgvn5NHR++H1TlV7j4fcg35hs9
	BfIytltKfw1fNWFzo/zR9zi1eJgsWltjQNZSsk1YbuNaTQjDcRDmmE2R+Heq7oXR
	f9ToHQWR2L7H6LBbFd+NxlGvwE+FeqTEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xg5K6XE1taO5fAmCU
	ukHngZ5kaA9N9yILUCnATygCF0=; b=JNMIXltjw8bQ3XvzMj3EX/e2k01AeLyt1
	9Tf2QEH0KfTqY022YAIgIeLKGOr2wrwHYCB2aMoK0DL4ZVKlHeDvvvN5v8UpkM9K
	KW05z2jsQYZnm2AWipr6cb0E5IYjnyFU4ccDvEX6/x0yBTcXpaJR0Thf83cwyegV
	6uNVFUlE9Wb2iD6GV45byL9TvSYZtLVGKDdF1dlUcctGTiqm4UazsFjuRU99Vcsl
	mTU/sRAWnO/A2IsST75UgAmzUQQw7e/UsNtFIHpL6yIE94TRYsOKb9uXPY2XpieS
	cl0yCh1JW0a7ToQ84a7dCVzryKHbHhPhMK/I4MUnXr6CqSDiZqFqg==
From: virtiofs-bot@sinrega.org
Message-Id: <76168.121111906172800154@us-mta-490.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue closed: Drop unneeded capabilities
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

As part of the self-sandboxing process, drop unneeded capabilities. Some time ago I created [capng](https://crates.io/crates/capng), a crate that wraps around `libcapng`, and I'd swear I added support to use it to drop capabilities in `vhost-user-fs`, but seems that I never created the PR. :-?
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/7

