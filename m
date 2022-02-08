Date: Tue, 8 Feb 2022 11:15:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=ZI81X4/TWyT7gKBVcaPspbS8RjY5KhiTz2OIXcJMIAQ=; b=Q
	ErZqB/3AUTS1w+T6KARicuI1L1cLm8OBb6dkJ6wGTY1DB/y61tC4YR9ClyHNgNai
	ykTkKxSSetG15mCTQafnilQ3eSmkhR4J9G97Hf0uvJuhxFgv4kisOUNuvHEX7oEh
	aX/N0PsPSi/hxScDNsHXOAWp1svGKB2paGLSNiW7oHMkDV07SBaT5wPj17ukjr2t
	9iamAQx83yXJhmqXp/IpO0KpQ5SHVSgBERc5fDqAMCAfsEZGzHBAAuE5/ozLdslx
	p096ePCUZ3NlDd4sx3pLZCtvg8G8wo51J/W4wlXLv/L2sUDoySVgGT+9eDnJ3sMs
	SVseO5VtADrtabwW1DI1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=ZI81X4/TWyT7gKBVcaPspbS8RjY5K
	hiTz2OIXcJMIAQ=; b=YYgq8GqxT/vZKrHw6rerZn9cVv+xg8WEqVBAlBa7NxhZf
	u3CRrhZca46JLTL1/V6yMoU7rOKV5hwTaKe8/dP3re62YK9KDfsUmXcDJ3HTQ6XU
	/IOyIDI+ZkiVCKQgZ3wghijMcwcD4yvbZd1csrRi/CoT9Jck0UjbNbl0M9EFerlX
	orUt3NHz3TOqoWu0GbJm8YZYdR0L1028jHuhhPVZbF0hTbm4Ibq4dxpZxKGNc+Ed
	K2WbQKIMGPCiXqA4ai/7wMo5xOcSwyH1Wfs5oRGY1clsuD0jWNtnPZfTHU5wUlG9
	aNbu+rGBVj/p6FD9yK9v9aqNYO7okjHLOfsW26CFw==
From: virtiofs-bot@sinrega.org
Message-Id: <86900.122020811145705816@us-mta-625.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR closed: vhost_user_backend: Skip locking
	if we have exclusive reference
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If we have an exclusive reference to the
`Mutex<VhostUserFsThread<F>>`, then we don't need to lock it.
Instead we can use `.get_mut()`.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/83

