DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=tlodzRLKjYsmSIvJvfyHmyRZLG20ROka1PyN+VfwfnY=;
	b=mdFl213r1n1uA6uKofvIKHWo5sizoJZyxajbWz27X3DF1VPnIRBBR8iCB7pGgabrWv
	0JKDQLz2F+SRodYFTB4NF/9URm8CCY9XPrzZ1jV7oFeOJOBt9hKPZOhLFvkyBXgOXhd8
	hA8SqcnfTAKYGkMOMHfAzHP2bOY32bYG7Hw8g=
MIME-Version: 1.0
References: <20210614174454.903555-1-vgoyal@redhat.com>
	<20210614174454.903555-2-vgoyal@redhat.com>
In-Reply-To: <20210614174454.903555-2-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jun 2021 09:07:14 +0200
Message-ID: <CAJfpeguD+F3Ai01=-JYNTKS4LP4d879=+8T7eOBewZpevTRbJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2 1/2] init/do_mounts.c: Add a path to boot
 from tag based filesystems
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, Richard Weinberger <richard.weinberger@gmail.com>, Dominique Martinet <asmadeus@codewreck.org>, linux-kernel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net

On Mon, 14 Jun 2021 at 19:45, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> We want to be able to mount virtiofs as rootfs and pass appropriate
> kernel command line. Right now there does not seem to be a good way
> to do that. If I specify "root=myfs rootfstype=virtiofs", system
> panics.
>
> virtio-fs: tag </dev/root> not found
> ..
> ..
> [ end Kernel panic - not syncing: VFS: Unable to mount root fs on
> +unknown-block(0,0) ]
>
> Basic problem here is that kernel assumes that device identifier
> passed in "root=" is a block device. But there are few execptions
> to this rule to take care of the needs of mtd, ubi, NFS and CIFS.
>
> For example, mtd and ubi prefix "mtd:" or "ubi:" respectively.
>
> "root=mtd:<identifier>" or "root=ubi:<identifier>"
>
> NFS and CIFS use "root=/dev/nfs" and CIFS passes "root=/dev/cifs" and
> actual root device details come from filesystem specific kernel
> command line options.
>
> virtiofs does not seem to fit in any of the above categories. In fact
> we have 9pfs which can be used to boot from but it also does not
> have a proper syntax to specify rootfs and does not fit into any of
> the existing syntax. They both expect a device "tag" to be passed
> in a device to be mounted. And filesystem knows how to parse and
> use "tag".
>
> So there seem to be a class of filesystems which specify root device
> using a "tag" which is understood by the filesystem. And filesystem
> simply expects that "tag" to be passed as "source" of mount and
> how to mount filesystem using that "tag" is responsibility of filesystem.
>
> This patch proposes that we internally create a list of filesystems
> which pass a "tag" in "root=<tag>" and expect that tag to be passed
> as "source" of mount. With this patch I can boot into virtiofs rootfs
> with following syntax.
>
> "root=myfs rootfstype=virtiofs rw"

The syntax and the implementation looks good.

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

