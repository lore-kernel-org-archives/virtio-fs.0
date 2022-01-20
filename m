Date: Thu, 20 Jan 2022 06:49:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=h74sR9poeaQPRjIPdsOutd3Kk4yuf9IvtCvwjXNIOW0=; b=n
	ic9v9oLjKiscRdxE13d7JNO7Vg6h5Fj/vSgZ6AG16INUYcwgImCOjTO50lrGv/3N
	YKBqmqS7drfunpyUK+aqAol4z6SMoE0qjxKvkf9I6usHhx2EwEHlUqWcdEdGL1EQ
	hfpi5KCrmaX3gydO8YW6PZQVt29r4RBSzYdQdQgik9AELBjTwJiEIswKttnzWL7b
	TATmWjXfxuo568L7V0lf7DZxMPKdxcVTNpLWcQwfk7voyvrsrg3b4gqAbMOaudGa
	vbBjpdipTZVEIIYrbm7sAbWIH+x41wBDLrM76DZb3jN/1zjyCYZDHUdN4HaqjUh+
	Pb8fqq1HkVoz0AR1ZpV3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=h74sR9poeaQPRjIPdsOutd3Kk4yuf
	9IvtCvwjXNIOW0=; b=e40utDX65kzx/PZHgEywv339OhMTSq1FPlhokfNCISfdF
	OwqjysA8FJhPKYY5cVR2wXv0Yvmq7GHTTSzxnHElqtDn26mM3TC1zQLSz93Ej3fK
	TXAJSMVucKK18cQ/n7+n4sJje/JUECzHt2eN5/FSYrAKvSt7x5OQ8rI4klu1WWj5
	DarpWJBa8dfZpf/jja1uzNGgTafcV/uX50oX933RIul8q+hByVjyDYrQkivRFugM
	Lnk0a7x7istwpUWFZgRMLpooadrMK4u3l+m1MgoVAD5biw/TxZjOdKcq7UfJEvSL
	IagtSipiawHfQcY+YlTbA9z6Pro2W6ySpfZ0FepQg==
From: virtiofs-bot@sinrega.org
Message-Id: <44474.122012006494001405@us-mta-626.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Replace crate seccomp-sys with
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

