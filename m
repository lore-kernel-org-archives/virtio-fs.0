Date: Mon, 27 Sep 2021 10:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=9EL0kRveUOgCZ5gaOjUDIVg2e/+do3udddFAq
	ceWdy0=; b=xWDtbhOrM6RJnm8svTpvLlE3bSq2DzwKvYuQpo5PoVJuGsoUD13EZ
	Twzf+bZ77LzyFbO6o0LAxfjN6XUkpqYysg2p8YZPUO8nSodMDLvULb0bbCRGXniV
	FxQiOFz29MDKzBuXiIGxHwk6v1y+Kgriho2EY+nY4dhHlApKf+J7ZH9KDZZfXER3
	70MBhrmfPojlwn6maQjNYv7isrQggIHWL/j2C327xvAtbST41139NBOkA0ZExKvJ
	FIljpVmZRusd9y9rTZlgieA/RVQsSBz2BXE+Iq+ZYQGuLPu1T6KiZWYFDKe1oTcT
	ljgAJAxFD0yDrl7WG2XZfnaWpjGahsIiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9EL0kRveUOgCZ5gaO
	jUDIVg2e/+do3udddFAqceWdy0=; b=ZjjdX01IGOhB7g5tcgMFmAx75pSMdVPiE
	BelOo9d2icB86xuBA5DBVpohYh12h/VI3wvxeXCrlynUdDPk8w4n8L3mTXj12O2K
	M1MXaqWAY4TzlO9rGuKcwmzRg9X8gNCoOLk/cr3hK+xyY26/AGwaFNdJQ2Dx1XUI
	1NXIcEwZdE3dYFwExUzKBNu03PZB5fxjftL2dYygZ5Z16yuugQm/xeJ/YSMwlmat
	RogS4cfkhpKN5t9HXK1CvuKZGW7brCG0/tZcVaaLU29Cr+awJSVVGHJAbuNXZo+m
	3WpsciF1mfSuCkfn+iMNyB5xMoG+8j86xqk7XaDn5SDg3CQm/f1UA==
From: virtiofs-bot@sinrega.org
Message-Id: <25913.121092710255200848@us-mta-494.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Update to vhost 0.2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Update to vhost 0.2
    
Update to use "vhost 0.2". In addition to pointing to the published
crate instead of the git repository, this change brings us the ability
to listening on existing file descriptors, enabling us to implement
the equivalent of virtiofsd "--fd" argument.
    
Also update all the required dependencies (vhost-user-backend,
vm-memory, vm-virtio/virtio-queue and vmm-sys-util) and apply the
minimum set of changes to support them.
    
Ideally, these changes would have been presented as different commits,
but we need to do a single one to avoid breaking bisect.
    
Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/35

