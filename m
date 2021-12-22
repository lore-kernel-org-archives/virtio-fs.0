Date: Wed, 22 Dec 2021 10:49:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=kU3/S1wBB/cWgoD/uW6jU+t5V+y2jpGBZvrqG
	IGtq+o=; b=bwyOdo+N2j9Zu0HyHmVZKyyFeUiWvBNykgLDUVtY6pMpnBM2ozymo
	9HY3SusdE99Bf8Xgcyqj+9akMPDXpkwX1yujjSyilfyhsBJXqysYnrmkxm3fUefv
	mbR1e3YqYPngLeEExbk7kRQ4fzt0XDjEHPKD3CSdgDmfNwIuxUEY6tiCtzfnxgxm
	hMfIOP1XM3byiioHO2aDQ5ADbPEzXtRhIaj04hGdzUTEw7j7l+bwpYJB3Icp7z3L
	B26Fi5hr7HPfzetZgSVk5qFgsQdX6csQiRtwb3Q3NHyjk3bHlHe54I4r8pwL5L71
	+sIRSP7cUPoxq6hSpMOJ3HuNR38U2QNZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kU3/S1wBB/cWgoD/u
	W6jU+t5V+y2jpGBZvrqGIGtq+o=; b=mP3qGfzatAC+TTS7Gi1SSEXd4agxHkORT
	dtJD/Qjq2cWx6VtG6V0jTQHuadTRAZCHa1+ju7zujOY1MVQwVw4GHlWYT3MpCfKK
	C6rIepi2cDrMsjz18fdRl/dxaNX+PKOCEzIHMsOELqVuiB70rFZG2l355CKCZUS6
	4+LpijY4zh14nb8tHxR63/8OeTDyCt+Pugkfh1UL7FgLXsLWVi94+Nt1aDQAyPkt
	a2KQzgYTKyKdoh8XfoUI75TJCGaoQPAwcOnCAZBfr/PE76qR4wQv0q3OkejKxTJZ
	a6cJiHgNvJdL8yEgRZdg866o1Egd2GOeTQx4RUKAkXJbtC+Ti3mzQ==
From: virtiofs-bot@sinrega.org
Message-Id: <77024.121122210493600267@us-mta-352.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR closed: Set up the stage for v1.0.0
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
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/56

