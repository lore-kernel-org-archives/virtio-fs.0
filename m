Date: Wed, 24 Mar 2021 13:08:07 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YFs5t34ASa4HcNEc@stefanha-x1.localdomain>
References: <47a35ffe-ef39-d098-2c29-34cf7d4eb7ef@redhat.com>
	<YFsnwtUqfmr3e7dI@stefanha-x1.localdomain>
	<f28daab1-515e-3282-f126-c599438f0833@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jLi9abmS2pbK6RTV"
Content-Disposition: inline
In-Reply-To: <f28daab1-515e-3282-f126-c599438f0833@redhat.com>
Subject: Re: [Virtio-fs] Current file handle status and open questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


--jLi9abmS2pbK6RTV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 24, 2021 at 01:28:48PM +0100, Max Reitz wrote:
> On 24.03.21 12:51, Stefan Hajnoczi wrote:
> > On Thu, Mar 18, 2021 at 06:09:58PM +0100, Max Reitz wrote:
> > > So, overall it seems like it may be workable to extend the in-kernel =
MAC
> > > verification to allow for persistent keys, but I still have some open
> > > questions, and I don=E2=80=99t know whether I should just defer them =
until we
> > > get to the point where we need persistency.
> >=20
> > It seems worth refining these ideas a little bit further until they
> > reach solid ground. Then we can be sure that there is at least one
> > possible solution. At the moment it seems like most the components of a
> > solution are known but it's not clear how they all fit together - and
> > they have a nasty tendency of failing to meet the requirements if they
> > aren't put together in exactly the right way :).
> >=20
> > > (Of note: If we implement something where a user space process (or
> > > multiple in conjunction) can arbitrarily choose a MAC key, then this
> > > will also be usable for live migration, because you can continue to u=
se
> > > the key from the source on the destination.)
> >=20
> > Definitely. Taking migration into account is worthwhile. One question
> > about that:
> >=20
> > Are Linux file handles transferrable between systems? Basic
> > configurations that come to mind:
> > 1. XFS, brtfs, ext4 on SAN (e.g. FibreChannel SCSI LUN)
> > 2. NFS
> >=20
> > I assumed they were in previous discussions but has anyone checked the
> > file handle implementations to see whether this is really the case?
>=20
> I=E2=80=99m not exactly sure what you mean.  I think you=E2=80=99re askin=
g whether for a
> single (shared) filesystem a file handle always works independently of wh=
ich
> Linux instance is using it?

Yes. What you've found sounds promising.

Stefan

--jLi9abmS2pbK6RTV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBbObYACgkQnKSrs4Gr
c8jtRgf/WFqKNgx5ROZIGp4tkZIE9CC850GnBS0Yiz01FrfhOYziwLtn9bi9V8Ad
MKLMwigXfnT9T1Z4O37AbIAseBbod1OPvJNYsmaEp75rBykdOU8qDptLnjf0l1+e
8QWnFo0mnLsnEdPDPNeABpaYNwn/uTTzlOUuNFtS+NDTDT2B/55wOQAP4RWIYdZp
NINp2azSXyXJ1JWiI0r9sz8TaoUX6Wd6Aa4pSYubLzSeUafAia4uiowl+ma1dDFN
OpZ9IYr80gg3aoMUkOFYFRH0HlatyHfOD9QuSHUobSmr7ZLU+K9Kjay+j7PUNGgP
ALQE1EMnovhCNsFbWNtK/1fjJCJumw==
=Xxz/
-----END PGP SIGNATURE-----

--jLi9abmS2pbK6RTV--

