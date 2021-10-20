Date: Wed, 20 Oct 2021 01:55:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=d/klWL9Dw6fusDFGIAZdC7Wcw3nrLWFI2BmIG
	746gxQ=; b=iHgi56PZEyR4fPLjquwLFq7fK8U5Cjrccn0hBaA6KQMqVOHRHb132
	A8aSSBudmao2wuhQ9uneM/rqk5woy7XWPLSsVy6mJ0LNSh/ggmNo5dNzutTF/ESa
	y2Gt++mqWC2iMyCWzDHyDp7c3R97Cr+CWpbzPGlRYtTN1NPgu0Vf2ASmDYGslF6r
	DgFGPFMI1OcHC7Bz/Q1zhsttUBg2yffkTXsWDWc7HXaUfi6n/WxRd3dCKS1wU9PL
	Bb98gpBpcheBNx2hgbh8WPXxGCLf3uBRWipz44i6BiG+cRivG80xrrrR+TnyHE6U
	wxUdSh6l/zME1sBYKL8ni3f3jxr86lMOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=d/klWL9Dw6fusDFGI
	AZdC7Wcw3nrLWFI2BmIG746gxQ=; b=Iym6pSpoPt0o16dEvEUGG76EpiOqHHUQr
	trlW171iccWaRHiEh7s+ZWHK9vEUfrcXgz4zXQBC7I8jIS2eOPxeDCzYBQbriv+l
	lH3tMaf3KFqP/rkZSJKVJXmhGaBSH4DUXU+OXf7JUPmM9Rpq0F/iD4EwviNI1lLM
	cUX+AulNQ881aXjZxTmeTGgZxCVHnRJeG4bdsnskFuxQUJ67DCcMwdvWFP1oF4r7
	7gqBebRwvRamXCFMWdcKVTmHMroonujnw8KNh+LRoiY8m4P8rG0PcPSu244ZunCZ
	eJeQlPmm9G39cZFACE39PDR8CLQ+Eq7b1QuCx0CNadBq2v9UL3bng==
From: virtiofs-bot@sinrega.org
Message-Id: <49927.121102001553200113@us-mta-484.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Drop mutability from
	FileReadWriteAtVolatile
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Internally, the FileReadWriteAtVolatile methods are going to use
pread/pwrite family of syscalls, which implies the file descriptor
offset is not altered. With this in mind, drop the mutability
requirement on the File argument.

This change allows us to drop the "try_clone()" on
PassthroughFs::[read()|write()], saving a "dup()" syscall on both of
those critical paths.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/42

