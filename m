Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1669876233; x=1669962633; bh=/waYuDUOnL474RGvbGdDd
 7Byv+7TZBpyfhpHZ6bNYcY=; b=ZhMg1lnq0jmCnrP4E6vSTNBoJqOgjh8vzsN8X
 jKZsXepO9AOzvX4PSGL9dMYJej1m9uqANNHEsHyiJafB32yb/EO4qsYfkBzy980E
 CoRwRkffGRiCZIrnjefkH2M71CTwqWVey9TlFuecrCWDj8fmsjBUzoODx30t4jYP
 jW9m4OMbetAGYZJxXyA+W81DQ+YX6aFGPgUoSOucm7086x4zr7pE1Qd4Ts9YP/FU
 zSwBjVlBwebhj6RJdd+HEXWkfXhN0ywiR91dIiGcJR1OxPXByQ49/HZgJESEA6Jp
 D7OJ4pY2BEbdumbcLIwiuWRZo166IAyeyqE1vTtAyH9zOJSUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1669876233; x=1669962633; bh=/waYuDUOnL474RGvbGdDd7Byv+7TZBpyfhp
 HZ6bNYcY=; b=uZp76EzZKnwnGFFUJy2lA8G99JxvGUwMz9eEbYd2Ctp7qzr/7qm
 u3PvA0xh2gSldIJCuIvw6Loe4k26AR4tzsiFozR1Qd2cbKyRBX1Poysc/MMdefIs
 4M2fLhS/5iP2kSMDItFBDbnQHjU84VN/x6HmGS5ja0GXJ5hWfUUsvz2A9GDRuX4d
 M0aAg9YRP6xzSJ2u+Ode56jAdpjkq6VkLxRON+TcO2Zy1zLqM9IAwE5k5PgZfsgZ
 0sSvmmPcORJAt/lrxNaBSpGCZX2Kx4eg+shw/pr+IxTu1ZyKMfHosOAiW/QtRfIl
 Ytfygjk/G74GFfFkymqQS6PobgY/NLA2rZw==
From: virtiofs-bot@sinrega.org
Message-Id: <41652.122120101303500517@us-mta-367.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  1 Dec 2022 06:30:37 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: keep `DAC_OVERRIDE` after
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

