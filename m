Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1661785813; x=1661872213; bh=4k9SHeRwCLVvtVLegCro4
 d/HDlYKO9kltZzaYzQQAPM=; b=dvN8kFoXL7RH3MQYyvmkXCQpPJsizosrl3LaU
 Y3AaXimnS/UJEg7XMzw8ojh0oDRfLOG/7D19YcyjJBbv0sV0Zf6/1WRUEKzFXnyK
 zMDj8gOKZXRDFVKWt2OZGzrrtbIJ3G32ocJ+3/S03mFEwAKNkN9jBoJEXcoVKCmG
 qzmH/HWEOWnJMaTMXDU/CcCXXdaSZvBXW7CvfeKTNfJ9+6c6BUbYNc4M+q8lp0Vw
 +wDbCrduNArrVQ9AXiq4PPtXc9EdQHqFk8f3sMVD4GiL1UHn5ICiPHLUUdkb/WuT
 GiB+i8lAvUa3A2wZfy2s0U0mw6yd8TqwoPsaYm4EKX1ZsMwyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1661785813; x=1661872213; bh=4k9SHeRwCLVvtVLegCro4d/HDlYKO9kltZz
 aYzQQAPM=; b=458XFZYDEaQUBbeVkAllUWvUi+UI7bDlcW924ey28wa/1g03Ymf
 J7q2IpFLXrMOnCQklfRtDJObAdodrwDuFXG1128DROWe0fkJGBqkFKMdMUSUc+Sh
 xzH5ejbvtTdPjYXWeebzi7fdp+RSnl9wRePXeUzjII85Rc+pFwW0+qPBClqK6GMh
 cmA5Ks89+SQ5wFIK1IqCnu3SQpwzjMaafE1KQ/ToLyi83bMUYkefNIe0WUvtLlkR
 X/NPKEZkzdhdSk29zyWFMbPsihAcFtAp4Z6xm6MyraBPSQ2/a9KHK62VyY9i10CJ
 nrAqmWWZRm7an42UkhAK+fj0agN84ycG3tg==
From: virtiofs-bot@sinrega.org
Message-Id: <93722.122082911101500231@us-mta-472.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 29 Aug 2022 15:10:17 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Add fchdir safe wrapper
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Continuing with the effort to remove `unsafe` blocks, a safe wrapper
for `fchdir(2)` is added.

Signed-off-by: German Maglione <gmaglione@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/131

