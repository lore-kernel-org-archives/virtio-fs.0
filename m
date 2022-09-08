Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1662651950; x=1662738350; bh=kkczRYRW+b/VJ1hQoWqje
 bLtjKq8MjcP/z0193Q2T1E=; b=ZhMLRii2OgUX2Dcfdq9L4ImnjapGs5hKywyUF
 Rl4OuD+XrpC8JwmxAsKfHYr7RATHQsD/+L2PBPbQ99SrY6CQhFkdCkbp34T9JXS+
 /5cMNV39QVFW2arcwH2php7U0IRd+zSFdqOeBHxpqKpVg0QVEL1O3/OQ0w9sY2x/
 1D71uidzA59jy+KEP61F6Fi1ElpvEXtxLJAnAkT6xureYUCNGpm4k96qUxottPOs
 97ieOWrJKcAgM++Uw01FYb/+4/4362fBrIVM+lsDBeMpS7BaXxzGLIYckquLJ91L
 oqhfD4pDRQLfAECRoKubdn4BxeSTldICa+tldm2+QNo3+DcZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1662651950; x=1662738350; bh=kkczRYRW+b/VJ1hQoWqjebLtjKq8MjcP/z0
 193Q2T1E=; b=1P3JJ4+A8yDpcNnJo+o7F/CYZLGRqr/lXAenF6iAjtuZi6QDXxW
 mlABxhaBXTd293LmivGJOqD51+ZZwXbIrKPPjRENu66IPJHk83oSoe9Px9Y8pUDo
 Uh0ii/cU8ddsySBzNb1XM/nwhUWSZxCDdHqszsfH9PRal3vMUyQjuPP44GB8hjoc
 N0MIIog/CgnR1EtY/brpgp7e4TFLQUdR/3moPiuOBIJudDjk3XrwvkfkvJ0WnIjw
 MPr/j4lG+p7jg/TLjhQ2xG/fdNeU28opHIm+EuxAcKfdVYMhTrbLtnJQfQQRkOFP
 V5L93u3IHWdEMCBEGl1dSvfbTx51CMjhr6g==
From: virtiofs-bot@sinrega.org
Message-Id: <97011.122090811455401067@us-mta-642.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  8 Sep 2022 15:45:57 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Draft: sandbox: Allow non-root
 users run the daemon without isolation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Although, virtiofsd expect to run as root, either as the real one, or the pseudo-root inside a user namespace, there are use cases there are use cases that need to be able to run virtiofsd as a non-privileged user outside a user namespace.
In this mode many operations will not be available (e.g. chown).

There are some issues that are related to this MR: #8 and #43. Besides the request in #8 recently there was a request for this functionality in the matrix channel, I am creating this MR to have that discussion here.

Notes:

- Even if we agree to accept this change, I think it would be convenient to wait and include it in the 2.0 version
- Some operations fails, like chown, but these also fail with --sandbox=namespace.
- I want to move the capability-related code and `enable_seccomp()` call into `sandbox.rs`, so I don't need to "leak" the info about the sandbox type chosen by the user.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/136

