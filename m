Date: Wed, 4 Sep 2019 19:10:30 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190904181030.GA26826@stefanha-x1.localdomain>
References: <20190829104133.17418-1-stefanha@redhat.com>
	<20190903153539.GM2744@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20190903153539.GM2744@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: add man page
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 03, 2019 at 04:35:39PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  Makefile                         |  7 +++
> >  contrib/virtiofsd/virtiofsd.texi | 85 ++++++++++++++++++++++++++++++++
> >  2 files changed, 92 insertions(+)
> >  create mode 100644 contrib/virtiofsd/virtiofsd.texi
> >=20
> > diff --git a/Makefile b/Makefile
> > index a3dfdd6fa8..cc18025753 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -334,6 +334,9 @@ DOCS+=3Ddocs/qemu-cpu-models.7
> >  ifdef CONFIG_VIRTFS
> >  DOCS+=3Dfsdev/virtfs-proxy-helper.1
> >  endif
> > +ifdef CONFIG_LINUX
>=20
> Is there a reason that's CONFIG_LINUX not CONFIG_VHOST_USER_FS ?
> (Although I guess it's guest vs daemon so the two are independent?)

Yes, this is virtiofsd, not vhost-user-fs-pci.  We don't have a
CONFIG_VIRTIOFSD.

> > +DOCS+=3Dcontrib/virtiofsd/virtiofsd.1
> > +endif
> >  ifdef CONFIG_TRACE_SYSTEMTAP
> >  DOCS+=3Dscripts/qemu-trace-stap.1
> >  endif
> > @@ -834,6 +837,9 @@ ifdef CONFIG_VIRTFS
> >  	$(INSTALL_DIR) "$(DESTDIR)$(mandir)/man1"
> >  	$(INSTALL_DATA) fsdev/virtfs-proxy-helper.1 "$(DESTDIR)$(mandir)/man1"
> >  endif
> > +ifdef CONFIG_LINUX
> > +	$(INSTALL_DATA) contrib/virtiofsd.1 "$(DESTDIR)$(mandir)/man1"
>=20
> I had to fix that to contrib/virtiofsd/virtiofsd.1 to get make install
> happy.

Thanks for spotting it!

> > +@c man begin DESCRIPTION
> > +
> > +Share a host directory tree with a guest through a virtio-fs device.  =
This
> > +program is a vhost-user backend that implements the virtio-fs device. =
 Each
> > +virtio-fs device instance requires its own virtiofsd process.
> > +
> > +This program is designed to work with QEMU's @code{--device vhost-user=
-fs-pci}
>=20
> Should we include the -pci there?
>=20
> (Merged with the path fix above)

We could also be more general and say "vhost-user virtio-fs device" to
avoid the issue.

Stefan

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1v/hYACgkQnKSrs4Gr
c8jtAQgAna0dQRA6RKpt4vAGNm9rRvw0sQ7/Vua3kBzhTp6kQPk5W7VIpLh+HHcs
STKfJ5Fvy7nH0FV8w9vrJmv6BsrP6/Jw3I2ZRv+I2/usHLA1sZRcYdX+a7nk3w+/
y1HkwJeG9NOkoYWBBEvUHN+aZlVcefypy1aH3NdSTTvi8vNcABXXu+vMfLVN/rGO
h0nX/3mFs7IFYI3DY45wFT3fQavVo5tSo7pjM5WeIx3I3JppxdhxWtTMzQoBIpCC
LcSZ8SX9Sxc6rNWWpAFtbCGAzrDCFpO0SdrrcownX2ryXvGeW8pD4Uz209VZUwIB
tpANPWJpOghUCN1FeMl+BF9QEQOpFw==
=NByF
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--

