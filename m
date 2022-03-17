Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=sfdjsJgQWeb0JP1zD0y1OmOw38vmpB1vChhNSW9CmjY=; b=Z
 KNDng3kZ0x7A5suNrnN8F9PMbQaH6BoX1CglqNx8fOwsFRk9tOc+x7+MoBmIsXrC
 1izvHUX7vZAvvA69BHHLhVaK1EDnP/+TgyzlFFCsRWxBV87qJbQ61tlAvpXOgls9
 K2wYuIW5EeAFM3k/2Yw3oq1PKVFlxAbaVhNiyelxR6VbQXVN2dtt0sEQ4Iy8+2r+
 hl77iaDrywuiNPRZJsDnJHQAcANRtGW0SHU4pdVJ3jKhJ6y8AFqGViRGoIeFoOTe
 CyE7/DbE24bsOvvoz8eaKMt4H7nOWGpEvrac+KdzVgpY6tL65A3htuFXz4aBAsCC
 bbEGXWMXkixIs1JIHSvDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=sfdjsJgQWeb0JP1zD0y1OmOw38vmp
 B1vChhNSW9CmjY=; b=Db7OW8khcva8/6x9Zt5kEK44wspZRYg+Ay2wXw7Fm/G3W
 XtHtvNCJxGwjRogtpFb9IUI8KqfE7Lilx9QIwxeS45ntdvRuDJKSKvLZd55zFAfq
 YmeuV5D3PGTwooCRhU8GlpYmcurNioq4RqdzaBGUY9hqZOla14gXBmQMW8SYAqx2
 dQPAGdCn9UuQEeF7oOW9K2C5jelUex0QnMMyNVRVdP9649JRGxdWbtq8ORoBuL16
 3UEEAPpX9lfL1hOd3HA8dwzZNGvKWopUbsX6j47MAeIZlOJPU2Rc5DwI2YkmY1/2
 UCEQt9dYm41tWPf1lP79Y+0ZFDq6zxtEjB4b1X0Rw==
From: virtiofs-bot@sinrega.org
Message-Id: <34267.122031711373300427@us-mta-258.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Thu, 17 Mar 2022 15:37:35 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Expand "map" type rule
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

