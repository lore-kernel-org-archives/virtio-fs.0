Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=gi04Dn7gR0hQhn/4TOEVj4EYsRBt0bJjEh9m3F0lz4Q=; b=P
 0uUteFG/t0nsuu+fPekZiDDJkMUVATosQ+Bu+Q4bk+bNX33dTAbff5bxk3o5Af0R
 Rw7r4MtF9Y0E/m3w3+6Ms4/JwnCrMJifyPQ9mjoA8PD5rI78MzRJEo4ANVEVlyyN
 E0U4h+fyR0nRTYhIiLTECFWGs+Q/A8AgJVjh4JjskGMUrqR7BBbupJaCbqP5tG8G
 NbKrmNKEkXEsfT8SnAYTBt4kxsHKdglzS8Lf1j/3fddC+Ln90jr3msp29zZhtk50
 tgo8SZHieJoFdqprEjanA4m2eJCv5IleTtUQuzVzp38jruApYXOgMn+xYv7rJsH8
 Qlrf939hmHvZvTv16tB2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=gi04Dn7gR0hQhn/4TOEVj4EYsRBt0
 bJjEh9m3F0lz4Q=; b=H4sADaOKVgvD+kB09Xqk1KlbCWDwtWD+7PJUDla3FLaVG
 U3jN9jiHP3IImIA48NtaQenuxrIEdEnT8RKBXq9uitjHptFjeWL0ZSR1vM5QamX1
 i2W1vtfj9GKs99Pqvh0Mqaa42BSK5kCD3aeA/kEw9f7SVYXQta3nvj53+eKtg9pS
 WVo1QenrGh0TEFz8LeQiQVqfzwJiiXX/BT2ht4DUR8tGXJTDFMqKDDIizA+hXwgE
 HDEZZlAOJyJ2jBVUfphhxNKOpYP6UrpEf9B6Qz5S0C6hB34EqCnWIi/eQCQn/na5
 deDT+/s+A2nwJ8JI7//7koSGR8EXXNIlDpGhZ9Ajw==
From: virtiofs-bot@sinrega.org
Message-Id: <79563.122033117381400383@us-mta-18.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu, 31 Mar 2022 21:38:20 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Add rate-limiting /
 io-throttling support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

We're using virtio-fs in our multi-tenant CI/CD and quite frequently see noisy neighbor problems that can really impact user impression of our solution. We've recently switched to cloud-hypervisor which is [using the fire-cracker rate-limiter module](https://github.com/cloud-hypervisor/cloud-hypervisor/blob/main/docs/io_throttling.md) for virtio-block and virtio-net. We're asking if the same support could be offered with virtio-fs so that we could have consistent support and similar isolation guarantees.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/44

