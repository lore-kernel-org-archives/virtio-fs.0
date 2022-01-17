Date: Mon, 17 Jan 2022 14:27:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=deWDvRE9zBviBqLcfJqbIozpd3JETRMy78nyB
	Mf2bA4=; b=GA97f6HTnriDseC99Ej6wReYaE7YKEQfRTmhc9nwPaSCHftL+V1uw
	hM8bGxINn/n1BpRU7/W9nhN/t1XQdG6ShabH/mEKxFxIk3XwDIOsCpnS1kPS23pE
	TG/sE3H19Kk7+xZasndJwuf+qHsUE+vBikLlOWPWgLu2cT4RSwEdlkD6ThnxkS2N
	b47qAUBned3n68nx8yoq84QJmnY8pWfXe6wGSvljmM+reOnmHSv9J7r8DTUUKqV4
	SrSPVnj46tQH4KuKmIdyiTjtECpFuLreLhm/SCTQ37XZ9iVAO2eWrqqta8HXaBKI
	K5SG9SIEBqO6CE3JhGyR8kJ83Q4gVlzsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=deWDvRE9zBviBqLcf
	JqbIozpd3JETRMy78nyBMf2bA4=; b=TKTuxXHVfcA4K8dOV69cyahGCJ3TcaHPR
	Pkm0ID4/gJmQ9kS3Ok1fgn2kczTDJGe0Rm5BGSuSDZyouVPLWiauN7cygkQ89Tid
	OoLzCfk2F0NUPg9tVoulpV77mlVKIi4W83aC81I9FdZTLsB4kpeQzYV2BuqBTt51
	01GFXzB0JgB5DrS3852cv0REF6tJ0TJYLMANMGPkKWwbXNeTYm/y+pHv9YnnIyd8
	QvYUu45SKljnpk+HIW6NVBOdxqhjxoIHT/CKHIHoddhsgd5xkXZQ6oQElLH9jzf0
	sPZf+CW8eMQEgJ3cb7TrpDA8RsLZx1koTybLU0Dg8j2+sGY2ibn5g==
From: virtiofs-bot@sinrega.org
Message-Id: <44077.122011714270300809@us-mta-651.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: mount_fd: Use RAII for MountFd
	reference counting
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This commit moves `MountFd` and `MountFds` into a separate crate
and introduces a new type `MountFdRef` that is a strong reference
to a `MountFd`.  `MountFdRef` uses RAII in order to correctly
mutate the refcount of the referenced `MountFd`.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/70

