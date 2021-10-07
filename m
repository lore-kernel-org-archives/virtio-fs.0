Date: Thu, 7 Oct 2021 09:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=+1vG2P98+jIiSZEg/VXKJkTY4FinT365DEj+j
	rOGuRo=; b=bf2UHrTfnZj20K1XvbaonqhMWo9sIpSHrpSwPhK6VTJCQ15efvPSq
	bh96X6SA5S0eLiQwWJw6qEMlOWWUHiO/LBwIDFJxQypkTLYPYzeM7qRHvnTLJEF/
	Gga1p2wqC8fXQKIVy1vN/l55NJmwQXpC4DTDHaIh0G4wF0JtICkQBESPfaykZpM0
	5NAdWKe9h8/pbM2pixkreRTvMQCn2AeV11y8YRLQ2cS9IK/Wv6hn7MSYBNIXjeMy
	f3bxdl0TJ8fRW88x2eliABGc9I2SnNOXF210HZLsb8GQPvRFk0E52tGl8zkP6AXf
	RDN8+UZ9vWQUcomhDuNmVruob9X5Xl9/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+1vG2P98+jIiSZEg/
	VXKJkTY4FinT365DEj+jrOGuRo=; b=JP4y1dW3kHuxQcr8yE77PXHWTWrtCAY4J
	fh8UD3dPPbrwP6Uiyi5nfesQZPfvBdfluVdid6f5rhD+uovV2p5GzFFSzQlZhUBx
	t8cU6S0hVwmZ70Kjtj+bvMj6ER/zFgCdeDMRelMAQRrqwWlhP+UruNoXHRkFVAwQ
	toNMFPZ6eZiqyygoSXWhsnMobHRPNZTU4OVbnGi3zGtuxFb1/dQXdCIPflK/2MqZ
	90cf66FK/p9VXjU/nPEsEKzbN5Yzqcb4YbZBRR9EEZxlafqLo/ZpnMC6yp0nL+9z
	1/80SItmt+AZce3QC28QhwQDPqHmpkV6okGdvwcNKw8LExoueUQMw==
From: virtiofs-bot@sinrega.org
Message-Id: <44967.121100709171001330@us-mta-555.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Add flags and options to be
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

