Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1666158937; x=1666245337; bh=GStzpMyeYHVrR3vT23tNj
 2t/ZliNPeoBLW2oq5QqCsQ=; b=hdfz3Fm8iALyFYwjZxNe+z/tFwjwzi72C1qig
 hWjfi8egIe5cdXWYpyJHugpyxwqDDEuyLyLZZthq05YxSedVXWC7rmXtiBzArPQT
 qJRXSECsnRE5aDzUewPLUxDlSFfmGmDS964pS7OS9rW/aV+a70ig6fOGBRrlQr8U
 iH1gydTuWCZ9+RIhMsFRiRMoEjmO32Z+H+Aw/ZdeyBJ704HQdKU8cGdrs0H9vQ7f
 skyirsW0xurwy/YWOUyrdEQ6rfH9x52thMwbVyl5P/bL7UxxjhAvG/rTHYXOIeHx
 UrQZbpuiKHWjwfk8EJsq1ZiWmCifurJhw2MMfWwKCAEz3EhVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1666158937; x=1666245337; bh=GStzpMyeYHVrR3vT23tNj2t/ZliNPeoBLW2
 oq5QqCsQ=; b=dblYZ4IE74rrBX/6Hv3rNbFGu4AWB9Q1uvHI6H+PPpKBLFkIqCt
 LErnajqa31JLeGxv98xybXpmLLx5YmgNC42fcxrpksephaIPAqcIDNr482mmh6wu
 iHNb8xJFrpqRhzd3fn2EHNOrAD7Lh+C+4bi84keNyR96+h13ZnkzV0plFSxKVF6p
 jNyHuX17QscVU8wcg9k3UoiXplhcbpEFntxWgrvvYrVZnNznAFAM8/QmUtbz86Y2
 mYgedMUPCk74yCwXbrFQ5DYnb8SjDheVIdAzmFkHjAxaX5lzTlZ2tpAj1WizjKoM
 EBot0TztTD5+gtSOBeGt1QLG2cCu1GdqIdw==
From: virtiofs-bot@sinrega.org
Message-Id: <55990.122101901553900319@us-mta-284.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 19 Oct 2022 05:55:42 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Add `umask(2)` safe wrapper
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
for `umask(2)` is added.

Signed-off-by: German Maglione <gmaglione@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/135

