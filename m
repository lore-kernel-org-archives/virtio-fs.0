Date: Tue, 16 Nov 2021 15:02:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=CgYhKTxN7ggXpiQWPATRiiIxmIp5pJMg0BhzL
	Mor09Q=; b=pGoXIDQcCUAhj+IwaLJk4KDTzQnFj6ctQ1Ne6Wmh8UthhO3y3ljR4
	bleKjJFbhwnkZ4p/xslkwk95mQMkaye7I/bYPk3GLyYkbASgO20WY8JYbi11OTvN
	pv8FzQpuLBCF2gYu7DS5+qd3eldk42gLv5SLDCX9E3qKSQl0LVvqC1b/uRvhyqIS
	jbG8nRF2CJ4VFVYYbLO0pPWfqC/3iLZpi7p90gvKS0gEn8BwAZG5kqBlynh1kRqc
	U0FQBNbovgbwcerRLwZS1dQLOY9FFEz0wrvJq4ngS3tpJKcUyDwDxDuA18okBtKd
	8hXsR1byefGmexNguBNZY9LaDWhgzic7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CgYhKTxN7ggXpiQWP
	ATRiiIxmIp5pJMg0BhzLMor09Q=; b=bQEtrblc1k1gbUBfUDZ1un31io+cVBTAJ
	/9Grjd2gtPMebHfj9yLBEDAICENwnLZJOKhdxLesXk4Ad2xvvwbwpRzxMDm9LuRw
	p+Thq5wMX6/eS3cF4IafyrWb3tPXUhFNjHBK5s56vbOXLHVAc5cGw/1DOY+GeoHu
	cKqdok5iV9FJpVRG5uNyi9oxeDEbtcqxHL8HOdRrBKxQmVBjTub5Ea5OpsRbCTnU
	ETeX7Ak1uPMY/B8IGYbHzp7jPoiufmxlGUw55WaXbRilUpZpyIZm7O+k7YOYOe4Z
	DGlxnIyxWOIlKzkk10kEjCmD5JgyFThLKLTbV5rS/bq5uQoV2bNSg==
From: virtiofs-bot@sinrega.org
Message-Id: <86161.121111615024603194@us-mta-369.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: libcap-ng failed because
	calling capng::apply without CAP_SETPCAP
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Inside drop_child_capabilities() there is a call to capng:apply() that clears the bounding set. It causes libcap-ng to fail when calling virtiofsd-rs with '--sandbox none' by an unprivileged user, because it doesn't have the CAP_SETPCAP capability.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/49

