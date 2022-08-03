Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1659549791; x=1659636191; bh=fiZIP2gowrHvZKMF7r0ny
 VAeaK7/dxkqIhND46lg7GY=; b=FLBEYOKXHk0zn04hgLxng4vP8mXc07GK5eDrP
 qu9mZa+eqET0CtpaPSNe1xC4tPoRCknxdJ+G7SqoENgg9dTGg+StnnNEJr7m9cSK
 ubbyz3TXxoS/CPteP8FVMpLjl4GmAA1AV1oMajk2AMeqA0BAUVVT4/vDrE3eC7oE
 vbmXX2exp+XEvrZORpB2IPfHGSISn/GTSmCHrDe1rjxuFFw/RcvNQr79M5gJtwCy
 eGUiN8w6H1G9b2JlF+I8NEoQ1jhwh0bGALYR64OIS+9ifoyrvu2J9HNpoBd0qvVT
 9mbuqvjhjwinudcC31K6ar3cEHRj89GCncBicklVeCjRiPjMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1659549791; x=1659636191; bh=fiZIP2gowrHvZKMF7r0nyVAeaK7/dxkqIhN
 D46lg7GY=; b=SVY14MnSLDWW76DnvpQsF+D+1/9qsO278V4yObeAujlZiOkpX6H
 CGg1Ag18cHxmhUr8+46jS4sJioBjomNPsLHucY8iaWl4GUNP1KXttpiC+UhU34y+
 yfObAvogJSY/ZeMRV5OzX5OI2p3GdPHb+shBI4kfP9iVgLRsP4ppaXWA7HBqU8iT
 XgTfhBp2x/0+kJAKlLWaVX7zCPc9jjgiN044DrWmeQy+Ft+xdcqJY3Lyy+PRLpe2
 NTByVeiswyMi3nU+2S5KGPEwEnlASImp1UGS/qGhpSHCVaFcCBSnXDNWKNCrjXBM
 7lC+HXirn4p1loA7IzBJseJ9dvXgZyFAgsQ==
From: virtiofs-bot@sinrega.org
Message-Id: <13140.122080314031103123@us-mta-620.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed,  3 Aug 2022 18:03:14 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Bump vhost-user-backend and
 virtio-queue dependencies
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Updating dependencies to:
- virtio-queue 0.5.0
- vhost-user-backend 0.6.0

This latest virtio-queue version introduces a few breaking changes,
which is why this patch slightly updates the code.

The latest vhost-user-backend version relies on the same virtio-queue
version, but it also contains a fix for proper vring initialization so
that booting a VM with OVMF firmware works as expected.

Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/129

