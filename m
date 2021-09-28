Date: Tue, 28 Sep 2021 10:37:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=6JRy8VXcc3l8pE+U4+w9kSKx1GS23HS+wD5hO
	c7/VjE=; b=Ztvjf2g2mMwbX0Grlbr37quH2hJRH+LrhwWUaNEDRFg8xfUN0Srrl
	oaYfWYVGxJvofpbXRJDRBjkro/KO9et11xMaaY2rMI3K6J0JITXlnjYD9cDVwtq/
	E9TMGGH5Q1eHns1C2Gi81FVkBu4VSKOhtrww+0xqrVx9+TjoxImcMQZdCrIAI9QA
	wVx/RTl8zz1OPk3Qn7WDHoNeyf+grHQE7RJC6N1QngIO8Oc90bMeXggh9Yeq7D9z
	g+dHbO4qcXTkEDdqnJhKIwc+2Qox3LMhl0iz+XbNPku7Lzi0XLyxWHASScrqIOBt
	RIGeOO+1jRtVNmIk+r3nR0IPJ80VEgJeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6JRy8VXcc3l8pE+U4
	+w9kSKx1GS23HS+wD5hOc7/VjE=; b=RfdGpZyi7Eb+I/Joie6jUmvtSeKN/URkD
	TpkrFsvBj15gZAhwQdQSNYgpSoIU8zuAfhPyoP0iRgULzFG8YV9lO5If22ZCiU3L
	9sIq/PZfAtm5/RyjIPA89oOekfAJsRrD965qqh3R84D0HnKBfxkS+VuUtXYu7iE5
	/S2awPANa1i8ykxxbi1D5fxpjkH+gX2ZEvcxQRADiOPrdWr1/2GAAsE3ggI2nkZr
	CJn9QcWr1doRcwcb+wxFiUbku4/k6XAz3Z/lsKQh7tNkQQSihps2IZ2CqJ2Md5Qy
	ThA67Zzvi3WMjlaXjvCV+2qN4+kkNilAz/EdevVJ0KwzU6aRp6Xaw==
From: virtiofs-bot@sinrega.org
Message-Id: <52242.121092810373002507@us-mta-163.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Implement a single thread mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Implement a mode that disables the thread pool and processes the
requests in a single thread.

By processing the requests in a single thread we lose the parallelism,
but in exchange we can apply some optimizations, such as acquiring the
vring mutex lock once and keeping it until all pending requests have
been processed.

The expectations are that the thread pool mode will perform better
when the backing filesystem is on a relatively slow storage and
there's a significant amount of I/O parallelism inside the guest,
while the single thread mode will consume less CPU and perform better
on pretty much every other case.

This mode can be enabled by specifying the value "0" for the
thread-pool-size command line argument. We also make "0" (single
thread mode) the default value, to mimic the behavior of the C
implementation.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/40

