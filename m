Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1654256708; x=1654343108; bh=TySl3vKccbF1ffRGsim6X
 teq6cSvesu/kMLuh5l2tW0=; b=YvdwwuzXd9FLppB93xF2vZBiaEZ2+5X+9x69y
 waBC3iyUimtRlCgSTLeQq0WYS5bWS35Qt1WfaGgwYikXDEy70NIo7cQNn56HzHP1
 p8h7pZ6NKsNlyzDledfJ+mC+hNC/xUXYL0EBuj6LIMCoe2gOagQiy/kXcQBMR3TY
 tGLDYd9pEtqjPVDf1NjHHCjYne2gJlcFPgXhGfovSRcmkZxA2vDbgoXu+pvOjk3t
 enC7t/0Z0JT5ZepqXcknAo15XPCUqIGugdJ+3ZZlCNpbwQQgINsxPqF0c+B+jxJ6
 5/AqJXA6XvEi/FNd+EcFIstMPzJIaGU46BSJ5oaW/ZzLStKYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1654256708; x=1654343108; bh=TySl3vKccbF1ffRGsim6Xteq6cSvesu/kML
 uh5l2tW0=; b=nUVb+GWRIaoLNs7UmQHM2Q1x2tYWJDg6KmkMZHULWLkAs8OEJTU
 pbgplJYXvXrq6QUQcrv9Lg/WraWZgim0VoHDje65wI7iB+1yePgScv0eLlK1yjYq
 GpqcNAXgFs3Bp4oJWdEj7mNp8VvC0Ze+7lEx9NFWK6zJBW815n8d0hVaEcQctz2o
 wPTc1/kiSXQzZo91BVGlgTCrfpsagLzBgtbKszEaZUpLA/GLelfMOsV/VOotPwEr
 s0XYnLjG6gHBCxh73y1YJ04abe9/E81TCovQN9noE0fa6geYvZLz7vXpeixN/gNH
 E1G/phazSsRKu3ASyVKEFALbJiX6gjOpN6w==
From: virtiofs-bot@sinrega.org
Message-Id: <88775.122060307450801118@us-mta-479.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri,  3 Jun 2022 11:45:11 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Fixes failed open mount point
 when using file handles with chroot
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When using a mount point as a shared directory (e.g. bind mount), using `--sandbox=chroot` and `--inode-file-handles=mandatory/prefer`, virtiofsd fails to open the mount point. This is because the shared directory (`path`) and the mount point (`mountprefix`) are the same, so `path.strip_prefix(mountprefix)` returns an empty string.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/124

