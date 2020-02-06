Date: Thu, 6 Feb 2020 13:46:58 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200206134658.GB84608@stefanha-x1.localdomain>
References: <cover.1580403751.git.jtomko@redhat.com>
	<484b10cf2a837ba7bc13400321978aa2076f0967.1580403751.git.jtomko@redhat.com>
	<20200203164351.GV1922177@redhat.com> <20200203183609.GX18565@lpt>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <20200203183609.GX18565@lpt>
Subject: Re: [Virtio-fs] [libvirt PATCHv3 10/12] qemu: add code for handling
 virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?iso-8859-1?B?SuFu?= Tomko <jtomko@redhat.com>
Cc: libvir-list@redhat.com, virtio-fs@redhat.com, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2020 at 07:36:09PM +0100, J=E1n Tomko wrote:
> [adding virtiofs list]
>=20
> On Mon, Feb 03, 2020 at 04:43:51PM +0000, Daniel P. Berrang=E9 wrote:
> > On Thu, Jan 30, 2020 at 06:06:26PM +0100, J=E1n Tomko wrote:
> > > Start virtiofsd for each <filesystem> device using it.
> > >=20
> > > Pre-create the socket for communication with QEMU and pass it
> > > to virtiofsd.
> > >=20
> > > Note that virtiofsd needs to run as root.
> >=20
> > So we're not able to use  virtiofsd with the session libvirtd
> > which runs completely unprivileged ?
> >=20
>=20
> Not with the version of virtiofsd currently merged in the QEMU tree.
>=20
> > I can understand the need to run as root if we want to support
> > chown() of files, or DAC_OVERRIDE, but I'm surprised it isn't
> > possible to run virtiofsd unprivileged & simply have a reduced
> > featureset where it can only create files as that one user.
> >=20
>=20
> Apart from the possibly missing features (I don't know how well
> virtiofsd internals are ready for those), current version of the
> daemon sets up namespaces and the seccomp sandbox.

Yes, running unprivileged is not a configuration that has been
investigated yet.  Today virtiofsd needs to be launched as root.

It would be interesting to rely on user namespaces to provide
unprivileged virtio-fs while still supporting more than 1 uid/gid.

I'm not a fan of using xattrs or other out-of-band information to store
guest ownership and permission information.  That is inconvenient to
manage (non-virtio-fs users of the directory won't see the right
uid/gid), reduces performance, and likely has race conditions.

Stefan

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl48GNIACgkQnKSrs4Gr
c8j/awgArv/kSgtBNJUFl2oJLlx2a+BiVI2kau9E2UQAXf+g4H4lxRyZqU241Z2u
yPR1ymhbfWz0DhafCfheowI9PE0cM//nipRi8MXpRYyf53tMe71fhjTnUl9TA9lf
W1UVgR8KJgq5mzf3OhI19EI68uFDm+9HrrH1e/6qgrjeaclZPt9p+Zu2Sa5z1/L1
YfUBGlsQwnEmkz8lXjboIOTNkLSwHkGj6o4hhRpsy2Z/ppakEgJD6QCRfmEmhvLw
Le9+gjoKlmt4zQDlBfQukdxAFxzfAmv+sQ/IH7ciGj+8vP2/pVOgT/aVy9hGdAJy
UmgZ3bxAqBVOqsYE7/nTRX6LJ7tx5g==
=dzEl
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--

