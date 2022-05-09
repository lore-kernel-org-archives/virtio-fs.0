Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1652088956; x=1652175356; bh=mDQ5/vilR3+AimC4mT2yZ
 2yS59H0gpyw4Azg5HAJ61k=; b=izUoZgkzOJSe+sZeWVgod+oKQFn5IClKUflKe
 71LkD2qil0ImtP263BkXUXi9QS87cOOCARj/0Giz2l/Tc8JzFBLm1Ub4dwKZFPIw
 IeiTJ6LBZoCEbX5At6bQhHyM/HjNbSzQMEEQemaiKzkOTLlTB9iB0ZlVE4RXf6Uw
 10LQkrwIuTfPOV6Ei3nnhxM/Vsy6CTR1toL48iszSCzsJHnJMjhDNxRnTmLKXNdU
 MFyoEQm9CietJuNZaCf5LPClWsXI4kMqMwiIEN4ezoQwVE/DZLg9or8kyzO2fHpj
 Qyv7dAJAWvFNuKY00wQ3FPz/OjxdWsyHBMsqeI6pAjEY8OuAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1652088956; x=1652175356; bh=m
 DQ5/vilR3+AimC4mT2yZ2yS59H0gpyw4Azg5HAJ61k=; b=z2D1KK1gmaVkG8RhB
 flygf39RsTkN503EZ0b7UK4pCBhuj/4XRZ3zERCc7WzIsE8tRagdQ4qfCcrs1wKB
 UmrxDDbYSmMjBQRhg/BQBilAFD1NlNeAFbfn9Mmsva+IaXRZ3XIF0hyWO3tpN3CL
 XD5Jm8G7wQu4SMk1EaQUaryEgggqVPAaoMEPVGF+8Edwkd2uQ+89QRCkWzrlFo6S
 2jDqyh0v0twVQpm70X1ccmo4AAmEiugfSX0TzFX4OhGPlvRBfzvCF2GpBQa00tj6
 M3+dsMt60U+5YM8HBYVqa2ZUkjLo4KB0bEYqquy+Nv6PlFr0ZnHkbUfkBCGW/YKz
 MoNLw==
From: virtiofs-bot@sinrega.org
Message-Id: <97098.122050905355800231@us-mta-213.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon,  9 May 2022 09:36:01 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: Do not allow two daemons to
 listen on same socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Right now I can start two daemons listening on same socket /tmp/vhostqemu. Drop in a pid lock file and use flock so that only one virtiofsd instance can listen and other fails with error. C version already does it and errors out with error.

"Cannot lock pid file: Resource temporarily unavailable"
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/31

