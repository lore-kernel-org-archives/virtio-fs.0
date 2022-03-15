Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=6/qgWS0oEgYI1vFW4geT6bUtNw8pW+/ff6GpIvHMyoY=; b=E
 elxbE933kP5z7eSwNCONcQLILwIiBc2lss7VSjksE2Mxle7JhrnCSg8WmYPBnA2s
 9vRMuRDh9ZaMuAQBn64YF58wKNS27JD3rr5lUrHFGEYqXJwSiV+Ea79v1xwuNukg
 z2wN9JVE9Gj0gc9yK41knuv4mP4Ayg+l44ICrWV+benmyhxJYegXO674MpRIT1Xo
 f3VddfNKydE0QjR8Cgnel0RaqEbgma+Ns0BiFs+AfzKBxH4XwA1haZ0wNBcayVe7
 C3iYV/mBN6uGpkF+FqlUXArv8wkE0o36F47S8hATO0yzGvT8P4vbkBeGnZnjnXyl
 Ya23xE92x8GKxZXFa1Ryw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=6/qgWS0oEgYI1vFW4geT6bUtNw8pW
 +/ff6GpIvHMyoY=; b=lGRIBndVkXzlJZ0HAe75E/483WAVHZcP7OAH1pJq0WSs/
 SIfU5GPKpq+au0v/Ji6cMhHrrPACAhH6xIFehHok5w3E1ORDk80Q7V1riQbqANUP
 5j01AwEuDMSNI79PkRKACLxWYNjcasj5BoMiO+s69FyjX4Oie8fgB4mTt8QcAM2b
 d60O2pKeFYAqforDxqSmpFJhGrdV31hMfsiXo4tVZNvVM7hQ41xNVaPHWJhldCr9
 fc+czSiQIRx6OuVUgcFh1RVNb4hwfmzODk+gCYWd/J/vxUrkequo6HXtnnvSt5wy
 8kZMvC1+5m9KEYjWpb6YfiTLahXCGpm3Vx6M3lwOQ==
From: virtiofs-bot@sinrega.org
Message-Id: <94031.122031420431100535@us-mta-274.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Tue, 15 Mar 2022 00:43:14 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: virtiofsd-rs dax panic
 QueueReader(FindMemoryRegion); virtiofsd(qemu) works.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

virtiofsd-rs behavior diverges from virtiofsd(qemu).

To reproduce:
boot guest with rootflags=dax with shared dir being a rootfs.
on the guest run:
`env -i -- firefox -headless`

virtiofsd-rs result:
`thread 'vring_worker' panicked at 'called `Result::unwrap()` on an `Err` value: QueueReader(FindMemoryRegion)', src/main.rs:222:18`

Platform used is cloud-hypervisor

As per sources Error(FindMemoryRegion) is associated with "no memory region for this address range"  and  "Failed to find memory region for guest physical address".


This may contribute some information on the issue, or be an unrelated issue:
When using virtiofsd(qemu) with stock cloud-hypervisor, cloud-hypervisor's seccomp kills CH process due to syscall=18 (pwrite64. pread, pwrite - read from or write to a file descriptor at a given offset) apparently being an unexpected syscall which doesn't occur in normal operation. Launching firefox triggers this syscall in the VMM.

Running cloud-hypervisor with --seccomp false and virtiofsd(qemu) results in no observable problems when launching firefox.

Unknown if issue reproduces on qemu.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/39

