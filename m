Date: Fri, 21 Jan 2022 14:36:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=4J/JOhu8zdIGXd/0DzVMihmTh9qoc2drU2HmgfNbLk4=; b=2
	S0SknifsqNVp6J/RJ4IGJymaVpMqE+B8VSTronsaD3MfbkhXDuXzhDFKF0LBAVEP
	BrQg/13DDB1iR+TXMCaiCOK0DHlp0TwiXQL2Sql82uDuM+mukjTRrAvKWeiqCtH1
	d1s/sdl24x2nS9qI3jdkHxaG+vWdulHvNV9THocUf/X64ohaLQGGJPtF8WfbHMIa
	AtUepjkixRmpzU9x7cPn/DGhjVoMjmTGibHpgR7QORkRXRigU+zVh+r+bld6ubSp
	6Yat6lxQIXqXn5qO46lbn/J0dD40Qqcvp1JxqX3ScLspAIDlx295v5BzxQ370CSv
	mzWYrHz1ALJ3toOh7Bo+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=4J/JOhu8zdIGXd/0DzVMihmTh9qoc
	2drU2HmgfNbLk4=; b=Kwimk/Hv3D3bkk02wP4xyQNV7fHk8CKwU504AlZDaoPZF
	7qAmuZnuowNNeJRezvkvCp8JXJHgAr25OTqNRjZOE0AKcMbBE1F18BSCOFHPdwh/
	o32w3CBAVfm7rNIqFYGyOyPITaYlBEf/ikME5HByElXTYeocVdYxYG339CQ8TI4l
	T2Yd79Ak6vQP6in0/trAt9+0gowI2rDbfJQ64DiiaY5LE/rubo2zY3Jo1B4LcoUK
	2OUROOJj3guQfR9JCvsYwgHYpE2kXQu4+/cpMjepgROZ8mRVh6FezfPVba1MlLS8
	WUcWuEEILCFghNW2a4o8DRm1avG8Kji2FQjXumIzQ==
From: virtiofs-bot@sinrega.org
Message-Id: <69227.122012114365000440@us-mta-400.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: mount_fd: Use Arc for MountFd
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

This commit moves `MountFd` and `MountFds` into a separate module
and uses `Arc<MountFd>` for refcounting instead of rolling
our own refcounting.

Supersedes !70
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/73

