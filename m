Date: Wed, 3 Nov 2021 08:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=Sc+3hD9PUHVnU7eHcYkeRmCn+aSOfXPx3/0Ww
	zPnQhA=; b=GQSrhY/R4oa8wpY7X5/zOxOg0bhMxshmG+EDeB/RjJewoeH4V3Rlk
	GVYSAZLI+XZnzZoJfvX2xlJ5DEQSEc2eJj4kb7JU0gsRelj0AAiTRWpDzdrw4dLX
	MlnCpLTE4Gkmuvkw1I+0bD7pjwyNM9J2OnC1ymo8+jyHuzZg6BOXRUXdZwAjZwNC
	bV/N3b7K3Pce6Q6aDJTT/I4py2hE0ATHnvEwc8raDte4gQTKiNdsQhJaO2fYd1yv
	W00xjJkaDuXwOIxPVhCuWJrS5H0Z3e1xRkHtnXlRL9grT4kdxtW03bZr2ICZrJiJ
	148yBTNcZM0HCEsPMRJKIqKmcUoxaU7XA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Sc+3hD9PUHVnU7eHc
	YkeRmCn+aSOfXPx3/0WwzPnQhA=; b=nJ2c1+sEhRaBoKd0s2vrLiHeJ4VHN0bsS
	+AdZJjE1BfpjWOtEcwUZdz6626raUF9Sz1nnyA5RzEbM/G8Lp4UL8lGk3ZoJbQ/y
	CBx3gEQlcuqYJ0jbGNbmOBFtTGm2GUVGPWmuFuAImiFWtHj64CoSuTdDQLfQC3d/
	24wG7dKxerpeptksh+tU3SbRgiQw/buVugZP3yX7gTsbXD7qrqXPIQ1rwuJ8x7aJ
	3iEyKS1LRSaRSgrobL3NT/Gl5tN2mXhliBKhkCI3nrSSyunLNlk66/Hhh+y4uSoo
	TYS4347CjizWLuw8Z2889leXV04JdG3j4dI/fi6j0/32EhrjzihUA==
From: virtiofs-bot@sinrega.org
Message-Id: <17342.121110308474200189@us-mta-118.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue closed: Follow-up from "File
	handle follow-up patches"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The following discussion from !41 should be addressed:

- [ ] @marcandre.lureau started a [discussion](https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/41#note_703625402):  (+2 comments)

    > I like it even better with .rustfmt.toml:
    > `imports_granularity="Crate"`
    > 
    > ok
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/16

