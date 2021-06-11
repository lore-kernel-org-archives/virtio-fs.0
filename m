Date: Fri, 11 Jun 2021 04:52:17 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <09353.121061104521200337@us-mta-203.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Pulw44miDH2wbc4hA
	tFNDlSSnXbRl3VdtKeQdBfkMdk=; b=mf0lBwWjm+TOKXkgH6s+kZC0KAOBwRaGO
	DB2HIPWz22lUvFwz9PuXPipsbygyoedTJdSydZGcSFFFdCIU2VBeJ+STzBvksXAD
	odMS2G9+BLKwm1ixfwlzOyF/G4sUMcDJSo7WhqtG3/M+JB9jkfnDfkNKTNrqZqJ7
	wzVGI49rckZ1CWkNu1pcwdwyssrZhn4NbhDNAxKMkw34+2SaYFBfMWht7ji65zkR
	7rS03bERTzq+eDLZ7AHb5Y9dYXeYMIyGwMDUpMpc5pZ1IWx+9ym/6b3Mq/u7Zrlg
	9H6fhFkd7rTtE+qTouH40Ry8oFkp/fF6hfgr2flq+bl+DhSjBSHpQ==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Fix file type check for
	submount points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The current check (`mode & IFDIR != 0`) only kind of works accidentally.
It should be `mode & IFMT == IFDIR`.

Judging from my bits/stat.h, block devices and sockets would also pass
the `mode & IFDIR != 0` condition.  That is not exactly catastrophic, we
just never tested what happens what happens if we were to mark something
that is not a directory a submount, and so we only allow directories to
be submount points until someone needs guest submounts for mount points
that are not directories.

Note that the kernel also has a guard to only allow submounts on
directory nodes, so in practice this patch should not change any
user-visible behavior.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/30

