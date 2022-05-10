Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1652219450; x=1652305850; bh=0032Qy8oaRZoOeUl1NjUK
 TSw/VEsB+2sIXbAvFnc/8k=; b=g/gHyIr5PvhcPSPSUL8lJ8tNs0raIx3WqKslu
 OVevoAQyecnmBn39wrNtjGfuT1S38afP49hWBPYkeTKrh8kkuYnH/Fg2Myu9h03o
 enJT4jtplAfiWbZEwZ+ZhbIF88ajczWA9xYw/6u5TY48xX9WnjNXCeY6TOa3LHRA
 wiXeUsM1LpnZIOPPtWhDF8cvKY31nP6VePnOidN9LrtJ/csJ/6p2WgqzLQxQNFIJ
 tYWpIyxTK7aT0wbTf32a1tvt1kzorTGO22JEI5Om6vnVC3vpir7Fm3I/Reh+IeiC
 b+VQ1uRbAmWm4BLe1YzllEVzxOF1AhXfBbK8eBEO1g0n80SRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1652219450; x=1652305850; bh=0
 032Qy8oaRZoOeUl1NjUKTSw/VEsB+2sIXbAvFnc/8k=; b=fmNpvj87o4AMciRFj
 ff07D1uvNxjS0Evzf3dx3bpdTyqc8fUFqug6I/UBt3GIUDHxgTrgtgaP6wXrA9BQ
 mA1rV9kZlSteR/9BO2Z2LlDBN4TMPp7yW+eADu6/aXgGuDpUbHV8KqSVe5w2Xt58
 zqf/XNJ2VJOfHXlAKR35e5PqPyRNiJ6iGax+IiYZ4mZHs88NhhIIIC6Nk5W1u4NY
 Re5iTUa1Ma2RWEuX3lULHXUJN/ibku8iUjSld7Y3T7Q6K9RH4N0dXxSCQ80SDnut
 KLTjWkjJKF7V9DYpOl7Y9hMMQt8Z6bERTyb+kM1BjkXYIbeegsCTpTA82fcosH3T
 fxA+Q==
From: virtiofs-bot@sinrega.org
Message-Id: <55695.122051017505200406@us-mta-589.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 10 May 2022 21:50:58 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Disable killpriv_v2 by default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Right now killpriv_v2 is enabled by default. It has few issues.

- Does not work on NFS. And I think there are other remote filesystems it
  will not work on because it primarily relies on dropping CAP_FSETID when
  needed and that triggers clearing suid/sgid in many of the cases as
  needed.

- killpriv_v2 is not perfect. Came to know that couple of fstests
  (generic/193 and generic/355) are failing. Something fails on
  ext4 and while other thing fails on xfs etc. Some of them are probably
  deep filesystem issues which need to be investigated and fixed.

I plan to start diving into the these issues and see how many of these
are fixable. But that will take time and fixes will show up slowly in
future kernels. And we need to also cater to existing kernels.
  
Hence I think disabling killpriv_v2 by default is better default for
our users. 

Given it is disabled by default now, I also had to add a new parameter
"--killpriv-v2" so that users can enable it if they want to test/debug
with this option.

Usage of overrides_with() allows POSIX style command line ordering
between --killpriv-v2 and --no-killpriv-v2 where last option wins
and takes affect if user decides to pass multiple of these arguments
on command line. 
 
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/116

