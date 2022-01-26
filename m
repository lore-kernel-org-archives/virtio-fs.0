Date: Wed, 26 Jan 2022 13:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=zpW/sYwiLqZh4AYEGUTt0OlfwWuGpfFk908+MTj+usc=; b=K
	NIMGNflf0HvfFWEGDJ8ie587os8xeGvYc4BWRSraYZMRkWUxXEe5PT7YGtmhQc7d
	EeJsiNtxpVZq0eGQy+90m3W66nVtw4YTnzB3snrXvrhj0O44vyF62C7IUdjTP2Rn
	IvDHS1tXAsFgblCRe3adR7nfLX20bgqlBkbklpqEBBdmXqYzvNsESvjxs3DSwT6E
	DiOHEnxOCX8dXnQk1ho7Z2tAgvFzCkm5KLDDgJp/PH1fZb0rHuvqvHkot5CedrAe
	xq30qfTFsBcOcIiIfBC96P38CfRQEjFONQvhTVh2/kjh7I0WEvODZBB34A6NuthW
	Qokfkf7FYvMkan8hWpc+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=zpW/sYwiLqZh4AYEGUTt0OlfwWuGp
	fFk908+MTj+usc=; b=WbwJegIB0pKQv4FvFpkAclNfjU47bpirrSNDnbA/yKrW9
	xfBYN5Udv1gsEU2ydRY9OCfVhV08otdGoRHClc9pbaeFRxi8aR0haWLM4nge4Jz7
	3zvBeXerZltGNuWVGocN9+sIWKr8/wGqB/vIePViX915mKLDrHGDuxcs42/KVnoq
	KEpJYQt2mv2YuBHAQrDh3CrM55fSEIW1yWstcxZ4HoUU3QxStjaKjjvcgL/rKL1k
	ERZnETcHjKGVyHlSAHup01qUiXY0ephI5wBiK2v6dl88tSKI7On2N5ECRZkCFPeO
	0WH8L24u28VwFkD/5L5tHCho1Yf2G/Bv8ZE4G/fGw==
From: virtiofs-bot@sinrega.org
Message-Id: <72580.122012613260600308@us-mta-658.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Bump version to v1.1.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Following SemVer, we need to bump the minor number, as we are adding
new features.

Changes since v1.0.0:

- xattr mapping add a new type "unsupported" (!67)
- sandbox: Support combining --rlimit-nofile and --sandbox=chroot (!65)
- sandbox: Propagate exit code from child to parent (!64)
- xattrmap: Fix documentation for type "map" (!68)
- Adds compatibility options (!61)
- Replace crate seccomp-sys with libseccomp-sys (!71)
- Drop membership of all supplementary groups (CVE-2022-0358) (!77)
- Adds killpriv_v2/no_killpriv_v2 options (!62)

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/78

