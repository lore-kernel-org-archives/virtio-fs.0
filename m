Date: Thu, 20 Jan 2022 06:56:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=Y3K99WKbK0eN0xJwknJWUCeZPYTAJqsz0rVFRDdbRak=; b=r
	oUIzGufEaUgJyAIyPesk+YaDO4GRYJIySifSTOzmAsJh3Cn1WspQvfadL92aRswj
	uELnOHnLl+ZMbTgqucqWKPnKhKhlUhsUqESb+BmbV45eMNiSIBVAum3ZmTQ5qn+U
	99qWaCKjWcumNWGwTVZexhGNA7LU/YjN5sp0AkdbqtqbYHDeWTuhoaNMBb/HleCL
	0Wo4YOrcDZICA3dYW+pBYbOzUbTE/68A3BLPZin+JR60FwyTRsZSZh9I6CuERCDL
	4CFOI/TaxRt7aoY7WYpCUnbJDwFE4h4/4pP39qsicnKno9qvTA4LuzXMvnU1MWDi
	0jPhu+/Rq03/trT5riHTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=Y3K99WKbK0eN0xJwknJWUCeZPYTAJ
	qsz0rVFRDdbRak=; b=WxhZgMohqmGbILgfV2wp+ebOTA491f12w/mwBcfWeUrsu
	FzzRoRkUDi7+S4ZcBSdO28rvkQwcBD1But7EyvnRT6Lcm5+dK0tmO1eZTFSLH4ng
	s1bmqE3d317pQoyllVyMxuNDpXwKd5Ym3s9dP21fkEYlBI8ly4wxi4fPkBdum2R2
	D7LTs2esDbzp0kyIgzunCSQv1uCLrJhhAJmVdEhrSv5ZRX2btl1gm3v0zCovfzOh
	AX6hZwHIjHrw2vww15v9d5JIpN88LoqZbrThutOdseg5waOl/cRhU8VQodp/0pJQ
	TNpcvW+ybB9Y6z860fK+O7+8PaecoFGMMkiFlK3FA==
From: virtiofs-bot@sinrega.org
Message-Id: <69042.122012006564300794@us-mta-497.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: Release v1.0.1
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Checklist for v1.0.1:

- [x] [Adds compatibility options](!61)
- [ ] [Draft: Adds killpriv_v2/no_killpriv_v2 options](!62)
- [ ] [xattr mapping add a new type "unsupported"](!67)
- [ ] [Replace crate seccomp-sys with libseccomp-sys](!71)

If you think there's something missing here, please say so.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/24

