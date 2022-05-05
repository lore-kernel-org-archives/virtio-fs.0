Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1651768495; x=1651854895; bh=NgdIdn7Kp7n4ARx5Ai1PR
 4ugTnsoukzBHxOYzB2KPog=; b=OmlqUek73GocEGF3OWCYhNM7RMtg0PFWXNFxQ
 Ci9qmT4XK1BFcxpcVKrYrErAHeDuJ9r+3VpnD9SuwkSTFyzA9VcaPpNqHojPuKlM
 lGSMRREAYx4TJk9SN5XIl+gzC/6CKyAbWKiFLaeS/zSu0qY+DqAj9VOCQylj8Vch
 OtA5i2fvwVUwtInvNwXcuoi+9vxApabRmP9rvW3Q6s3Ht1unGUpJiZUHYQyNxJnk
 YsTosmuTsrbjppKxJ9Y2whtNo+RXxhZK2g144LyyDdSado4oy6ftMJc9JBKodm/7
 RtOAU4XAJ4xtspcqLiDsZ4LO4/IhkYDFoeAZpLzy70o1IHkLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1651768495; x=1651854895; bh=N
 gdIdn7Kp7n4ARx5Ai1PR4ugTnsoukzBHxOYzB2KPog=; b=yDNBN2c29qC01QUWL
 ShvX/wI1/daH9cZ2BeAqWQUIWsF1vnWL1GvSn3vxM1LCp+aW1U25k34u01tW9CXi
 P8Eda66LSaziyGXwzN5+bJ85vFpwD7o/zXhobae6ZKks7qeRNie8n/wSD5rd/CsX
 a64GdsY7OT/afumNdgkGLYUCAdq99Li1RBUj7YlHzb6taUZ71KR31w0Ya6KKO0UM
 MhR305Sumr4QduOyJPC9FitvmMRw7gt7nUuBtepzcTjQq6hlUCJGFSUMyiE1cfQ0
 CQb8zHtY4WuH5dQsOKZQF7ih6jl4ugi1V15M+XHkWlnEtShZkJJkkPQm2rYbJsuR
 IGggg==
From: virtiofs-bot@sinrega.org
Message-Id: <63942.122050512345600121@us-mta-260.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  5 May 2022 16:35:22 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: server: Replay FUSE_INIT_EXT on
 FUSE_INIT
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, the kernel applies `InitOut.flags2` without checking
whether `FUSE_INIT_EXT` set in `InitOut.flags`, but this could change in the future.

See: https://lore.kernel.org/all/c63d9fdb-a980-c151-8a14-d62706fd17f8@linux.alibaba.com/T/
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/114

