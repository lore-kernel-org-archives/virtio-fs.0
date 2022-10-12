Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1665558564; x=1665644964; bh=bZEnl2YhL/VjJMjNuJmFu
 zX83/79J8sEUf37KrbvzKY=; b=jOcZQ3xOWw/wvxhU9ktpVK9GQzIL/aeaKo6NP
 vqVW7ETiW9GfdoHo5eRHIqqFGF4gCiAVfexcl/BLWcPOJRsy+v36kpP4hs/IONKw
 KBa9bhfk1ITm1aTPM8WW6+PQaygM/T5o49PbZCp5bBtvCjyupTYRl5T3jeMR6YCr
 n02paBfoFoKdcFTu8yxdJsA6kr0r5P9YOpfBEMZZVE40JU4oaz8CEZsH8fptg9gJ
 zFMSW0QVYBZR5liW5M5RjmR4cu+yN99D/RRtCqtSNmPqhUlVxBJcD6wBbE7K4XjO
 jr6K5QHcmE+NjajbeVJqHujEN4kqmLrXQt8ks+ia1qxYk4UMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1665558564; x=1665644964; bh=bZEnl2YhL/VjJMjNuJmFuzX83/79J8sEUf3
 7KrbvzKY=; b=BQIbYuQAQUZKtN9inG4URQnOOkqiYf6pw/Buk1tQYWinxfH3G1l
 sOQlESQ0gY5M3fCTeskwCcxAJF4sHOkzBwRFyzlm5NNslhP9lpveHPq9LAfLNKSu
 7ZT/WuPw5pcWrxg0J/XmZfRYD1OYs0jEjEk79gF2A+YmIPCHNZ9wwVY49fyZxcJt
 AWPY9KbIc6HporZGn7JQoGFu+Eb8IKHGeBdoWykmrMDNanW7OvWJexCIZSXQLn30
 yDxqDBz87MjIz/OqPnxVo0hxjdp2X4HmBs3V9u9Y2OPFTimse35HYfROel6csyHh
 yyGbuZeE8QnDT8B50yakWymCzZSU4LKSerA==
From: virtiofs-bot@sinrega.org
Message-Id: <28559.122101203092500145@us-mta-272.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 12 Oct 2022 07:09:27 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: sandbox issue when merging
 virtiofsd and Cloud-hypervisor
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi team,
Because of my use case, I'm merging virtiofsd to cloud-hypervisor, so that they are in one process. But I met a issue about the sandbox mode.
because virtiofsd are several threads after merging, I cannot use sandbox=namespace or sandbox=chroot since that causes forking a new process.
And if I force it not to do fork but apply new namespace to the current process, that also changes the namespace of the cloud-hypervisor since
the namespace setting is process-wide not thread-wide.
Any idea to address this issue, is it safe to run virtiofsd in sandbox=none mode?
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/63

