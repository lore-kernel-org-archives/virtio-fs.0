Date: Thu, 2 Sep 2021 08:32:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm1; bh=tAgdBDm7i0nCEdummYKQAHg4VW0V9Go73aJgw
	ZImz68=; b=l2a5ECigLosQ6qGQJA44XXk9NccgvBsTmSos8285bGm4PZkmXgchX
	d07SL/lkBZszeJ7AAZdHDcH9tgY52Cy2sxGGzruJhmUAMN8ifEUBb0fwkbR9smYl
	EwedqDGJNO0iV47fuhgCjLfURlYhARSTpbZWeDLlWMMpcp2nGgw1kvMsDHUaLQXn
	BPPDxPMFvIbPp4gXm1GcECFlvnSkJCjB1RJSoqorUPz8GdeuSiIkZA+TnsTjOGkH
	jeh19qD2XlDQt3s+NQiITud5R0prTJ/nCqcwzpaxZfg1lQizLZPRAonXD7kWz5Qh
	/SEzkMxNIJDQ4apBT6axKjDdbyBCTBdKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tAgdBDm7i0nCEdumm
	YKQAHg4VW0V9Go73aJgwZImz68=; b=makS/PtgMVKF8kmq3NASYGSUo+78p+uUX
	mr/WwGX3SqCPDUDoEqRsIRN+NxZ5x8pDQb70gQfyOMPLRnPBJtGOsbCwOPDY5Y8T
	+Mz15lnBR4A9IgDVvYLjPq7tPvrMVuNq4J66c6lKfUVvt3TGvgNX//6YgEABnEV3
	yA8X01Ox3E7gTpuM45/f3pm5etNDIG41nAhPVRi7mF+z88psVzLkXXAPmjcls/Jx
	zv1cw/6SwiDNP5PjRBNVlKOH7p58+X7fxMlqtTFlzFYzba3wKjfwd/LZq+wCv9BR
	pPDneSXxzm5+SL9aEuLYYQtPa7tTgdseI04zxSX79tNUIKERxuUQw==
From: virtiofs-bot@sinrega.org
Message-Id: <28448.121090208314601295@us-mta-154.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Do not filter out the
	RENAME_WHITEOUT flag of rename2
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
to passthrough the RENAME_WHITEOUT flag. The Linux kernel commit
519525fa47b5a8155f0b203e49a3a6a2319f75ae already enabled the passthrough of
the flag. Therefore, let's avoid filtering out it for rename2.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/34

