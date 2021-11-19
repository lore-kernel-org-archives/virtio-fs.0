Date: Fri, 19 Nov 2021 08:51:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=732KAdVt4UaZuLnrxveRSSEmqu9A9HnCVavlQ
	vNOv9c=; b=qTs66xt53EQcwBECDPLXMY4ldzG8FiQCfN8ZbCHlVi2ZbrOFUvI6l
	a1DQVslaACqTIbh1iSLln49EpXDaFBTBA8OURF3NvAPnfQNrnNB0FsXiKOi2QD+s
	qrrih6QfrjGC7k/c05Xo7kgufA5DO4NB5DNWq41u0dqS8Aiczia1404p8CU6eeYy
	t9DVBTJTmXv0+pR+/iQQKUMjSA0CxJQO0jsaJ2BsQi7GmX5ZWm2qSt8xalSptRBr
	VO6D1YLtNiVe2AciUEwJbKB/2wCsAGby1lLDSp+zzQBcn34XrMdFAT9QrD+FM1if
	duu6EmW/9jBiwq6VnudT3bH2vc/hOGdIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=732KAdVt4UaZuLnrx
	veRSSEmqu9A9HnCVavlQvNOv9c=; b=g1fpaM1xZuM4hYisIKafGTXZlGGvjoYfw
	NQH0gGVp/FgZ45gQ42bT1uqyfhe9W4IqHop38UcT2OvuK3s9MSbDTT0q+Tppv77t
	sJcCzdS3kUUmqPrrneXzk0KV0FA4ai4l7PKPLVRNgoi/zrXQyv2ty3N0xGqxc9Gx
	+FKev31KnldBHMsY+qucUBZHYLW3v7DjYURL55LhuOf8XZMIkZ3TX+RZ2/MIbRJJ
	VO/UKhvef5qBrleWmFG5d6/XqqjPW86YreDy8EyvqYNopkO0xY4SjMM9I6aAHpZQ
	ls4WC799/S+TPEDigghPXnDv9Pg6rFUJn3dXR1hfjKMabNjTyXm8Q==
From: virtiofs-bot@sinrega.org
Message-Id: <90551.121111908514801531@us-mta-334.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Enable back descriptor-utils
	tests
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Create a temporary Queue with an avail ring added at the end of the
descriptors table to avoid using an internal vm-virtio API.

Fixes: https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/1
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/50

