Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=sfdjsJgQWeb0JP1zD0y1OmOw38vmpB1vChhNSW9CmjY=; b=d
 1mbVt/eVGcxBvM1hUG1RlnRhdDxoXoQ3b6+dqKSgUG147vW2Njzdg/+c3oNXtzMl
 tej9RyTi2xgnzDEnMcDKFmCiS5xiSxDJMvHJ5eFvhterB1VshQtNpr3YdjN+5C0l
 xmFmNp2Ms7MN8m9Z0OHcCFItW5WgO86fEfe2uUFdjY+XLNHrO1D7bP3EwrEBaqK+
 rsD2DkGChLLKnbWqrceYGcrH0KkTU6XS4bGG3oybj6UZPgktwonLba+8QAjYWznP
 R6ZJPLbVZVm0f1liwsDDTO/E1VlfOIiFSiYndZm5Rnd1CTH4pvzBq+14xe3fyhD2
 6GlNOfYNV4wbcFve6BoYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=sfdjsJgQWeb0JP1zD0y1OmOw38vmp
 B1vChhNSW9CmjY=; b=NKAu2LTopGD1EWyhfAX3+Js4J1QWrHcD3wPSfyKpAVYiS
 h781A5j5xvjraA0hO2Aoa2Gd2GxV+u/zSPNPAcSm2JqxaH6D1z+/kOxY1/fG5klu
 cKe0UEfrDpV3q8Mug+PblHweaFZS7YaIuNGfMQZ7N3Xd3C4y/6DBTZx73hFfn7CC
 V4M75qdcL8xNXZhpBgvvUSzjYeYVoXVJsOat8/bFcnzNmOAa7esM3A2O72Dy0Yqh
 yaCUK6WCDPxx/CGDVr1tqlK5K7wRl2cM2e14L97Va+L0oT1TzGLaroL5CL4MudOm
 bKz/ANP5V++RWZV7X5c+19NHPXk8iRsdRXi7hjwHQ==
From: virtiofs-bot@sinrega.org
Message-Id: <39012.122032111580800430@us-mta-581.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Mon, 21 Mar 2022 15:58:13 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Expand "map" type rule
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The XattrMap "map" type must add  automatic rules,
depending on whether "key" is empty or not.

The rule ":map::prepend" must be expanded to:
:prefix::prepend:
:bad:all::

The rule ":map:key:prepend" must be expanded to
:prefix:all:key:prepend:
:bad:server::key:
:bad:client:prepend::
:ok:all::

Closes #40
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/103

