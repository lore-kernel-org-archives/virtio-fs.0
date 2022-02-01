Date: Tue, 1 Feb 2022 14:23:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=ZI81X4/TWyT7gKBVcaPspbS8RjY5KhiTz2OIXcJMIAQ=; b=j
	mpAAjQh8xPG9n6Z11WLGdNGlP2QCNKBCN8nNK1qLCHSl98tXKyaQKpiY1y61/Fs1
	zTRu9jeDukJ3yxsf688AtyCsbupe0NxVzXlh4zyzoTijsfrelAzpHfxygNF+n//i
	/ibsBH/M17B51XeP1m1cW2KGFBBTPsJsrLav9I9XoXLNiU84as5EU8wV4gef7gnk
	2nNhusC8CdG9dppR0ioETmSSpSh/Qu+/5TjYex0ZBX50CeEBeaKa6SZwj2aeC7lk
	99k2c5qSueGy95pZFucZqSgROWGFpQkbFLvEHad+xvql7Vyl6lQVFeGCECgZHhN+
	8VIEx/rK5glm0EclRD/4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=ZI81X4/TWyT7gKBVcaPspbS8RjY5K
	hiTz2OIXcJMIAQ=; b=ex44ZKja5kfU5X+RHdR9w1sD3DQdXSHqbeKEHncZxcHKZ
	6E9JQ2vyNkekR3gTly3n0+ungQ9nVEcC6lVp/1fAlM7zXtHQetwcV1oxPRCcg9aA
	tRiq8n3V/dRsEta6pxYQGo60lVwKKxp5oIKlqpirrYR45Kwn6EU7UXohWWx7/xB1
	e/qvsf02E7LjheZIrpqCPKqcaWtEKD5d7KbSSCjGnEqzP89F3rvQu7PMD5LcDl2f
	czAIKty4AgEK2Gwcqgi9IBheddwc6Ea1n9LWRWfzyj2YPjBi/V/xU3qXTyIPygKa
	mhUW2/Wx/7A0bKyfdk+exOyrcxJ/11iTv5SEVZ29g==
From: virtiofs-bot@sinrega.org
Message-Id: <11295.122020114234200511@us-mta-614.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: vhost_user_backend: Skip locking
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

