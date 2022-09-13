Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1663054564; x=1663140964; bh=TlOttof8FQBBJKrrjmUoB
 8rq07e82h46qOz43RLlYF4=; b=SCAhBHPfgheZMOXY+9MqA8T+Nyl6giKTt3XcX
 eKQGr5KXJwpQEybkYHw27BpvoirSAOUJ1xI753XnySY/72ZkCbQQbM3Oloy1maT7
 yLixuOSOb9it6vQbST8k072fyKqErcend/1ftAB/JPXfGPCHr2F4wkHZg/3FblWF
 rA2qETQsBbWOl7666vBPI31PdhjNXgum8TagNN1tp8D0dPUUNIu0VOvJRpMvvkyp
 CqGb07AZxL4g0Uc/xIPbSj7wJ87BfzvTzwk2YGQfYrkCRNHtJ2odOgWkcJ6USQA2
 lh6Jy6za/hIiWS/a95u4Kxa9sObeNP8thnaPDEN8jn5DMf4cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1663054564; x=1663140964; bh=TlOttof8FQBBJKrrjmUoB8rq07e82h46qOz
 43RLlYF4=; b=RzFyy6rTh9EmHnibkrQ/97Acp430DYnTzXZct9NtpiLVHRXcw9c
 Ic/cwE4lOfOvHvp6/GWMzRNPC4LOeIk+o2kom+10k4GJsUZvcTM9reRwC8AbcTjP
 IKdaLCK2gP4L5qzklipuucM41AhfEjS2X7uxjakegaRZ+QeLnqgrMgiSbYvHPMs2
 cqX+N8XHCiCB5KGyO4VdShcv3LXOlK6ljOj83qBHvilJCQtXSGus7hqGhEABqjkJ
 cxNv+phyi1Et6EFxzb3q5KYHVLJ/aoXR3QIYb96pFk/F9g7D0SpjRKLKoO1Hu0qv
 plOJdlCqyGrXHyQLiMGsXFj3qbzKvMMgd6Q==
From: virtiofs-bot@sinrega.org
Message-Id: <96909.122091303360600320@us-mta-640.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 13 Sep 2022 07:36:09 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Fix `listxattr()` response when
 xattr name list is empty
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

FUSE_LISTXATTR returns a xattr name list. It is possible that the name
list is empty, because either there are no xattrs or all xattrs have
been filtered out by the server.

As of now rust version of code writes a null byte to client supplied
buffer. This fails the kernel fuse code verification and return -EIO to
user space.

We need to send a response back with error code 0 and virtiofs kernel
code will handle it and update the variable argument size to 0.

Closes #55
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/132

