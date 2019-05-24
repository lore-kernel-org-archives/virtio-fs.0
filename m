DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=86aIenJ1wHA5Gn54HYA+VewXTupYwS2L1fcqZWUi9kM=;
	b=iNVaI4jf5suqMZ9zNEFV1VCn3z++5n/pd/j/hNEmGcj2liurVfmE8kMPSrI8tr2Rjk
	HZZfwR9w9iwmkjNt1B/67UNuO1WtiIi5BlsdPFdNGmwUm2YGBKF6bNuWYFK9u9638nK0
	bQP8U+Bd+RUol0dmMdMKxMXtOFAvydGPePHkLZXP9t4TWIm5YCzEzJmfsL9WQPJmPp9Z
	P41zS2u2xjn9MUAWWm4IbAU8HBj7vijjdD4vP2z+6eEE7l4e1xi4db02C4GbHzErdOSv
	WAuZifrOGU+CkeD2vRxmg3cyTrI+dkJ4BzsJJPtXnmai2AYu0PoIYykV/Zj2w2axNlXQ
	drXw==
MIME-Version: 1.0
References: <20190522162623.GH2666@work-vm>
In-Reply-To: <20190522162623.GH2666@work-vm>
From: Tao Peng <bergwolf@hyper.sh>
Date: Fri, 24 May 2019 15:39:41 +0800
Message-ID: <CACGKRzXxcwRZ+fmiDu7gL16cRf=vT3X-o=w3yYeOCZxZoBXpmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] qemu/virtiofsd dev tree
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

On Thu, May 23, 2019 at 12:26 AM Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:
>
> Hi,
>   I uploaded: https://gitlab.com/virtio-fs/qemu/commits/virtio-fs-dev
> which has:
>
>    * Fixes from Alibaba, Intel, Red Hat
>    * Stefan's security doc
>    * support for direct-io from virtiofs to virtiofs (e.g.
>      reading a virtiofs file into an mmap'd viritofs dax file)
>      - I've just finished this and it's lightly tested, so feedback
>      welcome
>    * Rebase on bleeding edge qemu.
>
> Let me know how it goes.
Thanks Dave! Is there a dev branch for the kernel part that we can
collaborate on?

Cheers,
Tao
-- 
bergwolf@hyper.sh

