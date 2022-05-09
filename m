Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1652127372; x=1652213772; bh=EnmvUdv+Eiu98YFkKlNzy
 Y6elKVPfOCg2c9Kpj/0Yu0=; b=Zbwz+47dDYGW4KXdaYKFGpZ+xEJvP17no4BO1
 EDoBMgEvn2lQHZfuU5xPcDou6H1QMzdARUkLplZ8GbyYm3yD0EmcZx/L7L7wY2De
 +FrHsKf9tC2ySE5FJjiJfujrYN1HD2ous4ePo2PadHsIrt4+Mg68Dpe/HjIYi4PV
 KvsN3AzqpdjhmegkkPVXm4itfRyh4bI8VQUNY2/ylEm/CKmOTk06uFH8NufmUPC8
 9kbUBq4rJCgEeuLu3YTdbMB4nBSjvwFgor6WyhygP5oc4uAwwYNwfPSUvlCAHf29
 Z261Q3VxaNLZlIj4SEFMEYBXoCP3N7bBtyRfuHKqU0vnjKd3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1652127372; x=1652213772; bh=E
 nmvUdv+Eiu98YFkKlNzyY6elKVPfOCg2c9Kpj/0Yu0=; b=VyaBTOmFFYRsqCp20
 JT8pqt8eTSHMAulogNL7W315fYV/3u/tTfPMS28+hnNp1rY2QMC/ckB95huTPv50
 Um5hHv3ZxsGss1KPDAe8M/dkHE0SQjBzQLgnhD7mIDca4/ccNrOnCEy4B43irDEb
 4j9vOsWiRjZuR/js7aPnQKvPoNUiPMmnmRhC8olBbt5k0jicZvIkIPVX9SAyTSt2
 yJmgIZSTxB6vCSTPF2UO9R3pstmKh+88fzY6cNU1aEVp7R8CmtoG4zPm6DCeOvmL
 3p1MtXZBDmUOCDC5rVGZ1XPBgip2wTBoCdbytYVQN5fBsrw0cXkR6lv3sm71egfl
 p1MCg==
From: virtiofs-bot@sinrega.org
Message-Id: <93607.122050916161200803@us-mta-81.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon,  9 May 2022 20:16:15 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Document how to run virtiofsd
 unprivileged
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Document how to run virtiofsd unprivileged. There are few users who want to run virtiofsd unprivileged and documentation will help.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/48

