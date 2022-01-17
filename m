Date: Mon, 17 Jan 2022 12:52:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=h5edD2I6QkmKGFz4Rf4/rPm+0USYFMxGVUHw2
	vRl9rc=; b=gaJrEROI0BWAQLgbVqba1Gna2w0SPdLQMclMnjde/dzwHbqInVu4d
	LVXlFBVaaMGuGx+OZq/62lT0nMtv1PvtG2LQZW5tvk+sdjWynBtH9Dl4SlYEzMjo
	VMPF0oFZ4CCj7UggOwBMR9B94CTXqD5xFZaKcOrut6Xbxu36pK7kSDpMG3zsw0JN
	SJbqsbFA06nNq5jbRBbmsuKU00loDhXDUUiUhtneUgulcEfJMKYgtLye6t7ZyGWX
	ysZO/tzhlvrU8IoWZGguNRK0UC0d+JfnJY69cKL+ym/qFk9cr1Ze83V48nHgBRtp
	Tp9YhUOWfbU0C5OXJcuGnPSoAeCbk+gVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=h5edD2I6QkmKGFz4R
	f4/rPm+0USYFMxGVUHw2vRl9rc=; b=js+nfIEtwHO50Fh7mgliUZerBPZYTnDWC
	eaIMDfDXCqkeKtWwew7esT3YiTbpdCgYFYZEBqLYigphxyFmsArRUJbaLjlCAexG
	dKxlwKMI0K4KvfyRCt2cagemJPI42qfZ6ebX9RZsdEKxjXdvgTLiTV91F9LbDwdH
	5SdJSUILnt1A20mbKtIDNTTc+Vr1HEjlVMfuAOtmhwY+53514Yy+r6FJ+QJT/mfQ
	u9O/HaOqwnAhGmB3D5hStIWJ3iyooFC/GVhiPMJqdZy4/1azR8+07eO/rn30SEYn
	aej+HgUQdM9IGqs7sfGqUea3i5Nc4DFwu3SHDjRsEgcfDyATG/Lyw==
From: virtiofs-bot@sinrega.org
Message-Id: <21298.122011712524700317@us-mta-263.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: Exit child process if parent
	exits
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, in namespace sandbox mode, if the parent process is terminated (by e.g. SIGINT), the child doesn't terminate.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/23

