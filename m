Date: Fri, 21 May 2021 10:16:54 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <82434.121052110165100326@us-mta-449.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Z/2slZ1aESyTvgdyt
	TjznhpFXIDpyRBdckvyuGvdLBM=; b=a98AwmNkhqWrZCxv/F+HwIa5HNxy64E99
	772OTzzEeXXdEusAVYkVnRtxS7f3LCXWSfhv/uMcdJhmIegvVEZHuMSAXhlsmrmQ
	PsJndmjAv+y5E1LYXRfcTUEbkQyVDCpQqAihblkthcjSBys5OFzMdSZVR3IZNC60
	zzARvZsoLhmhCeQVfCzARXQIi0Ix6BNySXfZOP8gkisdnb4jds2vwMvYTduilAXv
	0haw2kpShgvg6iIFUUuT2tWNjATzJB72V5JvAvLd/V4MoJKe/YOMfOqp+Oqgb4Ik
	h52FtytjkEhBlkXzWuVcvYcRisYLaURVV1SIFlP3JTqA8a/Joy4cw==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Infer type to fix build on
	Aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/28

