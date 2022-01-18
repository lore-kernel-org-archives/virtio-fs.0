Date: Tue, 18 Jan 2022 02:03:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=IuX8I5uGotGaW6alnNeBaE8TFP6c3JcujBnsx
	92TkSs=; b=rtuqNvftQOSp/WKf9QCx3dSLhv8/ZJitIMmRT0wv+eVf/EPfzDhWv
	8NaW0x5zGiKr9u6I6bKMsSZX+2hfgq8YNiOdmxKnkRvMv/kOaZkOzGSyb4hyrMMO
	cNSe/GKULQ2aqSj/Pij90srYu8Ob/MPs89dou4lfQpasrPX0azwKeplAczr80b3j
	d+qK0Uu+QBIUqlUJTdIN7q92OBPB/4QzKHY/hCCw2x5V4A/3rHHNeOcR8bPiZ3Ro
	em/J+GW4Zmtw/3fIdXe8JqE087quPfyyGHvSK9n9zeHOkGjcDMIjqvBVeZNAdWJL
	0JnKaJKLvKJvNgwoiKcN/HPU2RJBhUvHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=IuX8I5uGotGaW6aln
	NeBaE8TFP6c3JcujBnsx92TkSs=; b=Yc04gagPeFYpj01c1jvJvRFFV2ov2evfc
	8P597Eh6VvZlgGKDnDgRTuFIzy8OQpyBX98581P2RqeVi/4CZ0+2QI21tVBQQLWp
	+PlP9KL8TpazZcI90dIQerGuYrdgNbSXSnQP0EwhPBzriuxeSzxVG7BWSzGZetYm
	dd3vturrTXnbnyOcVHc4NJZqqbunOQFVFRYz442BN3nCip50B9dNpkadEu8D+9SI
	o2OJH7Nx2LJBpRsgmtNRNQaSdYifJlb5nheeB3CPyC1MIRUYOLtHXOXGxILCNebC
	CvkfrKQtStQrTGn1WcgA+cCpmxeEDvH8UkvXozbnf53uWlTLx4/FA==
From: virtiofs-bot@sinrega.org
Message-Id: <88229.122011802033300614@us-mta-644.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: sandbox: Propagate exit code
	from child to parent
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fixes: #10
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/64

