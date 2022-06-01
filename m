Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1654071591; x=1654157991; bh=LzvDYHwHJSL/Twyi4N0f4
 zQjaNrewyHFBR8AaTqMr+0=; b=S9l1SdrcA0KK8SeNzJ8U6AP/k6rj9XfCOGasj
 o8yj59Xh53ArA0ci/R8+YhbGy3/MvmxUMi4MNNZiNIUUF9tH0daFm2CHqOuVfi4H
 xySU2208yNsDy1UgCX0m+5VNniODf3Aj5qviiV/GqJeefvQ3EkjuKP7wCzu83JeT
 baJL9VRRfAqgjxSV5Kp9Jjbxg4KV0TUcXQf0jDR08kLXp6HVXxXMg+EifFldL/sp
 c0pFiwpWx2sl8S29qkb+MEefgsA4Qrko2F4yqW+isIKRKGMYiqBntEwKuh7+4rud
 DXaSSidSSBSN9QHzq0FN+8edj5vqrXxQHaRqPlsIb24l1/Jaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1654071591; x=1654157991; bh=LzvDYHwHJSL/Twyi4N0f4zQjaNrewyHFBR8
 AaTqMr+0=; b=eN0vTk1APn8f3dREF+i/SMmkJCbH2aPW26hIB4o7wRUA0PXJpaW
 YhVgIb8W8GFd1/YRGGwVW1SBa4N8LuWwRwVjyARtBhrd6zdhvK07zWbxnF3wsvCs
 A2SD1BjUh2LAwzqEwwnDCaoNrJG76M07mpTNI2nvNnuMn2YlFAsmpDn/H88XNOjQ
 uU95ICo8nBTD9roqO5aI6fyQUysDXLUfFlUZ0ombzIfAnzB8LiTsZiSiBtWxuNch
 PNQFfB3SscuM8sKk6OzLnUeimTS31W6DLLxsD5zWnC1+tmnRbrj0OKeolj+QrTCr
 1G8fM4xNogHw8hUK/PnvDi5Br6i//O+8ArA==
From: virtiofs-bot@sinrega.org
Message-Id: <05765.122060104195300567@us-mta-144.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed,  1 Jun 2022 08:19:55 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: virtiofsd crashes on ppc64le
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

Hoping to get help on debugging and resolving this issue :)
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/50

