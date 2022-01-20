Date: Thu, 20 Jan 2022 09:15:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=akd+ZWPb1s8OsHebYeuSmWmHwO0Cv1cFOwVVj92IOtI=; b=n
	nLZsTK2979KHhvLn50+sRT36sIedqIUM9+ELsWdMKZZ3HBltsoryIyYNXMP3YdaC
	o+HSm4v0rZBppbHJynDTKN3akGy2BxTZFmOfCH51AXNRMQHL5GxOGVf+Jh3FtcKr
	XSZUl7DpQiT6A/ZUsFEsn00fD3iwNgxhkVTgs16J2WjWhlHgA6FXCB8tL9HZxkym
	NqhTtm0o5syx2tHpepaC2vFXwdxkz4clqY0WwJo739XqRV+k9fmLkYTAWZn4eYa1
	wRUKLGHyJctTTTrOuJ5uqM/6q4qDKoPwkNBXJAAd7291ox9a1v1oiqAvXXYb+UL7
	hD2WFQHfI3ZGQ86JVkSGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=akd+ZWPb1s8OsHebYeuSmWmHwO0Cv
	1cFOwVVj92IOtI=; b=gGgW/OkrRineZ7wbMhdJwAD2XiyzMZze//ilN0IgFEAz9
	rj154JuNqucg+hKZdJIBHRbeF7o/b6GiBOIALOICoCNydiLyN7LkFmhK5ZDHtzcW
	ZBGujjpEAos8+JiPpR4q6Iuy0vDiQskb7E0zUc6VbuhO11m58vcL/cRBtaFqdZ0y
	UYGH1h6etzSUSxM4sKqptT8KvKg/702zw0Cey5KT2TmfpdsZpcym534O+1TJYiRh
	U1nbKSwde9Vn81v2o9HT5PDBrUAK2X/XpoCH0G8Nj+r0md0CTxvgKS2bpZpnzs2G
	xl8UKhDSggTt8bFkHlctfyfLM6igjp9j1FqNqpaug==
From: virtiofs-bot@sinrega.org
Message-Id: <84039.122012009151301618@us-mta-479.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Flexibilize our deps to support
	new patch versions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

For crates that follow SemVer, flexibilize the dependency so we can
support newer patch versions without updating our Cargo.toml

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/72

