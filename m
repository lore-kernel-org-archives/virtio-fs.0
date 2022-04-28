Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1651106035; x=1651192435; bh=ffmKHUPIpNWBxDWmBIR2+
 V5+DjyYizdsdYLmLs4fV/k=; b=M2Kl8O/JHeQYkdErQ7nlD+2H9gVTLcRkjZgjL
 HhBeTQYkkLngPAZDGCVaVla9dmjo6jfnGn6ua813vyF1jvwyLhH474h8qnfZYRLU
 94RHzcf5EToS2yzZG09T5X/QhOhybgKXiFF1YM3N1mQ87B1Htl3OpM2aijTpqY1a
 cGnftgznpVR5cFziX21RkK/WJkDSvMFvd28HYQM/cVWx1C5Hs25T1lpOCVnRRqUj
 7nac+lskfZ++oxmzJ/cs+fpqQnPhuDxT2Cl0TXKd6vOArYqJYHzMqdK8aRZtjqjT
 HE2EjmywCgw6U7DeQefmDghhrapXoSKJfAXOf6JdLsUJ+5LMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1651106035; x=1651192435; bh=f
 fmKHUPIpNWBxDWmBIR2+V5+DjyYizdsdYLmLs4fV/k=; b=wynTU1TBvoH7oNIuF
 Ybllr8c0SYGtOV6SLGDj7KxKYWVZgThhd0W1pg79RnanEacdsDrbA6+9JaKxoA8M
 uR3dl+Ry3qusXr99EqLCdKNA7ITcANjDmFXn4UYHgvULPS/BQioCSioDRKvj4iAh
 cSm65i/9y2WjHuVi0Bmsf/IS7Zpw9GsPnlwblXxpyIvUMM9DL1QhLUzGp5gXT1uT
 mI+EbRY/+O8t9p+aUzPAFeHlSxDyFxYUPxkxFTE4Hw9bgdWtfiQDCiwGga7upAD3
 ymJvo2JQtcxvxq9ResL11PrXts2TOmJEsVoNV/Fk7qdAG3oOyyORcgJzjmdXlFVS
 DE2Yw==
From: virtiofs-bot@sinrega.org
Message-Id: <22027.122042720335500503@us-mta-3.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu, 28 Apr 2022 00:34:02 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: virtiofsd with writeback
 sometimes ends up with stale handles
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

I am no specialist in virtiofsd, but here's the case:

I'm running virtiofsd with `--writeback` mode. On guest, I am using a Debian system with it's root partition actually being on a virtiofsd device.

When running `update-initramfs -u` I'm getting this error:

```sync: error syncing '/boot/initrd.img-5.17.0-1-amd64': Stale file handle```

As a side note, the /boot folder is not on a different filesystem, using the same virtiofsd device.
When removing `--writeback` from virtiofsd - it all starts to work.

Full virtiofsd command line parameters:

```/usr/bin/virtiofsd --writeback --socket-path=/<snip>/vfsd.sock --shared-dir /<snip>/fs --announce-submounts --inode-file-handles=fallback --seccomp=log --sandbox=namespace --socket-group kvm-instances```

Full qemu command line parameters (this one is huge though):

```/usr/bin/qemu-system-x86_64 -vnc none -enable-kvm -name <snip> -smp cores=4,threads=1,sockets=1,maxcpus=4 -cpu host -device virtio-balloon,deflate-on-oom=on,free-page-reporting=on,guest-stats-polling-interval=10,id=balloon0 -object memory-backend-memfd,id=ram0,size=8G,share=on -machine memory-backend=ram0 -m 8G -chardev socket,id=char0,path=/<snip>/vfsd.sock -device vhost-user-fs-pci,chardev=char0,tag=rootfs,cache-size=8G -kernel /<snip>/fs/vmlinuz -initrd /<snip>/fs/initrd.img -append root=rootfs rootfstype=virtiofs rw quiet -netdev type=bridge,id=virt0,br=virt0 -device virtio-net-pci,netdev=virt0,host_mtu=9000,mac=52:54:01:00:00:01 -monitor unix:/<snip>/monitor.sock,server=on,wait=off```

The qemu is the one built from https://gitlab.com/virtio-fs/qemu the branch virtio-fs-dev
The virtiofsd was built from the git source code, main branch.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/47

