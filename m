Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=ZUiyo8kf+mAz9qS6ken/5XZsm9HQeLCVPVTr2Hwzp8A=; b=J
 T2Sr+saF5aabRYsq/Sxr+p9yLc7qiZt3bEaMQMpKEtOzkHz+oj+wTdwlohpYXdpN
 nYfjuJr5O0ccI1OJzUmJ5EU0xDYQsXGet6MmGbVNq64shsAjdCLDvqUP3/r5BEBk
 0mf9rSSKlVkfcYln93DjyKdrKJ26YZCgEv58B9bfzLjCld/mpPoCY55UUclG6/J0
 oOwpNcapqiYF1bETRyZZBicxQPlHNgw99Uu57PQPY6TpKcrJXXAXcMqpvBZwZjV/
 NyMIUG95FIsTcq7+cGOah2iinDczCE3mH3lWy2GQSVyyYQ+7zps8rXFCII9Eq9Jv
 2nlvhr/C1CrvA6u+94PsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=ZUiyo8kf+mAz9qS6ken/5XZsm9HQe
 LCVPVTr2Hwzp8A=; b=eNM73P9yZQAg0C+h04yULhHKwKdR1StC7BEmAJ2Vs1/Bo
 TaLb7HzLfCe5hAME9xx5Qz20whnttlsbz5LtfzC5N2F63YDzivRHU1HwOX+hXWhm
 JEKOAuBsGRsFdw4aJ86kgBRzt2sBtBJfTgPgzUkWQe8CUvCjJ8DticSnU6qkHOXT
 oFRQotC7EgOJaUSLmFQk/4VEkPeCvvvfUqc2d/meRfwYT382RmOtQw37cpUYp7Yc
 9kC9H8gGIm+dPWLY19mjloE59AjusgJ67L6mepxpVwqZrRiZcR9s48w93gi3/i8H
 tBI7+wV42L1kpg3BaMDE/neGa7opAjRyauw5qfU2Q==
From: virtiofs-bot@sinrega.org
Message-Id: <42577.122032506424500267@us-mta-642.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 25 Mar 2022 10:42:48 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Support for running with
 sandbox=none without root and without namespaces
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hello,
I have question - before version 1.0 (somewhere around June 2021 eg. commit 513b9eaa0471d28c28a611f3ad447d15dccde446) it was possible to run with sandbox=none as unprivileged user and without namespace support, currently this is not possible.
Are you planning to support running as normal user without namespace support with sandbox=none?
Because currently sanbox=none is kinda not none and I really like old way of none, so want to ask if any plans for new sandbox mode maybe or if I have to stay on older version.
Thanks for answer and this awesome tool
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/42

