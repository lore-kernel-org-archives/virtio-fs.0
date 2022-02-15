Date: Mon, 14 Feb 2022 23:36:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=exUQdWHvPMu7uFYugGEtRnewWvfsZ5mDZSmxoB0O474=; b=o
	0txmr+MUXSK/ffBt6nGkw5ElCgpzgFYe42a0h2nhrR6hVP0kylC+fvO2MZYtwJUF
	AV6UB7JQcaqkBUVX/u4/N/x4CEw/p4JqYAWJ1lC+v+uHl5jbr7F1KqOjRVRNKX8F
	rBYkkydlDywE7hRW6csyUi1oqafJgKHuCHjZh4FhoHxI20/htU5oY8t4AhNU8heW
	akmdbbiVd3baqlfFAe1BeKFXAKdqa+cVc+wUKoQp4llIg1cyY/zBXgXmGny0v0od
	rSTKi83fPgJiGgGt5D5QbNlW3nDiKSTNg1GpgCgRAqQLN9DvzKl98vdFV5CLkTma
	mxOQHk3f3cciYrvRtUQUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=exUQdWHvPMu7uFYugGEtRnewWvfsZ
	5mDZSmxoB0O474=; b=dmzPNvzRUfclOK5qdbCbJW/8DnaDNMhKzKp2iGGKVP7xB
	LOr6AjJcpD4RSlzdzbSZSpxShOSWgP8ZTyB9gBBWzf3B5AKcxUPpYymJICVZhNrq
	q0IPyNdi9OXM6jcxsiMVXaogUS5ThQaUAGfC5zK/Xy2Xw7/yp10fN2vOJHcaQdSu
	GdVb2URM5aFCCO0pcHMQl24FxDFjg50G+4z2EN2+uUNzBXGx9+pqY5s8zm+tRB1J
	kvIqmULlI/7j1mkz1abCM8nFbhTrvGoZRHfQlNR2hjfyda5W/jrqfKEBaqDmDWi9
	FowJcaGKsKdg01W7vSko6/MZro/AyxW+uGdtlWAVw==
From: virtiofs-bot@sinrega.org
Message-Id: <99228.122021423364700249@us-mta-450.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: Feature request: Ensure
	virtiofsd will build and work on windows
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

My limited undersanding is that, virtiofsd reduces latency by allowing the DAX supporting guest-kernel, which is mounting a  virtiofs, to negotiate some shared host-memory, reuse the host-kernels paging without having to do a second level of paging . 
virtiofsd provides host-pages of read files directly to the guest via iomap.

Filing this bug to 
- document the obstacles that hinder bringing the feature to Windows/Mac 
- and track the progress of the development of feature, if and when it happens.

Windows build of qemu, also does not yet support virtiofsd. So In qemu-project, I have filed 
https://gitlab.com/qemu-project/qemu/-/issues/623
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/29

