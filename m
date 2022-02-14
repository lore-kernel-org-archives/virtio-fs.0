Date: Mon, 14 Feb 2022 02:56:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=UIimVwp4qpcDdxGvQ0h2gp+vfRENCOdas6tfmHMbOr8=; b=d
	ljAn8W7h3tH7AEbywAYdFWjX8aWycKAF75VNZE0Vkfo/KuKNCFg4Fy8P0GZzZRBb
	X6hWZH4CRksc7hHdP3O6mLB+wre0kJqy0G7sf9bhNKyR7mMFSd/jxeyvu39Lmaw8
	v/xA+/qjvxwAwGI69BmVBmLeDhcPavh2u/KKkgUaiTVmD8i1KaRYJPrN3IKbgj/w
	oKknCRi22qQpdnbR35zV0gIGHsnS4adKQYQvk8riv4GG5cqTJmMwO6at/EzhBXID
	LzGd+JW/dHM0GL//C8pDKSkcVBlfIYTGYZ3vZFPB3/lbIMrzxHryHDgiiq8LmZ9w
	0N4PfGo3HdnoI26kDuxsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=UIimVwp4qpcDdxGvQ0h2gp+vfRENC
	Odas6tfmHMbOr8=; b=ggRC3DeCnNaAaxNgJuxT7P6VBVgTLYuQ/vcy408/M9WF8
	ouZJYszqK9vE6PUrpfY615fgf6qHtOz5i8f+JjE6/P/OYx++lW5WpAjzkmYm2is2
	V3Eci9zQN2lFjdjsDdqSP1GW3B+/ojQPVs4ByWgOlS/9r6Klz8Rz9ueqEy0P2nFf
	DOsin/+KaoM5IYvOP/WYG+ejoZ4MzxEd3yRuhicATC4PLy0yXAd98vjd721lR7KU
	ayh9DgePxV6tS4MTgaJjeU8FQaT+Pc2EQu8dPaDXq0zwE0PRkjSU+Ix+Co/sHdB5
	dH1yDNm9BXHntdKGNdYVtPRJG32eLni17REE9bVHA==
From: virtiofs-bot@sinrega.org
Message-Id: <50893.122021402562900202@us-mta-634.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: Consider distributing the
	virtiofsd binary as part of the release
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

In the same way the binary is provided on every MR merge (see https://gitlab.com/virtio-fs/virtiofsd/-/tree/main#ci-built-binaries), it'd be really handy to have static binaries (using `musl` libc) provided on every release tag.

That would help and simplify **a lot** the CIs of projects consuming virtio-fs (such as Kata Containers).
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/28

