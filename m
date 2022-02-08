Date: Tue, 8 Feb 2022 06:16:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=Umuz9zo9JPjjDVTTBTp6L5Qasav+OGPqLaff996ZPEU=; b=l
	tgrR3N3dz4O7k7XqjUZTyCw1IvLqn4A/G1CorAkwVkGY8Nf0JYOokf9perAAmXBM
	4l/21sWleCpwoRw2B8PKHdWgJNQ7CnjsSDZD5VCOdt31Tq51icf0Deper6AO/zMu
	hnGdT3RD4s6EdST5oyLcyU7jh1Np9TXW+Q5pzmxaRjQ+9fdhmdMYqy0pB2+nL4/t
	CXo8s0Iz++ZWgapvjwhXnUPcjJQIrwOdZiGLVvtvHgi5cKaDFtOo/eO0ftWPYNaU
	fRUdpcRvsu8IL9m3UrIxRoCr65WMrHJ7O7i0o2lpCR6BmVSzEK62Upjciz1bXqwd
	v3YwETiPDKHMgdtfFozOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=Umuz9zo9JPjjDVTTBTp6L5Qasav+O
	GPqLaff996ZPEU=; b=FljyhuNSJldlygKXtC5RpJMWtUmp63FE6pdR4QHsrhQp1
	28KCxXb0HnXrJLD9g7DmjxIMmqUTuxMHVNw1NeyC7qMMcQ+gz6Q+D6Z3g4t3kjEM
	oktN1Awa0CMFqYoK3D2r5jjFJOhIyuc0mh/PVfgtBR7w8zBEbR8RWP6DvLDhGkwM
	UoS5EJMF6whHf4qaXnjy5HEJqgoFkJyvxJzsqMkbV1lK3i1lxE1Y7fI6yN19A/CI
	Czb+BKM/2hPeZO2Q3v79zy1HSYxCF0nVdK93gMKczDulneZqRmp2IV/cBPxMFRDl
	qzgGRweck5zPCbcSd27uG25Jz2Cyr1G9VAOLtPevg==
From: virtiofs-bot@sinrega.org
Message-Id: <71727.122020806163300649@us-mta-247.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: vhost_user_backend: Remove
	nested RwLock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Implement `VhostUserBackend` instead of `VhostUserBackendMut`, in
order to avoid having a nested `RwLock`.  When using
`VhostUserBackendMut`, it needs to be wrapped in an `RwLock` (or
`Mutex`) which doesn't make sense, because our implementation uses
its own `Mutex` for synchronization.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/91

