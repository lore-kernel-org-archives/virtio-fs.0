Date: Tue, 1 Feb 2022 16:41:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=MvW6qUDnkURX+NzsFut84zpxHXtoINcbfb7rYg4pc9M=; b=N
	aeOANhiVsOCyi+k/z1hA7cNlSWOsj1uWLsBp3wjShakEmbDS1ZAOAtXu/eTXCl9A
	5fPRDIc0beRqnu0pfkqqIpTnJSMDg3lgqTZGRxx2hc8UTdzN8xNOLkieSdb04zOv
	2LIJiOU8t5GktGVmEk1U1bazS/b1nRrikKGJiKKwV0cmFadQLvwZVplfRb30dOHe
	oiUILhjYra6UXiAF/CAN5FGFEDW9/dTFEXPnSnLNexeJABwZEZKCi85TCAeOWR3C
	JXp42cRCtqNji2oAAAPxLXW3jHhWLGW1ZLwjJEUQbsV+6tebS3AGCULB094Ag1AC
	SEvw2Dio7nRkpaD4o9nxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=MvW6qUDnkURX+NzsFut84zpxHXtoI
	Ncbfb7rYg4pc9M=; b=WqN5RCq1ynyT7TsySrl/Z3d05TIBgxorUme1lgzQt8QMi
	nSiZnbzRSj1pRV5vUzSigaTDWcpP15VZ4EgVhDgDFSso3Tf7yWoH/SCnUN2Qzxbg
	fSFYiKA6QEK9s67Vj1GbzIlyWr5h3CnocqTrZst1YkiEE3yDuhUl91hLeMzkrpwj
	pma+KH73lDWe+Yg/g4WV9AW2JjsiZDffoQ0Baud+HiTH1lt2AzgKARtoqe1ey73t
	xFci0po3PUsrYjG17KnIhzrO814oert1yxHKtFY+1qPfrSdAOvDhMil7Lmn6rpcc
	7KyyPagCqM8GaIssB7MDi+ZYFZhKXi0ILiLvrqa8A==
From: virtiofs-bot@sinrega.org
Message-Id: <63099.122020116414701355@us-mta-279.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: passthrough: Reset config on
	FUSE_DESTROY
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

`PassthroughFs::{writeback, announce_submounts}` are set (as the
circumstances require) in `init()`.  Therefore, we also reset them
in `destroy()`.  Without this commit, those variables would always
be set after they're set once.  This might be undesired when the
caller calls `destroy()` and then `init()` with deviating
`FsOptions`.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/84

