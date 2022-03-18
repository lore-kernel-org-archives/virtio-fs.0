Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=gR5MCmgnaBFAav3bJP7pVBWqylPTX0H+S8QvcZMEi38=; b=h
 xI0qz5ToaqOdFiqo4kVTYH6QKogZnW35Wx62qYDRHhXDq7iDR/PGuzk00Q/VH/ce
 IOq8M9dRCB2xal6FxgsxVWh2rVPMrTHZcJrMSMyoTBkdFr2Uzx8dB8burj3Tp45N
 MFwtdGItqICJBNcscIRt6fBucaMtkfF3XgchrWeg9qfMRqSL95CbLuoG6kEOpTzi
 1ihyCLR0PSipkJggerPEB3sBe6lnirNMI1ArS0Fo7m9/kedS0O2VUo8Nl/l4qIGV
 3in0LkVkV4dzTmtEglqLNiVfJfJ6TXKBhUE81EiYOUfiBRSjSvOnq9l2fKtoJ8/S
 BtEiVfBpYUOVR3inQZLFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=gR5MCmgnaBFAav3bJP7pVBWqylPTX
 0H+S8QvcZMEi38=; b=lOcT6Kg2KBL+cLWCVZlo1yIxu56vTWxiXyxI2Zr79SQND
 pU/n1R7Hxot/9wR/z4rzwOqRwlZ92Jbo+I9iEhZYvYUvccwMPpkUT/IBTy1cHFv6
 RbYeYi8NzKpSffGReCCVm9OEyFowlk7x4h9rOQfCQGUgWAhJ7hmFk01WiCLYoxVW
 3WDlxVKkLLeDyQL3d/rhIKTFXc+GhW5QJAc0Si29J/wbGuJkpO310OnJy3J00JuU
 C1JMkwVrzRsTazVDrwlJcc79CwLsJoCZCc38CuoHcFiv5hWXXRQ2U1H+ausY6eD6
 eAkD/CyS7Nb9O9aXq4vB9nhW+WgKIcoFOtQvbzj6g==
From: virtiofs-bot@sinrega.org
Message-Id: <66541.122031817133500764@us-mta-382.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Fri, 18 Mar 2022 21:13:38 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Increment the rlimit_nofile for
 all sandbox modes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, we only increment the rlimit_nofile with the user-supplied
value within sandbox modes 'chroot' and 'namespace'. However, in the
'namespace' mode, we don't honor '--rlimit-nofile=0' and we increase
the value to the maximum, as in the default case.

Let's apply the following logic:
- If the user pass '--rlimit-nofile=0' don't do anything.
- If the user pass '--rlimit-nofile=<val>':
    - try to setup the soft limit to 'val'
    - if not possible, log an error and exit.
- If the user don't pass '--rlimit-nofile':
    - if the soft limit is higher than 1M, do nothing. If not:
        - try to setup the soft limit to 1M
        - if not possible:
            - log a warning
            - try to setup the soft limit equal to the hard limit
            - if not possible, log an error and exit.

Closes #37
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/104

