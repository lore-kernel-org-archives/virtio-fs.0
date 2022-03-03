Date: Thu, 3 Mar 2022 12:42:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=DcW3bqL2gZV+5zNh+zCo8d9VYYVUn3Ff2c79W2OIQuM=; b=h
	z1GxQaeQyAK5Srcn4l6c2rhi8FO2RXab5DD2mcguqHef00UwrXDRqPKI3ZQ8SmfN
	TplLBQFlauvFB4y7w85TVm3Og7D0+fSCs3sDdiPwBFRdHzGGve3BeJndKt7Porx5
	XnRRfnSO0T1//RoLrsPp6TO8ApZfshbyLQlZ/WimJS+FIJlBqLVCQBcFiRaC2F3F
	jkHOQD2Kpw3aKo4ahDd3C00GqOhuCNQR3rlHR6hKP+/N1/AWuKNcxJpaDEVb7eVZ
	vugypMzKddWrII/XcYPU4oEdi/xQyDX/Bs8yDVOTX8m97x3wCP+fxWvD75PiR6Hf
	M8MlgUOnkh6m+pR6ng6gg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=DcW3bqL2gZV+5zNh+zCo8d9VYYVUn
	3Ff2c79W2OIQuM=; b=gVP9J6oqfqAQlJ1kE+02k/w6KFqd4oe6WUkmZgfcL5cjP
	Flv9fGo3A2J3ieS4Qa0fss5vp5rzh0rt11yOlJDcJt4mJL/f1bXfSKGeb/znyJDS
	kHiHF0c9N26S1QHWfxDJYBviMnc1u/LRCDsKCrPYqQlSLYjQ2Xc50ABb7L0uSKZk
	2ybzp0grLTuPCjRproBvFiH3qwe4V9z2O8hKBFuq1JIxVkLWvBo2DBcAYbHWDhnK
	SlFgHJxsR/q8mZ1KmjDGkJWxPkoMcp9WpewYmwsz7wpARliOhU0LwkvZGtwumq+O
	rsURKzNZFRNOTDOWHziDLo0A+OdTTZXhFQlBXZKPg==
From: virtiofs-bot@sinrega.org
Message-Id: <89334.122030312422800788@us-mta-495.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: Change options defaults
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This list compiles some proposed changes from default values.

Make default:
- [] `--inode-files-handles=fallback`
We could also take the opportunity to take a look at #20 deprecating `fallback` and changing it to: `best-effort`, `prefer`, `preferred`, etc.

- [] `--announce-submounts`


- [] `--no-killpriv-v2`


If you think there's something missing here, please add it.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/35

