Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1669740800; x=1669827200; bh=8aT1wdMR96I+waviPrZu/
 fEJDh2PmXtPfepHqI0a500=; b=DRXKI+Wy2Et6aLBQm/Euqhq5t1iaW5+OFwVSi
 /7w/KvYut93LVYN7iqKBs2LRSAOGbukHPYmyRJOh+JYOJhcwJJD1G8X4QsJmy/u9
 qs05Hw6dllZ7VQB/W8+fJNN9d1Y2bJRvqyAJiSSDRFOIrE1tYGpKrILEA11efEWY
 Hu0apJ8RjYYe/AYQFse6KUQKK3BNasaeoB9r82U+phVKk1Td3SAiv7+xiz2dajQl
 cXlq0obfzyX2o6kLcUaTCGuNq/CXe7wwVLjgFWlHwMMAuqI48nuWbyv51zXeMI2L
 Ee2reWjB58VsZCiNyZPsnYcFy2yrPsCrdtybGIKQ329DqfOTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1669740800; x=1669827200; bh=8aT1wdMR96I+waviPrZu/fEJDh2PmXtPfep
 HqI0a500=; b=KoImzCdnQOrt5C12WbUMvz3BGVFJ9ZnwWqB7WaG2sbkY2Elmlq8
 78M2+Yv15o0QzAKLXZO42G2pM7Y4We0RC/SxL1n6AskG5CWq8gK61rX3AHgKDYaN
 EyEsh7Il6cRcB6UPP9b/ac3GLzLFQa4Toln6UyGLhrED9zy8vNkQtD9SKwgk792R
 Mgar+MNc2libnA6yu3wQJ0irqQpVsbYnr3ic/Fg6JVw+vZKk5Kcaft1SeQ27lS80
 S0IUIz5iGqJXGU6m6LAsIXfZ97KO9WEW1r3H3M8D6G/eW+71vRyvNlys8jyrwrPc
 TfRCmz5H2GWu66HRpMTywRjf5GHTTSR5Jsg==
From: virtiofs-bot@sinrega.org
Message-Id: <44568.122112911532001137@us-mta-290.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 29 Nov 2022 16:53:23 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Add viommu support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

We don't support viommu, so the guest kernel hung when trying to access the virtiofs-mount directory with viommu enabled.

Libkrun seems to have a patch. Sergio is planning to propose it to upstream linux kernel. That will use iommu if available, otherwise it falls back to swiommu in case of confidential computing setup.

Tracking:
https://bugzilla.redhat.com/show_bug.cgi?id=1976676

Related:
https://bugzilla.redhat.com/show_bug.cgi?id=1812886
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/68

