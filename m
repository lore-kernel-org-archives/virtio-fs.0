Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1667923459; x=1668009859; bh=f7R7wWtM6WEfmLOMp/io7
 GrVayWEjYrQ6LwRCyGC7dU=; b=fJdtbiOld/TL38YsAelAxqgpSkGaa3b+2jPC7
 bI++h0nGOwlQ86nUoqN9xxUeR/9Ulo19gPpwbJrsuLGQzPLKRqBDreg2kyXTQdUD
 BLhZWYaghFyb5mrjNbY+y+hLSP5q7O0cjl0NaZr6al3x0kO/4GHoaMzq1fbDqyPS
 tIIqdYlu0+E6O28SFZTx2z639GMSb8rOl0figviiJ1p6Vbz06594H9TBzSb1GGV4
 rXrQSIkR1VFRO33lST6MIz8W4kQd6bbPcbfHRBZ+ng27ykKznNxH4pyzE+YW2FBu
 68dgsQ5aS44r3okC2ndXnbkmfYjzmuyFiwrZxITWwF63yf/GQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1667923459; x=1668009859; bh=f7R7wWtM6WEfmLOMp/io7GrVayWEjYrQ6Lw
 RCyGC7dU=; b=EkheVfi+WhLyvcA03sNlsmS8Kg09IBQcTUub9f5DBgl/EQKvCcy
 Ex6hygifcDY0drHA+2xMOowcCZt1pFgI8MwWk/8jB2tvx23W0ZRIv+at0FH5jsT2
 hjJljXJpiuCh5x7EXDl1Zi2Mv3wbZh2ad/Pct26xvWUELDem8dc8z/d9YtuiH4UV
 6eXOqbav1rNtlcUN9Mqg+UNcTfhLdgKNQIv6is5z6NkVg3Qt+OZcmaAXZekPahms
 NuOVom1Nv8bZWq8X1ULYriAK5WscPepJrADcoLegdGsBccxeTwlu1HEdpUK/1LKr
 DDgSc5jMHnfZRJOB1PqsjMnlq4c7AmPWqJQ==
From: virtiofs-bot@sinrega.org
Message-Id: <59157.122110811042000677@us-mta-244.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue,  8 Nov 2022 16:04:23 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Keep DAC_READ_SEARCH on setxattr
 with posix acl
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If posix acl is enabled we change the effective uid, if it's changed
to a non-zero uid then the effective set is cleared from all
capabilities. We need to keep `DAC_READ_SEARCH` if file handles is
enabled. This fixes the xfs test `generic/375`.

closes #56
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/140

