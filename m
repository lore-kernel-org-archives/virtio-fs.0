Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1652708471; x=1652794871; bh=gU09Li5iTqbaVmkiBRSYi
 u1qAkG+n2ThJB9shtOjucs=; b=brb02Xybgykq7yfv2fAI4muYe7Dq0gT0hvULF
 ASxgct9JhJwM2vvXVfRLGiWxepD5E3vQXq9XDmFjG4oGJ/Uvu1fetilpjlXEX+mI
 JkOcGWweFwBprQyPAi8QJpk5L4PjmHRXizJcBp80nIBYCtcSiGWoCQ52pzEb4qng
 /usWi+Nlu0hxlchf6kNeUEAqHttVlbYg3bMTUdlsJNE0PC5tH5ZHa9STaES8xRng
 xoP47SIvJhAIO/jnER3y+TmtqY1bryHsyopcchE4/8Kq8p+FKC83+Qr21DIZdw3q
 IMi6bfj6qdxpv2IawE4mghdbUXfurikrjkIAQuip4czqNea5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1652708471; x=1652794871; bh=g
 U09Li5iTqbaVmkiBRSYiu1qAkG+n2ThJB9shtOjucs=; b=WaD/gxGVH4UOAOn7c
 EKnJvj1AO8pB3NqiRC/vEmOkmOQVxPVaPn/fiXObzykvhWRrMuZOt/vSLntuq2MK
 qU4aBYWGRNAQXPP/Fg04679QR0Y6vc3isDlaLTnhGDg4whUErVUqONC7yyR4pb68
 /9CRc0ngVMxVaIBPajZNfQ/ZifmvozF4iMWY7nkRkeYW8FGqPQ5Ie+VBhklodY+x
 WsHjX9xJC9EhOcS4LqMZrY5nSnXuxT/r2Lc7+ocK0oeJT5BvTAsRye6dy8aURUbK
 80RWZ5RzGWg/6P2MyIzSTrlH7EoZj7cwLZSG9QgP9C0sDOlxlfnPVOAv4fznCGUP
 wuk3Q==
From: virtiofs-bot@sinrega.org
Message-Id: <91838.122051609411400259@us-mta-591.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 16 May 2022 13:41:16 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: sandbox: Move parent process
 code inside sandbox
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Only the namespace sandbox forks and the parent process
just waits for the child termination. This commit moves
the waiting code to a helper function, now the parent
waits inside the enter_namespace(). This will ease the
implementation of user namespace uid/gis mapping.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/118

