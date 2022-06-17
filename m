Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1655445729; x=1655532129; bh=NgdIdn7Kp7n4ARx5Ai1PR
 4ugTnsoukzBHxOYzB2KPog=; b=TW3juxy++z6Q4OvpJjHbloWu2/X+rYIIdbuJB
 JgDI2cnzMdgsgZvM8O/Tu4xtak0XsFxZQvWUTgqWlIUNZK9qEb8eXaOvWVGQSNaU
 8M2TMtE9HDC9NWhyR13Z92bKkeYvMBZ63oCGW/zH1Gzoq9NnrkC4PYooUn8xiaKh
 GAu8l5S50YPuFGf3r8d4LCDjw7sFhzPg4RC3E8DtdX50ZZsFAPQqk6yhoHyWuFli
 8aiQb+iSo2QZ/CDO74X9fkXX0y6C9AaACeAi9BdMNbci50Df64JwSBIuPYELP5b/
 I3UFsJi+Fjpf5LXqY2q7RBzPLe9b2XREbSD2SkLk/+NTvJnmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1655445729; x=1655532129; bh=NgdIdn7Kp7n4ARx5Ai1PR4ugTnsoukzBHxO
 YzB2KPog=; b=lVwWBshBQxuu8S8sDb+rMXoWH+M1lCIpzjyptOgE7OKuZATfQG8
 0wI7p9h+4CPdINxY3BBYMMn/apXaTuThxU73vTjWsYZq9UhnkUzO/yaRQ50KUni/
 VS1JkIv4PsSciv6BuWgEh+ckIHxxvKwKq4hE5zfvNvIuRM3/pMFtG0Q7gWO1ntm8
 T1a6G0Us4CDHywx7m9n6cFJWW7WC8G+g4sxiRdSJQhU8TgsbAUQxwYL+5YMyFJwf
 D6v6iFI7cUoJrIsMNko2z5EZP2prokS4wAtAuUFl14Gj9VN674TDO0K2tGypuZC4
 6qU9AYZk9MK114dn/QB6FtvZFUTioN+C4Fg==
From: virtiofs-bot@sinrega.org
Message-Id: <64472.122061702021100287@us-mta-70.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 17 Jun 2022 06:02:16 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: server: Reply FUSE_INIT_EXT on
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

