Date: Mon, 21 Feb 2022 14:35:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=U6K5nV1PeVzfVUggoNvu1X236G404Ifs8M6Xt6UMxq0=; b=N
	/nia2aEDSj+2MEEHLidqiFQ5jNHdL+Zhn61qqRcOrpT9QYjevQl8k4BGKeGlY4Pz
	7MXHE9PPqvpSpzV74vx2dPkgcgLUWkoeWjnRgk6hVTIAk2mEXGCU4o3fKKlM96Zg
	Wy+o18KArO/56ImpmSriJ5NDOLeoPr9B/j2oQKnlR2Q0iwOgC0rlibGSol9TzBLL
	oN5rWYENKwNA5ib3xwkho0fzIsAc4U0onqEw6IIOEdmI6APlXIj/qf0CJX0zBDSk
	A3cBJX7j/qMx1/xTZ5GXTay5/CMwal3SdQCRpj/8AU7goCWNW2cEVZhmyChbxJ4A
	kKJgXKJ5XBQWD/mmgO5FQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=U6K5nV1PeVzfVUggoNvu1X236G404
	Ifs8M6Xt6UMxq0=; b=PRrTK5KnleYDAnDKFw7BPtqn5u4NxQQSwVm+UxceoEO0o
	WqBelMZaCy4bY8eCzVJ+Ui66y2Guuz7GAybAVLONF0Zx4/xh2p6AfSE9mbNtdhKU
	04hvHqaddB3nvMR1y82UTypTrNmPmrz4fjM2VGfoNXz/nIK0LqWarCHnfbZI9Lmm
	h0cndoY66JS1ZuqW/gCd1euLeQNTPxvnTHdg3MY4WEk82+xQzQMvLNFl5IdDQk0p
	4bFSDL55YgRGJRO3ZUw/ZoiA8IlfCEdtp7lMaGTEZ3tZ9yVcc4HRWx2FTLYNVqIZ
	OpCRJ6ny8D9d35+6pNK4zeBmlWeMoagzV0LPKS5bg==
From: virtiofs-bot@sinrega.org
Message-Id: <18225.122022114345700973@us-mta-225.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: virtiofsd: Add capability to
	handle extended fuse init request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fuse has extended fuse_init_in and changed fields in fuse_init_out struct. It was running out of feature flags and it added another 32 bit field. This MR adds infrastructure so that one can parse feature flags in newly added fields and add support for these new features.

Once this is merged, I plan to bring in support for SELINUX context setup on file creation.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/94

