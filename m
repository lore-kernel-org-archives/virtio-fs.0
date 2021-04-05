DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=lz20C//rV6ZYZArjE52wV
	ehRiGD5xuhhGOVRuFwSh9o=; b=Q01LlNTXpuHoELCWJF81HsVU77Naa9MaWpp8A
	JIBjdMGaP7Hr56GH1d2C0okA7xUiTW51G8ZyEpoI7/7GOVWA8BDZFblDfJvTcI+Z
	tnqzsFmwlXYgCg4gbVjW5OGCnXQVVeJeQbuvgzroUF4xrC73ACHmD8gRIS9LOXGz
	sWmcoTryMvp88NkRWP9PI8LgnPzm4zn4xpKB3meb5xU+5PRANItLqby5icHT0uST
	IfieQh79YhxHcHIkUL27DUP6j3de2pxK5bkJ5CnIzND97E4AlXUE4vwdTT766QTL
	1fUCetYWFMiVkZB33zP9ngU7OwClak4AsZIvXwp9ivYuWAmIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=lz20C//rV6ZYZArjE52wVehRiGD5xuhhGOVRuFwSh9o=; b=IsRp5Btq
	gA4wwmALTMolmfZCUpl3y7w40JUb3+yQX61bFeccq3QX6lOLPEYZTWXiVHwLDOtd
	eNiblrngEfs8bKAOI0iMiWplyYnQ9eGi4E3iIq270v/JW9cgmXvB482qqPq6iMhG
	xBM3Y+IiLoTdTJNzjys0szyn0kT2oqHlSkNArcyiyxWUhG+L78bQCh1Ge+NvO6DV
	NF0rEB8cQNJ6huh+U/kGNFNgW+28VjbZdTTnt2NK2pYH0DFu9HZcR9BZhNUX6ILW
	XdroykLulhmFZ4ScRJZCdqq23ZSJsctR8Ymoq/mURrE0+D4xoJjOuaw8cet6L0XD
	r9vZIpCzarjkiQ==
Message-Id: <20210405154451.0CCC91080054@mailuser.nyi.internal>
Date: Mon,  5 Apr 2021 11:44:51 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Set up uid/gid mappings in
	user_namespace sandbox
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When using the namespace sandbox mode with a non-privileged user, set
up 1-to-1 mappings for the current process uid and gid. This allows
both root and a user with the same uid/gid in the VM to access the
files served by us. This scenario fits nicely with the "shared folder"
use case.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/16

