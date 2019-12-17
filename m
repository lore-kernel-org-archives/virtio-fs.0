Date: Tue, 17 Dec 2019 19:18:27 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191217191827.GA1335010@stefanha-x1.localdomain>
References: <20191210145105.329680-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20191210145105.329680-1-farosas@linux.ibm.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtio-fs-ci: build-rootfs tweaks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Fabiano Rosas <farosas@linux.ibm.com>
Cc: virtio-fs@redhat.com


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2019 at 11:51:03AM -0300, Fabiano Rosas wrote:
> Some improvements for the rootfs build:
>=20
> - first patch fixes the rootfs build in Fedora
>=20
> - second patch makes the bootstrap tool selection according to distro
>   automatically
>=20
>=20
> Fabiano Rosas (2):
>   build-rootfs: Fix fedora build
>   build-rootfs: Select bootstrap command based on build machine distro
>=20
>  build-rootfs.sh | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> --
> 2.23.0
>=20

Thanks, applied!

Stefan

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl35KgMACgkQnKSrs4Gr
c8gy5AgArSzm01FywowbdwagIGtWJTun4vDZKp4UIkTL3u0UEjR73OzdePBM7oQm
00y+a8GsZftHCXZBXv7q3SiAM/wnXPPeoAnLs/yRoicOC3BIE/ueCi9ZUuPQ1hGQ
2sJT8AwrlMDJ7JZ2SzSawu8kB1DC8OM9jgP7gyMRyhJ9uY1qFcgSOhcB3dLlI+gc
1dh1aqFq2Eod3E6+2twevERIOOxNazSIAY9dBBxGTauGAvitmk13WcpNUEPZUzSa
XHZ/WLjleks1Vi8qf3matSpdX9xDBtbK56W87cNTfrrQV42sA4Yil+tYMm6HbUO4
qdvirTBADuZ3PsTw59Yc33V1njmdQg==
=C5DF
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--

