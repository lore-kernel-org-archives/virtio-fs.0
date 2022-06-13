Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1655118155; x=1655204555; bh=3Ozhf5+CBIb9hJkhDZu1d
 JfQJ7+xwCLC153GjlCxj20=; b=RDe91Klv0NTD4SQ0BI+KS4htKwfy9TCYAQ+yc
 s0PWovq3JsMMZ01Okj7KH0ymTt8TSa6+hQ5+pXc7sacu6EqCES8SI0aHOIqfeykj
 LVcKjpCN4HEA40VIdvYfgFGeQL9Z5MbGANRKLxsEtIFOx7z4tnnSGVgDb5XZ5vQB
 RlQqnwp8mhrWiiFDiQALmwGq8nCPb0qDL+Xhi1IePWkg1Nss1i/a4svtp+qM2WuZ
 k80kictobRWy2NeGpFoepL1ZDgUeyFmsa08sdxeZ4Y4hg/4U1byAODnSrvJdUlTR
 Mf7E2L/kl/cdj32Rm59LnkrEPy9i0CGZEL7+dgSLc3m/i88XQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1655118155; x=1655204555; bh=3Ozhf5+CBIb9hJkhDZu1dJfQJ7+xwCLC153
 GjlCxj20=; b=YHRpZ7PkIL4eJ29B6gAjcj7Lloo8mykZR8vzuppu8vZ0VMsr+Qw
 WrTXs9PnwElMAsZXMNm2wgkCmU96gM4t5Gm0lQM3ezyU9k8qIu+e+m+PihF3HfQp
 JS8Ue0SbGbog8yTzWS5h80KyGf2lo57xocwqZC71jMFlONw8p7cW7p6Qoeb1vG3z
 MYIHAVDlWgrWJEJMPlAJDMZOqNvDX9tYaIKXYYjiPSRU+jTPR2gRAe23Imfvxvxz
 gB957lEDEhwp0/8GvHHJsrgOHmek/GJeEydY9AP73WW9I+8xJO7B2OvnIUexcsOf
 8szg4646kowv2gNAxrU0SyADnwZyjwdrS3A==
From: virtiofs-bot@sinrega.org
Message-Id: <58100.122061307023501197@us-mta-224.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 13 Jun 2022 11:02:38 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Fix nightly clippy
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

