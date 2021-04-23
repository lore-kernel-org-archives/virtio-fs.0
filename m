DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=yA5NEyjVMSeDdIK4uHgC+
	RsQOYV2MoJ7o8MnT5E0n0M=; b=XA913gKNE7QylJCazN5aD7QpTtWz9roiYAlHm
	aYWfwVunpkyRer1Hg1rCq6LarSizguC5H8HGZheDc3UenNmHnJRes92bulbHhvBC
	uIJoxRwoZPlKmr4iCpZ8cgEibKXvoFXEg1/JjhzMx3x70fR2XuL3UoCWBh+/MqRw
	xBf1CC5lHDaN4XY07A3zm7E+nFUgS0XdFh8kW2gDTGihtfSjtQcjUlsBavlbw4Ym
	pRD4omMpdWJ+Yc+CTIH7Et94i863/r0kzly8exBXl9HsUQRDLNVrgsyCPWCw/VWd
	XFC6P25p/IFihjZ5GIbNnCdwcw3J6ByHsrphhTG1ecy4EMw/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=yA5NEyjVMSeDdIK4uHgC+RsQOYV2MoJ7o8MnT5E0n0M=; b=b/dBZz7h
	yrux+H5x1xZfq68t5cXAWshvfqo1nAQzpc3mLTBvQjnrZsSVsKJbMvzwvW/pdS3R
	7kUp7StIP2PyBLbKfIvtyn+l9JY/tt7xjVL7DnLei0dU1Wm4BqIjtkhQ3az2iZEN
	BfeZY2nDH/VuY0k9AvUMSWCHQ2i03NODi1baDGJ1H0qotFSQZh55fgY2a/YJ6vey
	Gp1eKHSqzBFVBOHpTBDLMCn1gNwH9kGXIwChMVJDcr+C7q5pN+n62C/CmuB63DgU
	kXL6SaAbMOB5GuJQu/z7lGfGv73z2eCGXDEgFFPtzmftut2rzWVGoXYmeIhV2vhE
	fZCyAmz5JiDnwg==
Message-Id: <20210423153229.39721240054@mailuser.nyi.internal>
Date: Fri, 23 Apr 2021 11:32:29 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Fix killpriv v1 enforcement
	on writes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The `set_creds` function returns a pair of ScopedUid/ScopedGid objects
(well, they're `Option<Scoped...>`) that change the effective uid and
gid of the calling thread for the duration of their scope. That is, once
they're dropped, they "pop" the new uid/gid back to uid/gid 0.

Trouble is, right now, these objects' scope is actually the lexical
block of the if statement. This means the current thread's uid/gid
changes only for the scope of the if-statement and then is popped back
to uid/gid 0 before attempting the write.

To fix this, retain these objects for the enclosing function scope
rather than just the scope of the if statement. This way, the thread's
uid/gid change is effective for the duration of the write, which I
believe was the original intent.

Note: I was unable to test this with a mainline kernel. I dug into it,
and I think it's a backwards compatibility mixup in the FUSE module. I
sent a patch upstream[1]. I also tested _this_ patch with a patched kernel
and verified this works as intended. I also verified that _without this
patch_, the privileges are not killed.

[1] https://lore.kernel.org/linux-fsdevel/20210423151919.195033-1-ckuehl@redhat.com/T/#u

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/24

