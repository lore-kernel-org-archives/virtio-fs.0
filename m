Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1661246450; x=1661332850; bh=IhA9j+4adVgkTV5WZY8pC
 wzo4FX7XRr1TRkZc229L2E=; b=cumPQnvuLKWnStj8d3bjB4Z6OoFGKDO7H2jVF
 VblmeVS/DHAVMsb1mbjFppEDYiQNhQxtRRjuh2RHZbvEMhcXavcEUX/iouLyRw4v
 sQl9pR05+J5D8fDwu1Ims8uwxrKXNseVbZiXzhGHTnDtjHH6R3nd01w5qAm2+4hE
 UqXORd/CjgZ51z/9JIpD09FtiJ9bPBoPB8vLGFd1UBoCPSp5CwfvZDojMnXVLx0Q
 KfKOT5nl+sfeYZAgnGQ16Ib5nwFs1HZi5aO2zkuhxXTzyUG4jdsfymu1l08BPuOe
 78KVAoRanOadKXL8PVKAr7PQxorQayZ5wZ4acsiu19XwFfJYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1661246450; x=1661332850; bh=IhA9j+4adVgkTV5WZY8pCwzo4FX7XRr1TRk
 Zc229L2E=; b=XPo6y63lAJcdKsFKDSpsmWeFoYyYnKUF8OoqpMr1YSWNe7yFo/A
 1ydjzK8REYCe1I42skRxkAUAX3hiHqFwjV9hgfW9P2G43IPATXfKBnwEgunM3C3q
 x+/SlDqTFC45KBwoWHP2irKWzDuc4kwQEiJ0hbE+n/TvorzAsRKtKc7qPNDmPn2p
 9gxfgqGBjIiWlmJS3xO3iqPj+25JevGMjPFws71+JwsWUw3KYMax285bdTGJGXEI
 HIxTKS/4/MRK7u3hTyimHZFvibPFkTdt77FVr1TQJbg0A1byxq3qTNTyu5SAdXKf
 vXl/hwmQ/LTHRzDA/utNW/CysIpfY16QkDA==
From: virtiofs-bot@sinrega.org
Message-Id: <14001.122082305205200237@us-mta-203.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 23 Aug 2022 09:20:54 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Add ppc64le arch support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Running virtiofsd on ppc64le fails due to restricted syscalls. This PR adds support for allowing it.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/130

