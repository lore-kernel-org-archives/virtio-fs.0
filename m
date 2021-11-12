Date: Fri, 12 Nov 2021 05:25:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=LgmR2w6wgQ6JAe1OP/BQxoxSnZ7xjQnhicqIt
	yz92W0=; b=MuJ6zAYdVeU4++4XB50HmcmNZ39dKqZMFJw4Lv6VTxKXXrkox3prw
	9M2BljD8i+zjKYV5IEEjF2IErkSjRIx4dsL45/vsm8q35pJ97hJiQw2rUbf053Gv
	l9f+eCrxhOkCLgbNJA8UPMhsRgPYEVItEzPg1gnf6ra2M7oHQe3TuNZyUpnl/aDJ
	iSC4C6X0OKqFqdQtB2gl02rXpiCisDQT3+KLdFs3KjCrwGMzKDYwdigVtlK0txLc
	EnclJxeI/tOMPfGy3CLbFj6tiz8+ZANrc28ZdLg6kJscaY20y3qcs2353RQDjr5G
	BYp3p5W2XxwIUAOWcC4r/asllNIZwieXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LgmR2w6wgQ6JAe1OP
	/BQxoxSnZ7xjQnhicqItyz92W0=; b=lphPkhJ/AD5xcajnNmNJpZjNUHgRGZO22
	4Oo4PC/B0pL1hXCDE/3q5y+HuNDnjCXcamJaANn2LxbXVhWgFdpuORNIbAMvAPJZ
	aa7lES87g32pVIEr/7PJqvsdFPRyDCkGJl4ThcsRobW1qCLPNLzs1MpgKWiHLwjs
	LYqecIMY6EZh/j8xpDTXDukGpF+7dfZm2O8VXJPt5GqOFeo2Zci4R4HmlfwausEw
	QPWTLLwyj566ygSfMa+axe8soLCWDY+7VFx4E85SK9NFl5IxNGyzCBr2mJdG8Mk1
	Efc6pyFgy+zX0+DRE3nMQfvDCaWz9JjLCZPYAWwlNE2Y3KmWyVmPA==
From: virtiofs-bot@sinrega.org
Message-Id: <65079.121111205253500821@us-mta-179.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Add vhost-user JSON file
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Add a JSON file as defined by QEMU's docs/interop/vhost-user.rst in
the "Backend program conventions" section.

This is expected to be installed in
$DATADIR/qemu/vhost-user/50-qemu-virtiofsd.json

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/47

