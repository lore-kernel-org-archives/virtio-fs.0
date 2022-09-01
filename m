Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1662034257; x=1662120657; bh=9JoygGHduEMC147ibV8wr
 AQ9axkyZ6wQ+shfNRr3gtw=; b=aHWOS1+Axg+efdDGmeKAlnuNcxgKOLEUGz8QS
 MWakdJpgiP/T2GQ/OTGn0ahsh4AK5jxpo8Oq7PLOSxxNhtgfiNJ2I86eM7KDI57K
 i6DgLN0WP8EY5KHtMpVA+0ygrmTFjRDhrtPix9+DWa5OpHc7IiKXeVSQ/VYKefjh
 Vi56jsKyqJeLJu0WudwFWJnpl4dvXfCCgXj/qWainFnI0QF9rg/InHEz7ozPPbyf
 cKaMhzVaF5Ky/rp7RscEjze2KibJXiM/wSEUxZw4PdZQt2O7d79AvL5FZucCGRiO
 4TCvarCNZ8H4R1BwPFQsaqus0DDV+4ZMaYzHne2xf4m0PAEQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1662034257; x=1662120657; bh=9JoygGHduEMC147ibV8wrAQ9axkyZ6wQ+sh
 fNRr3gtw=; b=pii5A+PMBB1NPXFxhnOPDZUka8+FUJ4hu3hqdp1PGztESRLCWiz
 ZUjMZxGFQhWRrFwaXVk1fmaXmfJEKmbZhZljns96L01w19Onyr0ft7H+hS4eZYCb
 fKhczcjOvtoiMv2ClVAp+3jLgiJ8s3/JaGyLKyym9MF8+JwJET4qOGCUJOISPp3T
 EjgL1QtIdUvUhQweYK0zb/T2EW6QqyoaAnlQuy46mxZjSVIMvQ1kFcTLEPFzhAnx
 F2mC3MHHj6NWj09pntHmzRKQyg+0FjuwwJD5bl6NVu7mBqcxVbJjYbe5cDPg9bEX
 +gjDXzeXZBTwd3/hLazB35W9h/AJs4yud2A==
From: virtiofs-bot@sinrega.org
Message-Id: <29516.122090108110000449@us-mta-294.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  1 Sep 2022 12:11:02 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Add command line documentation
 details
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Just adds some details about posix acl and security label flags.

Signed-off-by: German Maglione <gmaglione@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/134

