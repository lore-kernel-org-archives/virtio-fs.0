Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1665493107; x=1665579507; bh=kG+U+4aCkV8g6K/achhIx
 7207AyNHmy1JcI6/4rI9hM=; b=Cgv5aOfMq7ezoD9MggSR2aHwuNFv0v6XTQD42
 YHwSMC4XMFSaNQK6ZuRYdND1rMXMrh/IMCtaPNfLtDbPemHq9y3114na2awi1pVs
 SfgPA1B4+C/8dM2X6ICpM9vfYKk1lD8G+dHOgcR5M/gYSS2o7Se4ebZxPJnxW8kg
 jJ6GJsQ5LIe3pIvaVOZxkmLlnSgH8pjccy3pdQoJSpBSAr7D+/60+jsn08tbWep7
 iC2rqf8mf4paga5lR4I3xzj9A4M30TLy4wPMcn/2rOgGFzeYtTv5zR9kIoG59Wt0
 vz/sQuRkt8ofR2U0DuGnR7gjsxC0tU1k+Dh2jzhW3PRNt42kQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1665493107; x=1665579507; bh=kG+U+4aCkV8g6K/achhIx7207AyNHmy1JcI
 6/4rI9hM=; b=LRPozRU7GhFHCKhfa12k9Y7zituVcyxLnZcdLzfl7FZYmnFRaO9
 8+8WU0/p1GuvAy5rbRC5/Jou4yAmUeMy82U7zpuEEbli5O50yK9jKDU5B3V0mXuy
 b7twfUTI+8ZeKzMZFG2ZBPorOvinV9yAJVxwX05A+IiHUKc5TiLHaaZcCGGEHJSm
 bLzzzFqTERDBgepNZoPYNeQcg194aK2zRf3TS6Zo1ZexML8YxaqCB/rJWp5K2lSY
 wDpeRgXD5bw5URMfqbQ/JOfX8TF8MCxCouHCVszt7jF922rD4u4Vf/oE4fLVPQRj
 A+bUcyavEffu5f8W6CxKUEOvznkQ5SdJnYA==
From: virtiofs-bot@sinrega.org
Message-Id: <14027.122101108582901062@us-mta-435.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 11 Oct 2022 12:58:32 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Allow for reconnection after
 the client disconnects
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

It'd be nice to give the user the possibility to choose if virtiofsd should retry to listen on the same socket after the connection from the client side has been closed.
In practice, there are a few use case where this can be useful, like VM reboot or a potential VM migration (on the same host). When these use cases are triggered, the VM might close the connection with the vhost-user backend, leading to the termination of the virtiofsd process.
Adding a CLI option `--keep-listening` to virtiofsd would give the user a way to choose if the virtiofsd process should terminate or keep listening after the client (the VMM) disconnected.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/62

