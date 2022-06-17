Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1655456302; x=1655542702; bh=14YzaxmwaZX0TQTlCcrD9
 R3msa7FrpoJ1SSN4k0Feek=; b=bNfLMFf36C1zkI/YAcoT6yTAFwkogF9fJycLU
 CPibwX1XMKrmBLWLHvwNMgvrfOAP5G91Jmu8a/NsHqZJvP1D0RYhs2S92KSz2x5Z
 aaMx2u1QoRPBeX1GWP7wOdgyRHkCgF9zqFYanglO70HXVD+31S4e1VGVB4Vt8oa9
 EqThgB1KqEq38bO6V/m9hgEA+5hpMMknMAGqOpOCmUFBnAiyY4xqlZd3g9+k3lD/
 OCNlqRi3pFEQh4/aCOwJZUyd88xqJbYwqbXbQAButkTEbhgOeyw/iBF+XP1wmlqL
 twslxWKKjIDJWDqV3VgJVCkgWbDg3cQzPGtGCLjitgtxdSdRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1655456302; x=1655542702; bh=14YzaxmwaZX0TQTlCcrD9R3msa7FrpoJ1SS
 N4k0Feek=; b=kQn4NVK5z03IrNYARhnKhuVF2dyXaDgJmXV3aKCZDzwfn8DQ6nj
 XpJmoH/lz0BhNsOzzvb/fIsEQu9TD9nMOmdFH40kGy5O5RUCAOrR8GIPWW5zIL9T
 ItWo5FyJI+nHhKBtBUFYr66E61Ty0d0NRfdguI0zJcUadOZiXSkJcscVJ2pFwTpv
 CWHCLkwKuQ3yAaufxZXntLS1aAsmRPcmD463QHVN6NTr2FmWsVV2oK8Qo3NP/EvM
 aawLhTKebozYop3XAbmxWlntIvvLqRttOXvIHTmlB5Hh1cXB3dsMO9prW3OFKVI0
 Zc4k2qzaN5UMtNozd06STNHwufZQ8cEe+/g==
From: virtiofs-bot@sinrega.org
Message-Id: <19119.122061704582400209@us-mta-651.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 17 Jun 2022 08:58:27 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: Cannot run executables in
 Windows guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When trying to run an executable on the mapped drive, I get "Windows cannot access Z:\something.exe":
![image](https://gitlab.com/virtio-fs/virtiofsd/uploads/7e4aadd7ad761ff0941561dac49d6f03/image.png)

I looks like the drive is mounted with limited permissions.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/51

