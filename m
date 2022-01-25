Date: Tue, 25 Jan 2022 06:37:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=85dKdpMUxPf/QX1W/GWmWeIy/Z9TqddNEjmQ0mcIWaE=; b=V
	1ZilX8JTluSY2l5hhltwSzhHJEYTWFvALRaUdpsjrCJ4VvIxPVGWJKLQhZpuIRGL
	bFjrHTtbNqp513wny6LOF/qvj1TVvI1VUrk20r/lZSthGngeAijod4LJ4UJl4rmB
	vPPBewLYaieWbcMQWxlmpUI2bA1p7UPLoq3yViuepsUmFl2OJ8O/H7Bkqhb8AGFU
	eatXYg/4qP9U8s0ptE3YNzUDhYgGt0IINNmX4SiW8jzYGUs6Cj8Lsx3V8LDF88Jp
	g658MdsR/Aft8rWpnW5d7X9aWUXddcoCJKdLYbWpAZIvWNInnZs79TWKyjQi7FFG
	oW4KeLuYGT0b+pBmcLTWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=85dKdpMUxPf/QX1W/GWmWeIy/Z9Tq
	ddNEjmQ0mcIWaE=; b=NoUpS7Kojv7MjeQF2htP6x7lXevGcSb1ADT/QFvszBNjD
	iY/J5HTS4/Lw+OQvoRQ2rijOay90xzlDzIGd37bBuooBrV5m8vYO3BBBBkWTBHP3
	eX3E1GX9hzhq302HIhw6s2BSZ4PJONao8CejiJL/OV7Kgvj83Agw7jeavNIoju4Z
	eKwfBD97g2aszdBAaJdsm+jnAcKvntwSuOAx9PPFN6Z7nqUnOlV+rofn4+Kz+WNg
	hQmz7y0uElt+0riV9ylcLqAY6p2OL5u9NMTxoNOZyAjoeWaFfgvvCw4uOBqsxIxx
	0isd11PWNWkR1Gm/7EnuxtmQeeU53K2UTtEHR7dzA==
From: virtiofs-bot@sinrega.org
Message-Id: <65809.122012506370900167@us-mta-352.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Set signal handlers,
	required to be an "init" process in a PID namespace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The first process created in a new PID namespace (pid_namespaces(7))
is the "init" process, for that namespace. Only signals for which the
"init" process has established a  signal handler can be sent to it.
To run  virtiofsd with '--sandbox namespace', we need to set handlers
to end the child process if the parent dies. Also, in case the
PID namespace is set by an external tool. Fixes #23
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/75

