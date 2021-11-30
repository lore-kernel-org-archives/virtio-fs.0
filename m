Date: Tue, 30 Nov 2021 04:04:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=4HWrMdKhD4LhdSzMF1sPEHdY9+ZNgBuEpme3i
	lbGOhE=; b=dLI9Fqm+bgngLQGJ2HOio9A3oiP46C6PH9nH8eCMMBdTRE8CLeO+i
	ECF9avgNki3HNI5YQmu2tnufZxlL4OEDXBAMp8w9HrljLGp/UndkDYTWA3NOKMnA
	lsCl/LaETaG+5LZdWaW5ZBE+Lb9+6p+ULsvJar+tjGSeJyp7IvkL7IVh4umjAISF
	lT4/BgjzV8+KACUXIto0WmqrMtrD1/UChsylKlQVQYBmQmCks8F4LHL4AZ+QBGaS
	B0ft3twLWs9C3dkZ1y8e3DXt8ZCrhCT2e0lH6w2bOG4zeYAGw6T93q1S95Xwl3M6
	lOqriuMWydQT5NHdwYP9DLVXr9p9/068w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4HWrMdKhD4LhdSzMF
	1sPEHdY9+ZNgBuEpme3ilbGOhE=; b=QZssh7i14QytwKZ19Wlt23dLDYiBgWeUG
	mU/Drjuc5sm4R64f+p9gXxHbs3ZhhR1nrLjgfX2hBp2ApR3tHWzc3ieraAEyoFk3
	ZOhM5N+QEao9xpldThDYx9LVSmp7njgnPT6Zf5yT1snMCb5qKNgUbiN4R/Ou8myb
	A/bbAkgIgPGFubDexIc9qquW3RCqWN6iL02oDIuCLozswI3BTfmznoWBMkw8M+8r
	dnMO5ntF5C50Tez/RCYYfrVYMRs5MWubXGywI0ekHJ8TdWtkCAAddvBaLrW7zsHF
	+u4D5ffsiagWWWisVsKW1UMsCvmRVmgrQPi2yPdU9qK/SfuA1lNsA==
From: virtiofs-bot@sinrega.org
Message-Id: <55052.121113004043400953@us-mta-487.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: descriptor-utils: fix
	split_at()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

split_at() doesn't correctly handle the front part of the splitted
buffer, which should be truncated to [0, rem].

Fixes: https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/6
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/51

