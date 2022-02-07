Date: Mon, 7 Feb 2022 10:45:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=JlC292hx0IjOuYujVBeIlXsid/GxXzFDaZwZOX3b5c4=; b=W
	6+lElWTaxjM37bjKy2IgoJcWNnD/go3YDszOQPkV4h7VqkMYGwDNhXKb5DiESQBU
	BO8EFjTqYVlEsxotN0HW4iJ2gKK4ZovTuV2LQP1OV+02jOfPoe2ORqCH24edW/Zb
	KAT75zrhhPkHFyJ33zzeoYmj22sb/dYIgoIT+R8DiuURIMN9987sa1gbZjcp77UL
	v311Ngf/WhctFMPNEthEPHDuv9y/NYnIhYGR48u5qZ+q7HkjQgg490561AWlQc5o
	564pPRAyIDmpum7M9aXrcIf2i9pOx1AyxYBgt4iyq4pada8fdgJW1guE9bYP9Sty
	mdMYBOseHS34assb03m6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=JlC292hx0IjOuYujVBeIlXsid/GxX
	zFDaZwZOX3b5c4=; b=derkuyXGjkUal7YbNzyEw8piKS5Nq37lN8vnY2/Ib8K+G
	FSo3kXcuILqEiZ4FVYSvJKFYKc1JMbietiwMQwApW1mHLG1LwZsyseLUI/A2dY65
	m8VCjfR0CQyTQPOeCT3IDL4E5iXGlr4/7vj6VvRnV6WHamgjvMGEUpsLcmDEdtoi
	vrC+V6Spw/4uTr9P/RHYv2t23kmZqjyFDnsduALN3VlTAwSsIqNywMkhevYiFMqP
	YmiRIFps2iWXgjKnaPeaQ6BN/T7DaOrEJSqop/17JHxSNtEHWc2/YTQG9IX818Js
	XcOxbggjCOYA3+1Tx7Sz/ebiEtMvwcIlm0vvsKFvQ==
From: virtiofs-bot@sinrega.org
Message-Id: <22015.122020710450700407@us-mta-551.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue closed: Wrongly implemented InodeData
	refcounting can increase refcount from 0 to 1
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The code at https://gitlab.com/virtio-fs/virtiofsd/-/blob/50ffd53962ffe10bc18760d91f21eae79bb7f42c/src/passthrough/mod.rs#L775 can increase the refcount from 0 to 1.
In this case, the consequence is that in `self.do_lookup()` we return an InodeData that is no longer in the `self.inodes` map. It probably doesn't violate any invariant we have, and hence it probably doesn't lead to a panic or the like. But it's nevertheless a behavior that's unexpected (and probably unintended by the programmer of that line).
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/25

