Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=8teeNpjXrkRE3k9qjwUN78Cg2gSvEelyeNj1X0lJEAk=; b=G
 9at8iOiTTSAgDaguoLz3mYfDSNG7ZPXsMNJaLt8kBbnMVqC3Jd7oC6It0K/sUpB0
 OTBle4gj29ot6NcXqZz458lycu/SEkRxMsOxfkujPOuaUXmXSBzRCw9qim5X0G1X
 n5XAGKrMGYVUOUwQqC3+ZiaxIhZyhk8tVGKRR02OGpmlIhgLTDtUP+C/gyySMmlO
 qOEZZ8oPcM0USqZu3XY2z/YoaljAT5PCboi/ldAnk/TQUCfcNdUF1u7CtdCWFs5q
 5iRqPWLCM/VnUhgrkZEXGpMDF8Q7i5MrQKGw4IO9XOVC6KMPjiwBWOyX83fnso0j
 4wOwhhgJE/6L2QjnXdCew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=8teeNpjXrkRE3k9qjwUN78Cg2gSvE
 elyeNj1X0lJEAk=; b=LBIHxuQEramvB0I/5G+lYzKo0XyrAsWXCMkC//TA1aKi8
 2fcGJB6Rd/zzWB4PFfQ2y3NcGontQEpncQdcV2ipHeQLdi7dB7fxtCys+kKDpWZM
 W8mM6Fdr0UHtYcs8KitH7Ti900ZBPiB5isYLwHALvZWTXibVfDiA6c38KQUe/gP/
 uxEtk3RHiHfJGiqTjA9b4jaH7pQh8+qJ4eqnvfqfPsXGdr8fskLVYS2GIeC5mQVy
 cZLlz0QtqPeREuwhJpaQNn+tJJ8XViID1fC8GQsI7NxnbYQ2+oAUAPvfRvc5K8wJ
 w3Q3TTVgsntWYZetVH14x2R/jDc3oj79tTBEYlaGA==
From: virtiofs-bot@sinrega.org
Message-Id: <78780.122031408053400176@us-mta-505.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Mon, 14 Mar 2022 12:05:35 +0000 (UTC)
Subject: [Virtio-fs] =?utf-8?q?=5Bvirtiofsd=5D_MR_merged=3A_Add_=28and_pr?=
 =?utf-8?q?efer=29_=E2=80=9Cprefer=E2=80=9D_alias_to_--inode-file-handles?=
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

As written in #20, the current name of the `fallback` mode for `--inode-file-handles` can be misleading.  This series first adds a `prefer` alias, then deprecates the `fallback` value, and finally changes the internal `InodeFileHandlesMode` enum to call it `Prefer` instead of `Fallback`, too.

**Note**: Patch 3 will conflict with !96.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/100

