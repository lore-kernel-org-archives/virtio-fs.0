DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=nI0HWLJgICoyePL8Ldl1+Q3Qdj/zpAln8rI/PCnTuA4=;
	b=Ti/XdWmxCICqMHvH3DLBF2lbfN511qtnxha4Fj+jSb6HtefXHztH2OMmsrVSxQ+Vz1
	iiIGmqlIbgmfSvkqT4IrGoJabOh0uD0OP7x/MrJv/DCub/GAOyg502J2xrSNBtKxCZdz
	AeAj3o2fSrIKY9uvsP3qKzwU6hFvE2yDoVyGw=
MIME-Version: 1.0
References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-3-mreitz@redhat.com>
	<20200911102459.GC94280@stefanha-x1.localdomain>
In-Reply-To: <20200911102459.GC94280@stefanha-x1.localdomain>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 11 Sep 2020 13:07:55 +0200
Message-ID: <CAJfpegvxmx995QihR+=bOcyWy0pGmxFtAJhzvw7O2k9rq9r5zA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [fuse-devel] [PATCH 2/9] fuse: Add
	FUSE_ATTR_SUBMOUNT
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, fuse-devel <fuse-devel@lists.sourceforge.net>, Max Reitz <mreitz@redhat.com>

On Fri, Sep 11, 2020 at 12:25 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Wed, Sep 09, 2020 at 08:45:56PM +0200, Max Reitz wrote:
> > This is a flag for fuse_attr.flags that indicates that the given entry
> > resides on a different filesystem than the parent, and as such should
> > have a different st_dev.
> >
> > Signed-off-by: Max Reitz <mreitz@redhat.com>
> > ---
> >  include/uapi/linux/fuse.h | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > index de94c11cfc3b..c034cdf8f5f4 100644
> > --- a/include/uapi/linux/fuse.h
> > +++ b/include/uapi/linux/fuse.h
> > @@ -417,6 +417,13 @@ struct fuse_file_lock {
> >   */
> >  #define FUSE_FSYNC_FDATASYNC (1 << 0)
> >
> > +/**
> > + * fuse_attr flags
> > + *
> > + * FUSE_ATTR_SUBMOUNT: File/directory is a submount point
> > + */
> > +#define FUSE_ATTR_SUBMOUNT      (1 << 0)
>
> If you respin, please add a little more detail here. How should clients

I'm just reviewing/queuing this, so no need to respin.

> act when this flag is detected (which FUSE messages should they send to
> deal with submounts)?

Actually, no new messages, since the reply containing
FUSE_ATTR_SUBMOUNT already refers to the submount root.  I'll fix the
description.

And since there's no separate information for the actual mount point
(userspace can't obtain it) AT_NO_AUTOMOUNT users become confused due
to the dummy mountpoint becoming visible with all the wrong data.
Maybe the fix is to force automount even with AT_NO_AUTOMOUNT.  Will
look into that.

Thanks,
Miklos

