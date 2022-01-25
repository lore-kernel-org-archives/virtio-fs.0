Date: Tue, 25 Jan 2022 13:22:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=l5g4pOhpRE3eIUSF1Dn4OMZ1nPBJxZOs8DmV35PrJE4=; b=0
	9ee2rMQtUjlw4aNdvZTpAEDCr/+Z9Z7Vd5qIIEQsEgJAvM4epwkf4taWAQZsErst
	aGPA7BN6N3+zoM65th5suUTRSgPA1XnD1l6wlnxL7nWBeu7Jw9xPpxWRIoiz+BB3
	kZeeS5BCpoHnVMrGoU5ZO2eZkXCL/vASiLsUctFAiXlBfoykXn38FKsm9RL3wmVG
	6gKdk2cUNEOHDZc//VaKXNAIzsfjNHtDzsjkv+HT4weOPnvCIeoUOWUgTj1pXhnt
	l6mnKtKGbQ7D3/EQ9JeF6cHyol83X6d4wIPIqonilrOKGlCdJuvFSZR8Aq6sI4CQ
	84e0soTM78x4QGYBjt+hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=l5g4pOhpRE3eIUSF1Dn4OMZ1nPBJx
	ZOs8DmV35PrJE4=; b=oEd26vBQ5EEbaeUFbTMp2UDIMWxAzK1gfcnE35wzQTCt/
	9a1SBHvHs3K8yVH4eOvEYMYKu4ZFjATD5jP/r/6Dr7FWtnjZuwDiA/iNr0u5GiSs
	CKZwecticOY+4Cex+LFqvfeqsYBPKcpqJlmBltpiwMkJ7iE9ujLlmwUHlaP0TPnQ
	SMO/BpNEWxb/SKPRKqA0CMbOpdP92rg6qNZ3yeKmkgZdfLFh9SkRIpfzH06bgkMP
	Vorzb69NweKEMiUlOpvnlZ486yyeeFBncL5AB3nl+OXjiyLyW7bLrWY4JtF8+uNv
	1vsxiBcqf1PeNbWaWL23eL4IlEmuE6yX52TYDlL0g==
From: virtiofs-bot@sinrega.org
Message-Id: <41158.122012513221000985@us-mta-539.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: passthrough: Move some functions
	to new util module
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This prevents cyclic dependencies in another MR I'm planning.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/76

