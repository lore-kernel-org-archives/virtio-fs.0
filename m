Date: Mon, 11 Oct 2021 04:00:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=hlOqkFr/eTXMZRwHdU8GO5cyE83RYdls3qAy+
	JnT9mE=; b=f3n4A4Nj1JJDAf00t/40736lUMlPYaFzmIk7jghcF5ZIF06z5CvAe
	v9cFtvQ2dgLjzv3BgSIiuGAfT8YsUl3377aFgM5ie89x9VWOVCeqg4NPBTqsFAXI
	vvPGtMyhtkYvwjGnzOZf2A+UfP9Xgf9Oy+QC+mlGmlk7dwReSdVXT2l9g79aaKZr
	y0lg4F7UzRUyNO+IrEmPV2BJTMwsWxwFnw4vRyRHDUAfUw2huJ6lopyqbHfwLp0b
	31gtDdBTCVHtWBaigHKuKZHuONjVZH/Jn5Q4cKgGOhbaMUaAB44hXLyeMFMRI/5S
	gSadLmr5g1J12g/3F5FHnGyWaX7PpJ3iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hlOqkFr/eTXMZRwHd
	U8GO5cyE83RYdls3qAy+JnT9mE=; b=M1k+6WC2prcaRWJ9f++NYTYolAUeU5iXi
	jnr2r5dI+1L++U72APRa2UFcTk5RH/yKZ2VV7M7ickc2QDPibf6U5LhmQIHuNkq5
	TXaumcKHAbVPpeALEGle0xXC4cUpwX7rmZQP+gi436RwckjyMn5aEFM12pSSeN37
	MNxXq28DerKeMIerx/X1GMHCYFXaTpOFjbh2fX5FJTee/CNNhAfsd4VYCRYAJvbO
	uw7GRatfbjSV07h/B+7thvo3L2gCWIbb7WuwhNam5DWbSkTaJQinTEC0Fz+78e5D
	4GJ7+Qah3N7xhvTsDHLHZfOgU0mhPl3PLaK4s7GtOiUusSSx+CiKQ==
From: virtiofs-bot@sinrega.org
Message-Id: <59051.121101104002500151@us-mta-87.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue closed: Incorporate mitigations
	for CVE-2020-35517
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

We should incorporate mitigations for CVE-2020-35517:

https://www.redhat.com/archives/virtio-fs/2021-February/msg00003.html
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/9

