Date: Wed, 22 Dec 2021 10:03:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=uyclnAp2bKKXKj1koGilOfgiUBCxXH5vVnYvf
	8RzbM4=; b=FNiFUjjzsBnZ0Ku4Ef79+WPdXKCg7blRNM8UwPFvIBayY7UVfT7yn
	LJDrTwxmCEMUmyJw+rOxTyQqryFqCbTDZggt354BM5vK07IX6o4174VUp3gkjb2z
	V/111H4ilb6SmLZSeweKQ+Fg4Lqxhv5UuqUyjL46WLwZXSwbxWqOHcB0QF68AHP5
	2MHjYz1SlYz609P0QX9XHaxaqsePur9tSKDYXN2doRlP3xZKd4eYcopoUeYbOEGu
	7uDvGuclxuYxeqzKyjeHdSX8OwJ1lyFl4E/Ju0GUR8iaUH4aP/CbVmk+0pbUiThS
	mGST1FpfXyejPVm7OcS2ZmqwH41A/s8hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uyclnAp2bKKXKj1ko
	GilOfgiUBCxXH5vVnYvf8RzbM4=; b=V2JtI6YW5ggFzV15aQMsmn+bDnSYm5qQn
	fd62hyx0plQ+iFjR/R9fzECJeMMnjwVmXvD/oVpVFl9rb9yagQinQ0odqB2qKJO4
	NIm4L+ks4+U9ypSPG9sErNgwOM0ysLdTv8SaiAJrvbgbIESwv0x0yLvuzcp2jK8h
	P9mojZZSJMjrh9WHNvyMAYw/zmTKxTSmB5XiUe470Ssp6Ismf8eNkSykqNbvIIcx
	I2KLab87GX6MxJeSfGezDmak+VMweNNQbi5o+3BclzKJb3yT4w0wfFn3bjv9oFpA
	66OUkMWJNDDj2fUvRwgIrGVur0X0Hmp9kyKDlq2NwVz6ocJRcEZ4Q==
From: virtiofs-bot@sinrega.org
Message-Id: <10643.121122210032100275@us-mta-277.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Add
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

