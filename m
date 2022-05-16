Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1652697615; x=1652784015; bh=b63vM4SU2e0+rLdMhmOK+
 76/RrWsjOif4Bd6SCu50K8=; b=Ku3HRrV3iANBx3h1XHKPXpSx7QjqxLOAHGiVk
 QB/UbEtslyiX0lCVt1VA60FmVqbKJK8t0+HAKyr9feKuo0WDETqrZhB3opoDAbLk
 ZnclslZjIYpTCOR3Qp33aJdg1vLeK/j49pnqoLvYBKWqf6krNDmshUHMFq3+cjf9
 92VP0g67ew7TMgATgl4PGTO6t5OZWfSToW4/EKOLfl5GKpZvIezzjeCR5W2xLf/G
 JUCy14H1o+1PFYmkDHqyP43XTs5Zd0qOnkXTDKHbvNtYdyFMbSD6MDlrT0UPDBVS
 CC1YjWz6kTlVAllk7vUGR3uttlJABflcgZLiVpebO9v8iHLvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1652697615; x=1652784015; bh=b
 63vM4SU2e0+rLdMhmOK+76/RrWsjOif4Bd6SCu50K8=; b=Iq1quOzaAaTy4MqwC
 DJ9uF1p0Wyns+6dRimdQkc8ZMGkd3GgohC5ONDSeBVlMm4jbt43NDXpH/dyXIipT
 v1ngNFxxlCv8BhRR8KLHCMmzx6Fl2pUwPyjnybNGDrkmN/x+W15f9QJQqtBDZsJt
 6CARDyIJayg0rD42UnjMqGI3UoYPOjk+s3XYMEkHPYAlfJrKd+R6IoeCQz/iIUN9
 tYETIl306qEDtnOGfz9W3ylV9VAYZzuZ9QwjN55OWcxl7+8lxMqddQrUbpT7oMYj
 wVRWr/6Hdv4nvhOiI6y7yfzXR1QAqG3n1/HqYlMLrQd59mTAxK0Y08bRoy3NKnm6
 MXQmw==
From: virtiofs-bot@sinrega.org
Message-Id: <62917.122051606401800120@us-mta-425.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 16 May 2022 10:40:24 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: sandbox: Fix PR_SET_PDEATHSIG
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

