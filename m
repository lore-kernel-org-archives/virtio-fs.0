DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=f4lqVL9E8teUhvToTgEeuMgi3bTyCtYt4jpvCxfm54Q=;
	b=M6kMLhhrR1rSwxoyoRq92O56PaUv4DjhHtEi23Zna8X3y6GiVStVcgzJOPeB9P6X1d
	DdVtzL1OUc3LB71I/dqAOxlGGmrNQpZB504ocPjGN3JGQcl6Ax9TqTmWb1ESVc1DoXwK
	B46n8m+4HwmtG0XpBl9stwF9MkxMcUuN6wozQ=
MIME-Version: 1.0
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<CAJfpegu8POz9gC4MDEcXxDWBD0giUNFgJhMEzntJX_u4+cS9Zw@mail.gmail.com>
	<20190906103613.GH5900@stefanha-x1.localdomain>
In-Reply-To: <20190906103613.GH5900@stefanha-x1.localdomain>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 6 Sep 2019 13:52:41 +0200
Message-ID: <CAJfpegudNVZitQ5L8gPvA45mRPFDk9fhyboceVW6xShpJ4mLww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 00/18] virtiofs: Fix various races and
	cleanups round 1
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>

On Fri, Sep 6, 2019 at 12:36 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Fri, Sep 06, 2019 at 10:15:14AM +0200, Miklos Szeredi wrote:
> > On Thu, Sep 5, 2019 at 9:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > Hi,
> > >
> > > Michael Tsirkin pointed out issues w.r.t various locking related TODO
> > > items and races w.r.t device removal.
> > >
> > > In this first round of cleanups, I have taken care of most pressing
> > > issues.
> > >
> > > These patches apply on top of following.
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#virtiofs-v4
> > >
> > > I have tested these patches with mount/umount and device removal using
> > > qemu monitor. For example.
> >
> > Is device removal mandatory?  Can't this be made a non-removable
> > device?  Is there a good reason why removing the virtio-fs device
> > makes sense?
>
> Hot plugging and unplugging virtio PCI adapters is common.  I'd very
> much like removal to work from the beginning.

Can you give an example use case?

Thanks,
Miklos

