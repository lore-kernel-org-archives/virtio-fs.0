Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=ltE6nf2wd5rKcpvby7T62giVxLM7K28oEqHFoMA0DCk=; b=G
 6sKIhXZULor5En3kCw9oIH9xvL8Uc/sZQdpFm5Nsi8CW7wLqLR/KoWNx7T25u+Sy
 GJTFO7nM8C5nhOVGTDTMjYZO0XoqV2d1WYM2Tp8uIgCm7s6Cv0NZ77bmqefb+VoW
 VInZPRErDDEzG2iUok3iG2wnZgrzlo6+Tqv+872FwlWY6v+2U+QbXT0Dq3jbcqrk
 tp+Cba83yzPbUhO56h94E8eDxh24OOpwTeyxJezHPRqgweNGme8LkqbsaMxhaJK6
 iSJkcDBBQ4hDRugoVGcsWI+cY2/d0SD9RpsFNeAczPvOEfsNrLN7MGdD/OTW6VCb
 q9DK/o1XNaF4KcyCVBkCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=ltE6nf2wd5rKcpvby7T62giVxLM7K
 28oEqHFoMA0DCk=; b=VIMG2sOgX8SC6gNBVIBHyMBUR+ElYB41YpHptQlOsFEW4
 VQVk5Rykd2MXdVpIgFCmTyjbgY8LvPv5g7/qQcawugVNzTnTZ06Rj/r5L0JiphZd
 zGvx71SKfiETyCpX9p1OF0FWAFW2reMaC5k9+O+dGcmKOJRPYrDiHBZtSy596xSw
 RUMTiHlYrgTjCrU15QbRibKfdkBhZ83Iqys3g+Otq0x5SWJU6ETZhwGkrt7G6X6j
 /2JBC47Uqxq5bemGFAiZHC1dSLnSKSGYUzNH6lcd8LwYVfDd9XI+Hte2b06JpxS9
 mWJIvNlHQOueinWthdWbIPgl6YmcSFqv5gsXvnl6A==
From: virtiofs-bot@sinrega.org
Message-Id: <90343.122040305555100233@us-mta-319.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Sun,  3 Apr 2022 09:55:57 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: Can't run unprivileged any
 more due to setgroups
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Since !77, it's not possible to run virtiofsd as an unprivileged user any more:

```
[2022-03-04T16:46:42Z ERROR virtiofsd] Error entering sandbox: DropSupplementalGroups(Os { code: 1, kind: PermissionDenied, message: "Operation not permitted" })
```

This is because `setgroups` is always called at startup, and it requires `CAP_SETGID`.  When using the namespace sandbox mode, should `setgroups` be called _after_ setting up the namespace?

cc @slp @vgoyal
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/36

