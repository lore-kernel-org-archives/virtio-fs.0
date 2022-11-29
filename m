Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1669740571; x=1669826971; bh=RI8wyk7wGpID4/2rsLOlM
 fYLd5h5iXp6IxaWSAsBAdg=; b=18/zPY3Up1tD08yjERRC6skPa+UeYWgkPMnWY
 JgVtKZrCQkKZ94qQfYH/UJ3jE+w0hzlKPfj1DZSg2FCN53b3MHCVeHaQWg5yZ/oL
 Uf//mWTOHUt905QFx9VPtW3Jyo7xRUqaXUS9y9lzwp0is6q9GYpPrrvmuoesUWrB
 pA+hZGrrkemiY9qpzHOw+DdxYWP99n2sx4tDV64mbw4R5sperzkc6SdXWXVk8Fnr
 o114bLUl1/RPzn6Khy833qBlKr9iFRyeT7sBsjbpRXGo9k6vgnDxaVe0u7rt5fT0
 iI+TT5F2uF/yRjdfpD8taq0s+2qOl5+y9m/aG4VCvDNqIWw2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1669740571; x=1669826971; bh=RI8wyk7wGpID4/2rsLOlMfYLd5h5iXp6Ixa
 WSAsBAdg=; b=Lr+m8gkJucXbU1dEZUodz5bFQCtBZ4ZAQ1ItwTsc5jcsas3XU0h
 E12UHdWFerZA2qKv1SuQiv010PIjQXdYjoOyQKYMXGXF1N7F1d0fxw7JmXplaNLr
 vkGsV+WaeQ9Jx4ROAuY3vyHmOMrLBA1HPgJrgFcoivLIx6c98gV6pRZ+YPwq75+f
 yrLk2K1RDZWJgN5zTH30qD0Kjii0sgvImpwwg8DhOfI9A8OyufoMQJONkUt6hG7b
 f9TvyYaAr4ALqxKX/aE9LnElxlg4AP1krdW/6BiEln8QiF3b+XhJc6CFfIk2xv7v
 7y3HEHDt/dzgdgY3IVTofmUhPN9wz2J+jPQ==
From: virtiofs-bot@sinrega.org
Message-Id: <42663.122112911493102330@us-mta-581.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 29 Nov 2022 16:49:34 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: remove file from host doesn't
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

