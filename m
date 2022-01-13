Date: Thu, 13 Jan 2022 09:54:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=uyclnAp2bKKXKj1koGilOfgiUBCxXH5vVnYvf
	8RzbM4=; b=OheBCv60KkB+wr3YXRAVhUwLxK2oWriG8kbjM8DMyBE7tTTc6zYtz
	p4WRElXO5QWrKovhVNmUon6shI1hcSL8Q4sFtVw/wHAGRoIRi2uwSMqYv2B5GKkt
	Zy3ZBK9Ge3so9ZCRf98qeXyxWr7ggX8qs/+1sDclvDKktIdhEBpctae5FFPDHNLL
	nkNzMRWfwDBociKQUlVjt3woAcjWe9Lsx/SA+3Yf0owFg0/NkoEE14zWKceRB7Oi
	amI2M8/svc8GDXZ8C4BpoDZXlptFu0HG6/ODLOw3qg4MyaNF/So01viSNUmctUNF
	w2wvBZYMGTpUvFdOS/8qF7tx0c2R9+uFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uyclnAp2bKKXKj1ko
	GilOfgiUBCxXH5vVnYvf8RzbM4=; b=mul4LsIC77Pnx55g5H9BOnleDi3rzIjUW
	4b/tDXp+0QLVl37EVNbmz6P+M7sSa8lU7Cm6OycClmbY2lqYhkkjNLjnnN9I2HMR
	zo0ZdfZzEtclhj0jslbJURgOkYQe1V7q4B6FgCBXrsgOfcJoKtJfcr1MT8UfER9R
	HTdjDRQjEL4WjpW7+YjQdJrPuMAqrBSrBUINbpzA6QCcuz0E3UCFgQED9u1mIOt6
	qthviA2AKQa0CMNVqHV8LXIgUeHCpYErrJoyABMEkeOIr9xa2hStz26zW/3t3hrK
	qjRROcDmqTPPep0Vntue1x7QpLMf1/laIb9Juc0uzCl0GZ5SmFyLw==
From: virtiofs-bot@sinrega.org
Message-Id: <15754.122011309541102036@us-mta-556.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Add
	--inode-file-handles=mandatory
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

In this mode, we never fall back to opening an `O_PATH` file descriptor to keep in our `InodeData` objects, but instead return all `name_to_handle_at()` errors to the guest.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/59

