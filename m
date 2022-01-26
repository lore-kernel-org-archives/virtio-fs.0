Date: Wed, 26 Jan 2022 13:53:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=zpW/sYwiLqZh4AYEGUTt0OlfwWuGpfFk908+MTj+usc=; b=i
	6GK7UYzJRzbhUI0BNKfM1Rv4exF+S3+XIavU7gY/8m5SZzurLeAmfhFYttbQGvz3
	TCXub3H2TiPFQZoD9rEhhajolrWCLjHIxBmUmvNvhJ616ewQEB3uhLSD+nOzMskV
	VBqkJhLLzPMIxrX0bRuHlLIpsbzFFMrcGejuZug5xVk5ma4eowBpNKGHVZKGbhky
	LbSSygc83vKRG/LfnyMTYtyzKBt9fgES4/oX78hoHJxaFA/HbZ/ZvDhKMobA/B9g
	XIJQQAj5TlCxhseV9nwWOORIbOx+M6BavR1W0Y3ppyXyW1ST8aYR4QPxoBhu0dXD
	7/CCohbVKVbJmGIxSqq2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=zpW/sYwiLqZh4AYEGUTt0OlfwWuGp
	fFk908+MTj+usc=; b=OVgVk1mm2rGNZEmhzfrkK+/6ulAiW2hqCB3WUYoMsMCva
	PXYmN9JAnfcuOPJP3CEHuvXscrS7t72mUu4TvUOiooLG9zIIuJK2QeEEOzbzqVZb
	9EUeXDUVIOLjs6RTQ25n4GXNb1VfJx4L3hvvi9UCBVp+UzPk3cHKMIoZFrAH0z0E
	kjtvTVefWWq1PoD/vg4rv7DxEgJQUESculUY/dJimMbcVWftMTBrZ2KIhxyzJCd3
	tYaCy3eAM6UtgroqW2p1uRgsghsuDv3O5zu96LN2h/czQsz/Jv3ymZZOxz39sXno
	j8SJ++i64Z4TiXiNGZqN3R2MgNR4YJBpNd/efisAw==
From: virtiofs-bot@sinrega.org
Message-Id: <55596.122012613532000660@us-mta-548.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Bump version to v1.1.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Following SemVer, we need to bump the minor number, as we are adding
new features.

Changes since v1.0.0:

- xattr mapping add a new type "unsupported" (!67)
- sandbox: Support combining --rlimit-nofile and --sandbox=chroot (!65)
- sandbox: Propagate exit code from child to parent (!64)
- xattrmap: Fix documentation for type "map" (!68)
- Adds compatibility options (!61)
- Replace crate seccomp-sys with libseccomp-sys (!71)
- Drop membership of all supplementary groups (CVE-2022-0358) (!77)
- Adds killpriv_v2/no_killpriv_v2 options (!62)

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/78

