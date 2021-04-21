DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=HenZHDGnT6B4bJ81ExpWzuy+n1GTfUCcohZ0EUgDUwY=;
	b=J4a0r9Ma/ZSFw7fZciyv6pvs8x14c4hZd2dIMHHK5pP4ugeQzp8ZgUyv+mZRugdM3k
	jYTfe1RAqP1ikp23TM88lM3zTW2rgiKCikF2UvSzgq/uXLmU9Y0D2EjVE5qrsXm6jFya
	82cNYIPBppu7jypwkXjd1zGdG8Qr3kL/Vd08c=
MIME-Version: 1.0
References: <20210419150848.275757-1-groug@kaod.org>
	<20210420184226.GC1529659@redhat.com>
	<20210421093904.68653e3e@bahia.lan>
In-Reply-To: <20210421093904.68653e3e@bahia.lan>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 21 Apr 2021 10:46:44 +0200
Message-ID: <CAJfpegs+wb=5jm8SBcqLOJgHXt5h__NWppvNUej_Y7HX3fNvvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofs: propagate sync() to file server
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Robert Krawitz <rlk@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Apr 21, 2021 at 9:39 AM Greg Kurz <groug@kaod.org> wrote:
>
> On Tue, 20 Apr 2021 14:42:26 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
>
> > On Mon, Apr 19, 2021 at 05:08:48PM +0200, Greg Kurz wrote:

> > > @@ -179,6 +179,9 @@
> > >   *  7.33
> > >   *  - add FUSE_HANDLE_KILLPRIV_V2, FUSE_WRITE_KILL_SUIDGID, FATTR_KILL_SUIDGID
> > >   *  - add FUSE_OPEN_KILL_SUIDGID
> > > + *
> > > + *  7.34
> > > + *  - add FUSE_SYNCFS
> > >   */
> > >
> > >  #ifndef _LINUX_FUSE_H
> > > @@ -214,7 +217,7 @@
> > >  #define FUSE_KERNEL_VERSION 7
> > >
> > >  /** Minor version number of this interface */
> > > -#define FUSE_KERNEL_MINOR_VERSION 33
> > > +#define FUSE_KERNEL_MINOR_VERSION 34
> >
> > I have always wondered what's the usage of minor version and when should
> > it be bumped up. IIUC, it is there to group features into a minor
> > version. So that file server (and may be client too) can deny to not
> > suppor client/server if a certain minimum version is not supported.
> >
> > So looks like you want to have capability to say it does not support
> > an older client (<34) beacuse it wants to make sure SYNCFS is supported.
> > Is that the reason to bump up the minor version or something else.
> >
>
> Ah... file history seemed to indicate that minor version was
> bumped up each time a new request was added but I might be
> wrong.

Yes, that's how it's done historically.   Turned out to be less useful
in practice than having individual feature bits (through FUSE_INIT
flags or through -ENOSYS).  But it doesn't hurt and adds s

> > > @@ -957,4 +961,9 @@ struct fuse_removemapping_one {
> > >  #define FUSE_REMOVEMAPPING_MAX_ENTRY   \
> > >             (PAGE_SIZE / sizeof(struct fuse_removemapping_one))
> > >
> > > +struct fuse_syncfs_in {
> > > +   /* Whether to wait for outstanding I/Os to complete */
> > > +   uint32_t wait;
> > > +};
> > > +
> >
> > Will it make sense to add a flag and use only one bit to signal whether
> > wait is required or not. Then rest of the 31bits in future can potentially
> > be used for something else if need be.
> >
>
> I don't envision much changes in this API but yes, we can certainly
> do that.

I'm not even sure we need the "wait" flag at all.  Userspace won't be
able to handle it, so it's just a gratuitous roundtrip at this point.

I'd suggest just skipping FUSE_SYNCFS for wait == 0.

That said, it might be a good idea to keep the flags argument in the
protocol regardless...

>
> > Looks like most of the fuse structures are 64bit aligned (except
> > fuse_removemapping_in and now fuse_syncfs_in). I am wondering does
> > it matter if it is 64bit aligned or not.
> >
>
> I don't know the required alignment but we already have a 32bit
> aligned fuse structure:
>
> struct fuse_removemapping_in {
>         /* number of fuse_removemapping_one follows */
>         uint32_t        count;
> };
>
> which is sent like this:
>
> static int fuse_send_removemapping(struct inode *inode,
>                                    struct fuse_removemapping_in *inargp,
>                                    struct fuse_removemapping_one *remove_one)
> {
> ...
>         args.in_args[0].size = sizeof(*inargp);
>         args.in_args[0].value = inargp;
>
> Again, maybe Miklos can clarify this ?

I don't think non-alignment would cause bugs.  But it definitely
doesn't hurt to align to 64bit, so I'd suggest to do that.

Thanks,
Miklos

