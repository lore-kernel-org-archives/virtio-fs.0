Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1656329257; x=1656415657; bh=b63vM4SU2e0+rLdMhmOK+
 76/RrWsjOif4Bd6SCu50K8=; b=AiY0oC6QHCIrrlyXXChVITfei+apFX6zhdvEC
 GFwOzrxGqt/8MoHhWmHfO4SVVHoz/dUZjijkaGCTBRXlYC3rPqP1c+JLYg8r3gFu
 QBL+MTVP4siNIUzDKOw5FZsme3yED1qBB7lJwZZM7lPL/mdsY+QtmIM2CP9yUeGp
 5YMMSNwimP/8CRMpsFN5dh8wVTaDNfJVFqd6dyO3o5zDd81Py1lnixC6bNd2xKzH
 UgcYB9MXdI7Q7NojoolQSA6ZR6ytV5uA8Oj0V5iFnNh9r7UUp6tsFRBsjMeYisOR
 GzQLR9XB5EjBk4/887PId1/KcCm7pw/hYIQ8aPkbMrPaFq89w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1656329257; x=1656415657; bh=b63vM4SU2e0+rLdMhmOK+76/RrWsjOif4Bd
 6SCu50K8=; b=V40m9iL/9St13ES/fCFaIn4+fJpCblXa3api5gY2rV+whPb43hl
 9ELSv1Qza5mSnPPHirFCxPT8XpNHvJyTOViZs6Z/AEjajnerRhFLWewqWnEPuUi2
 3fB06PfeLBX6m+pcmO7SjGOAluo8MAeCAGsdC2Ju/8H5hgGejddYGIUemBjwPKiw
 VQJMlUhmpiOkhHtEkT3ut0tPtCunznorTAOJmOmXP0PiJ4CMC4fFDWeqn2JZo3Yn
 wrtJlLkYUtOHiCRGgHCrnp2v0xueG16DVVcz6akEKZF69IWFDNEKheTMG21pXyO9
 8pW0SFbx5CgGZO5A8wQ0qYLzH9drB+n+yUA==
From: virtiofs-bot@sinrega.org
Message-Id: <22245.122062707273900389@us-mta-151.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 27 Jun 2022 11:27:42 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: sandbox: Fix PR_SET_PDEATHSIG
 race condition
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The child calls prctl(PR_SET_PDEATHSIG, SIGTERM) to receive the TERM
signal when the parent dies. But the parent could have died before the
child called prctl(2).

To solve the race we check if the original parent is the current parent
after calling prctl(2). The usual trick is to compare the parent pids,
but this will not work if the child is created inside a pid name space
since getppid(2) will always return 0.

For now, this is not a critical problem since the parent does nothing
more than wait for the child to finish, but this will change when
user namespace uid/gid mapping is implemented.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/117

