Date: Tue, 7 Dec 2021 08:45:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=Q2h9E2qSSURrpVtEXVVHId/jcOkjU4CUSky1q
	aBtdr4=; b=G6OSjX3ecds/VIBE61FF4YnDRd9yBD5eu//oLhZ2Fl5B/4Qdn5BfP
	9gzFYcXzKThmqvxx0/enVZesWmduAkWFTw/fSrJJWvi6za1LTqwk9lL7JgG8Ejon
	Sm+AnWDn2FRr7GlIojJ/ZQOK/fenElB20Vze5ypyDIdu3jOTWlo/N0R6shnuE1NZ
	vPBTZcbD5j6t4NN3YEAUqLfHOuYufU8VibOo6k59VqHaHwLdNbLxwJmvk6XilY4j
	mGi2IpSPF51DfJYzn4xvn7H1okgvZlII+E6gBplTZ1hd+8lhQ7fXU3xeQtLW0MAI
	gMyT0JrdWJco+t03xafveD7AZspvV92LQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Q2h9E2qSSURrpVtEX
	VVHId/jcOkjU4CUSky1qaBtdr4=; b=X5GpXX5mmPfo096vCUIFRew1MYDrn8wzZ
	xNOhR1iKfkQG8nFVzRJiqkOUH+3HvEPe7WnG0zcPaJR7CdrAvY3Zra3uG5kSGtN6
	MJMAY5kZGMwVaJiTJ+Mzc+M94gcIasi1Z3gZ6Aejw0I5d3kPsabwMFWJH2J4HED7
	YxwA9nzIY1IaZ8j1UNBX7RoVtj+Wf2kLlJDaLlQhdHH5u/vK0lSvAGgxAbGaAOkN
	rEAsLOwuKiQfy0IgMQ3u/HnuoohzhemHdsKW0ZsZaBN23Q/VBOZdi6huQ68Wm3Gy
	/JyRkXKYsnnSiwqh4x8VIYqDF7VAbjOQ1tDexogMCEE9zvkW0xHjA==
From: virtiofs-bot@sinrega.org
Message-Id: <56655.121120708450001939@us-mta-188.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Fix support for non-x86
	architectures
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

