Date: Thu, 23 Dec 2021 02:53:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=CtBFUPZkC6Im0OfkQP1GfpJTLvd2icaMslPdO
	AjrXmA=; b=Pjb+6LPYk0r89aJBI94hj0uUAzWqWtB60sk0xoAEdA/fk7E6Jlz9Y
	kX7yWuqspWKuy+89J4L2VoY0z2llDnlKMJfZ9uXmXd06FemHCE4Z10V3nYptlUjP
	zInEFUwUhwafAPniTh34t4zdFZeHMAUaH54bepS/nU/9Q4q2WHUuEPDStxK5dxv1
	vkiJyle++Ni61frtqd4t/ag8d1DKI2HGVWy/I2rUb8jYTqD1Hft7C5PRj+6eZo9o
	i+0Rll4NgAuh03Edjgy4j6+r7xQc3n7286TEXRIMvCaCYVXr8Jtlh+mOCkIelhPU
	Of/EYojtLvqwVEWPSgprJWjXThnBJZuUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CtBFUPZkC6Im0OfkQ
	P1GfpJTLvd2icaMslPdOAjrXmA=; b=DWAxHoO7SR7aGDEipf+IUIpqLItHJ1HoI
	XUWQ9UORY+RUFhlF9BfmK+g2Z7PMFi4kj0JH4AHffs+ANhm/qG2+1dy2GNcgqX1Q
	Hp4sVaifsrWOPukqK9fQVeIn1iMSwSU12A9GwCM0TLKP3omkqh3ZEClPP1G1wX9M
	DG/cPzbx0moQnSdUTWkRy5CGLngohA1DOQppoxtlubSW2KskCdXNqVr+8d6gKnpW
	Epbt25Atf8oXHtKBgqA9ZAGi7nZz3kqnY9rJHuEiVqjbW+AN1iLQzzUbueGm+s9/
	3m6IodI/WJfpePbJmywAUXeFU20fyZ9zMj0Rk15f07pNvktOUn8uQ==
From: virtiofs-bot@sinrega.org
Message-Id: <34070.121122302530900125@us-mta-286.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Set up the stage for v1.0.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This patch series gives the final touches to get the project ready for the v1.0.0 release.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/60

