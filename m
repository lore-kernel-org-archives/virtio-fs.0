Date: Thu, 13 Jan 2022 18:19:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=VgTpdYuRKbaO09MCQPAESi0U9ZAq6W/1PsrYK
	irF4Tg=; b=NVYL6ef9RDyQCwPf+oM5Kh3c48HSuU4UhE6dmjdVo5Tdr8TlkYxNh
	9d4Xlh4ct1zYXA0XOco/ZW3CLN+t6CdB8WcTDNsfGXZg1gt4nJjC/p+6vp/voV5n
	HOWrezqQCfBAF+ecW8dddwwaAORzNEctFfBPv9pc5sAiqpO/WTZNHzsJrtJuw6J+
	cAPClKct/RiYSYi9IJEi2y1UAVBY2nHntrnE0PXN2PLW1oyerVfOqs8TQEKK5PuB
	urcDlfWLn+IexHrqFoB0BOrqvTfXczERLP/k/JzemdJHEQxAGn1GbClohCgPVL7D
	vU+5tCKVIkz0EV7ieS2gg45r3erZMhRrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VgTpdYuRKbaO09MCQ
	PAESi0U9ZAq6W/1PsrYKirF4Tg=; b=jAzYLC7iI+Hab9HotEjUqQsIoBJKvt1jR
	ahE52l+TTYB+yFlN6SGmJR3N0LJxBeISBbXgPTlMoZH5j4BYVVHAYD+enKVUacJ0
	pKGPLgJ6jZYCawYFNqLgbWBUdXyHWnuU6tF6kvsRKyWec720Gdu+cLF0HzNWB3nB
	lTYdBk4S3GIA3GtVRp/psBh+vX2wGDQAszYijGEbzO6vX6sCzqqIx54VDiEZ89Sl
	BbMew2q+8NC6HHCIcMDU+6HZU1qLSzHDNBxjooQqr9hY51g6gMkhKzwE/1ee3wXg
	nYPVOnC5/lbgJQuLRv6hpFVq7HrriFTbuBwNbEwzgTIqpGjbr1Sng==
From: virtiofs-bot@sinrega.org
Message-Id: <36775.122011318193900259@us-mta-209.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: --inode-file-handles=fallback
	is misleading
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

`--inode-file-handles=fallback` sounds like inode file handles are used as fallback. However, as far as I know, it's the other way around: with this knob, inode file handles are prefered and O_PATH FDs are used as a fallback. Thus, I think `--inode-file-handles=fallback` should be renamed to `--inode-file-handles=prefer` or something like that.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/20

