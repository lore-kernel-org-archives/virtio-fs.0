Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=oWbRrBw2zQOKhJirFid/ntT+HAzuhENI3opgCczLfuw=; b=g
 36+vemLo8CZFBYLfa5lLpus6RABVfOjea6XtrSFb9GMtRvkIqcNPAQgZ1QM2xR0Q
 ejFwVD1gD31HfIFOgbD+ZMCHJtp2I4eMRO7Hi6xDuSeBQ30RIxxdSHKNM+KvhAch
 8tc1mI+ecakJE7jkT0nzaV7jLEHncBoQSLgvroNp6MzGSddOJf7x20CS2fiLCPZ0
 d8qUC7s4lRLQwehZvE+i2xJGXPE9S1EcT2TYBg1u2YidMoptNXwHNyl3XqBaYv5Z
 08iA1gIK4K8KtXfRb5q+Fhnhy606toGUrFmdCmjyYzyo6ALMiC/FYMCxJb0Y36yz
 cs5wUD7UulOugmZv9ypTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=oWbRrBw2zQOKhJirFid/ntT+HAzuh
 ENI3opgCczLfuw=; b=FmShM/56dRg76yVEUzIBm2qCRMyu4Vb37s8Ln0l+A7icZ
 z203Ushu290a0x3ZPnhR9BWPiSHOLZilzI6g3bx74pS7aaFf12zFCTm0qkISL1g4
 TrdHOa1ZILlRYs3pyfv+R/s2rytHK349iuSw7hWizCckTy2l2SJ9NWtxVBtbAHrR
 UHgWqNwsUUjWjMX4p1HOHuA6aeSFigkcPSVhZiYCw3zrFR2puR6Bc/1rbLCuhcuw
 OkPZKJ/vckveC+zaFl4OSt1VwBYxr6RVUVTeazZiqoXI6fCqPNuspZQLLhcsWeoZ
 kAJP14+MDLEjG3vwzkoS5W4xER1Or4fc4bIKAfVuw==
From: virtiofs-bot@sinrega.org
Message-Id: <12479.122032111552201497@us-mta-83.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Mon, 21 Mar 2022 15:55:37 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Add statx musl support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This MR adds musl support, adding the missing bit to make statx() available for the musl compilation target.

And removes the unused stat64() function. Currently, MountFds::get() uses statx() without checking its availability. But, even though PassthroughFs::new() checks if statx() is available, stat64() always returns a mount ID 0. This silently breaks '--announce-submounts', and with '--inode-file-handles' virtiofsd fails with a cryptic error, during mount.

Closes #27
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/99

