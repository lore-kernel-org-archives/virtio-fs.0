Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1659685429; x=1659771829; bh=AzQzmtSpF1fUvvEaG6vC5
 zhl3PEktUZaFJavxCzFY1Q=; b=FAv5WIjI/ssUgPWw/wW2PC3okIaRYxmFMWNYy
 cvzQ0kslIHFfAgjD22uEsU3xIwKpLViZk0DeQN1ZXsJF7O91BFEOtEAwKcGlu9+t
 plfnmORRjccDKdJCTcgQk5k8QE8BmWbLxYWD+ZOuWwf8MG9ejjqfiG5OiuiP5P98
 ZaDkcky6l3VM+Csh6iBnRONpRBAfL/ldKc3Iygasb+3d7ujBroBmLuXqTEeUYL2W
 bYxEqYUCgCzMtU/GaiG7uwaRllxpa/tRRSMo7rZac7NW3tX5r6Aw/NZce7uqWeVo
 i7u/7CkiyPm6LC1Q46fV+3eB4/B9Rte8tWIj9PiqH8wWj1csA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1659685429; x=1659771829; bh=AzQzmtSpF1fUvvEaG6vC5zhl3PEktUZaFJa
 vxCzFY1Q=; b=KH1qcHCIBE0FIhHeYWK46iR/RjYZDfznPcl/MgEuboyawUk7qYU
 UXUYLG8bLEpLhwgcMlX9wkyUxqkDfLLsK702RzOGi3b1HL/08lneV3bpwd5oc3Fu
 ZkJovxyt7hP4Rz1OCguCA+vykuw/AoFhOge9URhX5LM4S85hl4kTkkntdCJ9i4lh
 uPB/1h0dsoVtwscJLGHkPz0LJsT+MaEdMCA9hwvCSh2x8a7mcYOgGxIgJH7ss37B
 4Cg/J7IqEYAg9kgOEIP1GweOnzbrp3oYXR+prt096gFCnbQGxvwauzC9U+bB69p/
 +mHe1Dapuch7hiIgrFywymlyFAH+dBQ4fNA==
From: virtiofs-bot@sinrega.org
Message-Id: <04854.122080503435000137@us-mta-60.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri,  5 Aug 2022 07:43:52 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Implement suport for remote
 POSIX locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The C implementation of the daemon has limited support for remote POSIX locks, restricted exclusively to non-blocking operations. We tried to implement the same level of functionality in #2, but we finally decided against it because, in practice most applications will fail if non-blocking operations aren't supported.

Implementing support for non-blocking isn't trivial and will probably require extending the kernel interface before we can even start working on the daemon side.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/53

