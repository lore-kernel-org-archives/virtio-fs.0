Date: Thu, 9 Jan 2020 10:17:35 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200109101735.GB508720@stefanha-x1.localdomain>
References: <20200108152425.GD1995@redhat.com>
	<CAOssrKdomzxQsMh3FeQYN+HdLt-MSoZOi_MnWAbbf3P=U8ToPA@mail.gmail.com>
	<20200108155002.GE1995@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <20200108155002.GE1995@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Enable xattr support by default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2020 at 10:50:02AM -0500, Vivek Goyal wrote:
> On Wed, Jan 08, 2020 at 04:42:46PM +0100, Miklos Szeredi wrote:
> > On Wed, Jan 8, 2020 at 4:24 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > Enable xattr support by default. Currently it is disabled by defaut
> > > and that makes getfattr/setfattr fail in guest.
> >=20
> > I think the reason this was disabled by default is that it's a
> > significant performance hit for "ls" due to missing xattr caching.
> > Not sure how much it affects other workloads.
> >=20
>=20
> Aha... so this is intentional and not just an oversight. So maybe we can
> leave it disabled by default for now and let people enable it as need be
> (-o xattr).

I've added this issue to the virtio-fs issue tracker:

https://gitlab.com/virtio-fs/qemu/issues/15

Stefan

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl4W/b8ACgkQnKSrs4Gr
c8jIsgf9GFoE6VeVX3uRVGvDwJo6TKx54qS3pDzVUoNT8dcNBAuO7PYUTyrZXs7U
KB6SwebYLP8TwhGAeECO3qCWVMcR4K8yeY+sSj2sUXLyTflzfINGFNiibLI9/ApF
C6z14Crk9xR9t9SP+hRV09WneU1z26w7LRMGPbckNVQ/yTeLLqQC3T76MTbEyuC+
+L+Y5T9rzNMxyccrC1EhISXNLAFQ40ae53zxvGGo5mL25c6bVZ5TOcY9yjghS41V
B6D1ZCWC6QAvPjFg2YG3l1BAm2fR3C5iLuyQYmsVvrKl3QPOg3sV1/l0EjTMu8yl
BwqTJwp/Y52SJZWky275/HjUVGrZwA==
=3gn8
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--

