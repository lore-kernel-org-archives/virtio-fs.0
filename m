Date: Thu, 10 Feb 2022 17:07:43 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YgVGX7DIctqQiwVY@work-vm>
References: <20220209165040.56062-1-dgilbert@redhat.com>
	<CAFEAcA-JwQDQWQcY7tNSOb5LS8FNBjFi-msTyxUyV_q=OymXaw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-JwQDQWQcY7tNSOb5LS8FNBjFi-msTyxUyV_q=OymXaw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] Deprecate C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On Wed, 9 Feb 2022 at 16:57, Dr. David Alan Gilbert (git)
> <dgilbert@redhat.com> wrote:
> >
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> >
> > There's a nice new Rust implementation out there; recommend people
> > do new work on that.
> >
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> >  docs/about/deprecated.rst | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
> > index 47a594a3b6..3a0e15f8f5 100644
> > --- a/docs/about/deprecated.rst
> > +++ b/docs/about/deprecated.rst
> > @@ -454,3 +454,17 @@ nanoMIPS ISA
> >
> >  The ``nanoMIPS`` ISA has never been upstreamed to any compiler toolchain.
> >  As it is hard to generate binaries for it, declare it deprecated.
> > +
> > +Tools
> > +-----
> > +
> > +virtiofsd
> > +'''''''''
> > +
> > +There is a new Rust implementation of ``virtiofs`` at
> 
> I guess there's a missing "d" here ?

Oops yes, can add that.

Dave

> > +``https://gitlab.com/virtio-fs/virtiofsd``;
> > +since this is now marked stable, new development should be done on that
> > +rather than the existing C version in the QEMU tree.
> > +The C version will still accept fixes and patches that
> > +are already in development for the moment.
> 
> thanks
> -- PMM
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

