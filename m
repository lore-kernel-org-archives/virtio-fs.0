Date: Tue, 28 Sep 2021 06:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=+1vG2P98+jIiSZEg/VXKJkTY4FinT365DEj+j
	rOGuRo=; b=vGNgn74GRE/X/32wT9YScHpSbFF4c2PSMMlQCV559dP5IPx26ArUo
	6vMKZKBTreaaDAmXcjNo8Ykr6ni/UBhLkmGg3iorzwyOMOnwJcETUCtPn2HUXDSv
	9VdGTHGSEqQxOKUyb2G83MWVgOnrox0cGTR8ZWonNC6dTWifOVZPrE8tkHmI/ZTt
	971sBWjQgwELIbZuSQ6IGqlVsJ0O6Rs01lK1OF0n9V/AQ1aDQX3voqWAi0YUr/WD
	elvQmxd9uOcN4Q7D1RuhqeWZzvh6EpcLVZ/wpZxwc99SDiHpIgkGPis18y71TXM/
	RkUYHlHxZAnNEWbEGpt2GPqDcr4LDSZew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+1vG2P98+jIiSZEg/
	VXKJkTY4FinT365DEj+jrOGuRo=; b=ToIc9oiXUE+d1Vk/TRawDMRDRmyZpL5D/
	MaG6l8SPUAr427eXbUJeNWndWL4hT9QU0oQcCDhT1rOBV2SLfwy47v2Gqyjf6DEc
	LIfzgzdvyMhPZvCQvHjskDZA48aIqDZfszQavZUA5IpbVvxOuE/tKfc4fEIZ3f4g
	6G4YsUtA7OVwrQM9rBaFqPPAOAkJge3c5auPkKKIOC0paHD97cIrsqn7vADfSr6C
	+bBTUlIq06wGUdh4iQtSiFqMNKz632TsW2oE8GYduB53LsU3XZszNrchPc3WeFDE
	VGDSU6+d2GjETCMgXRcv+0UrGLHcwHg8eYgAwHfFtrk2RNmLiG+uw==
From: virtiofs-bot@sinrega.org
Message-Id: <71370.121092806551400484@us-mta-470.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Add flags and options to be
	compatible with the C implementation (Part 2)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This is the second part of the MRs implementing command line compatibility with the C implementation (the first part is !37).

This series adds:

- --fd
- --socket-path
- --socket-group
- --rlimit-nofile

In addition to them, it also adds support for parsing options in legacy format (`-o`), allowing virtiofsd-rs to be used as a drop-in replacement for the C implementation (tested with libvirt).
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/39

