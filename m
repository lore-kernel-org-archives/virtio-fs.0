Date: Tue, 22 Feb 2022 09:08:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=gn/u6BmZLaIPbeysQaolhE+HuOujkqtETUHL2H7eS1M=; b=H
	qAe3PjXO6jzL07aMnhfbXoPHI5S38yrD4qhRtnLvvVadLDThys2aAl8wIsGRbRbj
	qF9Kue4M4CGw0CfBwlJAfs/1niwVTCWiJwunA0vNCbo3dHC7pOmt2UtLCKP6guoS
	Jz1wy5SjAJh5zhbFCrnwu9zMQEu7tTc3ckS2NfgSoTo8AoHxkB+Xos5taiSKisFi
	4p4Haiqac2b7h0imXn95QmYSCvg7TbxXFDrT2TN72u8V7Mvn5ltYI5+dMI/yNBuU
	obIpWOGGfmAsW2tTyfqUfSHq6k9zgnND8pzpIvdTcCfWA2kBWfgoIrYFc9PBh2BX
	+pTxvKayzhD+svaqiiNgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=gn/u6BmZLaIPbeysQaolhE+HuOujk
	qtETUHL2H7eS1M=; b=LBWiWqneg/omQVmF5yzZh9hqVZdaBADst7pXZn37P/5hI
	yX0SBeahZis7xjMy+lmLBJ0EH7j7JPcymscpauWNelCE+mqu1m2ib6HcN0yW8idW
	oI9nZZ8p6LCQ9wEjg+eIfe3YuBuHy/zCB1BcYvsLsBE/3gsJWWvF9iEdNWvTSBwG
	PBV3yNEqX8isO64PaU9WtrnLvuNc9T/dfwz2KJ43GJQtijoDGHy/2WZ5Dfn079Bm
	Fr/9OhcwjOefnkZA3ng9A+gLomeDZIawkuh8QR4Rp92aJvSrS8Xo/OI94vKR6FuY
	pwvANukhy+MDM/Krkjux8/shm4sr9Cu3LJZfvbLwQ==
From: virtiofs-bot@sinrega.org
Message-Id: <54677.122022209082502495@us-mta-563.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: passthrough: Use
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

