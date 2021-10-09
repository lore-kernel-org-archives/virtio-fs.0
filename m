Date: Sat, 9 Oct 2021 10:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=TtcG6rEzUpZZSIk/mxYhWAOX+ZuWUHRkNv5b5
	xq3myc=; b=u+TeiwOanhq9NXmSJLc2GhaW1M4rWXU1INHpSm7DxpErsDFzFJt0n
	RzNYfkyWAYXhOTTZ7N6jVH6sjjwTcY2Kp0MFwhOThrmw/OyocDsVwafwHlnb2+ax
	OelpibXQZEr1F9ioWYAKh7JI+Qw4S0DBRbfzIaXhS5w8u3lBtKRUEFPdnd0/4hBs
	7Ag7PjP9R/ditzbPowui5wwwr+dk8lxJt3E8ZEgQ+PYPGrCO1OhLo1N5j7Sj2WSb
	yYW3elV3qyMKtmGn8zBo5yPiF0VdV8xHqfg9SSNkOIyOaCewj/3c7UhwzYitacmO
	eyjpMoiZWyR3TIZ0c7hPr4T3mtvmLKtRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TtcG6rEzUpZZSIk/m
	xYhWAOX+ZuWUHRkNv5b5xq3myc=; b=MREOzGVQAadPSjB9kCQ8LE6HnXvqbHveV
	m80ydE2mcjNTlAEyArzZSynq29VyWSje8CzdpqJDcT/XjZSmoAnTylKaKuu6YAq7
	/ahrzYSTGFaQWbpN82am+y5Bpg+yHJTfqOkYx4on5wj8hLMwQ7g76WSiMQIlaCeR
	+AmJ6tIKsgueoB+LAvFycg3qWSHc4fzFmqQ8/mmEuzTsObQyWJ15QJZK2LBdpPJh
	DJaP71WzS8JLA47fMdWSDSZpi030YsHXYG1xcN8NfCGldpLbMuw0Jw0RkGs50zjs
	CoifbKn5jqKxD3X0M1gB/DSedqp6vAWGLC3Dq8NmU5im+1Er7g+vA==
From: virtiofs-bot@sinrega.org
Message-Id: <96380.121100910004800283@us-mta-120.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue opened: [2021-10-09T13:58:55Z
	ERROR virtiofsd_rs] Waiting for daemon failed:
	HandleRequest(PartialMessage)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

doesnt appear to work on arm64.


```
[2021-10-09T13:58:55Z ERROR virtiofsd_rs] Waiting for daemon failed: HandleRequest(PartialMessage)
```

kernel says

```
[    0.738564] virtio-fs: tag <rootfs> not found
[    0.740972] virtio-fs: tag </dev/root> not found
[    0.743308] List of all partitions:
[    0.745015] No filesystem could mount root, tried: 
[    0.745019]  virtiofs
[    0.747413] 
[    0.749438] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    0.753228] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.0-rc3+ #14
[    0.756265] Hardware name: linux,dummy-virt (DT)

```
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/14

