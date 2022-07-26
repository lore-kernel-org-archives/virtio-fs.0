Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1658825401; x=1658911801; bh=LdOjIu8qijiLqcgmVsRia
 ZXOMWEjreLb+q9L7obB4Qg=; b=AKoxwYvYM05gZsEQWKIxH4gFtmk0+aggzNYBW
 xjcnOKknlDlJTpu6vwXzTexZFNYH0ibNy3+o9xH6aZnNe/nFgoSQkw65hbZCbAPE
 hW8ZbRXxz69OtlNSgA7RktzrYvXBUCbBL5BCv0pfiG2DoMUwNNl/KWF+zYkucVLm
 qvVTqOTuH7XChJaa9cjiB6ju81cx6PJIwOEOCFO2ciPRXOLGA9IrKgHupqwBc9bN
 Hopw3fcb6I6Yah+v0OCGSwQ8CPKtBUkxG1ufR3smfEkpVHjr52KOzYPnjTEEVIaf
 qsWRGZF3nWK8712UvtV00iDTtiwIfwGi++Zg7cBb1jKTkio2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1658825401; x=1658911801; bh=LdOjIu8qijiLqcgmVsRiaZXOMWEjreLb+q9
 L7obB4Qg=; b=a5ENvGk7M3MNQzBfq+qAml/3rrncjuNeuR27covr9lr7kAlTjKK
 ZLVAyDKoAGhKs0bvv6QYUIQkdE2j02MtQ7WaLq7fJPMU1C4QL22w75xtXN5KA9iq
 wMuuRdkpX/3K21iqAflKBUiuJJQcmpt1Y1HuUgj53M1coBzZIfnlnBGCf/H4qKlZ
 NnyOrZH+tvsKgLiY7tV74WqQnwRgTt0cgqoI/QCYv3Incrp6dLGYPSw9vreEi9ce
 VNb285S5j4GMM48FTqbgV1ia0XFX4VUWfRhKb1Yi6b3f/kRinIPDt/LlhIDFHXPq
 06ZeAtmLZ4T1WR8nUlTZ3X5z2Wd2jQDbJUA==
From: virtiofs-bot@sinrega.org
Message-Id: <85213.122072604500200127@us-mta-424.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 26 Jul 2022 08:50:05 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Adds safe versions of
 `libc::mount()` and `libc::umount2()`
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

As part of the effort to remove `unsafe` blocks to increase code
clarity, the wrappers for `libc::mount()` and `libc::umount2()`
are added and used inside sandbox.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/127

