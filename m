Date: Tue, 15 Feb 2022 16:47:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=mDQ5/vilR3+AimC4mT2yZ2yS59H0gpyw4Azg5HAJ61k=; b=I
	bSQB4PNbZCh1SoSvGS1lrwlwzQy8EMiEZ8wjuMhwUZsHeAONJGNjIavqRKj15VFU
	+5XoyxOdzJmfqjtlkk+0du+MX9lvLaTRgxSIvjT/bnnYtib25M+BeddeW1p5hz8d
	iGj7hN6ZTzwXYN6uSbF/ZgBcvJm8d/5FX7m88ksI7o3jVyWdGWNWdq8waK84dJrk
	9lye8t8Xvji7Z3uQR78EpuHZ7LzJDAVBI5P9cYAHFiL/gzBoCNTOPoOqvAYq/8A8
	5wl257dyii8TLBTO2MVgP6jNQ2VvhdqsmB2u6obXWOULhOA/UCteZqAzATPzF0MN
	I2TninGg0fv5MTF/IOVsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=mDQ5/vilR3+AimC4mT2yZ2yS59H0g
	pyw4Azg5HAJ61k=; b=d1luio89XgLs3CRQ4ouUrj7pVYMYxho/4+ZloXZRhEVa9
	uocfNUXvhccztAe+AljWeSB8lD/aerCHH1rOe26OaOdiJjaFIZiZ1wHoWpZq2+Jo
	LB/3XEpvoLa4OY1fK3+HYOC3cBW2If6eL4agtw1FCCZA28vFhv4PYHgDb/0HMEFP
	sFS0B+ZvjahFVtDpk78wjH0LEE7+eXCuTUHmdrcJwMiB1S9vuHxDn2Q8IKvEVftR
	QqsIsB/uq3e+nC7iKOiVQqohaMiJjzCJ+BmKvZb+tRNRReCXyf63eYOeDAiz+RcJ
	jz7aaLqMUR8qVNuhoZYvSdkTTR4waVGXUXDrWaSmg==
From: virtiofs-bot@sinrega.org
Message-Id: <85025.122021516470901923@us-mta-376.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: Do not allow two daemons to
	listen on same socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Right now I can start two daemons listening on same socket /tmp/vhostqemu. Drop in a pid lock file and use flock so that only one virtiofsd instance can listen and other fails with error. C version already does it and errors out with error.

"Cannot lock pid file: Resource temporarily unavailable"
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/31

