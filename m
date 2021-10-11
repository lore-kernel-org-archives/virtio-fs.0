Date: Mon, 11 Oct 2021 04:00:28 -0400
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
	U8GO5cyE83RYdls3qAy+JnT9mE=; b=i/hUl6K+i6h8RWb4FBuuBks+gV2sb3QVO
	PebrpNmGoqTEnM9q4WZReSeWbFKhK/0N4OoJeH9BCeulcJnS1bSJoZTfbYx+yanW
	uBG29QzrQo6xyIRR3tD4oyHhMw3/5LmMfiHupXfBDgeWiRwb7U3ryH0c1na83z8C
	dAoRsCLtMMkWPrFFSZ9qDVaTsjKAIYJWsWIN8A8EY3Xv1zNV1vNWiFQDPx/qvUSQ
	A+gRW/Kvz4Dtqb7Fotkqq70pHgQFIJXfAjRCAVlhfEU8C8NSvRw86o8Os72QJ/VP
	LEqU0wGwgjyaiIpIysFy4UCijktOh59xl9zCruteErfHxyU6kn/0w==
From: virtiofs-bot@sinrega.org
Message-Id: <00383.121101104002500914@us-mta-520.us.mimecast.lan>
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

