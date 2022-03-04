Date: Fri, 4 Mar 2022 11:53:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=ltE6nf2wd5rKcpvby7T62giVxLM7K28oEqHFoMA0DCk=; b=E
	IRl3MvWQH+DxxbXfAG+TxQMj9JUBxJPeLXDc4xxQ6ztjxtXEAfQ28aap3POsYy5V
	tKLBvskmzgykzFyuwB2lpE39MSB/dWkPhGV6CeJjqOYwIkIaGZGPB8bWMIWsJ5vO
	Lnib81Y8ll6c2+g0QTucaeFNvwmQMNY5rjNajppSF3sBuYKt1LAQPr3wPRNXrn8h
	yjRzkCLYjzlOIX36a7bNjuWp3FSOfXx7zMWfahy6+livDLCOhfDFagAbEqqQncOQ
	mSTRcJeobhA9Ef+f00I6W1yEfPWFCYk+BJZx8u8102yXTx9GKfd04p31XiI2/lUb
	u6bt7rm84xLWXIF+wG8qQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=ltE6nf2wd5rKcpvby7T62giVxLM7K
	28oEqHFoMA0DCk=; b=fQGt986T44iWyD/Xizj/c4MV/ldzwv1M5B61P7QG5NAA/
	6/IAVxBu6pSo5Avxa2PJMCxlyeaJuV9y4P4Pq3oBr6vUTDL0WxiJ9jDqPpVxUc6t
	QuPDFi0p0WVSFIsgmDeL1VAq8d2BGWTURkWIJR3wQFHypF/AAiAoEJjgatNNpT1T
	byKL17yzU7WYIyBeTsvnOJzJgNkLpWJGN2WR8HCKs6eVIkPZGvu/t7eHuEM9yzoq
	XefSMqO8Lpc/mIrNvLxHHioz+plW1WV5Va8gIIVmyyLF88B7NwT5Vg4Ev6cYJ758
	z6VSdC4h4WT4gjqo4TMi4rTM3R4aFBYCSEI2+SQCw==
From: virtiofs-bot@sinrega.org
Message-Id: <92677.122030411534300588@us-mta-371.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: Can't run unprivileged any
	more due to setgroups
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Since !77, it's not possible to run virtiofsd as an unprivileged user any more:

```
[2022-03-04T16:46:42Z ERROR virtiofsd] Error entering sandbox: DropSupplementalGroups(Os { code: 1, kind: PermissionDenied, message: "Operation not permitted" })
```

This is because `setgroups` is always called at startup, and it requires `CAP_SETGID`.  When using the namespace sandbox mode, should `setgroups` be called _after_ setting up the namespace?

cc @slp @vgoyal
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/36

