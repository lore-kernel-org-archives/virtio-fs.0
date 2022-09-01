Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1662033255; x=1662119655; bh=iOGxzJMkoElZjdPhiKHx3
 8InVVPdoOydOU7Ma0CQ5ls=; b=P2dJd1jPi9MsfLyoENV6unrjwK1fW1RmbSafe
 AJ6Zm56QC+xxLAuhRr2SnAjCwCZu6c6QbhVwc+ngMVPw4acpwXrweRo4tEigKu8O
 +yW4k7rhgFOvqySHzKcKyQs9gbccq/nhOSDzH2y6cSfdRct6nIiGSprqt39mpv8+
 vXrqdLlPm8cPR0mlbPpigrXP9NooEqPbuyF3t2GK4uxWIRq/dw1BIuK50+rTCT/r
 Ctwhv+uQfj8NFE/jFy/fPyFSL17qdCwi8cMc/ZX+QVfbCRcOmjsbgNk/NYQ5V5lB
 4Mz+Q96bzcTjXoBPyA5QXFyW4yWUpgUf1XgtK4tKqOUgFhCBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1662033255; x=1662119655; bh=iOGxzJMkoElZjdPhiKHx38InVVPdoOydOU7
 Ma0CQ5ls=; b=ewWBY3nCEznjbtApnR6d0/g1jh/9bGe4CtNp/43b7yWmOxfCaAL
 ++9BuQw18PSpwjxeOwK7wJCiufq9RW2wcZ6MMl1aj4C+e9rDqxiiIzCViFdL4TDE
 /O/rnTNkVi2EsKnMmaOcXckfvK80qNCobyBhiow3jz3Tetl45hMVPWg9vXdqUDJB
 2DYjGcuIBLPx9MprF6OuF/4j625b87uBDruTgwLNRiYo7kQFv+2ZXMSzSUI0uhh4
 Q+JlpX/6iSYQovcq5RMaYuLTLZM1YfvxfBgSe7ZoD8O6+EjwpGnn6KB+GC1sd4yX
 h+gKjlVvPqjf0/hZlicS494O1ktcnw6Hcvg==
From: virtiofs-bot@sinrega.org
Message-Id: <80366.122090107541700392@us-mta-629.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  1 Sep 2022 11:54:19 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Add missing license file header
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Add missing license file header BSD-3-Clause SPDX license identifier

NOTE:
There is another file that needs a license header `fs_cache_req_handler.rs`
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/133

