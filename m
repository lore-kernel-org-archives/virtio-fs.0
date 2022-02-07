Date: Mon, 7 Feb 2022 08:49:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=ZvZ3/bYahGFKALj+fwBTkdayjGWkADtJvL0lYQ/9FUk=; b=0
	aXzIhpsXf5HmkuOZGFzPDglIZ+uB0GKXRU5mQ15lJEoneo7VJkeIxGnsmALH0OWq
	ZrWkDkL57rJjxVpLyIQWs02M3w0nOp/abAlHh3wRXFmMLYbydbfITNlmzmjMa1Ln
	tdaYeC477xXvDr0JQsB6uuzcdi61EAvywbAYTMcuD66gie6iMa22wyqL9KArdI7S
	b1yOeDjZxkguP2UDqiVgVMBQhJ/XPRE3Uws0yFNL0zXfCbHxKVZszPop5RkMaWUQ
	ujYjLV4VYbjf5KHKoNs+wG05NQLjbKw8wv6p38HveRCxx44YmAKonqc5Hlgm1Vme
	lGlAt0r+91DPn5c2VXGfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=ZvZ3/bYahGFKALj+fwBTkdayjGWkA
	DtJvL0lYQ/9FUk=; b=SzogY0PIVZsMOoh5sK2trJWmvQXNVYF/mkVZxuusLgLJ8
	2OPR0JTlHgPK/KKAVaIeIiSshMeN+4irS7lEF/XsNsD59Cw0nT4ytYXpNnmGi900
	fasF6/E6sK1fsG5KIIVS+y0e2vb05uVl5m3uLF45kDSqQDeKoMZOaLh4SqOuOcCb
	MGFcCm5VshAKkmPaz+zoZcyp+Q3+byeMZxwLh9JPNoo+jzeEzeGvrgVsnDh0B4xC
	V+JBPIYnYAJSrwAC+T9qCTssFQPeZGvqAU4iWUSdnjsAqIoK9kyfUalq1hyR+YXs
	PYX1BCoCpoavXduzVVRQS5sHOvnXdf1SOyu9ZbMew==
From: virtiofs-bot@sinrega.org
Message-Id: <34449.122020708493601035@us-mta-147.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: process_queue_pool: Only acquire
	the VringMutex lock once
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Previously, the worker task in `process_queue_pool()` called
up to 3 functions on `worker_vring` where each function is a
wrapper that first locks the mutex.  This is unneccessary
congestion.  We fix this by locking the mutex once.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/87

