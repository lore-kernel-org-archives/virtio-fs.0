DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=MXzRjhwn8e2J5zYTCR4K+ZTW1our2Q6VsUPgVktuBLs=;
	b=LdTO8+I8XHmU+YCHchiFOBlCOwF2mhR5dAZx74JAbUsVoRU33CWaY86v/bbMDVm7wP
	oYKi0OpxacAUC3LC5vNhWGHA87ywut6e9wR3KE1bYg6VrM/LVLbCgXWuQc77HjQQITD7
	g2yIZPsT16veeMHQ81rSKzD82ttwqwbK+LSB4=
MIME-Version: 1.0
References: <20200901142634.1227109-1-vgoyal@redhat.com>
In-Reply-To: <20200901142634.1227109-1-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 4 Sep 2020 11:45:53 +0200
Message-ID: <CAJfpegtBA6XSbb+futZGt=NY-VjnN_GWFmnNfGjLfgnZ1ynM0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 0/2] fuse,
	dax: Couple of fixes for fuse dax support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Tue, Sep 1, 2020 at 4:26 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi Miklos,
>
> I am testing fuse dax branch now. To begin with here are couple of
> simple fixes to make sure I/O is going through dax path.
>
> Either you can roll these fixes into existing patches or apply on
> top.
>
> I ran blogbench workload and some fio mmap jobs and these seem to be
> running fine after these fixes.

Thanks for testing and fixing.

Pushed a rerolled series to #for-next.   Would be good if you cour retest.

There's one checkpatch warning I'm unsure about:

| WARNING: Using vsprintf specifier '%px' potentially exposes the
kernel memory layout, if you don't really need the address please
consider using '%p'.
| #173: FILE: fs/fuse/virtio_fs.c:812:
| +    dev_dbg(&vdev->dev, "%s: window kaddr 0x%px phys_addr 0x%llx
len 0x%llx\n",
| +        __func__, fs->window_kaddr, cache_reg.addr, cache_reg.len);
|
| total: 0 errors, 1 warnings, 175 lines checked
|
| NOTE: For some of the reported defects, checkpatch may be able to
|       mechanically convert to the typical style using --fix or --fix-inplace.
|
| patches/virtio_fs-dax-set-up-virtio_fs-dax_device.patch has style
problems, please review.

Do you think that the kernel address in the debug output is necessary?

Thanks,
Miklos

