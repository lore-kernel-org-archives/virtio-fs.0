Date: Fri, 6 Sep 2019 12:51:58 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906115158.GT5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-13-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="yypaS3FvPkEUiGyo"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-13-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 12/18] virtiofs: Use virtio_fs_free_devs()
	in error path
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org


--yypaS3FvPkEUiGyo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 03:48:53PM -0400, Vivek Goyal wrote:
> We already have an helper to cleanup fuse devices. Use that instead of
> duplicating the code.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--yypaS3FvPkEUiGyo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1ySF4ACgkQnKSrs4Gr
c8hVlggAupQb9gfTAr4egGumTVeZNasLSgBakY+MqFVWz6P9M1eU0+mtx0t+LTvK
6hPYtUtYRNcR4U4LWcuAf30gKaYbr5UFDYmQ8zp8sCouPeTZChlnd35T2Aez6RQw
lTlB2cAikH0aAjaLU1ldhLnx/+NkO8KkPh5tEYfCOHPEgpZSz1BQ5ce5iwVY9s5a
2OZEet0IehG38kKsyXW88H+F/p8vHVLRrUkhi5CCezvlim7HFWRLFhj4Dc6Eu0sT
HQmMvhppnlYqoDj8+Nkhs2Xv87KZxK2E6k2Z5NLle7vl1H6HbROZPMJB0WPLLZ2y
+yZpbk5cezyZigVO/ES7VBTJc6IZyA==
=OijB
-----END PGP SIGNATURE-----

--yypaS3FvPkEUiGyo--

