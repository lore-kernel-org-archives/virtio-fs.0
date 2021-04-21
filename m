DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=WdYfPNcuhe0LRKPzJ3/08
	eHCdd1XwiOwCUWI+wPuGD8=; b=KyiaUlY+A9Nbi/+aL0CTVkbtvyiskiAzyZxpE
	9inTCmnYK0hQ60LwslJKTatzemDa/D47QkjeIN9TWHsw9AGiEJ7M+TttzeJxhxjs
	m4y7hWz+qxNoItJv+oLMkikgRlsJpVGldpoASuPNNI4C6MmYrVpES0zyec2ltG3T
	XL+B4dZbmQpM0GuI62w9GpFlGgHY8YyOOZR5gtU+bACSHWGUtIfGonP/Tt/dCKo3
	kZmKclmUMaBRKE3JJQqNhy1B4hcfaQRz3WbUOm//R+iuYlHcgYLVTHu8qULZ2yET
	YZaKpR7A9y9xq8xdx0rKWLteKCgEuxPVQwhIU1Sl/dLrhs4+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=WdYfPNcuhe0LRKPzJ3/08eHCdd1XwiOwCUWI+wPuGD8=; b=krXg3c5v
	nKylAeGa1HwlupmWCY1xqK3Zu7fs3QcWaQ1FTII5K7ypoPI0+WkV1QOrW5fajehb
	XgpWKmooyPqmemtCJB9tpgzI8qEFBG/yq+P/pejjf0ghfLeqQY5X70gkIO0kepqj
	ZNLDvZ3dpOlzKKLaD9+WMdbkcAS4PYt43mteUoqdqwNmtBzheDb1MVrgSzTlIKAC
	niNQw2KDUVJTOHwfm2ICFyphFM1nq5F5hI1+uIvU08oCvLepxQo1mxqLk8lwPZhG
	jxKEhXy+CiQg1IzQ7t19aKG65rBnRbCczfS3Cx/Rloj+15CmRgpV+HtnBCxg5a+U
	GZZc9y0/1+gEKg==
Message-Id: <20210421081716.8D35224005A@mailuser.nyi.internal>
Date: Wed, 21 Apr 2021 04:17:16 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Add packaging-related content
	to the manifest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This will be helpful when packaging virtiofsd-rs for crates.io and will
simplify downstream packaging.

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/20

