MIME-Version: 1.0
References: <20210126103502.260758-1-stefanha@redhat.com>
	<20210126181604.1a4c69c6@bahia.lan>
	<CAOssrKdh3kqKN4uGE=s5eiymd2MXKsRXUegqRH-TFhqYOK7WOA@mail.gmail.com>
	<20210127112023.0e97f909@bahia.lan>
	<CAOssrKfezsvcECQ=mO_4T2B09e+2S4LA3=_U6TQyiTtPbE=OYg@mail.gmail.com>
	<20210127144909.22dd778e@bahia.lan>
	<CAOssrKeN9iYT-Z46FVtzdKnWcTLfMqK77b1faf78m3XTXnEVGw@mail.gmail.com>
	<20210127160920.062e47f0@bahia.lan>
	<CAOssrKc=kSQQLmrAR2VrKfDzkyNDEAAa5qusK1x6+-fCM4+yCA@mail.gmail.com>
	<20210127163524.4e34596d@bahia.lan>
In-Reply-To: <20210127163524.4e34596d@bahia.lan>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 27 Jan 2021 16:47:55 +0100
Message-ID: <CAOssrKcbymmsVtU=jMMcE=K1T9oC=NmOzt3aSCe27K7TxXF61A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: prevent opening of special
 files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Daniel Berrange <berrange@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, P J P <ppandit@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Alex Xu <alex@alxu.ca>, Laszlo Ersek <lersek@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jan 27, 2021 at 4:35 PM Greg Kurz <groug@kaod.org> wrote:
>
> On Wed, 27 Jan 2021 16:22:49 +0100
> Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> > On Wed, Jan 27, 2021 at 4:09 PM Greg Kurz <groug@kaod.org> wrote:
> > >
> > > On Wed, 27 Jan 2021 15:09:50 +0100
> > > Miklos Szeredi <mszeredi@redhat.com> wrote:
> > > > The semantics of O_CREATE are that it can fail neither because the
> > > > file exists nor because it doesn't.  This doesn't matter if the
> > > > exported tree is not modified outside of a single guest, because of
> > > > locking provided by the guest kernel.
> > > >
> > >
> > > Wrong. O_CREAT can legitimately fail with ENOENT if one element
> >
> > Let me make my  statement more precise:
> >
> > O_CREAT cannot fail with ENOENT if parent directory exists throughout
> > the operation.
> >
>
> True, but I still don't see what guarantees guest userspace that the
> parent directory doesn't go away... I must have missed something.
> Please elaborate.

Generally there's no guarantee, however there can be certain
situations where the caller can indeed rely on the existence of the
parent (e.g. /tmp).

Thanks,
Miklos

