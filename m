Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1654185273; x=1654271673; bh=kNNSRdGHAnYRLN9c8PU9W
 m7gyx16akfaMDn/d0O9xnQ=; b=B3BVCF9esKFWDQ+Y7AuHkHBPpGEG0uCDw7LfP
 tat599kfqHh/T2tnAb6EEWqOfEpv1iGiwTVA9N68ahPT9UuhPlACEF2zUME/I9co
 QRsj/Rw9vWEGumwFooDe+OJlcNYYepADERdTIIc7zW0pr3D9FFMQlICrIdm02kjJ
 Do06btPOK1MtpzXHR/uuks6Bse6T11AyA6bQcsi2h8SUOKjSqjgC8nOlAZvAN7xI
 NMxqrKi/WlNp7tJ0wybGFz7fFV582XlHyUatkTCZzsNtSYrSiy2oKqPEkP+onu+c
 E/Pu8jS/HhjaxZRI+4yJFsZ911fH5tbv9Z1H6DVjJ3hb8ZZQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1654185273; x=1654271673; bh=kNNSRdGHAnYRLN9c8PU9Wm7gyx16akfaMDn
 /d0O9xnQ=; b=YUtpNTGPuHXA1mrHEOtfI3FJn0iUDQdTiwRGyUpCPJEmd8uz/cb
 7NIq4d8hvGRWPKNKO0auDoQV+1u6pVEgxgPbDjvbaS9s5c1RXu9q/O5uR+h31mHI
 rxM7L06ygdpS/bLcwy9keUW0bqjFsr/PYwgT+1icaqLku/OQJfbs216IQ/vUUdgz
 SMv630/7f8dilhq+BkfhhRt1jlo1K5iETP5Jwahkpi3E/+P6/KeTbgXQ3wsTt5mm
 RORmZONq5AXzSIeOtFgVGpNyU+a/q0oaqNiociDqvzZK+m+CNvSsj7FI5AUYPWSP
 WJjwvXwT5z8LVKLkYEpHfMUQj76B6yddAQg==
From: virtiofs-bot@sinrega.org
Message-Id: <55781.122060211543501190@us-mta-522.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  2 Jun 2022 15:54:37 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Update rust-vmm dependencies
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Update rust-vmm dependencies to align the latest crates of the
vhost-user family.

While there, also update the Cargo.lock to reflect the latest status
of the dependencies on crates.io.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/123

