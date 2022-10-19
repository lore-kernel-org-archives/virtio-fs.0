Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1666158555; x=1666244955; bh=Hrq6GaUgvsPF05mJgh/C0
 sJpIEeniFnVmEtPGCV8PXg=; b=w618v6QTKlZ8/dgZ5aakaauZOeICDg1ys+A6U
 HlpGmAMlbFi7u8HWMXg0pbsoUAhoCzLDM78u404SgfxgNb2s+MzJ6BAFJSF7qwwV
 Z623L9hzgJaP9h3pESgLiBhLpvdRqOM8iLtxGOTVzW+MFevGXewClvkzdob2yNuu
 CnrGqtdiYohn9GFOAX0mWicSt+pnYVMq2YhUuGJnzj5rL3agPdLAchYqLAL92zp/
 /PpCM7OW6fpxV0RXOH4+rlu9pmcsip5jkhAA8UhqYw/cFEHCL+v00a+13PcmlEcn
 fLedRdD2BDktK/GAjW73v5qnceIPaEMq8XAAcx3wTdtArbEVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1666158555; x=1666244955; bh=Hrq6GaUgvsPF05mJgh/C0sJpIEeniFnVmEt
 PGCV8PXg=; b=iaDUtv9Moydca5MplZndIKAzIKkdKvTAYW5uGTmQLipoUd4WnLP
 AKo1ngLKClqpYctDwvYAd7lnG/12tj2T6A9v+0BRlelhWsISTf3Ua8P1IOgoQeR1
 bzRl78SYOcm8fR7UrvpPUJVRs/llsYhPk5EyFeoVsNMbUCXnl+Ne22plQ4kf1o0i
 PA1yxS8chhTArxx452wB9PWVvmpjEvryp0kAcF99E8ZI1zV/rcbhV8fKdHgR7t0o
 Bg2W2fnlMMSH915yZSbt88oRynXjAgZYe0tGkT4SFCSkR1XgchwPQWybcy5mOA4E
 jLpGkztw3RHggPas7Rt2jwS0vgTW8SDeLrg==
From: virtiofs-bot@sinrega.org
Message-Id: <55727.122101901491700193@us-mta-362.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 19 Oct 2022 05:49:21 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: descriptor_utils: Remove
 unnecessary deref
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Removes a dereferencing expression which is covered by auto-deref.
The next version of clippy is going to complain about this kind of
unnecessary deref expressions.

Signed-off-by: German Maglione <gmaglione@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/138

