Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1655445778; x=1655532178; bh=3Ozhf5+CBIb9hJkhDZu1d
 JfQJ7+xwCLC153GjlCxj20=; b=O6sVxaLGwDHm/wR02cUIVxT4yfeQCAAcK6yoQ
 Gz/VqcZPwr11AL3BOLLsaIkFW70NVNI0k5O556AsopGQXYGCplrTUlY19Gth/kxI
 8lIqIwWpY7zDSaxMQA7mdL5/zRYECle6OOSekE7TCW5CDeTm4DP5dInF4QN3DHOC
 JiooL5sayzEIUP1GUf2B+4eiOtvDaxnuc7WWvcPx/VVa0iJPl1DFr1XgPbQK+f5l
 Le4A2XW0bKlTNwdkZThQlA09NjDZx9nekYBvP/yUlipS64/3D4VLDaXco+PNpr1z
 m2XEMMwGbuCt8Gey5y21d5azopa9de0M0cPPxz7bHERx+Is6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1655445778; x=1655532178; bh=3Ozhf5+CBIb9hJkhDZu1dJfQJ7+xwCLC153
 GjlCxj20=; b=CtSFXVmiQ6wSwZoCK6ecccUtj7VcBQA6jIKaDRewJUltL+HRfu5
 M/PFdxt8isIUGGJVYV9pWAj6a1fOyH2Os2KMNwGhOpS5ndtHUES2Bhpr3TkLkOkh
 nXq0PK0r/ZCXUwRE3L1KL/qvGE7Av5btBhOUKvKfu11ADh7zjZbJsaUSl76aQqLR
 Zqq5aKUulHSmEBzIneYDC/leiVJdw+qEi0mW0d/H9hSVy5GjyRTb8FPimj49TLhm
 e33nsjpJhyTEc75d9OT4MM03jk1xAl7u8EZgTZBJAGbIpptPObHTwbO9E+7Dcudt
 nC6sEgLYa0HS6P3qHLMEBseuS35v0w8C3Qg==
From: virtiofs-bot@sinrega.org
Message-Id: <92515.122061702030000245@us-mta-253.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 17 Jun 2022 06:03:02 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Fix nightly clippy
 derive_partial_eq_without_eq warning
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The nightly version of clippy (v1.63.0) warns about implementing
`PartialEq` without implementing `Eq` when all the member of the
`struct` or `enum` implement both:

```
#[derive(Debug, Copy, Clone, PartialEq)]
                             ^^^^^^^^^ help: consider deriving `Eq` as well: `PartialEq, Eq`
```

For further information visit
https://rust-lang.github.io/rust-clippy/master/index.html#derive_partial_eq_without_eq
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/125

