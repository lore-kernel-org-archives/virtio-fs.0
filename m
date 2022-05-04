Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1651673744; x=1651760144; bh=NCMDEuVkmPF37gG6nHFEJ
 eknQKVE1bavXVMRyjuv5dE=; b=o29g0ewKBXhjkK2C4meJSUl/TwmbcdmmFjycC
 2sohSmwUoelMv0TyCfXrI91/NhidJe+kSOt90qEp6C9pc7WZJaqMBLj+aMbS0DKz
 xeBsXpcKAlIKjExUOrl29ACG0bggDu+rSvymV2kI8A5pfQ9ln/VsrfqE+hmzwpGp
 yXB/AqsgE/T+Jyo0VwtxKrBmtf9omgz/hC6dZM4F/F4uROA4SP0oH6iQhRImjgsf
 +8YjYQDCOBe0JzBp/RgE5P4TjlimIV+2k8o23YpdU4uJyJjX4iPUBxgCctPo56QS
 M5ELBAbuULOfT6FLwLoTi1SP+Xz0VvgxtA5RTzXHrb1k8QAfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1651673744; x=1651760144; bh=N
 CMDEuVkmPF37gG6nHFEJeknQKVE1bavXVMRyjuv5dE=; b=X37Fh//J4m/iE8PbB
 MXRrN8Cn6Z914TD0xyAMfErBeczaU0BypTitp8UWT+6+LNrX0ov65uwFGQkxqZ0s
 OQZU7Zcd6cnD3BGqr1o5AYgP2yv7jaq1pK8xwSfqfRUn0+yDI+udyrHR7i+q21Jt
 fEMUNwzyh3Rt/IpTDHtq5hvhDO8ohewcwBqiIW9DKFVUO0Ko7BzOelsoEzZoVH3S
 /XyBcg/kW6Bjdt1L+xlSlyWIvZ/S/rAswacjGXSxSBEkA9A1R2CR1JycBAWZuFt0
 MTF/ztrJdfn6X+7LHKfzg0AE8grRmhSnTrZosRKwf33f2jNnSTBE3TB6n7PmTnx3
 H3xvA==
From: virtiofs-bot@sinrega.org
Message-Id: <49796.122050410154500924@us-mta-473.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed,  4 May 2022 14:15:47 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Log the errno error description
 on debug
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, when the debug level is selected, when replying an error we
only log the errno value. This commit adds the error description.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/113

