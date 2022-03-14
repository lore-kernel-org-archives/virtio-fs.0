Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=LlD53OdPJj/B9UxjponE4ASLGJ6LsvX0fsw4icQz/G8=; b=V
 xGJEv2mwxrtk9LWOl7CkqeZzAlXy6cX7q46soSp0TYb7LeU9EKRyJKFlAsBkQJJ7
 PyPV/T5MvSisuUl2qhBpDLmSymbelRFBCXzq0GgnkZ2dXSAQ96RTBqBbi6HIYXqd
 2eDzAPXU1sOPzhziUOdgGrFnzSEVhRskeIh1JBOn8bazB0Oswlm+eP9LVMDJ2J1H
 HK4VE4q8+9ShYNxC1wXlQL8XloANvABo/uTS3i4RQIpcg9QR4ak90x2s4dQyCjhT
 4A31LPrUxp318dGsJklronD9A+iII6assG4rvrEHo3FGrisBrBq6Jg/Hm/oT40ua
 0z5ykz4FQpEbAnLq9v8+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=LlD53OdPJj/B9UxjponE4ASLGJ6Ls
 vX0fsw4icQz/G8=; b=oBkk7e36NkB8USwj42SEP9z9q4nvpMIQsc2+cPXqrcCD0
 6PqzKqpKUAvWm6Z7TiDTj6dHi3e2jFOsUmBv9RpxV/zNIQoE/50JT9JRJ7eij79C
 Ce/FsS7+cx1+5XTaL2bFESc3Ust0soZuslqm786MaBjoidOm5oM4p9IRUyFwBQjm
 2mj0XodISXxIGhgeDovqwyyLftAVHdcYCKZeqg6i6fB3cScRPzKU1pbwshpgFYTc
 2Qnmr28qx1Z2eF2rBSlDvw3g2/HWhaoBQ4FGnyJOKzOjOseGheq29wZWdrBIEYzN
 ei2oEmfQMN9c27addLnGkW/w0dFH4UVCOJKL9FxmA==
From: virtiofs-bot@sinrega.org
Message-Id: <77812.122031408060402423@us-mta-620.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Mon, 14 Mar 2022 12:06:06 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Set the number of written bytes
 for used descs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

As the Linux driver ignores the "len" field of used descriptors, we
didn't bother to set it properly when return those descriptors to the
queue.

The problem is that other implementations (at least, the Windows one),
do care about it, so let's do the right thing and set it properly.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/101

