Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1649688579; x=1649774979; bh=X0psM8mOPC5tboc4ALX7p
 SxlL04I+h8MQinfw7nvcP8=; b=p/8DnXYeN2tll3V4bTVfvaRZ43bUUDQXvcr02
 aHkc34DYp/b9l8rO7nat2iHpCSpPKthISETCdKeEBylYa/5ZxVONcSvJJnX/flgk
 jJGQCIZCsTDsslHQqkzgEgg/hjGgmskB2peip7a4bdMPfOrX89VNOYkJmbkL2rBq
 XciW8cQ+O774y/aa/BxfEtNNiACbLD6zXpyrb+eOgZGldyoUpR6+OS2oNN1oknkg
 ZIajpsntAamgegV08fp5f7ckT4hbvPI+lEGw/64hJPZraARJOgQ/k7wkbNOwwZCF
 2sU++zntINF6SZwNFEnkoCjNup6XqM8wyL8pz10FO3JDTZ+nQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; t=1649688579; x=1649774979; bh=X
 0psM8mOPC5tboc4ALX7pSxlL04I+h8MQinfw7nvcP8=; b=je/jpwxhtLlOiUkq/
 g8IT6zHU2oKYbILVNJ6u1mzN3aNo19aRhkpoCZwXXUk9vlQd9COD2Ca1j/fdCqE+
 NqD2wVfYI6dOCqvbRIJoqoxX2ZzGKJPPUzbZy5axQwNMTEUQM6lyXA5CRSX+W7LR
 PtBt2rz8JKTBo5vClX2JcHEt0HlF4xhJ7WLPANBmvnBbULBwB2ZUFwSmj2vApoJM
 r18r9ojoheIqmwZYtDfr8BSVS/cSpOBOtajIlE2zy14t0paRvrbhu1lKlL2II3K+
 gW2CNvfFDZQsqrrMgmHf8xoRqUvQ0NNfICPsizwp0zmd5QaavnAYU8c8rLHMCtiO
 MIhuw==
From: virtiofs-bot@sinrega.org
Message-Id: <70411.122041110493901941@us-mta-124.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 11 Apr 2022 14:49:41 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: Match default rlimit_nofile
 logic with C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently we don't raise open fd limit for sandbox=chroot mode. And for sandbox=namespace mode we do raise it.

I would say try to match the logic we have in C version. Idea is to get a minimum default in all configurations so that it works reasonably well for all configurations.

- If user passed option -o rlimit_nofile, simply follow that.
- If user did not pass anything, then try to keep a default of 1M. This should work reasonably well for lot of workloads out of the box.
- Call getrlimit() before raising limits. If caller has already setup the limit higher than 1M, don't do anything.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/37

