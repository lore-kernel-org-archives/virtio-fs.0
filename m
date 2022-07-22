Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1658484414; x=1658570814; bh=JJxb8c/26uVLP3RUglAyu
 5TC4wINLGKiioPdytpjIAc=; b=OUDxTjF7SWV9AOC6U5kd54npCU2nmKICXqGYp
 IKHdb2tNwPyClMr2E2Yy18uzcVBKpdokF7IpfkwvQInco4FJTQwFeoRla8HLTBIl
 uO7lkEe5L9FvC6lPpnWSao3jYzw7287+KZkp+8VanWsCbOdWb+HGXjhCE+8IRTv6
 jPvto/zZbO397zHUPHxPQob5f0g8yolbMU/FZ790MyiPWzUvzsIJan68MkZqC39L
 FzWt5zyXiVAu0Ejrd0cTgYRDlsShtSTS23faHHYztjK4b3Cm7K6zWuN0L/WxnFJ2
 oMMYZaseLv+0WmMf3o52frhQm5bddCUSMqnAOeln6bEFREj7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1658484414; x=1658570814; bh=JJxb8c/26uVLP3RUglAyu5TC4wINLGKiioP
 dytpjIAc=; b=VcHSaxA4l2Ba29B/bPB82/reNKMpUAl/5IuqpGnwAJilurgwHci
 q8uIU2ulYvVc+TGkLRS/e/XIfGmLPaCF2Dq4Ghht+oqmyk3RNbuSAU8caPpV2HUP
 mrNf3tLxP1/TgZyNSByxpnMvwJc6QbHRqNAV2A4Ox+UaGen0oUIREFC0KaSw7kEt
 zF7OnaHjrGDnH01He28y6HXb4fKB23MLfwv7mWmE0ghXXHWUAHgA1XOWR2XJ2oHq
 DZyL6g9Smze8/CwJiQYMI5ix3tmLjK78eJXBGQ2+L1PDsREzjsjHkOiaN0YmC8WA
 0JgWDZImlInjzxsEGoBhdKdvHCjLDrDVuRw==
From: virtiofs-bot@sinrega.org
Message-Id: <92059.122072206065500395@us-mta-154.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 22 Jul 2022 10:07:04 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Draft: Get ready to release
 v1.4.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Updates deps and bump version to 1.4.0
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/128

