Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=8teeNpjXrkRE3k9qjwUN78Cg2gSvEelyeNj1X0lJEAk=; b=m
 42V8QmHpwgdbhcomoNGC6hLh4OecXpBhvcrVnv1lMNDFTT7Emr3CzelPvDJbt47Y
 2oU7FRKkUYXSaOaO+fu2yfvH7JSoLq6wCBMy7T8fywR4YQSoHhRpbdjVa80P9S6/
 QiAIZT+qlaTfdVWBt0/2WsIkUUek6anAX4mwyxmrFzY+ADd8PvT/9BfIgahLqq1D
 W+mK+7cmqu1Jo5mMQUZL49t4yguo0oBDabHnOGWh61AWLoiTO0L9HsCiy6UI73gx
 230Q6KfiZ2njkRNp9GG6v15fVn9tW9fb+zgtZcpFlSToHY+tS7MSz6tDwoJaR5/3
 05zVrBjzKdleKyVZYMf7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=8teeNpjXrkRE3k9qjwUN78Cg2gSvE
 elyeNj1X0lJEAk=; b=ltMGHfIrV0tb4uwN53HFmfH1uaHytZWyTLBlnBI5s59ZF
 j327eKiU1SqdtU2nphFtwJ0gwhhz3ZO3AQkHB7HzxmWiQpiSrZIJkQTXN7tHlvFT
 BNer1QrNXJ5uTKsNG40S9D2pSQCe54btFNwg7Xg+kdp3ppw7n3jAFrKYqCJHeisk
 rYe2J03nhQe9DIxIAkw+ulUwQ+ssbQcZpX9hjGAq/fKTGeyQ7aJ87ebRvY+lam2o
 V852JaCkRI8JdaEOwZf3LsBiNP6aoDnE4xA4hoMZXS+DUNxoBYBzjCGOazWlvwzU
 kEo5+H2cy3DGOIUEETZddu5wQa+J7tv+0krMWCSXQ==
From: virtiofs-bot@sinrega.org
Message-Id: <11758.122030907041800267@us-mta-206.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Wed,  9 Mar 2022 12:04:26 +0000 (UTC)
Subject: [Virtio-fs] =?utf-8?q?=5Bvirtiofsd=5D_MR_opened=3A_Add_=28and_pr?=
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

