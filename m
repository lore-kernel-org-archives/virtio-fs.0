Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1653491400; x=1653577800; bh=BQ8Z96znvkVZhDxKmXZBq
 Ac4oRi+H1r/ollbC+6rqa4=; b=Ud9mO99deO95GSoqOq9rYqFc2UqTE3uQZ4K6T
 Fam7zbVAEHRsFjwXYvsYeOxAWG41U8M2kLxUH+3/0vPebsWPmMbJeC20VYgXKEWB
 oSH1OyQZ5QGbrbJ4w3hgoCvn/kqM+VVlQjF95NHrG5Vu/AM8wGdQG/yod3vMPOe+
 MOD+2tBGw+ajDY/AcBXVmx8luegqCE/2ogyUVA9TaNj5ez/oTja2nkpuN24hxmgA
 bSPiUYwzayMMUiZ1TCnmJ65NbE0RJ/fuktJkH9hRfqPDJUtlLJ5pp73SBVTYDVBB
 OqicmkZ+4zSDHePHhadfJ00QKa9FA5p9w3M53or/ZFtwXffFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1653491400; x=1653577800; bh=BQ8Z96znvkVZhDxKmXZBqAc4oRi+H1r/oll
 bC+6rqa4=; b=qadSaWOG/ml0KBudm7ykaoLOjR5UubULMemuq4HYBp/Mynn2QJY
 SNyz3rEf4wHYF1F42xsmFfy5IMp6CMotfyochrqiujX4eSrt3rbtf2pLGnemKk/f
 LLXf5hWnuTktPa0w12RXgw7ii5sxYVFThz69y2DeVWWfqdmi/ZVy4JL/EjrZwnHT
 c54e6YYktHwczQD2wjUmjKw/c6muG2RWMVVIadvvzfhahXvpBv+9y54Igu7IY9P2
 xPY/TevmtNdXtQUOud07W6bknwK1sUzIykGepM8o/U4XT+7Lt4iMwZD22w6jyEVh
 3gKm0gVbA+8OZHWBNmxvFKP+XPFaihs01og==
From: virtiofs-bot@sinrega.org
Message-Id: <77739.122052511100102079@us-mta-630.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 25 May 2022 15:10:03 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Show the nofile hard limit value
 in the warning message
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If increasing the nofile rlimit to 1M fails, try the hard limit, let's display the value of this limit in the warning message.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/120

