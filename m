Date: Thu, 20 Jan 2022 05:02:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=EUfLifk/77p9R+KSLqG46xi8ITBa0N76RPybks7PCdY=; b=R
	wsRmsZMYwV0BubNKqS/6pznmNw3guK7HIXRsVmmN+8fKC4mYuenA0C2aDEfxPqe+
	rLQmjrc435LsJkdXDwr8qTl3AwO4KuWiIdVailCT7uQHaDjhCyyGglLJj7yFdOma
	u0TUg4FkFVf1H2H2IGBTKgFjqV3PGq5I75jKtQ68sERtwXygeKaTVjFbtjtSrZ/T
	jZ1p7fjYQNYgf173xCQFkGIk+rGmyfKz8nQAQ6pD2J11jYLS4qcp+X9qLS87Tafp
	dUUIFtdzKi/JAHboXpNt3fFxsk6T/Bxwq2EPgVdk9XJj5J/WXTKj6U8WRK8UGEB3
	yvb6+3+WNnyObe8Mm8zFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=EUfLifk/77p9R+KSLqG46xi8ITBa0
	N76RPybks7PCdY=; b=CVbNy+8VBYwC+TT6EboZVgdj0I+SsDrNzJ/kZqQXBxVk1
	PQjpXVQWEd/nA4y2xAsFjSmvz9kOT5Upa+V9I7RzKJ7VB7QvKrxoUQbOP/FAlQ8g
	qrmKBba2nvdsZccffL1KT0HfBwI5txiYmhFMvThlj/oZSnxAFvYlV2l0c1rLLxpC
	lz96nb8L4omnlimK5Ws8nW+ZDJdYUr5cyfY2vPeO1W3UKNGUSiLdoq5tKL67mPAR
	tuVGJqBI5CBHkdEY2TKbwJ+m5f6d2ACNxjfcIh4wwCz/+1y2zvFIlyC/44PLVl4x
	BTgWOTGwIGC2p+LHaDCQXNsjeoCFGOheiQ0/hXflw==
From: virtiofs-bot@sinrega.org
Message-Id: <31237.122012005020000320@us-mta-602.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Adds compatibility options
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Adds compatibility options: `no_posix_lock`, `no_flock`, `-f` and `--syslog`.
The first 3 ones are just ignored, while the latter depends on the `syslog`crate to support sending log messages via syslog.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/61

