Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1664213792; x=1664300192; bh=pr9P9yGYHitAOm+lHzmJV
 QMyQCPRaH9MnbztYfhUNvI=; b=BcFpMtpAedmgAmRgcVP8n+AcJKCNs4OJ9NUBN
 QIkEGRICj6nB578LXPZg5H0Sv4nLn6cfM7Od97x3qgXQGcaAG3A1zVHET0rhAPdC
 AA/oBVYbJeU4khsGjjFAR8GdDKVgVO4Z9UlZxUDG5YA3L7m2+xYcjFowfYmsGhAR
 8b2g0X4fBg5KyX8h8CbKGWBKtuLu7Fwjz0hzJ7HZ7ZIcOWpxTpAuvj+9KxJGUGQX
 p2zniIZOiAustWAEeBpGAtYZbSCw1/ybF8ALuUPwRMRNo9l0i1oLn7UpJ3C+SjKo
 ywfNoChwVOkfSd5S45iBJNw5YJ13rFSo4wsginP3uO75HDrRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1664213792; x=1664300192; bh=pr9P9yGYHitAOm+lHzmJVQMyQCPRaH9Mnbz
 tYfhUNvI=; b=01jB0u9VsDQNsKCprjZbuR6pNs2LpWcLbZ7G4n9HkX1W+cfY004
 ZjzlwVswcgKX3qmj3Q0D58ozgY4XJqWm4Dg0gmeQKQSw3A22FvEzOpY6UIojz3FV
 Ee0JPP73BTepu5qh8lo9Yq6DfxSDw7CDFrThmc71RYfVwlJlHUvDkXN20Gfbgjot
 Bo2cL0RPw4rt36hLEwcKVGM0varreaf21fkkMcuCfdRP6TfrZEJdTuLzcKLFtr5y
 +gSrJZCn5+4Ri3sNdqvgmEUKqpbjeVCqSWUhcTd/sEMuKY6A0F0eA/hxnf332jPN
 /lwSxc+xFtvebC48/6NM8nSgvfdmW5VHbOA==
From: virtiofs-bot@sinrega.org
Message-Id: <39005.122092613363600553@us-mta-574.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 26 Sep 2022 17:36:39 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Cannot copy files / crash on
 Windows 11 22H2
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

I'm using:

1. the drivers bundled in https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.221-1/virtio-win-0.1.221.iso (only `viofs.sys` had a version string. and it is `100.91.104.22100`)
2. winfsp 1.11.22176
3. Windows 11 22H2 guest.
4. Ubuntu 22.04 host with packages:
   1. libvirt 8.0.0-1ubuntu7.1
   2. qemu-system-x86 6.2+dfsg-2ubuntu6.3

BTW, It would be useful to include some kind of version information in the `virtiofs.exe` file as its currently reporting its version as `0.0.0.0`.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/57

