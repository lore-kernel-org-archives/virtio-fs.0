Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1662049998; x=1662136398; bh=GStzpMyeYHVrR3vT23tNj
 2t/ZliNPeoBLW2oq5QqCsQ=; b=XrSlzpBxDcqWf5sD1giy8oCd79wihNCvwqK5A
 rjKYOMaj0GAO0s+2AabveMI+LJXuZZh7112t9XVZC0IJCY530zeG5Bf4fqAFFkul
 M4UcKPOsbbK1JMylyONwXygzlM3UJEovUEgL0zTH6cHCLZivGflFvTUTk4taSrqN
 NwIkiuTmPW0sVeAFGZhFADmI13vniPEevXkQxHLSff55BCFiWQpitiRHlfP0fARL
 eo8KKVKTvJg3OA0cjprgUZLJzhbM8OeIRgDAqnJvzy4kP6XTFqthaAflw8XLY8St
 zQhc8MDmMUomcCWY5olufCEXSWrjcLkurhexGw3fhIrtlciBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1662049998; x=1662136398; bh=GStzpMyeYHVrR3vT23tNj2t/ZliNPeoBLW2
 oq5QqCsQ=; b=POjUfmjhphtBAvcXMyhzZus9KrG/x38xFpX8fSAbvB4lDEUCG3Y
 xJh195QFEcedr+wvcJpcqApq17jN47akb5sLSK8o7WbUHpGBGQomz/LpEQoXKP3o
 IJlV0iHZrDnvC0ZLP7P5M6mlKL+hxca2u3lQE17ksdaD/TUDKfCD9vWo5lU94L9k
 bj/5wjq1NLIj2b3HF73hMfnyY+njQintsZCymz3c04raEQZIIUO4wpboMYp8auz2
 OOD1MGxi3u5LPcD+Xd2bVMwNCOANoPuP5gnZWY2ZVx6Z8hiyJUcU9BWNJr2iMc1s
 iAC63fBVW6SWIAoytHHEyKuaPlYxCT+NQgA==
From: virtiofs-bot@sinrega.org
Message-Id: <39253.122090112332100973@us-mta-638.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  1 Sep 2022 16:33:24 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Add `umask(2)`` safe wrapper
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

