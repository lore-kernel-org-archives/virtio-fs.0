DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=Z+yRq1r/td9CSNOBf3aqw
	KTxRf75BfHjSd9P+9sdY9s=; b=jIoHT+3Bxvxy7oZZGfWly3cKZLtA8xGRY3gvK
	DnQKANluL2CiX0MbS/wwIEJ9jBmTxVCHyCj4fs6SJ0PmtdYu9JbXyQXO/FEky1Cg
	B9xzEvnk/wEjdK6KzM41lNhDCmlM7sgxom5QbHalS7ea6wy1lw2Dxs4iIQXSQmvg
	oanYdd7JC/6g/gkdipcWiDWyIa/LMbHtSl1Ew0XZKkQGb4Ouj1+EQA98/CfWH2G9
	QB+6gShDKWqJXZS1mAGpFfmBiQrGhg75LcuPyU/R3ZDQed3qCT6x+k2j4Hw11YLN
	Oouwn/SgKRZJDrP1vTiVMpG8VUGu654wyNIwduuCbjl5IferQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=Z+yRq1r/td9CSNOBf3aqwKTxRf75BfHjSd9P+9sdY9s=; b=Dg6Ggmzh
	S/UYndPBCe+MQZtPtdFEWO5wNWwrWCGR6mSS7o7tcxyyMxktxrmW7wxEevbyJutE
	Fqs8GoFE3hi3W/Yo8weHCUk3YUcALqGvB7kwpex/JiqPOjv7jwwh9O2tYaGX6v+i
	BneaGOUjv/SFMP393bcDzRf5xy5pZetVMRPvHBbCZKNz9T/C2s/TbOHAAztivjjn
	VcTnTFU39QY0sf3PmEgo15avkPvjTViDNNeRSdf5U0qtuDM1eUO8WDW6HuTU061/
	lZoHXjO1QUQ8fneQUqg1a/cSu4pWsYLPRYQUPg/VKt80F/g1XrNDQqCvFiFWkP1C
	OTVhGJpCZnzxYg==
Message-Id: <20210405123403.1ED0124005C@mailuser.nyi.internal>
Date: Mon,  5 Apr 2021 08:34:03 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue closed: Implement xattr name
	mappings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtiofs-bot@sinrega.org

This is present in the C implementation, and allows the user of virtiofsd to define a fairly flexible mapping from the view of the xattr names the host fs has and the ones that the guest sees.

https://www.redhat.com/archives/virtio-fs/2020-August/msg00112.html
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/3

