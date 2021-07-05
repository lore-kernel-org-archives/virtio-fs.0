Date: Mon, 5 Jul 2021 15:14:12 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <57364.121070515140600271@us-mta-9.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OCeUlPuJzUMdT5PYA
	jx0WvnQJSpPEmC0YMwgbUb0UgQ=; b=MhulpKFQqeT2Xe0leIwIcSf7YT2p1mRwP
	J9VqNNiqmZywnYVv4pfndGalMN192lE4ZrJLj0NyUBiB5Q05su12K4ggNO97Zzbp
	erw6mEHf+y7uqTmSKAIW2HPY2nogay2d4AI/YrjAv0NIr/pP1Pvqc2VNqitMfPu2
	g3aD8bENTuMO6ET2tZe6p1Epza2E/R1L9upgPFsclfApbeS29vQA7ABqre8ezSaQ
	9irZ8jxgWq5KxrE0+StrRgfIBRQmGVUcNyqt2eyhA/1gXcfGIL6ZtbXTqB8Vls2L
	E6Gyvk3EkXKp88ooTEifNwzcfA2iGxbqnB6WvpjTfQOTsrUPefdEQ==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Do not fileter out the
	RENAME_NOREPLACE flag of rename2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

To use virtio-fs directories as the upperdir of overlayfs in VMs, we need
to passthrough the RENAME_NOREPLACE flag. The Linux kernel commit
519525fa47b5a8155f0b203e49a3a6a2319f75ae already enabled the passthrough of
the flag. Therefore, let's avoid filtering out it for rename2.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/34

