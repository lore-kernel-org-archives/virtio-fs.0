Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1669877082; x=1669963482; bh=ITcNCLGsV75tiHc2m3Wga
 9HaEhJsolszyVsy+BoIBy8=; b=EUG+MfRLbH2hOY0wcHmV13FWkH63oZuh0EjSo
 TM0jjisDDzCtAisVWGfohpNXRXbUusczCjY2lWK3crXY3Hfc1TcLETjtWTr6SVEI
 quHgNbb0O8UCoZi2aRHzCRfmIzGjCHdbsjGLN5vf/Fn+8rG7+aRI9Ox6dgmljjh+
 OUkvGfpaRO8fjEdjGip3yYlATkAY8I2Geguwa48VTlYakC7Cb1oetxlkUL7Lxe6P
 HzdkDFGt9fSdNCBZmgoIq8QDDi8k8dX1q/TPOhpUGQrJzVOY0VMj03z/bWQCXizL
 XRc/+Bska4rwqFkciFKRBcg+xKShT4WB8y1e8ZWLFphZXYtlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1669877082; x=1669963482; bh=ITcNCLGsV75tiHc2m3Wga9HaEhJsolszyVs
 y+BoIBy8=; b=wZo+kb2Karcu0+mZUQcH+kbufxVF+DgT4Lg+izeoRJtDWNTFs9b
 MV9uIcTaf5Vtjj+w+9q8XrUXrxBr0I8/tAsQpZR8lq+2bhTlnuFfsp5YNBrywGTt
 JAv1WR7ddTGutwB/3vN5a2VXsKNeaVA6GBIy9nVPj/eO3a/jzyQUUKWASHRjqpW9
 4a1I/flpBKMVLlkOpmKL+ljoNJjNpBeCqwqdFDgjuLGSf8yp+9HNupJYFyCjEVMJ
 OW8RdphPsjm8q4Cd40NFiSnFrk8JUQ04IneQFTwLdE98MrNGxFK3YFwsgM3XTu9S
 NzlgETAemGYbeT2fL00u1z/7Hlx1zJqbTGw==
From: virtiofs-bot@sinrega.org
Message-Id: <53361.122120101444400261@us-mta-251.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  1 Dec 2022 06:44:47 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Release version 1.5.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

MRs that should be merged before releasing 1.5.0:

- [x] [Keep DAC_READ_SEARCH on setxattr with posix acl](https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/140)
- [x] [seccomp: Allow `SYS_sigreturn` for s390x](https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/144)
- [x] [keep `DAC_OVERRIDE` after changing the uid/gid](https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/142)
- [ ] [passthrough: Replace `openat(2)` with `openat2(2)`](https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/141)
- [ ] [passthrough: Set `RWF_APPEND` on non-cached writes on append only files](https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/143)
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/69

