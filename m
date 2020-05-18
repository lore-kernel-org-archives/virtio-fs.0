DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=1RDSyGRpw2VRf31bxawCo734Y2yQmHYTppNEBtUFy1U=;
	b=O5Xa9XcVP4RwdKpVI1k4ps0IER5omUHFawIxpk5Ybxlk9fTdR2HkLbmmgySRZZleUZ
	Y4uhpBdv1uADkBZpmeQcC2FNKVG8Bs4de8RCzkQUybqChWSsbGpB4c3xL/xOX2aV7kv3
	DizqHRexmJk5lBp10WaPkb9GltwF2YLEfzTYo=
MIME-Version: 1.0
References: <20200430171814.GA275398@redhat.com>
	<CAJfpegt9XraNpzBK+qOo2y-Lox3HZ7FBouSV6ioh+uQHCtqsbg@mail.gmail.com>
	<20200504183315.GF9022@redhat.com>
In-Reply-To: <20200504183315.GF9022@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 May 2020 14:15:21 +0200
Message-ID: <CAJfpegtoNV9HzFu1WE_hPZ_uxXH7iDb1Yfbzv3FBzXku3yQ7Gw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH][v2] fuse,
	virtiofs: Do not alloc/install fuse device in
	fuse_fill_super_common()
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

On Mon, May 4, 2020 at 8:33 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>

> Subject: virtiofs: Do not use fuse_fill_super_common() for fuse device installation
>
> fuse_fill_super_common() allocates and installs one fuse_device. Hence
> virtiofs allocates and install all fuse devices by itself except one.
>
> This makes logic little twisted. There does not seem to be any real need
> that why virtiofs can't allocate and install all fuse devices itself.
>
> So opt out of fuse device allocation and installation while calling
> fuse_fill_super_common().
>
> Regular fuse still wants fuse_fill_super_common() to install fuse_device.
> It needs to prevent against races where two mounters are trying to mount
> fuse using same fd. In that case one will succeed while other will get
> -EINVAL.
>
> virtiofs does not have this issue because sget_fc() resolves the race
> w.r.t multiple mounters and only one instance of virtio_fs_fill_super()
> should be in progress for same filesystem.

Thanks, applied.

Miklos

