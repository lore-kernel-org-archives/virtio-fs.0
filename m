Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1661538980; x=1661625380; bh=NgDfIdQNuJulhpWUDZ8QO
 KwhX3EIhT4zkRe/BbSE1Sg=; b=gJo2EGTlApuIGgdLGVh5RU5/p1zUcnEaoYVrC
 j1aOhwKLIC1fphgDVRSKnjbw0YLrsnbukoj+ddvIKSFUBqLhkLM33H5ptMfnu3Bs
 YFLL+6okTVHnIvTO+efFqIGS6vUbND4QS4HnexeiFfKe+NmO2o63axUpAWdIAR6R
 F+W/d5FLs3iSqJ/JzqFKc4BOpUIV3voGTrC1sMoJWMJfqeax6Hr8bHOqXdL0Q0a/
 MujY2Cwd3ZrvPDCfiy030sAYkpfLJFnFDmTNrk23PafLs6/dtx+u+4uaClBIyF6A
 VnFxkF2AdGd0Gia23HJhppc2XEryn/sMJgvZUNSfPSCP450rw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1661538980; x=1661625380; bh=NgDfIdQNuJulhpWUDZ8QOKwhX3EIhT4zkRe
 /BbSE1Sg=; b=q6/C3XXHMo68SZUzqC3kqNRo/OQjNVWUELlvWd17XchaButRRh8
 1PK7RXLhhZMcVJoVST+b8hQyfi2l5xNQyN91+f6hDQis65z/jjbfy5CSF2Bb0uU8
 ZhVgaAR5Yeu9TRWHU0MyhovyXre41QItFeZVNVklSfnqbJw+ghwcDjuM178iAb8H
 V6RTk199qDqg5xG5mj2/UI07IyXhzvx1ybifavZDPkevx+rDue2biybSLHE+60cx
 OMBYNh8HbJ/FZHEQCDPgEtne5WeD6KEezEIw0F5peCZQlZ2OGtg7SgXHjiZLS7uw
 D8yQY9XERKjBi4Ife/2kwacyo27ZTRLrrNg==
From: virtiofs-bot@sinrega.org
Message-Id: <88673.122082614362200701@us-mta-134.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 26 Aug 2022 18:36:25 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Fix listxattr() response when
 name list is empty
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

FUSE_LISTXATTR returns a xattr name list. It is possible that all xattrs have been filtered out by server and resulting name list is empty. As of now rust version of code writes a null byte to client supplied buffer. This fails the kernel fuse code verification and return -EIO to user space.

Fix this by not writing a single null byte. Simply send a response back with error code 0 and virtiofs kernel code should be able to handle it and update variable argument size to 0.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/55

