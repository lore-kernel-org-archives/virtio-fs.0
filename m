Date: Wed, 26 Jan 2022 14:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=gCF0raMZ/0c8Cw7Egr5SHRnmSP2OMc48mhqtQ7D4nMM=; b=C
	+PQgJimuwijSus3ZoqW1c+Rmd8Z0g6aeyHvHH+vb14zk9VEAtOgG4QqoHiWeLyOm
	p9z279OyVBiezaCibh0I2s50YfS1i5/XYqaeWsFgYcdPYGYi46s0LnEPhpdDmNPb
	/wAD7bHUsqa1vdUinpibwqRULjodCCgQSiwfjfS64b1Q2BQduI5uKjXv+hDObX0Z
	orOA+BRNTzZn6nQEZ/9TLmh/fhQfqMgVCSfqG3WyPfxrXOXt0vQvLke0vYoAN9hH
	sXpTBTe7jh9hmwNx1xp0+u+PT3dWKPoqeOzvNTXW5hPlQsPVs7fc0wDj6zjgV7A7
	ekAkRcaipkthuEOVWyU0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=gCF0raMZ/0c8Cw7Egr5SHRnmSP2OM
	c48mhqtQ7D4nMM=; b=ipb0/uAg5trbuqmewpy7Xh9UOmfJK5i1NyXtpz6jMBLlw
	ybHs2RHbJsFPE1IP8x08TTP0b7c2IJxdXVOwu2GTaoIkIpMrZAcA8fhbo/ANN0D1
	I+kmhD+DUcddlV2AQ0pcYYfyykSxE8eDg0Xm5nx1Dpx9RhLQKb8QcrmaQffTCmMu
	wumZlhgw+lT8xw48PG8RW8CI1CDJMeWBSmmKQVkXK6z4X4g65uuz2/DQe2jHIeMM
	6BWXFyyU+4hVx8Rf6DqkUVGvSEkl7xnDyEIVSVDhm2Mfmah2r7N7yRuHm6MM3xeA
	/gd6Pje21kMiGSD2kScXHyDNubB5QsEBrwowKQRKQ==
From: virtiofs-bot@sinrega.org
Message-Id: <78111.122012614243600545@us-mta-272.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: mount_fd: Manually manage mount
	file descriptors
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Still we have a hash map of all existing mount FDs. But instead of
refcounting mount FDs and letting them remove themselves from the
map, we manually

- add a mount FD when the (sub)mount inode is looked up, and
- remove a mount FD when the (sub)mount inode is forgotten.

When later implementing FUSE_SYNCFS for the case without
--announce-submounts, we need to defer removing mount FDs until
syncfs was called by them. This can be done by either (a) calling
syncfs on any mount FD that is about to be removed, or (b) keeping
them until the client calls syncfs. Both ways ((a) or (b)) are
easier to implement on top of the manual management introduced
in this commit.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/79

