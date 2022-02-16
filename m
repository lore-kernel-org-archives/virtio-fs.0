Date: Wed, 16 Feb 2022 12:37:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=/WeDeqWb8vGhDA/ScTvKBpzrgSLnmXlQZycmrV4q7L4=; b=h
	xj/SoPGVuf5gO3wvW4y11deoWbW/GWKgANaSA0ABP04hvNFH00c1Yzd1f633xnUy
	o4izTGYRm6+Oj7wiuYnAQMWXuLlRMqH20oMo8M+PNJHwfi39NFm4icXqXilXcusm
	YY55BALqvLsxP0Dns1GYT/xgqH3+kD2g8R4u8FNM67PZamY4zF4Pp06f5dpDaOR5
	a9oXg+SmdTFmcXF/HSo9mUcy/zSbnoJSBJZ6L6FScmVrikssE+YJHYfW/1gwGCYT
	eyQIVvE0c3DrcNjZPIdt1ZJiR08QgvjYSvQ3oJBtwayJS8Xk+oHffJVXPqyV03db
	zybQjcoAF2L1rj+2ea5ZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=/WeDeqWb8vGhDA/ScTvKBpzrgSLnm
	XlQZycmrV4q7L4=; b=Q2ufqBgpxFtabN/cwKp+A9ueHmJhxMr355Xcbfo8c7PFM
	L/J5dU9fmozSTN4pcRyRIw0XgtakGqoFazHuv02F5bIFWglqU2aw3tElUdUS+kFV
	ghOMwySYzZ8r7FV/OMfTvAm39R5OiQitxaDn473WzkXS0ti2s4bKZysbSRL2l7xd
	I43ZKTPnKTIUEOgLeSz2/MAI8Ph43ww+dHIg+nu2XGZIUWV4X4OVJR1HiXSc2yMe
	E0RLLmujRW380Jm2Q0SKf3XkDuVea3GR2NXTuCCpRwxzk+zj9HevW5RM4lgT86j6
	tHBIT0OrEGbGKY7uqOI7qlGbPQh4Zm4v9msi6nJDw==
From: virtiofs-bot@sinrega.org
Message-Id: <04825.122021612374700958@us-mta-378.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue closed: Indicate an error if child
	gets killed by SIGSYS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, if the child gets killed by SIGSYS, the parent indicates no error.

Q: Should this be a logged error, or non-zero exit code, or both? Currently none of that happens.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/21

