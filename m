Date: Mon, 17 Jan 2022 06:57:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=NgebdAXy7uyUtUGIPY66WWXlD6XOvxPHZgmhI
	8H+cpQ=; b=imp+6xKvW2YI65oxK0lpR9EuKKrwuI+foesIie4CuQJFFg5FBEw6V
	8Zw//5ntjeTndY9e9jh4ANx+DHg3a8DP9DpODdsoC7zGlEieehZft+xYtctl+yeH
	DBLhHZZl3mmMPQGuhD/C6a6TPKBc64JOGDhr3vZ40hZZ+I1wOwspc6mjmSqtwWNL
	KPY4jnuOyAgYYM+fpK4MOIIWatVbkPvfj3/8ejYkjHlFc6jKfcHqEYWjqXctNyFF
	LHsEg6R7RVjAeCyhHuGqsb8QO5hRTS+7mnB/AWyFtvX3/uorp7yJF7vaVx7LkNtT
	SuZxWGv1ca2jRb3IzC8ZiGUSXSFORqNqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NgebdAXy7uyUtUGIP
	Y66WWXlD6XOvxPHZgmhI8H+cpQ=; b=jANqCW11C7xc2lANSsOl3yQyjqOJIjInJ
	5emM5/xLoeiztiK7M7IGUKuERLZKUDcgf78C3HPOQzy+j5kFUwHruoQJlk1Gx6r+
	exVLMEnVV5FX1HpbPYV2Tt9UNGTeIxg7E7utsCnwwKC8MF32xMZ0HxERZdidlPaE
	nFAXvTyYCBVHx0fvEmYwqDhLTU8D4ZI1BZSpqJauff9dDWRQmZ3E8DR92SOEyXjX
	EM2drjx531HoaopvbKrllLiowzeQ5XYW7KO9Do6IWgW68fx7LSJMiiyL80hi2EsC
	7knX0ofSUflCegaveqjHNHPsHxC1NR534/4bzdcqgojYkz92WdUGQ==
From: virtiofs-bot@sinrega.org
Message-Id: <86072.122011706571300608@us-mta-422.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: xattr mapping add a new type
	"unsupported"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This is ported from the C version.

Right now for xattr remapping, we support types of "prefix", "ok" or
"bad". Type "bad" returns -EPERM on getxattr()/setxattr() and hides xattr in
listxattr().

A new semantics is needed where if an xattr is unsupported, then
getxattr()/setxattr() return -ENOTSUP and listxattr() should hide
the xattr. And, for getxattr(), when the mapping code returns -EPERM,
for type "bad", getxattr() code converts it to -ENODATA.

This is needed to simulate that security.selinux is not
supported by virtiofs filesystem and in that case client falls back
to some default label specified by policy.

So add a new type "unsupported" which returns -ENOTSUP on getxattr()
and setxattr() and hides xattrs in listxattr().

For example, one can use following mapping rule to not support
security.selinux xattr and allow others.

"-o xattrmap=/unsupported/all/security.selinux/security.selinux//ok/all///"
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/67

