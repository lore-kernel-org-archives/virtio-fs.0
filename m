DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=66IEjZQpaQRtziAI2rhrv
	STpd6AwIoR3UAnnV8nv2KI=; b=fQzqG1+cuu/T4xET5+PtMPWSYSz82ryMDkRn2
	aBIDofdfzULL5a4emULyFIzu/qNPLz9Gw3qS/quLPbuxoJ1Xkf5jfdDigdJgxF1P
	NLLKgpfH/72FNpORDwZ3S8NRw/ZveHqNbpS2eSzGcv+tyrwpVUhyNUkYx+pKaxOP
	VMIwd3ITCTNkR7dSL580WDn3EqaZnNRPiDjkOQ3gb8qg0kjuLwvdl83OiAM0BgyP
	Z9UstLk96WgYKgR8h7r1ya62jSG6ZeMVcYEp6rX5ifaUx9LpRpvvKn1Nhz0UeiA9
	4DTVC8IAqZUWtusNO3lAaOddpgzEOQ8EJ0ga1iVllForGcZGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=66IEjZQpaQRtziAI2rhrvSTpd6AwIoR3UAnnV8nv2KI=; b=dctI+p7n
	QIrdJxJmsn5Mwls3AaOoFrIrDHBn5Ayv1sKGRJvveTXg5ZEbd0hgSAzLyA7aZfts
	PX/kw8sM96jjxUgYcBZX2r3I5eflchpz3s8Mf8mGXtyyU/EoQl9372nitNloq2o+
	GUwp2Zz4pX2cges7yh69p2VrgVMf+hugN/E2XD0Igjs6utwbofDa87lrvJTfqnzx
	A278mIA2B+rCvkdX9eqlWDtroJ3Zqie+W9nGMHG0+0C0RR4SxJPOidIauxJpj/Tm
	DpsBqnMG1nSU1T8kBu0VRc019/Fl09K4paeWEv2d5cQF8+qLoK0QgBZlE2sOw+Dx
	qxCHsId+bKuAcQ==
Message-Id: <20210421080129.EF91D1080067@mailuser.nyi.internal>
Date: Wed, 21 Apr 2021 04:01:29 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Document the xattrmap module
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

For a more pleasant reading experience, I recommend

	$ cargo doc --no-deps --open

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/19

