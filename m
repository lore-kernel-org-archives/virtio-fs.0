Date: Tue, 16 Nov 2021 12:02:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=LgmR2w6wgQ6JAe1OP/BQxoxSnZ7xjQnhicqIt
	yz92W0=; b=1f/dhg4puiyAbi/ai5iR7RKPsTwML4nbNMtrNCIyjWZv59p5+8quI
	dWbNEtWMUy2fQFBUAZlic0n7iYpz6zdx6elrt4JdFG72WEVdWPhrOzNmVXQX1qID
	inUbpZLqnHlQjQHx8Sit1vn3L92akMZO6DA3bqJz5mhZh5cvbqMPRZ/tzQ19+RpJ
	eimOac8HNZr3fVCF0dMM13jl8WSLeFFrc2BAeWZuBig3nWR/WLK1fmaqNlNUxzTA
	o6K1LENWBnS/wTmRo+IIkgyJDMG2BU/7uFzGkX4fsTBMlnkFwU0xMNueMeFTZ6c8
	fW5xsyzMmlfUrAV41iyVB3/ppOPkjeYWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LgmR2w6wgQ6JAe1OP
	/BQxoxSnZ7xjQnhicqItyz92W0=; b=YYcpsSlq/p4fPsUBHwlIWXQe52fSAhEh6
	Ga/yvVQEZnXueB1lv1ijaZQmZydYpEGMlVUVPRMf8CppaTg003EItqZiUezHTDyD
	TFmxjcg2T1rQZpidOXkIZGRMsvcVuDHlhfDEeV0iDT7d5UH7jkO1eoOHxJh0qtKg
	+blHwHeMyCts2QfPwgP10BtiN2+vfDAkqBs2d2fGYEGXx7sF1+3ZeZyoRdQ5Q5D/
	F7xiJLcFLEaWGBZDCchXomI+rxaeCBdwLVWLq4WDHyoWrsdLcofQC8XqH9+7f2s+
	5tWFErwq1rbCDGsKNMLVrM/poBwBObR6bZsLfh4l72s/6WVczKARw==
From: virtiofs-bot@sinrega.org
Message-Id: <84020.121111612015802197@us-mta-407.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Add vhost-user JSON file
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Add a JSON file as defined by QEMU's docs/interop/vhost-user.rst in
the "Backend program conventions" section.

This is expected to be installed in
$DATADIR/qemu/vhost-user/50-qemu-virtiofsd.json

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/47

