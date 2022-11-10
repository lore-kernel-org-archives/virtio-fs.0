Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1668091905; x=1668178305; bh=Q9w6h+UVTIj/h0sRRfmHr
 3EI8EEooqKcwJwTMebZEdA=; b=C1MHdC0fMYYgvQitPX/L73OaS1DCHSmoxnKfD
 nEe4NtL+KgwsbIk50uqt0GOABowQaBoUVf5GDrFJZv3Vtsn48jko/JdY/DfgnvyX
 qSsNey4WLVUVBgLK435y+b4AoYucWfFHlqtIl3SQlOF/+pEre/dSzjuF/3OwrHaA
 7A2YKg140nUlsP+KD+emMmg//Eu2Q/sVF5KCJp1BFatHfE9/ERvpZNZHDFz3hn18
 QmNz0Vm159Dq4fWiurCfv2owhwoxzOHZiqV/8z9Tlwx+jDDcKKiN+3RGl+6NYqdu
 q/mm50AG7Cekkt7zBHkEESsmTH6blSzbB1YJWVVHUM+IUT70g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1668091905; x=1668178305; bh=Q9w6h+UVTIj/h0sRRfmHr3EI8EEooqKcwJw
 TMebZEdA=; b=AYrYvOylqqzGWk4ja1lUnjDiEgHW2MSZHnpcBXu3aNuG4j/JFov
 JMcRWiCxmZJLD1R7v0HGIWzLdmwi68Gpvi1rh+dzjZFPYMEgmq4u+V1B76bsAolA
 TUvQ+ayXODfi8R5vvi5fhL+KP2FjelCNoQbuf1bLnipILtzVWoCCZ1QPKyu3WCEe
 uJ5dQMZ8Hib4Gi6Y7gFyfAJf0XdIVAmMUXorBpYlWNPGdKJJI2+5KcWy3I5B0veQ
 APmkZxH50bJoIGJBtp/Ko9iNrsfPWBrxHvlOKnIZd3O5/Xpq50WSuG/Zwr0U9mUb
 8QdxHZa5cwmsJnyuZxHJxYxvnCdDWBI44dA==
From: virtiofs-bot@sinrega.org
Message-Id: <30170.122111009514800261@us-mta-459.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu, 10 Nov 2022 14:51:55 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Unexpected behavior observed
 when using mmap on virtiofs backed paths
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When using python and writing to a mmap file, I am seeing with cache mode auto and always that the file is increasing in size each time I write to it.  This is seen with virtiofsd C version ( 6.1.0 ) as well as RS version (1.3.0), and can be reproduced using QEMU (6.2) as well as Cloud Hypervisor (v0.26). When switching to a different vhost-user-fs backend (nydusd), we can no longer reproduce the failure.  

The following python script will show the failure behavior if run on a virtiofs backed path:
```
import mmap
import struct
l = 1024
f = open("./test.db", "a+b")
f.truncate(l)
m = mmap.mmap(f.fileno(), 1024, access=mmap.ACCESS_WRITE)
m[0:4] = b"0000"
m.flush()
m.size()
m[0:4] = b"0000"
m.flush()
m.size()
```

See https://github.com/kata-containers/kata-containers/issues/5634 for more details on reproduction.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/67

