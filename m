Date: Wed, 26 Jan 2022 13:53:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=FUrfEnJd3Eui/lMX3gsWW50/8tn78WUMk7KFMI3sGDY=; b=A
	2pwb+0XDo5QgBgtTuyOEGFS3QKz+aP4/kJ1QSbNu3caOIgcLXJdDzdlS3nLpsi/l
	/GvYKmGzVVjM7NAIKJ6nJtrkjgUMYPGje2CmFYiilR0dU0bnPppj+0x3j29uA8/Q
	5pQZ/yygIjJLvqrMd7tEoQUgSgaDzok4ihLZgM9Oe4gQbol0+ZeCpf5OTTLtY6aI
	OY18tw8fnzAOzoOIkxlXIuDITM4b/BIStujnHZISd06hb0B1F8s29viBSAoxlUl2
	L5pV7G+wUVJqDI/RiS98SFDAyimFButfKrkPOqoooGlgLO2hrxJHAh0h8B3lnbqC
	YF0wi8AQgQ0OFIiXOHzlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=FUrfEnJd3Eui/lMX3gsWW50/8tn78
	WUMk7KFMI3sGDY=; b=nb+MraHPkH5Msf7wN1xpCDHRAmSCrJ+Aq4of5/31JsnFC
	gqp7CpJGFuowZLoGfpraRoiOnMxECHR5OvHsRm+fovcl5D9P4/8UG9jOeUSx6zrf
	TmAfBhunUG6nQMzP/g6ycc8CHMMkLJ4uDatlb0dShCYZsOKMGTjjjuwH5wIWYPWJ
	hBCdWLBR6TR8ekNLZAqutu29nVTiL/LCEUQef9ATnfzc5e33ji/GC4g+Ci6X+3xG
	KmNlpZu6QxQtGEyoola7N5tOOsUSk5J5wGLYgodJC/yOVfebQtz7n4kLoiXWJBKw
	8wf9XdPWsSe5+DdPqkui3Gx2SIq7B/cAW9OcMDVIg==
From: virtiofs-bot@sinrega.org
Message-Id: <12317.122012613531701484@us-mta-538.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue closed: Release v1.1.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Checklist for v1.1.0:

- [x] [Adds compatibility options](!61)
- [x] [Draft: Adds killpriv_v2/no_killpriv_v2 options](!62)
- [x] [xattr mapping add a new type "unsupported"](!67)
- [x] [Replace crate seccomp-sys with libseccomp-sys](!71)
- [x] [Drop membership of all supplementary groups (CVE-2022-0358)](!77)

If you think there's something missing here, please say so.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/24

