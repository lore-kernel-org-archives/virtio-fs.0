Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1666158820; x=1666245220; bh=9JoygGHduEMC147ibV8wr
 AQ9axkyZ6wQ+shfNRr3gtw=; b=OJQhmtFphxzVbgyF5erlF0559WlRR3e9DBxQC
 iq9y7weQTEKMmftxdz9km7lyHTDFTPjkNejC/2qObc/FXSHvfSKvxtdekN6ODVF7
 ZbD+2V6EgvkyHqz5NwYLWRhYtBCV87ZxzayiDY4VsnNKavLdS9uAeYo0AZeDQtsA
 I1dZvXG2392V911pieUH8Iu0OGDIxixbycWKYZl4rb1Q8mTGMgiScL1SuAbcEDaH
 wJJ2epyfZL/pPZQDr8sn3MEDI44gB3SYdBvF+baE9LuAxscFf9eqo4huiaLpo3tx
 Qt9PJ0fMMKzeuB8SIxsTN4CuzJiQ0zgvZBkhLstqGeweTqBzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1666158820; x=1666245220; bh=9JoygGHduEMC147ibV8wrAQ9axkyZ6wQ+sh
 fNRr3gtw=; b=gT/4aiq4jxr5N98bCWkHrD1PjOQaPjX+1bVqadJu+JdwRvpMmjt
 Weqe/ua/zHCCzeSyACUHj3W1buJzS1bvEpbm1282V+NBg9E8khGiPuj4eE6PwUNa
 SXGIkJhy17kD65zLnTfNaZYvZOLeY13eKM3RQGL/kOtT56/Kz63E8sl57H6DShF1
 tgV9mCeBFvoHLXYp5CyKxZf6PaVpU5l5AeXsqzpLLd/kSYqBK84pGNgW1o6bMsi/
 Gl4+sLqQk2N0TjZRxHJ7qby0Bg6hmhSpNR8u9WlaqE2+94nl/Fe1NiszkQcG4FJk
 ML20+xkNoz5PMIgQ1A/Mu7WPu4mNNy5lYpA==
From: virtiofs-bot@sinrega.org
Message-Id: <86078.122101901534100168@us-mta-397.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 19 Oct 2022 05:54:07 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Add command line documentation
 details
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Just adds some details about posix acl and security label flags.

Signed-off-by: German Maglione <gmaglione@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/134

