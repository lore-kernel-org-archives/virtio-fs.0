Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=uq2MBwhxNTvM44uB0e2sH8srrUwd7CAyI9VpWDuTqSw=; b=V
 WPus0C5gDpkpC0d+Ovee2lQMo8u3CEZnj30TN7l6hVf49uCRbRc3ddowNFFwPqkF
 uiQu9pdWYQAATLnfMCkb5SMHrF5Bl4gTFAmrQSzMGGxIHlcedIxKMPh/cpjF/Gtq
 fZ5EMwIAUuJxRayE9le0EOkTEItuAMyQp84//nEF2QvwM/+6j3uT2T1MoAOaYnii
 To8vq+NjnvR2bwuHSJrhR5uFm+bKNPwEfLxDUCsrG1lF8/vAREyDn4Q/5or/dBGe
 rgvOirhQ89lXn7vaZD1ViLDkxX9mls1m99s19+FNoLtxTO+mRe73GmtyhXPNe4zu
 oSDvSFe5wtrsXUTfoMHnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=uq2MBwhxNTvM44uB0e2sH8srrUwd7
 CAyI9VpWDuTqSw=; b=odpZ+lFx+0AohzJr8D+09h/EQDxxZOiVUSxLuuylL98SV
 hu6X1udqWmcDoIONfmGsfCf2UZbz7ND1B+vURXe3sgbiqGr7fWHoiQ2/034LGekm
 8fg01EuA2pNWDnJEnxRouNG9lCDWJzpcNTJy+prU5iGWocShsH7J777tazrFHCXs
 q3X5QPI1smciHcEAe4V0sxPnz9HxJeJ50ZWHPkZwPjNJZZA17GNjdpatcyvBVqc6
 DYu6B7BePgq2lZi0OlYHls2V2ZSi3oVVlhqq5MVWowFEYO5hmTv6JajI2EeYdcbD
 1qsT1j/i+eprCGAYuiXZR2YUg3/6dczS/5rQSI8Qg==
From: virtiofs-bot@sinrega.org
Message-Id: <09914.122031017062400633@us-mta-187.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Thu, 10 Mar 2022 22:06:27 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Add capability to create
 security context (SELinux) during file creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fuse has capability to send security context of file (SELinux), during file creation if server opted for it (FUSE_SECURITY_CTX). Enable this feature and opt for SECURITY_CTX if user passed option "-o security_label". This should help with support SELinux on top of virtiofs.

As of now file creation and security context setting operation are non-atomic. In some cases these can be made atomic. These additional changes I will follow in separate MR once these changes are merged. Otherwise it becomes too much of code.

Please review.

Vivek
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/102

