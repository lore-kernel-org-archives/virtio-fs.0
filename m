DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=AohTzW2iCf55qgyXthxu7
	Ovk3LfKU/RdHANWV8j1GbU=; b=FHKdMMuVyPF3gfZp8T5GU9f1jalOr/CI9iJ/x
	LkdNxecd6SddXPu6EayCHWfCNgcvdMYFPFZtnHDOelepI3WiuaotOBCPXoLNuzCN
	zsCvNOEe3cx1RvGjYKMGta/B2f3i9bmKdWx9j5jtjpvcajelP/+Sz5jYQPB0BR0z
	A8J4IaSitUBbK06p/KUvhZqrBXlDAVSzu7SxZ0d8bwb1ftDZ8GT9MVqJxL4mjqMo
	kxe3S92+PPryiKEV6czLL94frok+siYKIy5HpTKtxBnbxwkjmmB6NpaRhfu7BOwE
	N9W//zAaRhoBdxf4yXFGT2nSlItFugy9DYi+cZ/x2M4VLqQ4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=AohTzW2iCf55qgyXthxu7Ovk3LfKU/RdHANWV8j1GbU=; b=rFM8ZSuJ
	+XyqY4SqKeiM6cZiEByOPEZWlfBvp/NmJrp2pIJqiN1/MyZHJPPSBY88693XSye8
	eSFvubmtCFMOup+De5tnWRC+QnbwEABsD0seiKUB1wbJ7K+oIEHpnWeDFiNyKl1H
	NmOfncjrmnTJGIV8bRcx6nkncO3waahx7139mN7kCoMzLd4FA923AkMj4Cj098N6
	njsgMAHZJF1HBgNgy54rBlExHvWdwBFH1356VY8+QJCIokqGhONy8ZahkTFTLcaX
	zlrJE/3Ba1b48hq/a6zlc1GVtQJtaxJQ2Hcri4ixXwgqfR1IrdJv/DpCbrgN0FZd
	9aLk4Q0MkEVW0w==
Message-Id: <20210421075938.6F61324005A@mailuser.nyi.internal>
Date: Wed, 21 Apr 2021 03:59:38 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Add statx() (so we can use
	mount IDs)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This series of commits adds support for `statx()` (if available) as the preferred alternative over `fstatat64()`. The advantage of `statx()` is that it gives us a mount ID to identify a mount, which is better than the device ID, because a single filesystem (same device ID) may be mounted multiple times (different mount IDs), and every tree may be different (because of submounts in those trees).

Then we use this mount ID as an additional field in `InodeAltKey` so that inodes on the same filesystem but on different mounts are treated separately. Furthermore, when checking for submounts, we have to consider the mount ID in addition to the device ID.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/18

