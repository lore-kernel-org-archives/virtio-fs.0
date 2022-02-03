Date: Thu, 3 Feb 2022 10:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=l5g4pOhpRE3eIUSF1Dn4OMZ1nPBJxZOs8DmV35PrJE4=; b=h
	kfnYn6WiJJQijnvgv46/rvGVPMIrcCH+ZANeKW/+YXIyLonFisJI3n1FBrKz4Eml
	nJozwIfqHIjPHkp2ApNuuCsjZtai80o9u1crE9nW0PCeYySq6WmqMnEnwr4IPeJh
	ocFvRowln7XrOwRBLXUU0x0pc6MCNBThzBW4YfhVF7T8GcTDIPpbfTNk4/siFGti
	TZVc5MiCEMRMdb15QFREjY3aZio0/j0GFPf5fqb6eJn7ELWC8IFSC1fGaAIcaa9E
	EnsIGrz7aOgENfNt/lAxDY98Hn4WL0FXmw5KhGA8K6nyi3SsIQtCteF18stvpN1j
	w4Z9Qyvgxit1RsB/0YPeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=l5g4pOhpRE3eIUSF1Dn4OMZ1nPBJx
	ZOs8DmV35PrJE4=; b=E1v9XsnR3t/b5UxblfU0ow4dzkzQ4NpO9WRRZiAxodh8h
	bJr91NokRcvLtbO/E/CG37jqs1zSW5Jugoxj313mfnhb4ILIpZEShnr6e3NtiNaN
	SUT8ngwvDPNHhBbo1dc9LyYclCeqCmP70d1eRSbiY3SuiDNJYtehSD2RAM/J5BFZ
	dDwc4caLowIVBk/711UN3DI4FvO0ftLpuQc/RnaeHKMQtCUIDW8TPxKzr6jgQvZQ
	ulblqCd+A+M+zMxi12zhlPADykQowJAxbInKwJCs8NB7P773g7LGl0kjCRD4tPQv
	8IORlNIe7wHdHJVn5z9XwPUl+bJOKLmIVvz2LZFgQ==
From: virtiofs-bot@sinrega.org
Message-Id: <67550.122020310293200663@us-mta-639.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR closed: passthrough: Move some functions
	to new util module
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This prevents cyclic dependencies in another MR I'm planning.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/76

