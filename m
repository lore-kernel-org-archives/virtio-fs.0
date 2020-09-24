DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=u88Nz3rBig4xGKGFNxDHE9sSRToky27GfnUF7UrAav0=;
	b=L97D8fFtnQeKDLVRu9hkAR/8BpBDSzS6M0rNIZhFTqrVKCYltGQNSUzWKvYNTgmvXl
	Jz12MC1X+MSDOESlQ+u7Om6WBZXhAD4yT0Ld9Rirzy2hSOCXK97V576x/2miNQbOX5uS
	eyYTQYTv76zGTHL1QH8L12Pfzz4TQ8qnVxwuo=
MIME-Version: 1.0
References: <20200909184603.263700-1-mreitz@redhat.com>
	<CAJfpegt92oj88FbGxphce80AWtU51Qgm87KuZqYD9kfpSVq2tA@mail.gmail.com>
	<e87d7603-100b-173a-07c6-3ef4c2400e94@redhat.com>
	<CAJfpegt-BOG7Xz4Xyy4OEnK+2EPGQ61e4qk7WBKUVjQN4yAiSw@mail.gmail.com>
	<5249b6e0-597a-ce62-0e44-ac3e2398842c@redhat.com>
In-Reply-To: <5249b6e0-597a-ce62-0e44-ac3e2398842c@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Sep 2020 10:13:42 +0200
Message-ID: <CAJfpegsxPzBA_M+ZRoHM88+pojdk5=3q0fCNaFN8euTvMt0krA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [fuse-devel] [PATCH 0/9] fuse: Mirror virtio-fs
	submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, fuse-devel <fuse-devel@lists.sourceforge.net>

On Thu, Sep 24, 2020 at 10:10 AM Max Reitz <mreitz@redhat.com> wrote:

> > No, object creation never results in a mounted object.  If the newly
> > created object is mounted on at a later time, the revalidate logic
> > will take care of that.
>
> So lo_getattr() is not an issue either, because all mount operations
> will be handled by the revalidate logic?

Right.  Attribute revalidation is done by GETATTR and lookup
revalidation is done by LOOKUP.  Setting the automount point in case
of attribute revalidation would not make any difference, since no
lookup is being performed at that point.

Thanks,
Miklos

