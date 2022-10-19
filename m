Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1666191592; x=1666277992; bh=mcLwRZjLpb0bWhgVhExMD
 daw1HpFYcAJXwapGFeJczA=; b=barM5OrR0IJbof5YKaRK/2YN1tgJJgBriIGBB
 CCFl+6gBS2vJRkBUJ/UiEd7oYs8H9kMQcsmuxuN7G9AG2Wgl9q+6ZSj3F7tJajcH
 msQhbJNAQ9TWiYi0aDdwFLuQB14a6UoBcvp3RZxXRRxMolxtTbLk1LAWr9q/Xy+J
 YTb0SDf1jkj6H5wCFKrAsX1WtiNB1zrYV9vcBnTfluKMqojT1cx42GYUGSsMBAGC
 LNTHFC0Gh2oyA+I7DgVv7sIZo/gpmBT9GJwzOzDvlZrU+6nY2tJn43LSu2yMHtAS
 oCpa73YYazfxzlh7AYEzz2rAx+8jWgFPm8/0p85vLdNCYkYyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1666191592; x=1666277992; bh=mcLwRZjLpb0bWhgVhExMDdaw1HpFYcAJXwa
 pGFeJczA=; b=Ncd0pNvi7QNSEgvKuDZQsCIs5BFh498pzhdJPZSVtji99qMxkk1
 LtMIfiiyyP8kagfgtZxU2uONBxN11zx371NBIUar4XyvaLCjTGM3CAhe9wOKs3J8
 b8MyIoZGpS//jIRmq5FJ7xjs74tfRg8HPCViaulA8PQODD8pcbBQ2Ow+ofDDWaqR
 MybjNtWb7CWXxwY5hOD/e2YW0LbdYb7Yk9UHUv3L7a1p6AvTJhAyax8ZuyWLQE3b
 t7q26O/CP2r30MdxbWU0dpYpccdoR5qKItob5sIXxHq6j6CFbvpCPy+mhIFwdqLV
 iMigKaStCMVdlA/4CNlZe5s0YnP3tHs1urQ==
From: virtiofs-bot@sinrega.org
Message-Id: <89183.122101910595401469@us-mta-621.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 19 Oct 2022 14:59:58 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Implement support for storing
 security info in extended attributes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Some user cannot use user namespaces for uid/gid mapping. Storing the security information (i.e., uid, gid, umask, etc.) in extending attributes will provide a similar functionality (although partial) than user namespaces.

Features that will not work:
- posix acls: killpriv_v2 has no clear boundary between what should be done in the guest and host, so we still rely on the host for certain actions.


Features that probably will not work:
- selinux support
- file capabilities
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/65

