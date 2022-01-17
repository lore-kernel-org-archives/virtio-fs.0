Date: Mon, 17 Jan 2022 07:20:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=kbI1OlAUjMlcUPAhF+ItAkfIfJLcnUUzTBSg9
	tBSZzc=; b=G6XhxYnInaoKfUpYtCSOTCttd4Tmci7oSrzJlu55ctrI0gOGlHeDw
	rJf60vdLSGsBlNufDJWNYC6IYGpQYWaa32H1BGMADTo6035Y4ixC4xbzhBd6b9jn
	8kQF2g452ap2bCzmJsGEuvDjhL5TyYRycP/ZUPDFQ6pCmwgWMQuSQQ6sW5wLgVbW
	cLOiWGSc8aSrgoCfICjDaswI57iTfSlJ+oDp7///UvAGYqwKxm8w1GN9jALAgsOt
	zFnDMsB7iJfxRxy/sqUPbOVs4uUF6342Ie3QeVIu7VE8I4quStnigVY+AnpIUADW
	ahA6HtcuiuBEp6c8+ZbFrNgqLZ381GlpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kbI1OlAUjMlcUPAhF
	+ItAkfIfJLcnUUzTBSg9tBSZzc=; b=JwVb4UsoGplsB/foHiMCHaQMAJyi8HB3N
	DXnr+7hYwVpGYY4e5YHznsJit+ZjyLuaK4WoWSmX9BuvRfUIFeoQ/1M2ImxlTBlr
	/9mF1JCq73nw6UNLHvNC6jIyXM3OGRU5PMjBAUwLReSmvKwbg/ejub06uXLKnCPq
	oG7LoEjWYpZkoptm/NxGonlRv5WeqKw5mefCEniju1LyBcxVRA7c3mvvJg1L3PiN
	2RUTi9p5pjlnzzzQwFVVVr+X+83MZZgdf5YVHeAPUC/HMTO/hU4Sj7mucg9wkBf1
	3FuKw9WT7bwfnxofF8f2+MOSkBu3QzpGnNKM+yYmMGqiiY92Fcl5w==
From: virtiofs-bot@sinrega.org
Message-Id: <96293.122011707201202646@us-mta-608.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: xattrmap: Fix documentation for
	type "map"
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
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/68

