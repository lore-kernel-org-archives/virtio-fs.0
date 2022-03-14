Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=BNnE3HpM3Kz2IPMF9+K3CNCl3RrbJeTWsOeOZeyEKy8=; b=r
 csn8c9oexW6bqiiyYxh6BFv5fR2m4tA11uw/19y2mS4qEVSJNTfH0HdJyOYoid8X
 rM1xuOuKxkD6vBphRw/olnGl25nZaOV65kogHAugPPsYrH5pbKPrFXQWWNnV72BT
 QwXuTzQLRpiNvATOpWIQR47J7VX3papw19tMQ5khDED1eBC67wz0shT91/SoKGbr
 qjp/W+whk6uVTqOTurWBzknHhT621tFoElAvj29LGS33PvcOVv2LT0nltQUceRHP
 J0FOOLjab2bOM5ZlcZ70PrEOBDgmQsV6SPZHBc9nJ2/E5Y/eYc0H0sfcYrtp1BKh
 bfiJyAApu1jXnjzF32UYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=BNnE3HpM3Kz2IPMF9+K3CNCl3RrbJ
 eTWsOeOZeyEKy8=; b=RsoN76eTfMD7FNy3HELJbXK0MH/vFhZfM5sAyPZ7MRgk3
 03ARgl/XdY5u1Wskv1BpN3F1ArB38mNqywqV9l4OIxcX8fm+Fm0sZYkBoY5e6O+/
 BZ3XJCsRqqmOING7dqKCE2VDvaEupS3SClNXy25bCl3YfQ1tOBF9Febv0J0opXfx
 4VVJcgsxSfvZ/QeDSaLRkBt8KlG1gG3khuCQRe7AeZFa7Hs0KCt4SDs7h6qYk1BX
 w0Nkbbvq/KVNqa3zVbclJaEN0dbLd9+4/lWCfV+NQ1QpYkC+rA/uvjlLBQ1h7+Oy
 PkFxwV1PrhUx/zKMPZcUn20G4/1Gr6/bj1WcmGr+g==
From: virtiofs-bot@sinrega.org
Message-Id: <30437.122031408050000805@us-mta-626.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Mon, 14 Mar 2022 12:05:02 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Set edition to 2018 in
 rustfmt.toml and update some deps
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Set edition to 2018 in rustfmt.toml and update some deps
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/98

