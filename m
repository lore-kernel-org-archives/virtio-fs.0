Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=X0psM8mOPC5tboc4ALX7pSxlL04I+h8MQinfw7nvcP8=; b=Q
 9T9eeYpA/5pSBP7anDj1ZYXwidmfUBqmIUgfjeUClFr66MTm8yt1qtLevgg61OSA
 ntfIN4iphkRSLyfQ6/xHE2hiZGHjuuLbqSqUKmgaDDw7nE0bsJy16mVi5h/25P2P
 GZ8sqJ4yiOKHcFfJHN7qRTHQ25uloUh7wYqN/FSMuM+QEb496d7VduqB1TF6LK0/
 Xx//YH2t/GeH1usfKPM9r37B+AJcyCDNg/d1vO4iPSn2pO7svImroL0BsKRtYnz9
 9rBYDKvmhodH6bSRMiDiOKiynzaRoS7VjI1DvdixrRs5GigJeDsf/hiey8Htld3W
 4+KgnQ3mgJA3aYmCbRbRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=X0psM8mOPC5tboc4ALX7pSxlL04I+
 h8MQinfw7nvcP8=; b=ZAp/WgIi19dH/+DXI59A6dyNHHrdo14Wd1teD6DZ5I9nC
 gt5Algk6WfjH2k1k1+Cevma0wkbjZgy7Ld9l6BfHobGN7xmhb5fvz/VZPu6e8q78
 2ew8CJ5rFcg4NGZkwitjvw3fieJwBVUVD7Ig/NpJ/hlYHrPJ/u0hsxFRiUiJubC8
 ZJAUumokgmLwXvLuogfpwEw4HhrQILlnM1z+dBCMRV2vZBmljnVENnLE5MZYM8Yb
 rUeuACtKhcoXQ2TaNxsE4d91Dm+EWGPYsTbxzwKQ/4QqbPAeH7Pw8GTQl3z4Uy2W
 /xf21fOktkpp+UOCxls5YbMXNx+2VsxP9qxaecSbA==
From: virtiofs-bot@sinrega.org
Message-Id: <57298.122031008550300183@us-mta-36.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Thu, 10 Mar 2022 13:55:06 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Match default rlimit_nofile
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

