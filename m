Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1667923167; x=1668009567; bh=fY8ZBIH+dDj0RoWImf82c
 LrW1HRf5EVYsLVn+cz6D7M=; b=HyW48qLs1521zG+KImEVOnsZiRquWEdsoajze
 G4SvVuM+J5BlKJZM/BAPBT4VQDxTugIxwZSoTwxKT/Oc773HqKV1XtvdXurCKlKf
 0FYmKe3VdjOZMS8voF5U2K6ePy8MdUzzGN4oGFC9T8p7e3L9XPnrABbx88pVTsRr
 QESYkcO5dEap8dE3KMqdK95Fuv9rw0nhmrK563jho924GHUlnF2aEfWewxstXl34
 7AYRTQhJJV54DXsR1OtVxDju8MPWXv/5Vq78KHoPcEGl6xS/xjGgjDLhc0/MUY3u
 JV09aqTskfofoio+DrGVhtLOwuL6HX6sHzauNqXW6BRbS62yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1667923167; x=1668009567; bh=fY8ZBIH+dDj0RoWImf82cLrW1HRf5EVYsLV
 n+cz6D7M=; b=gnXG9wNQ9efTZN5/TXBogzc1/zrzAGICTa3K5Zh/JpA/VWS/ENy
 X5xErml4RhvnsubC56uzNVwtRt50E8ANdLs8fe2UHHzGbud8dVz/W7IVv3nVSuNV
 iVHN4RCWtYC6bGI/X7emwvsa0s5QpWoW8Iy8TQig1hdXmcmjFmrQ6IerON/ZeNWI
 ZHvjm3HjFQJ9FUAPtSDOjoBqt4mcP2LkZOzwKIkdp1sQupHiPQzxMoaovrUF3HZ6
 xfZs69/ukuy70NSMpYwF0XueLQkt7CI058BG+aMmI4RsR+9kEPYFFCbOlISvYIQZ
 4ochqkVp37CA45sRdRtru4uzzX1zLo37wzw==
From: virtiofs-bot@sinrega.org
Message-Id: <64879.122110810592700171@us-mta-133.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue,  8 Nov 2022 15:59:29 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Bump rust-vmm crates dependencies
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

