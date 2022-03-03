Date: Thu, 3 Mar 2022 06:30:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=BwfVvNrgpoQuQ1ShHkg+kDtSQpgeXHnC8Nw4lEvDoYY=; b=O
	HkkD4zHsGI8rCvCqUU+i79I+0lYdTN3e5r6fSTV4d1HdW1H2lgTA7FXnacrUf9AN
	cq8PIukCxWQyoa5AEG4BhSdVG2xvM5Q69jZ1h+PYxn/y1rFr7g5KlonOkAWMUpQx
	p7MdXsOYlDlmYHn8/rgm9yWA02298o7XdUQEUVRkXp1pxMYjAfgABfPl1zT5FP8f
	ub3ED8YcwFWHsCeU7hNXU+nx0iSTCelLKXmivMtGkEIAfqWdcVxWMNM+aLx4PeSe
	XqW54fimcpc/iGtQSgUeQR3BQI4gPeB5prVlsAadSe/r4JraEUovLOcaFzEGvwvZ
	bKtnzZwa8GSnwOeNt994g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=BwfVvNrgpoQuQ1ShHkg+kDtSQpgeX
	HnC8Nw4lEvDoYY=; b=KP+11raRO9r8j1n22PLnQ9mVo6urYlpYnCGIQxZNqx34O
	83szCZtA/haY4DExnDpym1qForXM4hP8HJEi+qtvR1Ksg9idMZeVwT4j2EqAYWTi
	4JSyZSjnfASO9GarhWWo6+ogZ3gel1eKhJiaQikY1TkD/3WzqZZXaYDq9vsuFPBS
	yiF8T2Qn2IImyer6ifnsF9LN34QuhD/1uphu+Gq0QQjZhP/jnKo4dJlrTOEhEAb3
	0k1QOSk7VovYKT89nEI4m1p3blvadbgTthGq5HNla33/cvwon5aWRk8gfOulmW7q
	tDxOP6Ufh738GSS2Oy7Z2Ey9BKeq9jX7aqCKdqf5A==
From: virtiofs-bot@sinrega.org
Message-Id: <87942.122030306303000337@us-mta-60.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Extend the documentation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This MR extends the documentation in the following ways:
- enumerating the required capabilities
- showing a short description of each flag/option
- porting the documentation from the C version on how to do xattr mapping
- adding links to relevant sections/documents, such as contributing, running as non-root and xattr mapping
- adding the uid/gid mapping requirement for user namespaces 
- adding a shot FAQ section

It also adds the `off` option to the `--log-level` documentation and changes `--sandbox none` to `--sandbox chroot` in the "Running as non-privileged user" section examples.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/97

