Date: Thu, 10 Feb 2022 17:13:19 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YgVHr2zgTrPHVhez@work-vm>
References: <20220209165040.56062-1-dgilbert@redhat.com>
	<YgTTbAWj1CGlmv/R@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YgTTbAWj1CGlmv/R@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH] Deprecate C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Daniel P. Berrang=E9 (berrange@redhat.com) wrote:
> On Wed, Feb 09, 2022 at 04:50:40PM +0000, Dr. David Alan Gilbert (git) wr=
ote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> >=20
> > There's a nice new Rust implementation out there; recommend people
> > do new work on that.
> >=20
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> >  docs/about/deprecated.rst | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >=20
> > diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
> > index 47a594a3b6..3a0e15f8f5 100644
> > --- a/docs/about/deprecated.rst
> > +++ b/docs/about/deprecated.rst
> > @@ -454,3 +454,17 @@ nanoMIPS ISA
> > =20
> >  The ``nanoMIPS`` ISA has never been upstreamed to any compiler toolcha=
in.
> >  As it is hard to generate binaries for it, declare it deprecated.
> > +
> > +Tools
> > +-----
> > +
> > +virtiofsd
> > +'''''''''
> > +
> > +There is a new Rust implementation of ``virtiofs`` at
> > +``https://gitlab.com/virtio-fs/virtiofsd``;
> > +since this is now marked stable, new development should be done on that
> > +rather than the existing C version in the QEMU tree.
> > +The C version will still accept fixes and patches that
> > +are already in development for the moment.
>=20
> Just to be clear, 'deprecation' is usually expected to turn into
> 'deletion' a minimum of 2 releases later.  We are targetting the
> C virtiofsd to be deleted, right ?  The last sentance here gives
> vibes that we're expecting it to stick around despite deprecation.

I am targeting it to be deleted, but I'm expecting to give it a bit
more time than 2 releases; how do I do that?

> Assuming we're deleting it after deprecation, then I think thue
> message should be more direct in telling people they shold be
> proactively switching to deployment of the rust version. Something
> along lines of
>=20
>   "The C implementation is in maintenance mode only and will
>    be deleted once the deprecation period is complete. New
>    deployments of virtiofs are strongly recommended to switch
>    to use of the Rust implementation of virtiofsd, which is
>    a drop in replacement will compatible command line and
>    featureset."

Yeh, I'll rework it in that direction; I was trying to be gentle at
first.

Dave

>=20
> Regards,
> Daniel
> --=20
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberran=
ge :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.c=
om :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberran=
ge :|
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

