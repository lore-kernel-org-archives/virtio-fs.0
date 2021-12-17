Date: Fri, 17 Dec 2021 04:38:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=L6iK9Vwgb3ESHbXe7JL4H+mDtMpw35ouCk9Yk
	mHg/vs=; b=bYwEykLyUdavgrDhiOHuWA7FoPdqFUMMcg0ECb9OSi6edx5RP8xzP
	QL6m7LhOn1yhlKP7OMGK8azuTRGDKXksC8st6bYpL3rpTOvsKY+smIhw9FyFZyIr
	wcFyGYdtQ82pzu3W0lvubzYNEqYcEmPPhNiwJTKpcgpKlSSWfweM/CFWa/VF+Fcc
	Vlvi05TbidUozVWfVjRJhd3qadnyj8sgramO7f+EfHs0sKUz0wKqMwx8T3zGBb8v
	g+dRAGsWZSwPHae6SW39Az7iddZthDlxT33ITacGMZ8MTO9A/w6dgT5PLV0Z9uq9
	/ooLFbCE8PO5FseXKXjLBtO112L39bHiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=L6iK9Vwgb3ESHbXe7
	JL4H+mDtMpw35ouCk9YkmHg/vs=; b=PSOl48xnxfPFVZWI8CcOAbX0q1PV/Eps4
	Tyu8o9ePpH1NC921cC5u1cI12fcfAk3sSFe4zYlGKTJ02YhwW60XIFB0HRIKV97y
	nuJnuW9awK1SgVAHwXn6EBhrFjF1QBMbalnsCIjWtAwfX6at3m1d7gPJiqtCSZiA
	AbJq8losxOIf7uSQKGsfjQXVCUAj01f8Qm8CJ4mK8+/aVjxhJ9AWzhstCyI7Q1TP
	Wi4uaQKXWXAWqsJ+zuvAb5C/d0n4CS7b7JiFF+X8Htyl2ojCXxnVwKpEyJh95Aec
	pW1y59b8iJ6ip4CflXAJ9KaiblzGu/xf/mTJvp+QgD6V3J9NNdBkw==
From: virtiofs-bot@sinrega.org
Message-Id: <87060.121121704385500121@us-mta-653.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Display vhost-user Listener
	error messages
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If the socket creation fails, it shows only the error message instead of being mixed with rust errors.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/55

