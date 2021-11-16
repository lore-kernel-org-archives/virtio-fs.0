Date: Tue, 16 Nov 2021 11:58:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=Q2h9E2qSSURrpVtEXVVHId/jcOkjU4CUSky1q
	aBtdr4=; b=sNZUvtDkN8NNbL+lfydx/3gW/2/duUVTF5nkioHhvMP2+IOLkpXCf
	CLMdZFZMXIc2rqHTeszE8bQbcPBiWp9zn8fymxoCVY5phVT8HHjk3j9olhcJX4M9
	Z2uN5dMjdMPpaz5F/f8gocQnYsuocBx2eqET9DTJ/gxeey06cmJW/0kfvv9asVQo
	Ra9kSJWLfvIg2b/PS4+wN4xBmY626fa0jsl8mkiFq3Vw87S7tb7kXwr6iBLNkDJd
	hFLkM4zWGJOCTganRxVkY5OVCquWITqDAvfkC3dB1alsZUIsha1OigxDrZejBErc
	yLzmHGYXtw6OwPQR44zgrm1NQkeAgMjDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Q2h9E2qSSURrpVtEX
	VVHId/jcOkjU4CUSky1qaBtdr4=; b=aZ03qsoMgix6EQz2TMGFpf6vC8Ss5DaLP
	TrrlvMTUFzmYNe8IExcgTyKOE3G+qzFCp3sqnI1KlUm5vY4fGUByWJ/iQZalHHXe
	HUc9rUTp1ZMdwYBvz4Q58Ux/ONO+KKQLHjs/ZdK3fh2Bkhs1mCDO1rDiquC6zaU3
	tgK2mpHqOH5inA7jO/rLGzNWs0NbgrKdEIvuqC3aFaFknM3+VcM8JFBAPrGAr5oL
	iW85crWSOShQWeM0RR7iSv0/HQCEJ2fK+LE/yjW+qyuPN1NVElwW3Hfc0a/rmNhP
	NGIuVdRYpZoBAi3j1ArK5F9HQJEHRzRd+0BS7nRBwyxKX/j8OCFNQ==
From: virtiofs-bot@sinrega.org
Message-Id: <41371.121111611583600221@us-mta-48.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Draft: Fix support for
	non-x86 architectures
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fix support for non-x86 architectures, or at least for aarch64 and s390x. In addition for some minor adjustments to the seccomp filter, we need to bring a newer version of `capng` that fixes building on non-x86, and patch `virtio-queue` to a fork that supports big-endian arches.

The `virtio-queue` API is currently in a turmoil, so I'm marking this one as a draft until we know what's going to happen upstream. I don't discard having to keep using a fork for a while.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/48

