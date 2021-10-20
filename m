Date: Wed, 20 Oct 2021 01:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=lb0FriZ4YhI+l6hcIkW2utP/oPxaVV3r9Vf5X
	soz/ko=; b=I6zW4dWPeibjh/Sihgwnjl8soHD75rAmYMCd7Bj4p1ruKx6WjDjNa
	XcM7hKzxBGagxuuRNup5yiub43k87U/7tuFbKIrnxSGmtYzMmzKzMs+1mD/IO2A4
	LF5XV+iOLoKIQrp6TOn+uiVoZzZVpBT30k/3fi09lROZ+Hjs2CxHaKgjmpLd6j9l
	1WSQCyJjzV2qdmQgra8YgnTwUXsIH8zwD3Q8TwwXFliKJzeuFMsix3JxQYRYdQim
	M9UGcf4e/lq/m0v2xCb2c5Y6+ixZq989d0PUiG+K2QKbW1Zh5QH0gPDntHmeoxZ+
	9O7Yzf0yWHneAznQWp2gxxmL/D3vywvMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lb0FriZ4YhI+l6hcI
	kW2utP/oPxaVV3r9Vf5Xsoz/ko=; b=CIDYtE9BcSS9m5SIztTnI1fuE1ADeviGy
	QHZc9sYZtebs28kphV7kWdjn4e25qJd2CzUs/qrzgIVsPhjA+GsvJdNXJ/aE2O6s
	BHj4hO1mBGyrXoKqeLba/I6/mOeaUW7jad+uXmZfBvq8OxB89x7EvQdyd6qmBwgu
	RqDN7yomUrOhwKpjG9gMlX40sjqB5QNrmj8JNf6Ga+Px9NGMkb+fnkwQ/imY7sak
	FVR8OUFOHH2lz+aJw1CH+lhDi+h401K5NeSF3LLO3NrczntgL3DLdCL4M268pdDp
	kbUwrFMxAjPl1/+GPdbtyB3Kb98OcpiJx/7YBCk068EDYlnMi2EwA==
From: virtiofs-bot@sinrega.org
Message-Id: <11466.121102001422500325@us-mta-546.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue closed: switch to using
	fuse-backend-rs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

For clh, there is a crate [fuse-backend-rs](https://github.com/cloud-hypervisor/fuse-backend-rs) which provides core components like passthroughfs and fuse, including forget support and several corner case fixes around readdir (with [more](https://github.com/cloud-hypervisor/fuse-backend-rs/pull/10) to come)

By switching to it, virtiofsd-rs can not only get all fixes, but save a lot of code base.

Thoughts?
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/4

