Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1655445879; x=1655532279; bh=NCMDEuVkmPF37gG6nHFEJ
 eknQKVE1bavXVMRyjuv5dE=; b=h17n1eeDFCcsJFrDWiIvmaF15AXIggCHFLZmw
 x3UmPQrtbXYkpp+rhY8hvtRZ5ffK//VnhHte5fpjxsp9j9mwv60L/z1dY5ZPjNe+
 fxYll+gxLYC6k8TQ8oeBYBXWt8MD8irRciDYaFwzWS4h5iyloKQ4OxPgvRN3rDqW
 V+XbRV+UDRYcV5RUZIX+5Bw7bNKu4kGyfDDNOS3Nuetg2/BMQqZbkHmbQxxIVhaH
 okGfTmNtNeIo2LdLFF0MqLkYNRNA78r95mYRE0S9jfZ8DdZJ/0xvxur+k4gNxFwb
 8orBU/Uy+VHtlTD/ASlxXuANICdnB8w8pFFN/VK/FhsrzdklQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1655445879; x=1655532279; bh=NCMDEuVkmPF37gG6nHFEJeknQKVE1bavXVM
 Ryjuv5dE=; b=cgjZ6Ik9o42DE6Y5OOZIxsqDI2lxedEkHC0nm8cQQv+n24RTNNc
 qwYf8nHaKl1p8p3KP+wi7Ln7Zf5aHWjEmVCGO0kJTENE+HjBT1NCAIxBItzcjjei
 Jn/k6yqiHaV4TVxIDmhmeIIJd0sWvMgYF1LFJa8DS9P4WtZFqcZLIdpE+2jcvyqQ
 /wyO4lwyXocgPfqq5ctoAF+5yNZFdHjvvBvAPjpjWpUR2TUcmOnMqrgksosiy3ak
 +zbKkw3xQDSa6/oI1SoAPx60NXYR+Q4W0O8D6orOtskRFergl2n7JuAsoaG+fsl8
 2OON1Sglejk3t+gKUZk1cr01alYVGjD0Sgg==
From: virtiofs-bot@sinrega.org
Message-Id: <76339.122061702044100218@us-mta-586.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 17 Jun 2022 06:04:43 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Log the errno error description
 on debug
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, when the debug level is selected, when replying an error we
only log the errno value. This commit adds the error description.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/113

