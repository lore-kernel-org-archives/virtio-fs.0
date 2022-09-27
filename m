Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1664294969; x=1664381369; bh=HYKcR1Lf3nTplrBEA//nY
 NWtxNGhcx7iQ22P+VAJa4M=; b=XspmJ7IugHO8lOTdQPunbW5FA0Q9R148bs27e
 4VHATwOhcJSJpWtZe8ecXjA9ll8jXsqzxKjOH2yX+Yw3EebtTVU+drq/2lwCMMXI
 zt7Wb9DPS1X37w+lBGpRkz1m22AF1xchHlJkkJf3gvWZa90v8aMP/ljO4l7QFLDp
 a5tLdiyApwefsjHNz/zoGPjre9LcIJ0brwFUFAdkmghZliLG6RtfBzSnaMr0sRqL
 IkF6Y5qCQZlHp94pOrQ+1M0bPQ/TxqPJ8AVIGsTfhh5XW1EjfrUuJeXvQT3bJLB+
 pt3bRvNzX5QHelopXPdROnRPiHxmKy9WozgIDmfSH3fCB5hzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1664294969; x=1664381369; bh=HYKcR1Lf3nTplrBEA//nYNWtxNGhcx7iQ22
 P+VAJa4M=; b=zC0eKIpY/duVCie9kyMtVI1NP7xR/L7OZcN7v1K5YTOZHMFZTUC
 CObxNcPQDbluzU5EiOmTh8KvMMsKGwPpZR4k4R8iKqfpaAEqhkcEE1SmTBzGFW4H
 6jH6EpWTglHkCEgijIZyAkWwJwT1jDtrx9qe+A95mFZNFHaIqR1JV7QaoTKrrBoQ
 Ud3U8vXtyzydXS1kX5oriVuep+GFviZr1XwYPZO16NDHUO5bbWhZVPd9bqMpSndZ
 uG3gKcW7Bz3a62Ril+fb6ak8hmw/ZYgYc3rKa0n4Otaoqo3Gu+G8vF4EB7dsjs50
 Q3qoTsy8fi2u5wwOEwelcVwSaylRZl+jNyA==
From: virtiofs-bot@sinrega.org
Message-Id: <24382.122092712093001487@us-mta-402.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 27 Sep 2022 16:09:33 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: Cannot copy files / crash on
 Windows 11 22H2, Server 2019, Server 2022
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

While trying to copy any file from the virtio-fs drive into the local disk, `virtiofs.exe` crashed with:

```
Faulting application name: virtiofs.exe, version: 0.0.0.0, time stamp: 0x62887e76
Faulting module name: virtiofs.exe, version: 0.0.0.0, time stamp: 0x62887e76
Exception code: 0xc0000005
Fault offset: 0x0000000000008f70
Faulting process id: 0x0x10CC
Faulting application start time: 0x0x1D8D1CAF5E62D04
Faulting application path: C:\Program Files\Virtio-Win\VioFS\virtiofs.exe
Faulting module path: C:\Program Files\Virtio-Win\VioFS\virtiofs.exe
Report Id: 6d921400-ca34-4501-b33e-6d9d8ab87909
Faulting package full name: 
Faulting package-relative application ID: 
```

![image](https://gitlab.com/virtio-fs/virtiofsd/uploads/5614deedbf07cae5fec26ad36bace46b/image.png)

I'm using:

1. the drivers bundled in https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.221-1/virtio-win-0.1.221.iso (only `viofs.sys` had a version string. and it is `100.91.104.22100`)
2. winfsp 1.11.22176
3. Windows 11 22H2 guest, Windows Server 2019 or 2022 guest.
4. Ubuntu 22.04 host with packages:
   1. libvirt 8.0.0-1ubuntu7.1
   2. qemu-system-x86 6.2+dfsg-2ubuntu6.3
5. the libvirt virtiofs configuration snippet:
   ```xml
    <filesystem type="mount" accessmode="passthrough">
      <driver type="virtiofs"/>
      <binary path="/usr/lib/qemu/virtiofsd"/>
      <source dir="/home/vagrant/Projects/windows-vagrant/example"/>
      <target dir="9ee5aaf7cf944b385ee3e99881442aa"/>
      <alias name="fs0"/>
      <address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
    </filesystem>
    ```
6. the libvirt shared memory configuration snippet:
   ```xml
    <memoryBacking>
      <source type="memfd"/>
      <access mode="shared"/>
    </memoryBacking>
   ```

BTW, It would be useful to include some kind of version information in the `virtiofs.exe` file as its currently reporting its version as `0.0.0.0`.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/57

