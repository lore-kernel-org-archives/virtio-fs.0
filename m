Date: Tue, 18 Jan 2022 10:33:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=kbI1OlAUjMlcUPAhF+ItAkfIfJLcnUUzTBSg9
	tBSZzc=; b=u31e7zWkGuLEvkyvF1MbuaAWNOmHZErRI4fE40VJXJABPKiAfWr29
	aFZ8YYKeLbPtcMDgAmh4USw8EI8HK5ShTg+k7lUA+2Hq57huS+2O5aXsyd0zAVPb
	CYNIyCQvKLNCwy/dLFhO4ptpsyEqqR+AyywWoN5KBBni/n5+xexcgvEgw0LrwOWF
	1n7v42WF9uCsL9xN4CI5SPGwlAZSQ2gjgf/Q2Jsj2vdyYBc9BDPgLbPGWxHSkBlD
	HQc5E5kEb9WrNxol8XmpHzNALfjrPc4aCuMlT1ysFxhVgExegEBGri+eJmPmxV+Q
	c4ElDB2YJ7Y0L+Lz8VOne9FMlzYZshYAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kbI1OlAUjMlcUPAhF
	+ItAkfIfJLcnUUzTBSg9tBSZzc=; b=NIYSRDTS2fHDW+DmHoMtZwzGnrDlRsRiH
	xNEgqciDVOGg7uIwwVQRIfctGp3gFz5nlx60qXyCg9O71yhnRTyztDx2PIa0ad5V
	/Kj1rQOZvFk1kbvRMyThJmRhGDqvj+0V78yrumm0PuxrwgTlK4HG67SK78l7LdPQ
	LiJbFgD2BYB/V3ZLu2rZkgnLnr19xQPFMjhZBAPEWzPxl9Vr0ZH/0mgws+2wOIGL
	06uStgbBTRT4tJ0w1PewpB69b7WkDyt1/GI7Z6eLQVHBrvzygZ0W58/KmOuAZVe9
	OLvUGokcwTT/nhaxzzDJrB4bOOTk52Pb8cJBMK7KMc7vscz58s3YA==
From: virtiofs-bot@sinrega.org
Message-Id: <48936.122011810330800614@us-mta-520.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: xattrmap: Fix documentation for
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

