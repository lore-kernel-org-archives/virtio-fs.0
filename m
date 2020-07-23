Date: Thu, 23 Jul 2020 13:46:45 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200723124645.GM186372@stefanha-x1.localdomain>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722181914.GB598987@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xtx0sNU5lZ46KfgK"
Content-Disposition: inline
In-Reply-To: <20200722181914.GB598987@redhat.com>
Subject: Re: [Virtio-fs] [PATCH for-5.1 0/3] virtiofsd: allow virtiofsd to
 run in a container
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, vromanso@redhat.com, qemu-devel@nongnu.org, rmohr@redhat.com


--xtx0sNU5lZ46KfgK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2020 at 02:19:14PM -0400, Vivek Goyal wrote:
> On Wed, Jul 22, 2020 at 02:02:03PM +0100, Stefan Hajnoczi wrote:
> > Container runtimes handle namespace setup and remove privileges needed =
by
> > virtiofsd to perform sandboxing. Luckily the container environment alre=
ady
> > provides most of the sandbox that virtiofsd needs for security.
> >=20
> > Introduce a new "virtiofsd -o chroot" option that uses chroot(2) instea=
d of
> > namespaces. This option allows virtiofsd to work inside a container.
> >=20
> > Please see the individual patches for details on the changes and securi=
ty
> > implications.
> >=20
> > Given that people are starting to attempt running virtiofsd in containe=
rs I
> > think this should go into QEMU 5.1.
>=20
> Hi Stefan,
>=20
> I have written a document to help with testing virtiofs with any changes.
>=20
> https://github.com/rhvgoyal/misc/blob/master/virtiofs-tests/virtio-fs-tes=
ting-requirement.txt
>=20
> Will be good to run some of these tests to make sure there are no
> regressions due to these changes.

Thank you! I will run them and post the results.

Stefan

--xtx0sNU5lZ46KfgK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8ZhrUACgkQnKSrs4Gr
c8ifwQgAnRfwLw3v2RsrTVxdGUTdcqsHwsvUWfjyL9nd764aMInem2uO2wX1uwS8
LBCwSetSYNjGvZPUJTQ4EPAD/cE3Y7v6e8M9Uxc/iM69Nye10KnwfyOWizYi217G
JTaAjXYU5WEZJJzNtZW3oqJJKKTdbx+D8mVXYnBH58xqAbM0X3ijPgbuywrTz26g
U4+/fjbCD+9O1JYZEs6Mj89U6GKusjMG4bGVozNtWT9y1I5e6tJZuY9IGOyB9EtB
tRJWMZWQAy7Gut1C1bvCqR3hF3ff63OzJHAs6ORLC83ZZVrX0FYL+hQEnllS3pk0
FgJKkdj7Hv1A8e9vpw5y7aDL4xJ4Xw==
=GCV3
-----END PGP SIGNATURE-----

--xtx0sNU5lZ46KfgK--

