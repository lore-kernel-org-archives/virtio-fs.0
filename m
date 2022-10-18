Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1666119840; x=1666206240; bh=NlRmZS10uZBnzGpyJdet9
 e+WiAhh/dKHdw6hjQDa+G4=; b=yYl76aNQdnQTSBmbmpmK0m3Y4fy7yT3paQ1G3
 n7QB4OshORMNlo0xk9uEFxDeklkKzhSeUB+bhL/H7gQB+php5GoRurAvKeM1UEuP
 SY5qDikZCEl2IBmF1SMiizauzvjt9bGzw9l5cQXTJh6TeCcb7j/GapIP7+kKrfjS
 rZ9NGGrUS7rJewqRWuvoi+yh8F+8qoSKw2nY6LxOva9Wvkul2v2yY2URwE715LN/
 n+rvAXmdxTwK/USgvoaf5Sgzh3GkLz4hpil6E3WEcQylr6Uc2Kh3OMsJZXWt7PY1
 BHcSCPXSVqqdE02f9p/C21HlaukhOu2+dXOcALsQXkc2kqxfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1666119840; x=1666206240; bh=NlRmZS10uZBnzGpyJdet9e+WiAhh/dKHdw6
 hjQDa+G4=; b=pRn4DO8WkOvJ48B2fTorkkaKBNEARiPf664fdMNS5V6r0X/cNJM
 V3rc43kIPsXhQ8wE4hoYlrl97S8TLyV8/JRX6BVdcY4PuK8fj4K0cTzcInMxFFeT
 7EQ8g9iS0Tc9TVHZdZ+lSwg1kim/uPjtHuYmFCwma81s/JilmexbHyYwDbNvWbmo
 IHOVlo/suetuZvCq1MtMlfgoFxNe7ag3CyrMIwwnDKNho8GeuEc2um5M+PQ4Tgza
 py6LJCs6NOdCPBjTUZa/VHpIEf/3joEXDZDkdNqucEQp2qL7Rs8aoeUAZgOSCewt
 3Jc+39IwUidwezbtSxjNg5ljHPf4bFatvEg==
From: virtiofs-bot@sinrega.org
Message-Id: <43656.122101815040209989@us-mta-561.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 18 Oct 2022 19:04:05 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: passthrough: Replace `openat(2)`
 with `openat2(2)`
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Although it is not a sandboxing solution Using `openat2(2)` with
`RESOLVE_IN_ROOT` and `RESOLVE_NO_MAGICLINKS` add a bit more security
especially if running as non-root and no sandboxing option is available.

This was requested to be able to run inside an OpenShift unprivileged
pod where "virtiofsd is already in a container". The OSP seccomp policy
denies CLONE_NEWUSER and NO_NEW_PRIVILEGES is turn on by default.

This could be useful in combination with !136, related: #63
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/141

