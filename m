DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=EuENc7crj8rqhon/s/3YCSFArTMbg3aHshy4WFfnKAI=;
	b=Od7NQm+xjFA01cLuFmHtQg+5TCm8UxKX2tGkiw8Mr4ix+wsAC5OqGe+z4RAxvjqQg/
	hOmmsMGgfL9ALOuzShRamJV28nj5bc9nAX+IVwfcCIvdcYByCAo2CXCt3AMWA49czLno
	sGMa721iOqpXpP31sm3p2t8tpiPNVDM2tg89o=
MIME-Version: 1.0
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<CAJfpegvPTxkaNhXWhiQSprSJqyW1cLXeZEz6x_f0PxCd-yzHQg@mail.gmail.com>
	<20190903041507-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190903041507-mutt-send-email-mst@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 3 Sep 2019 11:17:35 +0200
Message-ID: <CAJfpeguB6fFhghuFS420ZQ+JuQvTLc5TgsGjoB_RvFrSVf+v5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3 00/13] virtio-fs: shared file system for
	virtual machines
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Tue, Sep 3, 2019 at 10:31 AM Michael S. Tsirkin <mst@redhat.com> wrote:

> Can the patches themselves be posted to the relevant list(s) please?
> If possible, please also include "v3" in all patches so they are
> easier to find.

I'll post a v4.

> I poked at
> https://lwn.net/ml/linux-kernel/20190821173742.24574-1-vgoyal@redhat.com/
> specifically
> https://lwn.net/ml/linux-kernel/20190821173742.24574-12-vgoyal@redhat.com/
> and things like:
> +       /* TODO lock */
> give me pause.
>
> Cleanup generally seems broken to me - what pauses the FS
>
> What about the rest of TODOs in that file?

AFAICS, some of those are QOI issues, and some are long term
performance items.  I see no blockers or things that would pose a
security concern.

That said, it would be nice to get rid of them at some point.

> use of usleep is hacky - can't we do better e.g. with a
> completion?

Yes.  I have a different implementation, but was planning to leave
this one in until the dust settles.

> Some typos - e.g. "reuests".

Fixed.

> > >  fs/fuse/Kconfig                 |   11 +
> > >  fs/fuse/Makefile                |    1 +
> > >  fs/fuse/control.c               |    4 +-
> > >  fs/fuse/cuse.c                  |    4 +-
> > >  fs/fuse/dev.c                   |   89 ++-
> > >  fs/fuse/dir.c                   |   26 +-
> > >  fs/fuse/file.c                  |   15 +-
> > >  fs/fuse/fuse_i.h                |  120 +++-
> > >  fs/fuse/inode.c                 |  203 +++---
> > >  fs/fuse/virtio_fs.c             | 1061 +++++++++++++++++++++++++++++++
> > >  fs/splice.c                     |    3 +-
> > >  include/linux/fs.h              |    2 +
> > >  include/uapi/linux/virtio_fs.h  |   41 ++
> > >  include/uapi/linux/virtio_ids.h |    1 +
> > >  init/do_mounts.c                |   10 +
> > >  15 files changed, 1462 insertions(+), 129 deletions(-)
> > >  create mode 100644 fs/fuse/virtio_fs.c
> > >  create mode 100644 include/uapi/linux/virtio_fs.h
>
> Don't the new files need a MAINTAINERS entry?
> I think we want virtualization@lists.linux-foundation.org to be
> copied.

Yep.

Stefan, do you want to formally maintain this file?

Thanks,
Miklos

