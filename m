Date: Wed, 26 Jan 2022 04:53:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=h74sR9poeaQPRjIPdsOutd3Kk4yuf9IvtCvwjXNIOW0=; b=O
	SqMVRGZgUqSsOM9mmlGw/9pmwQitoHNjVkw2VX7B/+CwWTBGieZ5pD7g32msliLS
	JVv+f2cMWN1juhzUu4odkP4SxnpSjq5JQBWHmVznw4CTe9y4c46COHkPxCFDg947
	jQOZdPqFr9c01jWMrfkhsHpFkVW/gTYt7kBbdWnUDXpBBaWfHrc3UzyMvoNK+qZS
	Fd4EXx+L7VlxCAtnCRXmbxYkEBfVVNxVOqea5/FO/EMuftrOMIGQB86ft2GD6vO7
	HF2kALeA58xYMnvmxXy61MBF+I4jG9/r0FSj/Yf4klqexsLTOAECbYS+V9g5l/xX
	2C96D+igvE7A7yoaR46Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=h74sR9poeaQPRjIPdsOutd3Kk4yuf
	9IvtCvwjXNIOW0=; b=jCr66FG92jVukE5OwOR0AgT5l4sFGT8ofhhOb9MxVJhba
	aAA1h857YD+XsEE3GpmiirWczuOSe3r5xRlTM13/9ZQ9r1qMcOG52rNHgIehS4Lh
	UOuTjMZFmGEHmlH7rdJh3BIT2SLvUQRqYFsrhEblPErOgfbwR/MIpTSLFL1RrCil
	0wtee4H2mwhRt+pHdqZtZmwHsWjQbeJGHW7QiYsyKuGTtNhruoa+qjfr0xfJkzC3
	PITfybxqDQxm5/dcco1weJmVO5DBIM8b7nomIvsMXTtZo8QjRJRbSONHxMUggxV4
	HC41hZ0rb7O5yIymP56OSWHpXI+MKvv0e+wwDxUpQ==
From: virtiofs-bot@sinrega.org
Message-Id: <30150.122012604534800147@us-mta-38.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Replace crate seccomp-sys with
	libseccomp-sys
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The crate seccomp-sys is licensed under the LGPLv2.1, which is
problematic because code from crates is not dynamically linked, but
compiled and linked into the binary.

Replace it with libseccomp-sys, which also provides the bindings we
need (in fact, we only need to change the reference to the crate), and
it's licensed under MIT or Apache-2.0.

As a nice bonus, the bindings in libseccomp-sys are newer, meaning we
can now support the "log" action for seccomp for real. We'll do that
in the next commit.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/71

