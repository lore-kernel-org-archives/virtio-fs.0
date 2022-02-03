Date: Thu, 3 Feb 2022 05:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=akd+ZWPb1s8OsHebYeuSmWmHwO0Cv1cFOwVVj92IOtI=; b=2
	UnOX71grWqPwJEsHVQXr8tUMRuWVOvQWA5umSVfPQPsWDLcfJr0DgqbR2qI7R1KR
	IEv4seTUUulJgOdOYpwItakSdtQoWET6EM5zaeauQb5nm3g/nvSu606J8TazN4jn
	J9lXgNTJtnMBsIPdPZsJp4AjIFcOY64mfPaJ+F/VULNoQSDt+UJ6QBqfqHkTww+t
	yqL5qW8GH04xrqCs5DffWvuPMNqlVCIyxSwECHmwuxXHavdHYqcvD9ZGx0atbsCn
	H6GIxhXHSCeZ1pXuGGi/Ly/YunY+v5RDq5VpCU+FmP73R5mqQI9f4xUHfmi+lU43
	dejtzCyaZGyJHYjzyg9HQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=akd+ZWPb1s8OsHebYeuSmWmHwO0Cv
	1cFOwVVj92IOtI=; b=YfP8DmCLqONNFZuO2zHsBZxqxl656nFRaEo/WDrCbr/ns
	Gf+O4uAXtGMDxosAlF3itlR8NulR62bTVy9GtSmzElt5dH46ZDJXFjtBtyqgp9eq
	v+MHDRY6hHcDVb4n30ut3Xa6bmMhHiaafqvOP8jK6pO7oo9h5nhlddS4K/9c4QAX
	ORwlcFi+JWXbZsTa/C0eM8iWzMf6A62qw9iehh9e974YLK7yg65iq4FAKv1QySbr
	O1OmTl7X0UFYBbVajIssqeM2YelePaklAv7csQpm51Oye//5J277dyTZWfQmYD76
	+D7Y+bFZJJenWr2y6FwtugXKzKPIR17xOn84UkADg==
From: virtiofs-bot@sinrega.org
Message-Id: <60125.122020305143700137@us-mta-60.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR closed: Flexibilize our deps to support
	new patch versions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

For crates that follow SemVer, flexibilize the dependency so we can
support newer patch versions without updating our Cargo.toml

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/72

