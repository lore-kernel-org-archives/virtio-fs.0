Date: Wed, 22 Dec 2021 10:49:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=CtBFUPZkC6Im0OfkQP1GfpJTLvd2icaMslPdO
	AjrXmA=; b=S/pNM7K2+vNORkFzYFYukoepwSv8ImBklSyZY5/qtcWyvSJHnjIlk
	lcyikt/Sw5dCcH8FgWjTujgnL18K/FjLaLH2FxNsDPQs1txFBhos2iKawT+47MGm
	FFhy1o1CfMT2uokUes6BjKpFbO1b5Ahuo4pcf+WMruYtNxLun3KYEK8/qckxgQcU
	dtUiWbw6/njHn1Fu4dEb2hmIR/Hwgd+OHza6tvtHsQ8v0rPr8uMnL05HP/fd3X0d
	5egOUPRH4MEx8wjqXwcomEbDVx01NJh+bbTFWY+ha7mlqLgVauVQnbXhar8DSiNy
	6s7Qbf9yGvKEEC550xHHTbW8vF2+Er7Gw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CtBFUPZkC6Im0OfkQ
	P1GfpJTLvd2icaMslPdOAjrXmA=; b=Rq2QcaMyBq3SkJJk4D5EG2r2f/Sl+0h+S
	IZSUk/nV9hPujSmeWIUNmlRJypJMrmGGMP35JnNu5Zhuamzy9lYatkmrjWtPrUkS
	eQbIohSvdChbGI56wULswS+6tpSRxP6zJN0q3G3Zz7lTIXFK0Uk4Uen9ha7eK1dU
	HaZbIAzXNalzLFGp4GrHo9pUC2YQ6esUiVFR6gelBWUrLUVmCL+1nlPWiMNXPDEJ
	2hvW7Wg/7cbR0VZoqKXc/s93qri9cx/UPOLcQ9LxM1M0QfAB76IlyQH7nz+XhW4C
	7P+TrDT0IZqY9/+6GzQKuODlDnl7Jq0b7q5VP81HNCMvv5LA5wBFg==
From: virtiofs-bot@sinrega.org
Message-Id: <52177.121122210492202944@us-mta-654.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Set up the stage for v1.0.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This patch series gives the final touches to get the project ready for the v1.0.0 release.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/60

