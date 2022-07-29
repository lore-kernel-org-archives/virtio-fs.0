Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1659064902; x=1659151302; bh=RwVILZKNbf7njBxnury6S
 yMdchGRDpx2XoBp9zZ3tqQ=; b=Atvn66AJp5BWPbHhgxsdJ2tHi9RIiBSRg4NTb
 4Sml8S3L60n4WVKI9rShBdp4uuQ+PKCzx4IfroGhYoygFMv0HAlfUvvMQUYfEyHu
 gzoLwHvWe36MX6rjMxlF7F7jPKSSRo2H9QM2TIF4wDIFFpVVpyuZ3OoYE1HtXKdo
 8xmsKMzPPvnsVA0AicKfdzNALaJaITRZc616IuNd+V2TNpzEndLDffE1bJwR6Dx0
 8hNGQ6wT1QiBsQ2grcs1tvuA2XKmw1VgtKLIOl10QrfS6vQpvYvcDhCjiqMd0m5Y
 5My86dqYiEMZRTJkAvVn9j1pRdWwzaUJNq5Zo1VVFoVa3KerQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1659064902; x=1659151302; bh=RwVILZKNbf7njBxnury6SyMdchGRDpx2XoB
 p9zZ3tqQ=; b=yyy1SACqRAQ/dSHnKg14GnzDwAEYPj0hwtrKTuQ5OTNGo7gHyF/
 5KPnd19udCAan12XMIA1x+0sJiJFruFc4Opcu2JNGVd85WG6BWi4vfUpnu3GEIKo
 UUK2zz+CaR7be5NB/zhlj57Bdjudqxp/6zwGSvtp0ses24z85TuYYHC178XgwLOU
 FhqYN/KKO7GKs/O8Uxo70FetiTNSragLHZIcqwlZLQu/TZMlKpPVmyST4dJSdcRW
 edx8At72yrZkBXF90cmuHSvBSnujQG0MmkYcw36SWt+NCg60xDG0jwvJMwtISWMz
 8f0pLwlPZN+ZYchhtRNlJYhX34Wk5uK/lGA==
From: virtiofs-bot@sinrega.org
Message-Id: <74807.122072823214400239@us-mta-256.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 29 Jul 2022 03:21:48 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Number of enabled queues
 lower than min: 1 vs 2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hello,

I'm hitting an issue that requires virtiofsd to pull the crates mentioned in this cloud hypervisor issue thread:
https://github.com/cloud-hypervisor/cloud-hypervisor/issues/4314#issuecomment-1198468751

Here is the commit we need from vhost-user-backend:
https://github.com/rust-vmm/vhost-user-backend/pull/77

It's been tested using a private fork, and we are looking forward to consuming this as part of an official release. I saw you had added a tag for v1.4.0 that pulls v0.5.1 vhost-user-backend, but they have not made a tag for this yet. Do you know which version this will be targeting?
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/52

