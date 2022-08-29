Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1661792058; x=1661878458; bh=TlOttof8FQBBJKrrjmUoB
 8rq07e82h46qOz43RLlYF4=; b=d8W8AfXAznKaBjYhOo5Ek0ule/4HuQdBpyjow
 b9yqZK4JSepfwOWAztt7b8IkSWC+VY8S2rxk9L5PnwUJQTC1u5wXgMTMBwmCHwry
 6Td/d/CDylO8tazXCDx3/z7HeWvOftQj3fnEsTAxEzqeGWsacU+M5YzhDFEofE6A
 BTGytnmO9QaOs7/TApaD/EqsRE05gICEKgwbbcmXoTOHJTfoXFzduUhWv1mUvqGq
 OI+XW4YAbBy8D04awOZHTAHtxZEY4P3jGAzG2OPetSUeTmz7YnRilisCQy4s0uMR
 q3tSN8ZxP08zf3UMtaMWXC+pjkpXKvH+60eNR++59dsWL5dWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1661792058; x=1661878458; bh=TlOttof8FQBBJKrrjmUoB8rq07e82h46qOz
 43RLlYF4=; b=ZAfcQ/fywAmGthNYIKEIQx04d9ISr20xUO95/+xge4IPF3uvcu1
 BCo9+DlU0e5aTz+yvahDM2WjdbUD2ADhxu79Vuzg5zkMT3pU6h+sk7eRDv+TZETU
 sc0rN/PBxvsOOIkQuYruxuuP+7WhZHbxdh/Y676YocgZ+8MXdMcAr0b0aZ7h542i
 ZM6qJ2xfPN2/zF1+Zgk1wRA1YNJGtilcEJkUGj5/XtuWbi8/4O3oovniCdVP8BQQ
 0kxb2CNXUcN8Ii38DlKaOcp9KGarQ0tUyuriSbqRe1cVu2XaLdywfdD6/W/6e9wh
 7l0dBX6ZxRVJ9ZYqZx6/HvgYcHJJfKvRlng==
From: virtiofs-bot@sinrega.org
Message-Id: <50338.122082912542000799@us-mta-360.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 29 Aug 2022 16:54:23 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Fix `listxattr()` response when
 xattr name list is empty
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

FUSE_LISTXATTR returns a xattr name list. It is possible that the name
list is empty, because either there are no xattrs or all xattrs have
been filtered out by the server.

As of now rust version of code writes a null byte to client supplied
buffer. This fails the kernel fuse code verification and return -EIO to
user space.

We need to send a response back with error code 0 and virtiofs kernel
code will handle it and update the variable argument size to 0.

Closes #55
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/132

