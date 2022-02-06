Date: Sun, 6 Feb 2022 12:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=TD1sBrghyPCvUPjk2De3WZOQMHRUYazfqE50sSx1VtY=; b=J
	PITeroSg8VY4hyQ3vx5GTIxBN7rhMh4RzouZhogXawFsDYFoN4ywdkvUIzEjFpBh
	JwguexH+atsjx+FUIb2b1P0FMTvGw+5tEcD4A44QNV096QxRRM8LQv/KViMkBIUY
	YGhv2EBrq1+vk+RSth7QX12NZ+nlZs6qIkQ3AFXXhXnLsao1noxpw32kPJmwH4J2
	yt82+DwUfXMKq346WlK5OBng0qqIxD6YgXRBl3cKwqVPNWE7B0wqY7py+p3rrAHD
	ZslqnvGu1NTci7TneGXzIAC/6r9WCpruS8MYEYPJHcO6yrBPTagm0OM7gU7FbFEw
	zluz4vZMI/thBSwy912sA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=TD1sBrghyPCvUPjk2De3WZOQMHRUY
	azfqE50sSx1VtY=; b=W/G2WUwVg64dJDyiEnKQ4+EMjJE7T4VHdUbzZXehucUfJ
	SrlNerhFyOdRP1Um1tG1wUwTHgJ1xJeqWKaux8BLLCSEKoPtySaw4nfFlPzCQwkI
	aeJnhnaCKYZUJdbId5fOeZwpnA0khSBvjszkNqJAxzu2X3Seblb0uOyt1hBilaTK
	NkVQ40t02N+6LlkYMMnrddptFNu8750dgBiz3Aa43WfvBvEY8Hrhl1JuIE6BRLrB
	zIp4cdHe5Nmq5umeMX/9UFih2xQhAhShJBOeOLqByXWFX3jbtWO2OKDnP0rozpYW
	gVeTYkmS0yfNqo7OXZojGvml/AzXPOSRVeuVtpSWA==
From: virtiofs-bot@sinrega.org
Message-Id: <51682.122020612260300169@us-mta-261.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: process_queue_pool: Prevent
	queue starvation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

In `process_queue_pool()`, instead of processing the queue until
it's empty, we collect the entries from the queue once and then
process only those entries.  This prevents queues from starve
other queues. Without this commit, `process_queue_pool()` might
never return, preventing all other queues from making progress:
e.g., the REQ queue might prevent the HIPRIO queue from making
progress.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/90

