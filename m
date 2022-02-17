Date: Thu, 17 Feb 2022 09:12:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=r4k0ZqT34VshzxerShz00BGBd0YiqJhaZIbN5WO6I6A=; b=j
	H6ddPKPCSbHlTnOD/dAAKT9G2z+wTr7vzWtGtkVrlmxdcueA0rALRhlR3J3kdjEd
	mud8rXQ9tONCK0w8i0zyjVzdPBEwzHnFiVC8agkIHh9Q4irNhw2kwuYNr7emULF8
	6WCt9+oz4yXTLxLLdEt86BbSQYonYUQV2BRhsTaS8UMHAsnhsflWN0UpnL6CuSeW
	mmJnQRjk0+e4gtwqcYx7JlAIzT6KIkW8humvksUgsliSy6ypMRU3Bdl5f7XCVs7J
	CAa1OLXmWnAtsVRi5exKeq4aPRNLpdfpDJDpLgd8GgDLoCxg0zItYudaJscYvZWZ
	vQsfm7/s9QJmUlMYu4FSA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=r4k0ZqT34VshzxerShz00BGBd0Yiq
	JhaZIbN5WO6I6A=; b=C4+v5KrkJ22CiJ+QEhcBIaVJVWt1yKYpakLH0irAlYadg
	ReFIj2MslXWWsrh/xqGFpYCyiFGP9UJ4xs4fiSFcjKFktzDzkxL7KOv8n7pCnFsQ
	8bUkNAHq907VJzoLs0mu5UaO9grfyTX6bJFC+1llgbflcQhVyZ/r+twJcLZBKtF1
	pTgN9JXEV8oIoFdLPF8mm0kCE/aP6Bmjy14gJnUuOyAdeUB63Tu+6yQtw2Nf2kVz
	25li61EiyIshQHzYx4BhH/NFzg3f4YZVLQNIW7HkyKP8EcqTiup8FFtLkmu1eppN
	TzjnOWici79XeJUgcCdC8R4UdhZwnsY6WIrCqERRw==
From: virtiofs-bot@sinrega.org
Message-Id: <27256.122021709120600217@us-mta-230.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR closed: Adds 'posix_acl' option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Adds options to enable/disable FUSE_POSIX_ACL by specifying <br>
option `--posxi_acl` or `-o posix_acl/no_posix_acl`

The C version had this option too.
So this is a step to make the Rust version once again a bit closer to be a drop in replacement.

Signed-off-by: Jan Braun <jan-kai@braun-bs.de>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/81

