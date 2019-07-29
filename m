Date: Mon, 29 Jul 2019 09:15:55 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190729081555.GA3369@stefanha-x1.localdomain>
References: <20190726091103.23503-1-stefanha@redhat.com>
	<20190726091103.23503-3-stefanha@redhat.com>
	<20190726212613.24lionrtvt3kz2g3@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <20190726212613.24lionrtvt3kz2g3@US-160370MP2.local>
Subject: Re: [Virtio-fs] [PATCH 2/5] virtiofsd: prevent lo_lookup() NULL
 pointer	dereference
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2019 at 02:26:14PM -0700, Liu Bo wrote:
> On Fri, Jul 26, 2019 at 10:11:00AM +0100, Stefan Hajnoczi wrote:
> > Most lo_do_lookup() have already checked that the parent inode exists.
> > lo_lookup() hasn't and can therefore hit a NULL pointer dereference when
> > lo_inode(req, parent) returns NULL.
> >
>=20
> Sigh...this one has been fixed by 3 different developers...Me, Pengtao an=
d Stefan.
>=20
> The following one on the ML did the exactly same thing.
> ---
> Subject: [Virtio-fs] [PATCH] virtiofsd: fix lo_do_lookup panic
>=20
> It needs to check for invalid parent dir.
>=20
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> ---

One of the previously posted patches will be merged before mine.  It's a
shame that work has been duplicated.  As a contributor I will send a
ping email if there has been no response to a patch after a few days.

Stefan

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0+qzsACgkQnKSrs4Gr
c8iJXgf/U/VBNuvKL5LjEl5+H6xgeDHD1ZgRS47yfQQbb1wC9RcEUptTYcR7xtcc
AUcoV/kfg+kLHxxUljUWAJ5mznHQ0GPB4LmZ+DQVYjUny3SyMLn8lNqQqzoObzFV
d1sntaJVR7NA1n+UT2j96pjbFMemCRY5wwAs7JJyd/CzDbSoYf7PZNTNuEx94ZMo
6Jp20u5bZ/kTR0kQ/e4ctdBOPMZgeDYQDlNedl2vee/B/tMW03+0Fh5fpRqS2fMV
5ZfYM4Lyl2r1tBOgx/vNtm0fDsS7B/uZ/YDesF0ZyqyY9ke9hgxdVzJKGatypz3I
ZJZwkWcz9fDtLbFowfKYGj30Vnbe0w==
=uqIi
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--

