Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1665612097; x=1665698497; bh=RI8wyk7wGpID4/2rsLOlM
 fYLd5h5iXp6IxaWSAsBAdg=; b=RT5CwwNE+u5Ng5YZUog69eXizksb/TU4EmN37
 Cn2LTu8Sd4hCdDdgk/esdwo72UKpkKhcQbZI3bhqUhR8f2uH3J4vcppWGhdBJgw2
 wmWHHlRqTRcVS35kqVgvbsXAOLVG3bIRNckmthYXGFdLejin5RdKHYv75eDm7IM3
 5dYM17niSeQg8JWATwUHR4is1mL2odvYe0YINlZGOQWbvmY1kz3WLbzu8Nog8/ei
 cgo8mvHSLYY1Vijx9Q9AvnAucQp2vnthJIPx3irBFQDRj6hXjT7SrtJiOtyXN54M
 YSN93NEXLWhQufRfaEkS1sNGFqfWD8HSsn/gBRAmMnz/2emrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1665612097; x=1665698497; bh=RI8wyk7wGpID4/2rsLOlMfYLd5h5iXp6Ixa
 WSAsBAdg=; b=rijs3QikYON4V6cvpHrba25Vqg+jX9aEs0jJXAjJPntfyIbMz+E
 loPOoVjPIjRvrQAvxAm+5KREaJGScH1vptd0P3OlCH6/S2Q1h2tSBsBWve1KRvID
 H8K4oh7rgD5Nxwi6+8TI6nN/zNVECbVdjyMZzoSTzYiXjdGmPjsrwJUY7r2/rM4U
 zTHEYsnWf0Tul37RjSrpXxmjRt/FPHK7RwxmQEK/C642qL906btT/jZHjpBJ6uzS
 H736tktOUWrkONP6s0fxlTPxQ+88AQzcJzHNpAWmg29XpgX2XbSDlMBpSq08jk3r
 SAbtPwgcq7ZaMBBfinFrjeYMBJL0QJBxmVQ==
From: virtiofs-bot@sinrega.org
Message-Id: <58468.122101218013900789@us-mta-212.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 12 Oct 2022 22:01:42 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: remove file from host doesn't
 free up the disk space.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi guys,
we are using qemu to create some sandboxes and use virtiofs to share some folders between the host and the guest. This is the command that we start the virtiofsd
`virtiofsd --syslog -o cache=auto -o no_posix_lock -o source={some path} --fd=3 -f --thread-pool-size=1`

We find out that with such settings, when we creating some file inside guest and then delete those file in the host. The disk space will not be freed until we run the `rm {file}` inside guest again and guest will report  `no such file or directory` but the space is freed.

We also find out that once we change the option to `cache=none`, this wierd behavior disappears. 

Is this expected. Is there a way that we can enable the cache while make the scenario that I mentioned above work?
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/64

