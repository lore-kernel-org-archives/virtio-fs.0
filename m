Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1666009836; x=1666096236; bh=fY8ZBIH+dDj0RoWImf82c
 LrW1HRf5EVYsLVn+cz6D7M=; b=oKAlL9qkWF1Cxwd4ksMDd4IXYLahO2mQlsYZu
 EyH+Tf1TR6I9ZuBz0A3uUnl4BdW1A5qXB0HjOhWr/h2PFfF+qJzwpQHQzIQ2avqc
 yjFDpR5fqIr6QtLlKA5KGuB5AduueRbrD/gajKMUYnbU/MgDpiaVVlbaeeI6OlEG
 q9DnKBhGyvLOzY7HRTm4Hj3ryNCaBIkTuiJEWsm3h49rUd6fnLiVq4oClFm/ozvI
 0fNqt0r1nMqfEti3+L11d3V01c5ruQcOa+jeRL/MxHR0n5ar5nLpeVu+EFK9C6OS
 Ov46dtyK85+nej6LMMJzApI59QRwzxDAiBOdm+qF1FxNq7Qew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1666009836; x=1666096236; bh=fY8ZBIH+dDj0RoWImf82cLrW1HRf5EVYsLV
 n+cz6D7M=; b=OsHjCRpI8lb908iSL2xMuoeV+KRn3khykw6mKJ0GmQpSu4rlKGH
 e9M4+OAPF1okvj1D7qWi2cxgEzz2e3AhZuutVevE1renBhc3BsfTkxZkJTtkXA/T
 QK0xWR10mhji2GPk7iWtaKubkI/FiMNZNHsNctgH0+T/kTzLRwvzaZu0nEueuIi5
 dRZQCusjMVHx0YmxKCl/Fbt5C6v2W2Qw9gBRIcpszsBAT97vsS+gH2KlBxn/hjj6
 tVHvH1ozbW3bZiw2yvhKsZiG9DJyZKFTtY3ZQTdm115/wg2h2FLveVTSPOujQjfG
 iME/L+/F9dMUP+Z0rbpmFTcUE0UGOq84/jg==
From: virtiofs-bot@sinrega.org
Message-Id: <40246.122101708303800983@us-mta-471.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 17 Oct 2022 12:30:41 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Bump rust-vmm crates dependencies
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Updating dependencies to:
  - vhost 0.5.0
  - vhost-user-backend 0.7.0
  - virtio-queue 0.6.1

Signed-off-by: German Maglione <gmaglione@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/139

