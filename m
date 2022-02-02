Date: Wed, 2 Feb 2022 05:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=YfQ3jHuT4anRvIT9bLEr17qP9f6pHnUyalQz/AAyFBE=; b=V
	xH0Wpx/pZk2SoLcg/0lTmyPxNSc81F77msyoUwwpPAtRidI3Dy8XhTFB7DQZzJJ2
	lqKuIHpL4O2ky95MyrywIFoEcOwhnL4OOk4yEDMq8GCNAXVLBnWusfKi5RMbG3/D
	1kHZ4IidSUPvPm2Y3cWEA6StBK0J+cvEfN7zw6lb4FhmKVejKh2bA1pzUV8yucam
	qKF0K0mv637wiCX4xnYlU+1N6Az9jQUomdXGd5b2Ze1/oFstijUWfN8sei6QFxc1
	exU7qErDtM3Z1XdNXxpTV1+66h7FgOPJceMyd6Rm0J0Dup7ioMRuOYvpDnJNp8U+
	+8C5jxr+6sse/idpatBSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=YfQ3jHuT4anRvIT9bLEr17qP9f6pH
	nUyalQz/AAyFBE=; b=BO0lLduh86sE7DtxJ9EHqlLZ2mR0WFmC1giHw4sadTY/w
	gfN9gI8dTNPcR/Zhhv1sFYtq80785nP+Bgvdnrbjyio+J39i/i2S5sE+8DNu4Uge
	bsQVXyW2orbbARXTY1J1VbGf//iZ0No7jJr+Zdy8wnpwkaVx+d8sVCuIiHEYoFZA
	Efx8ktHbf/HUYlrCezHYkpitJJgdyL4iB+T+NGivRG3vwJrZvdbkvZX099dL1pl3
	eDabLjcePqqxZZLnZsWvhnGOsGuxotvnv4jhQt99q2J93U7IiVo5juGywtQsntAM
	DexW11CKukx6waUTGejfbXYGw80fgLSRh8+VMtDLQ==
From: virtiofs-bot@sinrega.org
Message-Id: <97857.122020205370400139@us-mta-643.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Modify the list of enabled
	capabilities from the command line
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Add both the new '--modcaps=<modcaps>' and the legacy option '-o modcaps=<modcaps>'. Both options expect the same format, a ':' separated list of '(+|-)capability',  e.g., --modcaps=+sys_adm:-mknod

Requested by Kata
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/86

