Date: Fri, 14 Jan 2022 06:13:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=5TmA/etBZ8be4SE0fRm3dkXbGx9k/R/FexPQT
	N6MneQ=; b=TqQoAP2La18evhJqji2NhWjouqhK4OrWY8OkpVmU8o7ryi83R+/3V
	gE9cXtOQwM7VsmiI+qLe9PqPTYm6vpalNxhqT10mZqoRv0bDgSzo8Y9uQUM76p5A
	lY9KqQYQtlfctarcw4XoD1FrFH4JF9FSiOcUux7U2iGQa/3wC77MLIy1fRwkZw2x
	6UYc818zpWoXxxBLulNBM9zgopLWVf7uHf/zwZiNxiHXMTPzk2O6vDwvdlW+368F
	FfG2r/t3I0b1tODIflc3S8ZGgCIky1L00qrtHAXHxjCoGn+iYHOgAD4f8JS3hDoE
	tGA/AfXTZpNNVrTM58jOSsAjWkR9auTUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5TmA/etBZ8be4SE0f
	Rm3dkXbGx9k/R/FexPQTN6MneQ=; b=iiTQuyQwnUwNFYjDJuQ5mIIJnigViR6zJ
	OGjhsOcE17Phlb7J/JfNsAX5aB9rRkX7x+zfcHymk6CPrsTLOrcO/JiPUdeuvWyc
	R9fH88cOSgIFwgCwCb/k+xhkb5SSPwjsKyuD0eekeD+c4x9MwIl9mN4Wj5nVlN06
	7fYAWavDHAjQk1RAJPeZaGeIr+y7mlHAiVVBHsXVyYdXqc5tfFsSJ4mpmYBVQepn
	0d8ThhpO6PKRC68IiN1lbazgVl4qO4vGggIGZVqBFpd8uh838iQyZZNV0qwcPOTW
	lOrNLvQXmGNDF71dCRWcAQmO+NGOKh8nJIoB5XKma/AH4ihHD73rQ==
From: virtiofs-bot@sinrega.org
Message-Id: <14484.122011406133600314@us-mta-644.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Draft: vhost_user_fs: Implement
	syncfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/66

