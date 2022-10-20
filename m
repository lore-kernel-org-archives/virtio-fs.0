Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1666282393; x=1666368793; bh=/waYuDUOnL474RGvbGdDd
 7Byv+7TZBpyfhpHZ6bNYcY=; b=XMkOt5iUp1xfUgBmJVgMxZq9U88adn8OW06lQ
 1vkKhF0Zpr8T5+uQ2foThCGrPGhZaI0hU0JGudt100K4QAbiUeh0aNFivb6MnB98
 7jQ+cAxtGYp39OjWsvIPqVjUvkGD46p8OjhNOGf3EEHPJ7wdXVkCxIEgKN3L8jhk
 Ot7nkgSehqNFCv6Ind6h2l7aNN8RZHRfLW+sTpjZTbQ5n+WNoFdAH+lAwO7WsyZx
 t2e8/Wp24z9y60Q0iN/IadVGoPXNoaOhkFdXUsQnHvY+5mIIhmukg8Eiy7F/cKOM
 EgXVCQMjr+vOqExvZw3FK6GTEbpiUIAsOtAEOob5zhV9jj9Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1666282393; x=1666368793; bh=/waYuDUOnL474RGvbGdDd7Byv+7TZBpyfhp
 HZ6bNYcY=; b=tJ9eYKiYnuqQTlSyE5+gdhoKZWt5XjbsXdzOiEUBuTXAm9QMj25
 eXPK6kMc1n7ntvqhe7rR4mgbA1gKB4HPvidiO2IAZpk0+US1BCsNuPYS9ciBqXju
 AYELiWd0c3ig10DfWZhJ+DpIAnyFTrPYKcZ5xbPLAC/yhAGkLkXX01kXvgeRTC6x
 L4Aqm2hlhDGwZ9sUqMgc6GwpXe4v7DTvwsWNTziq/DwhY8iWfM9efdFBV519oO2h
 a5MmAgZwsQ0y6WcsTogiVPo2YVocTYt6xBR93zvmC85tKb9u3HXvvjER+hl4al84
 A9x6YiFZx+MoEm2pNYE6JXdxgnjrN9VKzRg==
From: virtiofs-bot@sinrega.org
Message-Id: <26231.122102012131605323@us-mta-620.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu, 20 Oct 2022 16:13:19 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: keep `DAC_OVERRIDE` after
 changing the uid/gid
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, the FUSE protocol doesn't send the process supplementary
groups. This causes some use cases to fail, for instance
(user belongs to "wheel"):

    # mkdir -m 0770 testdir
    # chgrp wheel testdir
    # su user -c "touch testdir/file"

it should succeed but fails with "Permission denied".

The Kata team also reported a database init failure due to lack of
support of supplementary groups:

"kata database failed due to permission issue in mssql/mariadb/pssql:
cannot create directory '/var/lib/mysql/data': Permission denied"

Although the actual solution requires a modification of the FUSE
protocol, and Miklos is working on a solution. In the meantime,
to work around this, we can set the `DAC_OVERRIDE` in the effective set
after changing the credentials. We are allowed to set the capability
because we only change the effective user ID, so we still have the
'DAC_OVERRIDE' in the permitted set.

An alternative workaround is to set `SECBIT_NO_SETUID_FIXUP` to avoid
clearing the caps effective set, but it has the disadvantage that we
must be careful and drop `FSETID` (and probably a few others) or we
risk introducing some security bugs, like CVE-2022-0358 [0].

The biggest drawback of this workaround, it will not work on top of
NFS (and probably also CEPH) and might be limited to local
filesystems.

[0] https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/77

This is a workaround for #59 

closes #30
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/142

