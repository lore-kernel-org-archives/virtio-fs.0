Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1649834202; x=1649920602; bh=bGlrZqGW2NAZZ3zBqluFp
 jtDLM+vC7/yDyOUiCrguAU=; b=q2vE0s0w/ukG1qg4BLAiHaGYBcx5AYsplOcx8
 Rwcb+jodmyWKqBFzSoDZItt4NCosstO3cHsJFWLqOv0sjxqGEcPGBr9a4/N8BLxf
 g2zzJC9GeONe2mwQNTMMTPxDRvbHAkU1ZigTY3HJlqvEVjM5pq2ip3vbme9luQoF
 k9T3c2nd5CnxAJEKybPP2x6+QmYn2tCzN2SjRKHgR9SQyBAJlC1c+fxwxkyHPvxk
 EOxes6RhsxOnNsGMLZz9g7O3d5Zrou/eWQ8MZAPATd95rcj0YL2JcgISMWMzKgpa
 wonoapTaIcvsHzGHP/y3fyYuV9NyU7B5aZlMrndPT1TgXQIBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1649834202; x=1649920602; bh=b
 GlrZqGW2NAZZ3zBqluFpjtDLM+vC7/yDyOUiCrguAU=; b=ELaAa7DxnsK/EQHbg
 PZd5ZPR30LTC5jDpwDIJp3mGxKLbBHh7PhCGHFVwyXTyLSbQ5PmvhUie8VdV4JsK
 4hLZUSIacCCu9GzGzLx3cCbwnfc4vTW5lJ0PVMOq1myZEpvfxbyiZHQtA08IXws/
 wtajGpRj9BczlsLHrpkuinJ0cScGGthwcH5Ol6cp2HzzzY3bOZna1GHnpqGU8awq
 XUpWogmTZ2jOreeHtlJQ6O80/W/fAY9E60yaSQq8580T3UZf0Lh0tYHqmM+h9PgK
 upbiT75ScTrwaAA/zWi/H0ad44HewTr1Yuzf8mzDO/tRUTroQSQp6shdM9vU0QPk
 6Atxg==
From: virtiofs-bot@sinrega.org
Message-Id: <67403.122041303164400203@us-mta-67.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 13 Apr 2022 07:16:52 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Add posix ACLs support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fuse has an option FUSE_POSIX_ACL which needs to be opted in by fuse server to enable posix ACLs. Add virtiofsd option '--posix-acls ' to let users enable posix ACLs support, and the compatibility options '-o posix_acl/no_posix_acl'.

Closes #33
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/95

