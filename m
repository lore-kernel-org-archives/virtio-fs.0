Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=zwkhmPk1Z7yd4Zi4OQjO47FwCcH/DVYghDpIbtYRdnc=; b=j
 hTdRw8xeJLSo6/tez05JuUu2gruo2qeb8/sEdpM4ZyR7DhxLvZsuOYTY2bCzaICf
 7omNqk5kD4XykWZrVpmVAKZFeR8pf0psiwcviZmxUZDo77GTfYSVFSENR8J+hbcH
 5wCcIiDIkbBIp7uDhFAWuzNh9eZT2/RCuz3gKWXaY7t5YPr+83t3ZztUqRe84VjD
 YL7hGgh+1MJmWcB0ZSw5ZR7V+Ey5k0HA/jkOglSk8RshZA3bk/WVfg55DRmTLlTv
 JPbjr9FfKsA7/N9QeVnvGJdt6YVNNWGCKgzheN5hqQvqT0u7hW/FSZR6g5oYpmSW
 WQWkxD/WW0bTK7GJ7Rezg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=zwkhmPk1Z7yd4Zi4OQjO47FwCcH/D
 VYghDpIbtYRdnc=; b=k4JBGVhLPQaXtLlcJqR+eppUGHYfSc2/+zKTtdt26kbkP
 lmWaZbR5MEdk3ems9Fr7irGokYnQncYtkLD1p3OvzJEsaDM2ATH/YICySEGxH9YW
 UenjVtYpff8ge8qBJOyHj1cHjp9bwALvDxK9o62U2thIHZ5tC1+YlsZ//7q4VWon
 6Dr8ieheKUmJJNy0OEaTGgiRpCvqd74510EaeheSlmeXBP21dcWaB3nrlsNkmcwN
 +nORTNshqwNvO4VLPlirQrvaAojzIJF2WEBA9GUrruIoEUc46AKESeJToUtXZI5j
 YRdU2PQPreE8rCtP+w37AqUPrurNE/arfAR/A/Ttw==
From: virtiofs-bot@sinrega.org
Message-Id: <06834.122031610534600288@us-mta-371.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Wed, 16 Mar 2022 14:53:49 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Xattrmap "map" type does not
 add automatic rules
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The "map" type is expected to be expanded from
`:map:key:prepend`
 to:
```
:prefix:key:prepend:
:bad:server::prepend:
:bad:client:key::
:ok:all::
```
or if `key` is empty:
```
:prefix::prepend:
:bad:all::
```
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/40

