Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1660125809; x=1660212209; bh=5Z98L7vJlrMHhcRJS6uwj
 fskNsumv0OUPJekcY0jGEE=; b=qOFv0J2fn9gkenZ6yH31ce/NbtP6+IOd6cTTY
 PxtqTh6DGLt9XuqOKbH5yduAnX3v5aOoabBJyoHNJq7eKYuBVPUarhDc6L5pZXIn
 6t5kWAYOHLHph6b03mJnjbjy4euImzStS6e2nBAsWquTJ2jMstURyo4jIK5+wbnJ
 bLZHJ6o9lW2RrjFSCMYQBlRc1yFFo1z7Hp73gf+5qF2PzgjIWjUfTxQYvC8Ea/ea
 iia0D3dA9HNvjzDVnGgl1kyRxI2sBCh6Zgbgk5BwkczTa+SQpK76x8nu9N+RJW1h
 EfSgFQxyoDNlFT74/gQtFIrYfibW7pOZPlsREgfOqTYnD66ZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1660125809; x=1660212209; bh=5Z98L7vJlrMHhcRJS6uwjfskNsumv0OUPJe
 kcY0jGEE=; b=DY5YvwQluM5dBvlV3tjpmNwbeyVgbP9T+elGHTMFs7EW8VX0eSW
 QNqtN7of1irt1lmco92X9S/F6DpRpJSvR5yktxz7/v7TsZmyhwEVcWZi5oZiUojt
 aLuby1MklbIZ5YKYwOJ/Xm7UyY/t/F2/aXJ0a55vk6VUVZ13JC3XxFE+7QausCEn
 Kx6on+rmS61dlnmA8Avp9W4hKKhUMUVp2OfDOKRTDBaQkiLmCYwEjwOBUyVhwt5v
 j9omj68eiBwU9ycTxphjDD84aoF1nSoO2irhiQDFMssZrOaa0pzrzYeXGxN07/mG
 5q3GSEibmIw18yBELd+w5PtbXqleDbAoObw==
From: virtiofs-bot@sinrega.org
Message-Id: <17993.122081006033100547@us-mta-38.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 10 Aug 2022 10:03:36 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Question about hardcoded
 number of queues in code
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The number of queues is hardcoded as 2. Why is it not configurable by users?

I am wondering if having more queues can make the daemon achieve better performance.

Thanks.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/54

