Date: Tue, 27 Apr 2021 11:02:12 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <81609.121042711020700920@us-mta-425.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yA5NEyjVMSeDdIK4u
	HgC+RsQOYV2MoJ7o8MnT5E0n0M=; b=QSq1WEw4NFhgsnWoeF6vvuAkzuf4K3jF/
	wGds3PlunvsChRGvF9DQ1MkhquOMBE3b/8wksH5UI/TTcCYrBLD+vSf2JMh0v+TX
	mCAWs8A9HCQp8cCs/twu9A13OWV/C5VrsiKeI1X75sZ0R1Lg1gFSXNv84oSKvIJ2
	TAFtCXuHxE+U5PSOH7j1jbhW69CfyKbAPVMKN6qG8vZq3mTtS6SxyOxG96tOUN49
	BqAINjTTZ8Q0iIGrIicig2FVSCWg6VdsWP0aa5IOyvAiUatJWaNpe/GuMHcsJvXN
	gGbMsJQohLsffy25Y8oyB0IWWhY7HcmBN+zZGOaZh8BUFacBuYmBg==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Fix killpriv v1 enforcement
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

