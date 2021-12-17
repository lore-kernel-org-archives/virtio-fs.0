Date: Fri, 17 Dec 2021 05:19:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=kU3/S1wBB/cWgoD/uW6jU+t5V+y2jpGBZvrqG
	IGtq+o=; b=D9qRQz/lWWRzMFLULvPhkFR5zRs+c64hY9+nkJ0/4REMmDPInn8RE
	6WSUhS6tBfj/thxPSoWK3M8dVMx90EtDNF8l+FXyTHawDzAee69zzuQiuLgI4kdM
	WrTww9Kbn0G0OOO35AMgEPxB5PgoHJ3IMrFrmBRmjNPvdrPhRafY8WwHgTRWXsmL
	c7Qbhma3oACGiwEXl44UyFI6XkSPPRkQ8udSlZgPTc9GsPuK+vr5fmjxzBvHrT1a
	p8ncDs76BfFdQpiA3UgQjIR1m9kOtJXyKxJEk06v9o42Q1EWGSy+lHNIRuYiZ4RI
	ki6njyukVrRgDVkGZ1dbQhcErKnKP5PEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kU3/S1wBB/cWgoD/u
	W6jU+t5V+y2jpGBZvrqGIGtq+o=; b=PK5hTbDCZsxo3h5FZhFkZQvGdlYtc05f2
	+zUIJUwVMf6dO8AKANzahb4orrdbASaz5WvcA3L62gDiQjk4ah4hSG2yTSRkwIzL
	340IewGF9Xv+riH6HmEtq6R8Ml75ugNhb5AZbDJdhc9yn1P6P26kQskEew2NZxVJ
	8d85b+loTVfQGIeds5OV+xAGYiZ0+knS8DPUo4SbkjRd/a58FOwfCxXB4ez0h9J1
	OgvuCykMq8Xxs9PgRq7/5T6jov7y4wtXBpr4mv6g9+2youpdMOw/ZyLI1d0JIOay
	bzlBCJNmwVgSSu4GRvr7uIAv/iUOPGg0pEyqx59xnLUWm+j7FaVdw==
From: virtiofs-bot@sinrega.org
Message-Id: <52877.121121705190000355@us-mta-249.us.mimecast.lan>
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
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/56

