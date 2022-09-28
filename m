Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1664348552; x=1664434952; bh=2nyAv5JRuaAxqOlLZLoQJ
 MbBGMLg3u3QLCSClnrQ1kY=; b=hDFtNXVgk1ba4p1Mc5rCk6bFTF3vk08EyxOTY
 +/Y+/WklXJ5aWZtl+HZjSaDzZOoGuF4KPUnSPv/+RVPLMRuE/ExEAJ/qWHfaWjSn
 ptSA47n9Aiz1OWogmXXqtp1BcKt8X7J0nkrpsX9ttcVmdP/vFOf76gK/OkVqVTyI
 WTUne0mYy5f5x+av0UIF5U71wr2uTvbbvqnLgw5KdGhBGnm0CjYCHrrVc7hbcgK7
 0W5cKk2mV4xN55Vpt7VDb2SVQ/cku5LUFIlWk0HokaHwyvw9RpFBiK8sN94cSuxV
 Mem/4UGhEB3r69J+ILR0KyNbxviq5/dgafSHAr9PgimXyUidg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1664348552; x=1664434952; bh=2nyAv5JRuaAxqOlLZLoQJMbBGMLg3u3QLCS
 ClnrQ1kY=; b=XfMZEdU5WrCvupcpx1VGQ3x9r9IixY6ID8h6eoL8UrGvdW9nvG+
 ZpyV2Z4eF8+VEpXyJkk5Ql0pJTbjFLdbpXc+s1EywiVUwOxhqB6LLRtvbAq9Os0p
 60BFcbhprPZgO3EzDi8XpwXul0cnrTtKRuhQBQo2aWZRQJ3OKQCD+JWw7HkYOTp1
 vk1jYuESRevqOmF4wabpf5UGQOEzOLpuiyUY6lL5PDOorz5kwBtfu0XKJxvOmyFg
 /DeWDU8l4SYDfIpUohOgBmlOBGroF9fs7FZAl3yxYgOXO1wodgB3mab1dlqlhizl
 7gV3tMNNmZO64iIiUW1ncGlYPJG/bA7AU/w==
From: virtiofs-bot@sinrega.org
Message-Id: <37382.122092803023200217@us-mta-92.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 28 Sep 2022 07:02:35 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: What does --cache exactly
 mean?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

What does --cache exactly mean? My understanding is there is no page cache in the guest kernel for virtiofs, so this option is to control the behaviour of host kernel page cache. So does it mean:
  - never     each time writing to a page cache page, flush it
  - always    don't flush unless the user asks to do it
  - auto      flush page cache when close a file.

Do I think it in the right way? Here why do we have --cache=never? Seems it doesn't make sense when we are in the passthroughFS case.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/58

