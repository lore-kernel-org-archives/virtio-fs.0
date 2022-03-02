Date: Wed, 2 Mar 2022 06:45:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=U6K5nV1PeVzfVUggoNvu1X236G404Ifs8M6Xt6UMxq0=; b=C
	GNTLsmeHHE/Szu8R/gHXmuO2JeimcHj61UBym7LbzGWOsbPNchcyiKBojJGf/m/V
	X4P0/zEEGpVn6Dne+nh4/0L04unsHbX4JwYhJv0VQaHc5+eJvHHCUz/XTmshL4JD
	SVeoVzr4teZPL6pvoUlX9CLyAOgawz640766MOiDyPRK25J7rPkNf2vey6HSzKqL
	XOQlgcphTxvog2ICuGJvPg5lrIYHHkzQtvnJ5LdyUdWlObvmcI1i5nEpedGmTu9y
	ueFgcW+W6MTQ6w/JPtuxrBOtBpYzIxyUjjW80jGVYGO1MI3CJ4xq+PHT0dO5S305
	bzddNsnBuzwO3cK9+9Tng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=U6K5nV1PeVzfVUggoNvu1X236G404
	Ifs8M6Xt6UMxq0=; b=i8UeD3PoqPN9lxZ4xSIbNaPPRJdNQZMGqdf13uat0HEWK
	72LoQvWpFo5OrU6CrL15soXjM2wCgoXzcriIYENZ8v/nQVIZ4C3dgKJ+aWABb7HZ
	r5N8d42LRKo6c0Rk/kYq1+OLjNTYN4ETDzTlc8H+ERIJeyN1h01Z2NCf4Dh/YjsA
	wb9x1fZMQIz/oTI2e+e8n0ZBjj6Y3jLcQcMxJTxOBngd5j0Cb+DtuEnmzXAxRDwN
	UqtE90oBMT/eR3iSOxEs0nFqSqDu1a6biWG7lD+klI8axnyU3Kx504bNE/BYicEn
	EF21x0b9yJWG1LBtQtNclRZZ+XupGxlHf/X9+KfYQ==
From: virtiofs-bot@sinrega.org
Message-Id: <77909.122030206452300135@us-mta-373.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: virtiofsd: Add capability to
	handle extended fuse init request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fuse has extended fuse_init_in and changed fields in fuse_init_out struct. It was running out of feature flags and it added another 32 bit field. This MR adds infrastructure so that one can parse feature flags in newly added fields and add support for these new features.

Once this is merged, I plan to bring in support for SELINUX context setup on file creation.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/94

