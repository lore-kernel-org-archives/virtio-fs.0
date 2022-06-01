Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1654079537; x=1654165937; bh=kNNSRdGHAnYRLN9c8PU9W
 m7gyx16akfaMDn/d0O9xnQ=; b=pj++r5r6GojX6qD0mEPYc1lCLs7AMqKBVtGKQ
 e46GuWClP6eIpzhd23w3SSN8nuGMVKOrrFcDMWK42EFm2c/CkM95auniiz42rpht
 XF9CwIptCIzkq2n29ALetL40qrJJG4KSOv4BV/9w2d3u9RBQM27LNc1SYtipGmIr
 J5pzRZ7O/bO6q/OKPFM03hbkLHzCSQYvxViqUNmRSTce/EwsxCxIhTyKU4fMJEj5
 BdU/udtEcPsfqvVrBqNw5P7g0uDVUZU+eHc6tiHSnK5hdRuN/CZZM9gdEAh4lrIq
 XjJvfxojOxCWtLPjJbzV21x4bS7vLdCgvQym5aKHPRxxMH5mQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1654079537; x=1654165937; bh=kNNSRdGHAnYRLN9c8PU9Wm7gyx16akfaMDn
 /d0O9xnQ=; b=tEKRAIePLGjbrwhl5Ftz8Fy1zmeD7zDNJW3yDZI3P7u5JKmYdpa
 g667dRvUs8uG/5MaC4fwfKhaMEVv9O9B+T2DRmy6zM1KJGwTQHrvgd8Oy6kjZ/Di
 le7KeBwsQs4Mt5QUYGv2FKwbrubr0oLe4pQCJzLnZYRwKO+Jvugc7HLHEruDVw9o
 5RRXzCYeVSeMFm5jTu1iHwjw97A6tbF36cDPRHwNyy11WEuoztYR+xqwJ/D3Vfo/
 FpNBPZjmGrhzo/QGRs+8mNDQr0ncAV03UyAKinHbewb/QKEZIgFxugiai3sR0D/5
 61hdYs+kZX8jzG4f3xjTL33p+uAIxrwLtYg==
From: virtiofs-bot@sinrega.org
Message-Id: <61186.122060106321900283@us-mta-301.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed,  1 Jun 2022 10:32:21 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Update rust-vmm dependencies
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Update rust-vmm dependencies to align the latest crates of the
vhost-user family.

While there, also update the Cargo.lock to reflect the latest status
of the dependencies on crates.io.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/123

