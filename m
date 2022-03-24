Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=T+sraxTsgVW3hLMBsphV2TbCFPqpbnliPIarQ8qX4Pc=; b=P
 i1YGPK5IrgrrvYT3MK7cQgvB0PKvY56HgcwikDlRKffkLyUqcBNnIvZrwTPh83Tl
 xvc8FaKgHAVycCPwGIkQnS+uyMYz2yZOzsOK1gE65N+xA3UsAGBQoE3M4Q0A7z3w
 YhnRwbRa4xGWm2ezY4wHYD3Xl0RN2eJcG2dCPaodyPVQuAm6+47E2qmFhngVHuGd
 kJGAjSxvRYbC1N68mQRtxgbud9XXeDFzgkRsTIao7SL9VOE9UJgVr+hcmfiJkCi8
 01bPGdhgZrbf7cMDQGeEwWH20nzy+j7sYZ7+nVU7JQN0nO/ongOT6HI2jKqvBtSI
 yYbIeItDp7ABG3Fc3eMmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=T+sraxTsgVW3hLMBsphV2TbCFPqpb
 nliPIarQ8qX4Pc=; b=J4J5dogq72zoxWVqINEc3O/9LQw27Y/F04w24EKOK9I0j
 AmUCADBLmif4u4EdqaSmKRLGFKBn2zrF0eh4jL606CVRKFp8FGbbeUWSjdfDApqR
 ZLLE0Y7sXBRhaeb3uVdNJJXg9+jDfubESZbvD8I/JdrE2I1UHrBEgGNtB1g7KcYg
 mVf67WmiJUAu8tqWhZFyenSXuiy8vA93jiDWCAFBOERN3G0f26yjpT/EEvkqazNF
 /3LfV0yuE7ZYO6bdXsWPcJ0m2JUK8IY9NWI3ybO9FoRxKk1mzF/nWlaUSBabCh4l
 0qseMlS4LTbmBaOk1u4+6u+OQB9dSw8iFl4Zd7Qbg==
From: virtiofs-bot@sinrega.org
Message-Id: <39395.122032418361400255@us-mta-532.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu, 24 Mar 2022 22:36:17 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Do not call setgroups() for
 unprivileged user namespace mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Right now --sandbox=Namespace is broken when called by unprivileged user. Reason being that we call setgroups() and that's not allowed for unprivileged user both outside and inside user namespace.

When unprivileged user is launching user namespace (without help from newuidmap/newgidmap), then it can only map its own id. That means there is no arbitrary swithing of uid/gid. And that also means anything not owned by user will show up as "nobody" and user can not write to that file/dir.

So all this means that we should not have to necessary call setgroups() for this particular mode. This patch gets rid of call for setgroups() for "--sandbox=Namespace" mode when called by unprivileged user. When root starts with "--sandbox=Namespace", setgroups() is still called.

I also picked a patch from Sergio which establishes 1:1 mapping of uid/gid in newly created namespace. So uid outside the user namespace is mapped to same uid inside the user namespace. This is good if user wants to export his/her own home directory into a VM. Without this patch, user owned files show up as nobody which is not very useful at all.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/105

