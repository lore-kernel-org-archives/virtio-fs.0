Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=6EvM4LgXAaPwY8jvFxsxAoqVVfWHOwH/91yesE5vR8Q=; b=q
 gcmqG8e3R+HsXyyKnouX5inY0tx1BerRzbxzrQAW11qMmrDCZo00HoEdHX6T2Ttz
 0wdgXXH1ZW+PgW//LoY97/OEcdv+a4JgsnLNdSmCCjcrGTMf4ekcoFZMk2d7xrIC
 90b7Rqj7nRRzrZQmPvw816TXFRj25pWfpp9nGqZis4rxawIQ/l00GQIPQDgB/QJv
 JlftF8ORqGZ/ubnJQfUURIuabo01UmbKHWJLlhaKXJcLkLniZuDe19SbMF2Pya/U
 NzGoc9dwH8fRC+vbowE1oshKQhWtijG/X1BYntAEIKcgEz1DQ7NBNAMcqAeLkgpq
 /Yl53ECBpJ7xl15VRGsjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=6EvM4LgXAaPwY8jvFxsxAoqVVfWHO
 wH/91yesE5vR8Q=; b=Y/p92oy28hShkponipL/93EYY/zFfhAXcAQDBhiCKMHo9
 DxdW3a+ab6frBHaPzfhYOyufVejEgIiUp5PvnABf8z8r3JSVmm2Vf+cMulJY9i0U
 qA9ggBg3uXus0ytxhkhwXry7Y4yGZzFHWdelpISh+siMgIgxQQ3zrmJxa/TlLXtB
 orPl+rEKXX94IYo/MyHQt2gfbi6QOIsuYXX8+83n+GRR//rIs8PQ4WHH89XRm9f6
 A+SMZs3BImT91vqLaLuUJMZ836Txs7xrwjI4F1qcT++RlC04UZi9zEcKKiL5Vpvl
 qB7x/PlL226kN0z9q3/ZaQgKu21Worjl/V8n8NI2A==
From: virtiofs-bot@sinrega.org
Message-Id: <98299.122032111580703317@us-mta-616.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Mon, 21 Mar 2022 15:58:10 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: Xattrmap "map" type does not
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
:prefix:all:key:prepend:
:bad:server::key:
:bad:client:prepend::
:ok:all::
```
or if `key` is empty:
```
:prefix::prepend:
:bad:all::
```
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/40

