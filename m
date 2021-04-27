Date: Tue, 27 Apr 2021 10:50:24 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <59543.121042710502000137@us-mta-336.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Lm3ENkXazy8jzMXde
	pffxoAWFHIIjn7lK7TfBDb4A9A=; b=qnH/odvBc2laKbJRmYr+rH3w1FrgBxwbM
	6QJAfmIc0H7tuKPe0mfxaA4fwyECnFgxPHzUbcbQ6GdeZ2iMnzit8PDgKdtsGQL5
	vGcYDkqiiSf0+lPN9/fZvpCfgqX80fpAtqN3K23e6l9DRfhr5ldBXTCpize4OhaB
	I1JjOnV3N69qdnU84TKfaRhKv6vpaj7+TWRAjr3jftXpXYXcHEt4ZoemDFXpYQPT
	UeKznmXulQNXg/WKtEHOMEYk0AoyAC4FTWPMH7xFOGXJzzcYsLtrh9f1Ac3dvZOZ
	WnW/PeY3eT/kgBbI3BKmMrX10vSE7vL4eD/Q+TCpFgJuYrZDNVPKQ==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Drop security.capability in
	setattr() branches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If the security.capability xattr is mapped to something else for the
guest, drop it when executing the uid/gid/trunc branches for setattr.

It must be dropped on all writes and the host kernel won't know to look
for the mapped attribute; only the server knows what the mapped attribute
name is.

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/21

