DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=U0MGv1y1F0WYbwqNAIg1w6XGdt99IUf8puJ2a4PrjtQ=;
	b=eVDJOwASSOF6O4gCTeM7sHeK9zcoZ3LffJdSqKnhm0rK9/hTOw/bNYTGCm/u8jD7sj
	PbYKwUAKHudkOae5TQvheCGPwHVTSrnQNSzLMq2QW5C/q986g1yCrOlgaR6cibwRp9eu
	9KGzw74/LwFEoYQokLEHB/SPig0QC/W21DrqI=
MIME-Version: 1.0
References: <20210412145919.GE1184147@redhat.com>
	<CAJfpegsaY05jSRNFTcquNFyMr+GMpPBMgoEO0YZcXxfqBi3g2A@mail.gmail.com>
	<20210414135622.4d677fd7@bahia.lan>
In-Reply-To: <20210414135622.4d677fd7@bahia.lan>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 14 Apr 2021 13:58:58 +0200
Message-ID: <CAJfpegv60U4EecWhZSE27iC0n13kxOBfT83UZD6ziSRE4h9xVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] Query about fuse ->sync_fs and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, Robert Krawitz <rkrawitz@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Apr 14, 2021 at 1:56 PM Greg Kurz <groug@kaod.org> wrote:
>
> On Mon, 12 Apr 2021 17:08:26 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > On Mon, Apr 12, 2021 at 4:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > Hi Miklos,
> > >
> > > Robert Krawitz drew attention to the fact that fuse does not seem to
> > > have a ->sync_fs implementation. That probably means that in case of
> > > virtiofs, upon sync()/syncfs(), host cache will not be written back
> > > to disk. And that's not something people expect.
> > >
> > > I read somewhere that fuse did not implement ->sync_fs because file
> > > server might not be trusted and it could block sync().
> > >
> > > In case of virtiofs, file server is trusted entity (w.r.t guest kernel),
> > > so it probably should be ok to implement ->sync_fs atleast for virtiofs?
> >
> > Yes, that looks like a good idea.
> >
>
> I've started looking into this. First observation is that implementing
> ->sync_fs() is file server agnostic, so if we want this to only be used
> by a trusted file server, we need to introduce such a notion in FUSE.
> Not sure where though... in struct fuse_fs_context maybe ?

Yep, makes sense.

Thanks,
Miklos

