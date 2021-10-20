Date: Wed, 20 Oct 2021 01:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=TtcG6rEzUpZZSIk/mxYhWAOX+ZuWUHRkNv5b5
	xq3myc=; b=Xme5ZlmQZmZKY6t0Z0iWWhKo1TEhd1qL4RHeE3lLYMh1EEz+iUHy2
	F47gdzVA8BKZb19Tl7gRASRepkZcI9J8JzwfqYMHnvXn1cZTMUpxAkfLTjGj3KOT
	Qvy0pnzVSPXPpmUAa4Z3osfomODbV2ty8Co7ZZYmGk+f9Hj8r50t9FLlBatlBXyM
	LiWK6uTs4A4VvEeKLRPZv6uyWxnTH/S8+1Ivk7o8/uLx7w6UCAwgcmu+lAXiof1b
	aeJgnJZL/AQgzJJi1Ka4TCheNLKEy/H+HBGMiPsB2KP7a45Eq+2973NGgDwZjFQu
	M3K+rQMgSRjzMeb9LnJLIJQKz50jILqSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TtcG6rEzUpZZSIk/m
	xYhWAOX+ZuWUHRkNv5b5xq3myc=; b=Sloi1yS/faJr2dvhKDAS4Q60c37fNDtN8
	fitGBtT7dy+I2dRaBXoMHErd653qpO7l0T3cEzrj3wfjWqrPu6brppDl81BgyKjo
	dDOqMALBaWod/oi9EfsY0XkawqKmXpJnzoO/rN3eiynjVaf84gLNJf3nUe1snwtl
	M2cMTjL7DyRMjmsBR0sKmCKgA1BNmqVa1qhsIRCp2XB/GgCk1XP6Fxog/BBtSnU+
	rSWcGZygT/Gfiv+g/z8spaosfXE7+CIfxhOXq9V5mmUuF8YGSye73aHj/vVsHS/q
	jNkMu75wMTZrBoENOTNPOKe8Fmjz7CfYZx32MNVN0qiBa45yf2ifA==
From: virtiofs-bot@sinrega.org
Message-Id: <75471.121102001443800159@us-mta-117.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue closed: [2021-10-09T13:58:55Z
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

