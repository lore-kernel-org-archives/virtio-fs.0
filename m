Date: Wed, 22 Dec 2021 09:59:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=k1hsyYqqjiPfeBFku2H+tp30nRQarp7nOPvz3
	O9qz/I=; b=wCsSvOBX+NEA43uwxt2vRYM1liKEDeIiuosnqjxhe/DkxsaI4K6w4
	gIgCIeKXgKqDTHyKPrPspTZ0Z9+b8ttcVYqs7RlwatZ/jPVyORVYgTJHh9w5R8Mn
	uGxRMKUgWhkWI1p1midYx0wmCQ+YfFnIhbY2vilMmBtJ6g5A9Eei8qna1meL11rt
	gD7vXlH/DYgbRV3AH/g2Ey+r3mRDwD1otDTSI5VGqEB4ZnVn/K6CD8U4bJYs3Tq+
	CFng+0ynQZbXmr+dExF4Om4IazsogwRr2P+uTryCX2OmCB4dWNDNl62rKC+44vyy
	Oy6Z+AJEnk5RVSr0rh0Ay9Gik0fNtXFPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=k1hsyYqqjiPfeBFku
	2H+tp30nRQarp7nOPvz3O9qz/I=; b=WRh7q9JZB5bC1pbMCqikgQLAUREQTFYya
	COhRrB35dwNM0emUL/LGYKrIooSTxDgn1HivlAf7neirJHpAgJv9JK/cqqzDyopQ
	Vj53qpvds0Hsn2q4A28dlfV3xZXhLhZb3JaosgN8iFzQhX4PYsXQqt99lLsp8Ynl
	E98El9dQ1XdaaZkas//j4Lu7Q/Q9kVRkYMvWLm+lJafK2Hwokpx4vHTq5WTUqu6e
	ig7z62rZpD6MM/KFnD6Sgqj9fkMTEPIiSycYgyhkJ4cJtL7YHknkYwvlRUm4569A
	KQhYPxkW0Vx4tecVJxVf1tLqge5W26YN9BkRGZH5ePMhe7ve33vtg==
From: virtiofs-bot@sinrega.org
Message-Id: <25163.121122209594000493@us-mta-266.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue opened: Add syncfs() support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fuse in kernel now has support to send FUSE_SYNCFS request. But there is no support in virtiofsd. Add the support. This is important because it is a data integrity operation.

Greg was doing syncfs() work (and was fixing issues related to submounts). I think submounts related issues he unearthed as part of syncfs work.

His last posting of syncfs patches is here.

https://lore.kernel.org/kvm/20210510191502.GA193692@horse/T/
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/19

