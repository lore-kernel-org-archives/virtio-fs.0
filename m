Date: Tue, 21 Dec 2021 20:16:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=jjoNk9ipJyoXYpkAJ9Ij7IUJQwFAhwjfDbRl3
	uRILOw=; b=yLKUgGYjUCxQ+2LbkbhtHfSmmD3fJMH7uEgeg9v7FfI6hAFr5FVc2
	Ln8VEdbocvwSLCZpTBeD11AgorwHWdvImUMZ8K5GEgQFLi8FgFKwOyr0PrL8AIh1
	3hefG+SGEVd1Q/l8amkrpd3Sh1qrcWFx7ejpuEUfJSP4Ivw+EjlHyCtlcHaM4SNU
	k0hKEx5BYL2/zu1haNgpUejmcrqq0jCnOQWQa5Up/w1d3euOOQ1s31QD+oBVkmtc
	DWvodvgrrMHAKn51w8eJ4MASMuXCkEj0zhwIuRiL01iRAZtsJmQ6u7rVEn0O7WmZ
	3X9wxUe9L3rmyQ5LgAYoFPJcznLuURvkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jjoNk9ipJyoXYpkAJ
	9Ij7IUJQwFAhwjfDbRl3uRILOw=; b=WXkubkKGavv6luqAenHIyA61zH32Daj7Y
	gxgC6eNsn7qbyRHqAUaA9PchKWxLXnoxiREXwRLBVSitPtJw30lNOLh0IROhumtU
	S8h7sLgtACbih8kmLl9HLK6XySzyZpcyNhI1RvAk41JFVBAF8HlLtHj74AOW/NL5
	jZw4GtyWcQ3VtNNNCbax9iMk7S2Zk+sFt6CpBSZK2CJjZIWQqOSrNY9IVigjEup8
	znhGgl73bDrdN6rIve4sTKITN3TgWS+ifgkmTVk5TIl8gHd7/7R3JxBL4GWoVgnh
	34I9krZYuWnAjVFBGtrRtf2mq1OoohsWD93axmBR8U/ctwxSLmYSQ==
From: virtiofs-bot@sinrega.org
Message-Id: <46681.121122120160800245@us-mta-58.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue closed: Instructions on building
	and installing from the source code
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi Team,

It would be great if you can point me in the right direction for building and installing virtiofsd from source, thanks so much!
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/18

