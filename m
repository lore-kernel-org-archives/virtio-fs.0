Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1661947894; x=1662034294; bh=4k9SHeRwCLVvtVLegCro4
 d/HDlYKO9kltZzaYzQQAPM=; b=l6NNmDGNDGxGGSOMoD1Wk64EEVOHOW8zNDFJ9
 6x+qctc4Ql1GywwdUu/UzDXK4+eZwAFUYp0gieD/xDZvNAu3fnoXjGZNAK9tooAT
 DxnpEHfE1s+yfdZoNrpDw1ZeHKOBTu0N1k4lUiScyr7uqUcLlaAX4HY4uSlAvPyl
 sdDCDXLKVBeUrUK7GHf8EcfwDuwXIX4yzENROwJjm89ss7Q0z+vbCTiRDFCuFfwU
 RDNjA9q/TgFU3su/HsiT6FWSksRYoKFmUj65doo+U4fPmnrcWAuU0egM+G7QFhYC
 XNusJCPI4GBjuSWnolosrQEF2SFoGaVyH69BeJcId11qTW1Hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1661947894; x=1662034294; bh=4k9SHeRwCLVvtVLegCro4d/HDlYKO9kltZz
 aYzQQAPM=; b=YBz74s10lNg1eEuOYL5z0lvhEJLHdE028mNTCyYHCJ1EOShpVIJ
 CiygzvXgr5T77D1lXRTGyZt4wHiVDzjkibFpv2FvYSo0e99/7gNc/qoefWjM3HVS
 QKt4TJeoyjBZTUik8eE9XyK00Boh09YAtya5411SI6vIb5LCZ88fq2/aJu6OuXm8
 +5v50lvaFXLvwuGb7EhVSEjUU2JTQfVgS/GcrldmOtwcrx/ERWyswLTy+2UQyMA8
 dfJyinitxkpqNyQ5IL1FKjPMQfql0ro6dUDhUVZGqVJteI9r4fXhMJGoWODg9N/E
 nOFIMSfbs8XaZuEzddvn5WfEwT1rWprfL3g==
From: virtiofs-bot@sinrega.org
Message-Id: <22162.122083108113500167@us-mta-352.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 31 Aug 2022 12:11:37 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Add fchdir safe wrapper
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Continuing with the effort to remove `unsafe` blocks, a safe wrapper
for `fchdir(2)` is added.

Signed-off-by: German Maglione <gmaglione@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/131

