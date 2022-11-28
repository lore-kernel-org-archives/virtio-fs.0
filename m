Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1669630136; x=1669716536; bh=ilZ9G9P4XQvbU5ZiQLGt2
 gFYnbvCKFBPGhhDaUc9jgg=; b=SbxPptg9h3lBck3l1MmLzrOwxg5ah+aQTvRnK
 9c0lH64GIfVbRR/6teJL3/o8fWBMeoSP/kt/kvDWpJFMR7qEtOG7Nko8Yz6Vry5K
 FKslAOpHhXX2GhbOKdBm4zUeofL1LCiT/WM4m+i+uR1p8FXyqq7E4M/K8N6OwKlg
 QGWcvXzSE0yA5B83jIX1dkzQr8V+B14JbPTOpq7CHtQ4MAkGFQh0LK48tXS9Er0i
 BPK7c4MICDvP4x4FddoYAlFVWhIRLz9T0CAEsxYGVUZT85jHmhpR9HtUwEjIg261
 Kg+HZsc1Iq17b9YZeIhodUtEA1jWoUL6BVMn6vMWyESILafdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1669630136; x=1669716536; bh=ilZ9G9P4XQvbU5ZiQLGt2gFYnbvCKFBPGhh
 DaUc9jgg=; b=dJGFx3U2+38pzF1GsM6TwP0KFJfJb/Adp44GH0v3dudcKpmaGeU
 aSjWqr6pfbsMYW9jtskjz9cycxyd92Hi6cT8VDU+4Ytf5YjLzPIxLI+TtAQJif2m
 maSVYO4rPjwLRwT/0QsaB5sqN3aEL4sAu+HwPc/baV37ZyvrqgUUNxzTU0XkbD/g
 sN5+t9Hnzv8yXcc8e8tWY764o7BTwDXrITBhiRHhF0xV2TCQNFsvJkTQTxrW8dVp
 nbTF2KsWkYxQuOoPAlcmS09uLrajW6ukkKZ/ghB9hJvgGESRDgmu8e4KNFtfQs8e
 tJbSTlqmGuUpmZypJZff1GthoBiPzoh8Zkg==
From: virtiofs-bot@sinrega.org
Message-Id: <98354.122112805085900373@us-mta-638.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 28 Nov 2022 10:09:02 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: seccomp: Allow `SYS_sigreturn`
 for s390x
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The virtiofsd currently crashes on s390x. This is because of a `sigreturn` system call.

This was originally reported and fixed, for the C version, by Marc Hartmayer <mhartmay@linux.ibm.com>
https://listman.redhat.com/archives/virtio-fs/2022-November/005292.html


Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: German Maglione <gmaglione@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/144

