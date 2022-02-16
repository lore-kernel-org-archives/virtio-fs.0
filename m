Date: Wed, 16 Feb 2022 12:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=YfQ3jHuT4anRvIT9bLEr17qP9f6pHnUyalQz/AAyFBE=; b=m
	wyPjDaLq23CtFw5la6yfX8mC/iIBFXXl7bgwvvcukDbVURbKzotlf3lRoN0LAs5Q
	CBd5lP4IQOVXKQUIwbsDdYQqsrJUwaWr8ra/E8GfPWlhSsLGeYSD+TLlnrmr3n6n
	dO83xnJnlzcxW+qfOcHGH5Ja3vq5J1HT1kN01W3gAV/BjwjbNXqS6co+utPLxAqa
	Tv9S/UnsHblOcsifNgUJ4pt8KGHCld+61FL3cJzsg5XrysHm8jiU/Zze1/bxdKZx
	ApfwAt3wv36FnhFf+on0coB8cR3jgsKcZwS0nVEPF1HvgEA60wkAVXWq1nLF+j9m
	cliGkcKpJO/XxGDvIOkbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=YfQ3jHuT4anRvIT9bLEr17qP9f6pH
	nUyalQz/AAyFBE=; b=It8Sh8o7pktHewNzYkmGk+lS4d8O5JdqOdDSad6y1126D
	kBbCn635S2xVhFX+TwwOJiazNDg1aZVB3+ug4OO0+meu7EHo8BvIpn557wxxx5yt
	3NE0b8aGgedwKYRCFQBEfq+TytYY/bQPzBn6n8MPpRIo0cCNvY+pXGQvxTsbxO1v
	heHBNZFgVB/a+Crkdju5DTuPPtecR0kwyuAUOXVGdaByLoYlaGgj+t7WcOmfvqS8
	lFWmQ88yHrBEBYUK/rnYPkiqSTPq1D/UA97dswIe8JEkRtGDzEOtGzjrH4Eq6gT0
	iWahsKfWNG/83b/SSim8JePjnp0l/Wabu8RMjFDeg==
From: virtiofs-bot@sinrega.org
Message-Id: <07599.122021612204101355@us-mta-214.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Modify the list of enabled
	capabilities from the command line
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Add both the new '--modcaps=<modcaps>' and the legacy option '-o modcaps=<modcaps>'. Both options expect the same format, a ':' separated list of '(+|-)capability',  e.g., --modcaps=+sys_adm:-mknod

Requested by Kata
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/86

