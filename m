Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1653492126; x=1653578526; bh=D7YUHBa6+KyhoQcScapzs
 qGNYKAJaOLLu+8ztpsXNi0=; b=HfOLy8z9jsH+KkkdWzfrscNzvEYUKycjTemdX
 I1ECikgGt2U5n9haXzDBuTXMLZS0na3+82kRF+FD4YfeU7/j6Upkj/HQcJl+JnLT
 gqTPzZst2HL6rn2ujPnN1+mcPfWwBFp0A8GLDtfhAL3J4YcLu/z3/cMktPZAcDV/
 c2/WZLHI1ib4nXk7IJp/EbMPY7Ham9LyzwqEXlBGRD+Ka383DYUKjlzzOT+xImx9
 YOceBccG0deY1g0VA82V+Dq4nbH8ZApEUgof9NCc3iULDK8tBQHYapvcmhRkl+iG
 cFxvvPRvH9cU6y8lc+/LP2IIF9vkfsh0xVACCW+0omabPdFAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1653492126; x=1653578526; bh=D7YUHBa6+KyhoQcScapzsqGNYKAJaOLLu+8
 ztpsXNi0=; b=egQ5jz9IV9FVoJRc/LrL1q2gJvFhqBFTJoniyRp/w4JpCmynkRU
 G3/IzbMVxgpv3RUHbDMh6+gHU3EdvwJ9AfFXdB0/I1ttG8y4NJ1yYt0TYDscdnJE
 DbkQJPi53Rah2T2UqYKOfv9J4aQ2g342x7ARW8hYSsSavrmWH6zYAxB9xVpoljDP
 2T1HOl8NV5l2x46sbirazbsflr9+cJZHYGv5jmw3EJhehmEUOS+30cbgXWqKXTDk
 s/Lxvg9YwSFtwcBdJKG7V2jV88xPpP1ovLi8WneOGbqXlmxuqBe/0w/ARTvS4IU8
 dxLRnFQpFJW92u8sRFolFyoncKhr9FIOPAQ==
From: virtiofs-bot@sinrega.org
Message-Id: <68837.122052511220801239@us-mta-29.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 25 May 2022 15:22:33 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: implement std::error::Error trait
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The seccomp and sandbox modules declare a custom error enum, they should implement the std:error:Error trait.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/121

