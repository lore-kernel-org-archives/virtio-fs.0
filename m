Date: Thu, 10 Jun 2021 16:53:26 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <78958.121061016532004215@us-mta-44.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vRdTomjeXo8vecvuc
	H40a30bCvEo7B9E9upzoXOT4Cc=; b=g2M2mghihBAfpjWV0JNYL6paXIJEWdX+r
	9MhDrjW7hfA1ePeSgWqv3O66PZzyFXB3pAPVjav+Ui/4J5rSswOZRhZ5bvc3iA+e
	KnYTmm65n+krrfdCm0OypZ/mgPSoHSdF+Q8AkCFrvHIu9b9xdnzNM1X2F1w28iln
	mFInL8ZeaPAX9wazCnLK6UN36bri2c4DrPbcR3lmmLymEkXZdBo9mIwQGU0yYohL
	pWld49mbZ1Ons9/AGNETgOMF/n//bM1IoEcvnFhPxQ0EaL3KmbfeXzGbC6HrZD6P
	lg6ve/q0rzGbLXftcIaMKSTapcs9vyU7MBoRCbMC6ctb8nGIj1Q2Q==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Enable killpriv v2 support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Most of this series is just setup, introducing the relevant FUSE flags needed to our FUSE types.

When applied, the pjdfstests suite now passes without any failures since the killpriv v2 semantics are upheld by the server.

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/31

