Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1663054563; x=1663140963; bh=NgDfIdQNuJulhpWUDZ8QO
 KwhX3EIhT4zkRe/BbSE1Sg=; b=CyqtDkGPRncTMSxtpfQA7iKOfLCwLZHwKr/Rj
 j4EOe1GrZkppNcGtqwmHrvCS/qT6XxAuvdFbB+Brp4m991U7iVOKf3Qfx4nPz65D
 3eFA7oiIZ1rXbhsM66znH1hXq+vdhwhbUa9BXANfzByQPTY57ouYSIz9+X1yT7XK
 KCkArlCjqAasvSCd/KVQpRFwn0Gy/eYNPbr/nVvMyUblhhQGICmBTcvFfofj0sJG
 0HUgzi03N+h0iWn96vV/Mgh1FrlH+GpeASziVL38mNlTZjgmHAC1l4XL0mawBrj3
 ycKY6nJITlRMAQJXc7/tgm/HZdj0MbG1Lloj03b0haW2fDozw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1663054563; x=1663140963; bh=NgDfIdQNuJulhpWUDZ8QOKwhX3EIhT4zkRe
 /BbSE1Sg=; b=PKCVcUB9QfgZvAlmdU/f9ckJznJyUJCSs/aFbitOn34JdyGToik
 EVN8/ixEOTRRiieVUVjpbfnaB7D07bIqB1sW18hPVIGBufD2CI6k6OiDACXvg82r
 u1HNUlULnd1k5+qKfRmwVGOa3M14x1EXGtiEAdCpbaosvOyd3fTT2ZmmnfgjPCog
 gv8PtqgtfQ2pGEEHoaMcNV7kEvFCW8SpgIx70qAc8j9WI6yVVAYO4g8gGfFdBXSG
 Akrq5bN5YLmuY8ZZMOYghnFpKhRZOzf6Mxo66cXo5ep0o7ylNiRyDFNoxFCGSmiH
 KxjqxSyter+TEI/fkwJhun78vCDww2/3uMQ==
From: virtiofs-bot@sinrega.org
Message-Id: <39028.122091303360500936@us-mta-596.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 13 Sep 2022 07:36:10 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: Fix listxattr() response when
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

