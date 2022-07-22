Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1658482773; x=1658569173; bh=gU09Li5iTqbaVmkiBRSYi
 u1qAkG+n2ThJB9shtOjucs=; b=k6UaDZcCHsG0aZiE+CuqTLpDozHWYUzCSbKwE
 sjw8Rl70vc5GkL4G6uNZzQAFfuwZD5SALNW4+MC0tIJoKCSnlv3HCiE5BAkUwi5+
 ZOZHTFe5YUnZ+VAi/ctK3iK/VpziVW7G3PXOZVhWkxQFQd23HQK8cNsYt68AfWSM
 PeYHygXBuogDwT9DS+w/GOigoV6QHzBqsaVNRbFutjknE3w/N0YoOkdMUlBo1IXA
 4eIw1Nu/it71RlAJNzPBANeca1pApogy//pw1BYsyHvMujfmUcV83nHTNMjr54Ig
 FKk2icsZrh1dDiyZSBHdZ3fKu7+7vEQitaIj813HWTbqJScTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1658482773; x=1658569173; bh=gU09Li5iTqbaVmkiBRSYiu1qAkG+n2ThJB9
 shtOjucs=; b=2MYEZcoMdMOL7AXlDlQQQV1MZ2skBBvZqCvpMtbzSSJqDQ9DeXe
 s8Jrjw9OOw3ZgnrLrGDmCTVIdmkIXCi93YVXWOIvRluLuNtFRmS6AsY/3UgAzFQ/
 2/0orvhXlhXfqNqp/9rzeNGJxgCKYP25qzHp6htVQWrt4eWHIHLqLxjXqZgzUP+P
 2jxjn2PEc6k3ivoVNILPk3iFNuQKvb6Z8T4BlosOkqRwmC50aA1daTl2tzq6vISy
 3lMVZByhna7X1Irq9BXKC/2rDWvyOsfSOezlZ4vtxmbS0VNDHeYbWbqDLrwSdZa6
 4fvfAPtfdnmfCBMDsGE//KG8JBajtxKEZ4Q==
From: virtiofs-bot@sinrega.org
Message-Id: <66295.122072205393300673@us-mta-225.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 22 Jul 2022 09:39:35 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: sandbox: Move parent process
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

