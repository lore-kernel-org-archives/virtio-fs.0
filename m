Date: Thu, 13 Jan 2022 17:24:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=IuX8I5uGotGaW6alnNeBaE8TFP6c3JcujBnsx
	92TkSs=; b=fVWWfQ7UKSPozUO8hjlPf/t2/eT4wr5YlbjlFXETtuD+ODvLghFkc
	1taSKB2kWK1wVnNg2zfQYqMTN/T8sjcGxMK1ciLPDun8xGpqywP9BchWnCFaN574
	2vRZ26QqZqtWwCrwYrMa6RR7rllLBxm4HzbyMnOkCuqSxAhI1qPWPpzEG3TXm6Du
	i6mFuge2QeQHWvUwE7m8wi4gIQgTjJ2tlubzMgYiHtT0tgJqx41ajshfW1w+q6Tg
	rMCpJnktspwLgOzxxGdNcMUb1WHBG2meM8JdcIv8JalqwGNzpckHueUUrLktJXcO
	SYJmDOimUBktYon+zU20h2iWQL80+3PQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=IuX8I5uGotGaW6aln
	NeBaE8TFP6c3JcujBnsx92TkSs=; b=e8z1WXvbmM+kBecS7agkSznHBL4c1akH/
	Yzu3KiwbIqia93jfAxkLjGCUI/003zTlu9amzQbgUHIzDEIoDOuwE8Bnc80NuZz/
	biRCEOiylsMYFTqx0thAJvucIooRoz4J4JmQQMVaNDLSeljbxckYktWjS5GfE0LL
	6YED4sG/iNtkykhWr0O4Owwz51OtFh637H8eDbBJiqzZAXocBNPmli8ggTuCVy+5
	k79YHEltKXmiJ0OLQ2DfAW26LVaSFjTzXLkYmg0wy8UYK9MflAQAJZQ43pIfsLcr
	iawYhR/vcQx2jbcekYYICOKLR2QyO1QezfXdhuup9SCymT9L4lPxQ==
From: virtiofs-bot@sinrega.org
Message-Id: <65456.122011317243300115@us-mta-82.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: sandbox: Propagate exit code
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

