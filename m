Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1659112885; x=1659199285; bh=fiZIP2gowrHvZKMF7r0ny
 VAeaK7/dxkqIhND46lg7GY=; b=VuHdbATC//SCy8/nARo99qv0ytRF42V8OKZrs
 RmL9ymOFzlj8F4B0sedlyvSzBZMHxccZzLS1l/8wS6SgpC1R0za71SgZoDFfSK8C
 1Qo2rbNcVjrEnKvdS/pCZnyj7mezC2brfT0Lb2IOXEUy1kaz6MWF+X4tWr8PnJzL
 rl+BB7lUAEmnSuc2DJrpGlC2nOw2DVbLGhdQQ73mGeiZD9kXndLdBMx3L8ajDe0Z
 kWRrpH0EbZVonlb/BD9ToLAon1vCb+vUzTj1KuZONSicSWWgWUA8KKDe1cd0LqZF
 BVQqz+Wt8hOHGijwqxNM4yODemcpd+XBpqsafSPLboVp08vFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1659112885; x=1659199285; bh=fiZIP2gowrHvZKMF7r0nyVAeaK7/dxkqIhN
 D46lg7GY=; b=IGqb4h7F/YZwjucpFCnd4Cnyp8EWfvmJLa8CE7D2C1NcY67OwoM
 oKeERt/zhaFSfhWG1MrzcGImoleE5KCWrF0dnWto8UBriVCI3sDOgFB3e8aKCgjK
 bISeP+5vdWDp4y1EhdV/wVZbsTBB0/fvMPSg0TOs7NKC/ZPyBl++5LINb0a5En5d
 9hbZpxZ7HjOEnhaBGAP33KSWuaAs+4gOkHyr8rNoRmBYYOUOJv5Vo3Ule3Vmb90i
 90ohtsO3z3e45LAIhZgxpKgTNsRgsbqEh/XxzXBN/rlZgR/NC4sf7IjD332D7xqk
 eY2RvzFlJtKtm+SLeorNxhipw+fWheCfWYw==
From: virtiofs-bot@sinrega.org
Message-Id: <54885.122072912412800578@us-mta-474.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 29 Jul 2022 16:41:30 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Bump vhost-user-backend and
 virtio-queue dependencies
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
- virtio-queue 0.5.0
- vhost-user-backend 0.6.0

This latest virtio-queue version introduces a few breaking changes,
which is why this patch slightly updates the code.

The latest vhost-user-backend version relies on the same virtio-queue
version, but it also contains a fix for proper vring initialization so
that booting a VM with OVMF firmware works as expected.

Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/129

