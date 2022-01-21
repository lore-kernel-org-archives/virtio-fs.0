Date: Fri, 21 Jan 2022 04:41:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=NgebdAXy7uyUtUGIPY66WWXlD6XOvxPHZgmhI8H+cpQ=; b=t
	Ce0TbxtkWkbVyHbebKE1cAmMViegD3nCcvMSPglkestbXBUGCjqr6TgpUNrvezLI
	PLrY+5sfRGWDWu2MYZRFBB/Ya8O2de07pAPXdhbOtPVevGhAlDsKVcMzteQy8n9c
	7NmOnOd7rI3NbdETT7u8XVmLcVBRiqDQB316dp8Ny6b1Y2r/Y8dY+Yo32/I64Y1c
	GVZJkB0xv2IRZ3GI6tX3b7XLFLj6iymYqILNVtZZVnueFsyqOXBzljOjjxf2+4pY
	kytEjIurJhfpniT1bBuoGOybL52U3f88jHUmlGzriyAf1xQrZJM4K2mYmfrqSisg
	fDdG95lnHQswg1baACu6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=NgebdAXy7uyUtUGIPY66WWXlD6XOv
	xPHZgmhI8H+cpQ=; b=f6USu66SG/fICgi10pXm3TblSzrAiTHC7dPej9hZvo60m
	I5TJBmlnujyg04s/M+NelL6i+FSU+KtPOiZ0Q1GooGYxmC6GBuRnjwTOnNYPqvd3
	MVoPDhbpgN2W5HTlWLldm7fASshn8tPytYzNdTrbks81pyztso9L8z0nna/rweIj
	ZlKV3dqH2hvQI7jX1c5IfjSkflu8+VF8Ze6d1yx6P18tQViMNYRh3AyxdVVKGvO4
	BCqzTdo482SggZ4weLBPiLVtOa0UqKkkNF6KnZDEQ85L8hKUvbaJyeiPz8xmZhQp
	rpbFds1FltwydLK6RsyLqx7q1RYBnIhg0SwlNzIBg==
From: virtiofs-bot@sinrega.org
Message-Id: <03375.122012104411900643@us-mta-245.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: xattr mapping add a new type
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

