Date: Thu, 3 Feb 2022 05:33:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=gn/u6BmZLaIPbeysQaolhE+HuOujkqtETUHL2H7eS1M=; b=Q
	LriU6tIb7v0lOZaMQ0LB5lS4MevxhlYFrZ7/ZGRX5aP/RZ7WmWSQ3/gljc3hxFHp
	duDHq23DchkyM6v5dw3BS3/FkNCAWNXtguZdMfv4yRRtvxTRY5nAdI3yMJjOVaC1
	Wuu7jZkXbyisiw9mLlUaH2cAUbeYvyFhnRPqAkn4y1RriZDmgGuGL+Gzl8CZZy53
	OOrX4MV4DyIeQJcqMZoR16Dm88eANG6qicHe3IU0xrZeB4/qFm+TC9Ib4QlEkiPI
	EtRoajA4kqywYw+vEF0wxB4kfQK9cb+4T9uZG83cwKZpXIAfthYEugQDVv215mmS
	9Z7fyMwXBuNzxhuma1zmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=gn/u6BmZLaIPbeysQaolhE+HuOujk
	qtETUHL2H7eS1M=; b=bHUkwuC6kYDdClew8CvrDFSUZnNjbs8JHXPdLFZjZrArG
	d9St4ey2hTsNw7liZg0UqbSmV3O61JY62O/sJqJHgAd57BeVpDQHIW1VJgTFHxdE
	mMopntYcmJ9M2mn7EHHXCeJln88ClFGhxBZ8oecv4TOgh2NLvErjT6E5ISNPP2w0
	z+C4hR6bT0qaark1EiuNxF1IJrW+t4TLf1Ic11a76gzrsfdNAFkvLnGZCWYpeB04
	EZ2yiiOm3R73qYf/7qif0kOBi38CcBrq/6tkSE7u0wdQuSGGth1om7pTwFQvzoRK
	IClZVa09aUgWIuCxJIQtqpR8AhHj4aIBeucu1UVJQ==
From: virtiofs-bot@sinrega.org
Message-Id: <58979.122020305332800123@us-mta-88.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: passthrough: Use
	application-specific inode storage
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Use an application-specific InodeStore struct instead of using the
more generic `MultikeyBTreeMap`.  The generic solution wasn't used
for anything except for storing inodes, and thus didn't compensate
the disadvantage of a less fitting API through the advantage of
code reuse.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/88

