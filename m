Date: Mon, 14 Feb 2022 01:50:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=5TmA/etBZ8be4SE0fRm3dkXbGx9k/R/FexPQTN6MneQ=; b=G
	CHTfMvhx9Vud4NHBDF9uZsRq6PYnZBamsH4qx3arqS1nqVRTO4RiEI+LDm0j341L
	dBrv1Off1i9ILZbBDAXqAK7DWd4wRf2UiHnN7jTMV8x0Hn4GEDFPWQquC8cAjQ74
	cX07NiDxBoHA3zb7TocWKZEA3IwrlkZX6jLiMxWQbkwaZBnh3uORrzmyby2gYDLd
	OHq7tjytMbxpN54OciIYBVIGzeMUg15xToKGWxSwlplhLpZOvstza/jWJQ05tjFs
	x4pkgw/2D9IDf2xcQROzPcrt3ENMQgEWDkol90fNRgiysPCBCH90rw8BlxFNrfz2
	wlDK8ocQzFgG086/C407A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=5TmA/etBZ8be4SE0fRm3dkXbGx9k/
	R/FexPQTN6MneQ=; b=Njfv/wRc1enEpsfIADrnoLEDlq+E2IJV6YuvGJnGUm1E6
	Y6P1rKrihBHnIqa1+VQjFooSnHHzdGwTC0PSaYQS5k0tTEAvfE4GsHj2ZvBi12kZ
	rgT4EDDVx4hxzNV3J0xcS9GgmYu0Ala2PBLJnSkJ9cu7kRQOtV6d47DXezs04rZh
	YX/FfF0jHcINAmltNON1OfQ14GnVHjeoOBjBvrrftn5GKoRA0lyq86OlgNnDlmc4
	K6p9X6/Zofiok2RnXMCAFW4JdPAMwODyNjhV4/DMeAza8lsPKVt2GtrPcZWwQa9+
	wyJyeeqZA8dRya5QuG3nodzaWSnlXYE+7j3tGOafA==
From: virtiofs-bot@sinrega.org
Message-Id: <09525.122021401501600180@us-mta-663.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: vhost_user_fs: Implement syncfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/66

