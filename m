Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1661528211; x=1661614611; bh=NUuxxBrqCfOSqiAHH369t
 +BU7X9/PiC5fUjiABeBeTw=; b=nUZRDk6B51tSlsb/ZAPeEEYN9KtW1sbZuOqtO
 V/4WLMD9Y9oilHMwiw7EvQdaXJGGZwGSneudulrTJljlR8J2bL3lwAV3tVifklNi
 /pe6pKfJL0kbYFxy/3kDuzU3PWy2HrjScCi7TmepfBKD3pEGukfrRnzH2rLpKgrl
 tEPLQRBbVXKHL1tM9/Xx7ShgQwBh/lHv4t04/6FERiW2LYCmXeCbwq8O7z/gFjAB
 ORlkWKqDkobT/iA30P211dPR1kt7S+JN+L5yyxe7t23Px8yhBv//bwXlN3jaXxm+
 vXPU/gadud/r3uUEO9OATaPCU5inaBB0ACoclx5E55u71HSug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1661528211; x=1661614611; bh=NUuxxBrqCfOSqiAHH369t+BU7X9/PiC5fUj
 iABeBeTw=; b=Zz1zBxMXfRO4w7taXIuqn0nO8MNf5BjRdG/OM7IdWjnD1yD05kT
 yT2ddnva27PxvZ69w/EmMN9WyFy9QWJgZUp1IrS3IGEPsLmtZ7dPdWRKScwodrBB
 Cbh3IRnMO6IIBaSTTIOo58Sy5gKGodR1ML3ffR2nhxpK23NfAYXbniKQWoBTTUfh
 ak0nTqc9/jAcDCENT19iTllF63sxpCG5yZKt4wORQhpdp5NSmO2SAxgAcli3NlLF
 OV8yHnqXHjMy+EZ+HzaEW88r9QuFLp5A+1upeeQU/DssBA7wAtX5P5ZbPy86aZtU
 wKrSzMEmbRMjeVjQzeelvw88sD9WIdCFFew==
From: virtiofs-bot@sinrega.org
Message-Id: <12365.122082611365300600@us-mta-368.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 26 Aug 2022 15:36:55 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: virtiofsd crashes on ppc64le
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

On running kata-containers with virtio-fs on `ppc64le`, the daemon crashes
```
kata5 kernel: virtiofsd[2972424]: segfault (11) at ffffffffffff7fa8 nip 10000408 lr 0 code 3 in virtiofsd[10000000+100000]
kata5 kernel: virtiofsd[2972424]: code: 000000f8 00000000 100bba70 00000000 1010fbf8 00000000 000000f8 00000000
kernel: virtiofsd[2972424]: code: 100b0a30 00000000 f8410018 3d82ffff <e98c7fa8> 7d8903a6 4e800420 00000000

```

Error from qemu
```
containerd[2955383]: time="2022-06-01T03:52:16.097442066-04:00" level=debug msg="qemu-system-ppc64: -device vhost-user-fs-pci,chardev=char-fda46e8b9aef8bfb,tag=kataShared: Failed to read msg header. Read 0 instead of 12. Original request 1." name=containerd-shim-v2 pid=2972415 sandbox=qwert source=virtcontainers/hypervisor subsystem=qemu
containerd[2955383]: time="2022-06-01T03:52:16.097475126-04:00" level=debug msg="qemu-system-ppc64: -device vhost-user-fs-pci,chardev=char-fda46e8b9aef8bfb,tag=kataShared: vhost_backend_init failed: Protocol error" name=containerd-shim-v2 pid=2972415 sandbox=qwert source=virtcontainers/hypervisor subsystem=qemu

```
```
# qemu-system-ppc64le --version
QEMU emulator version 6.2.0 (v6.2.0-dirty)
```
virtiofsd built from source - version: "v1.2.0"

Hoping to get help on debugging and resolving this issue :)
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/50

