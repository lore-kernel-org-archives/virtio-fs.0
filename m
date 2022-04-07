Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=ftyNwvA/OO5409WS5LpQuGyfU1QK4Wk02o9oUfQ5Zz8=; b=E
 QXpp4d6O25Tw84z8BrYSgngFofo3Ja/wZ1x+cWjbuSAUevq+0ewla+mVxKGjZqt9
 GlgdLAdWBme7lFaHWQAXzIxmR3hZ0OnBZJ/s4jyoX1PfnSUSHz9xzF2uSDSqeVvn
 TnAXxJ4b3te630quEA4Jn45eyXQ2YJodtI33eyxv0d8yEUxGeqh64kPo6iXdSixY
 LTi7gEAZOcX0gR5kqDftvW/rNZ6WXYFyBMK5FJbiqtL9fygqDrl9g3v5jT5dkrBS
 Aqxf3Q4cK8zbuZYgyoA3k/w6VVDS9hwWzucbkeSaPryV57PhRxl1BSPwdVVPjlon
 jVrlhb4RPT6edG9EQ8fBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=ftyNwvA/OO5409WS5LpQuGyfU1QK4
 Wk02o9oUfQ5Zz8=; b=nA/psap2PLZRNBBL/2DYH5agL6oMoYxSA6ASKq9CO/+qc
 mD915kcBFYlBpYNLWof6620A9a1d1b52sp+idrip7BQWexAGPyDe3dwjgnVmtkLa
 pI+56Ey4sgv1tQXF4Uwz9s7Z7G7/pP0V2cy1bYznNICkVhLy99ce85/+jf29uYxI
 6gr8eltnFdzMBFSYqvlJp9m6CsqKJvDp4a/fNZm9fYZ9rGgVGAaifVSWuz23FBE4
 312L7YzPaOdpEh95SF8NYMkT7noO2kSmrfl80MukAvgeaKVrmtvia/WvfAYnG9SD
 dBChCiLOSNmDGCeRUbEVKCnLd7qb2E0knMlN1b2Dg==
From: virtiofs-bot@sinrega.org
Message-Id: <97989.122040712440600620@us-mta-425.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  7 Apr 2022 16:44:28 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Allow only one daemon to bind
 the socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, more than one daemon can start using the same unix socket.
Although only the last one will use it. This happens because the socket
is deleted before bind to it.

Closes #31
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/110

