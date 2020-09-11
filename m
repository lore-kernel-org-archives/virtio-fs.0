Date: Fri, 11 Sep 2020 11:25:38 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200911102538.GF94280@stefanha-x1.localdomain>
References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-5-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/QKKmeG/X/bPShih"
Content-Disposition: inline
In-Reply-To: <20200909184603.263700-5-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 4/9] fuse: Announce FUSE_ATTR_FLAGS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, fuse-devel@lists.sourceforge.net


--/QKKmeG/X/bPShih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 09, 2020 at 08:45:58PM +0200, Max Reitz wrote:
> We do not have to interpret fuse_attr.flags, but we can let servers know
> that we do expect a value there.
>=20
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  fs/fuse/fuse_i.h | 3 +++
>  fs/fuse/inode.c  | 5 ++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--/QKKmeG/X/bPShih
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9bUKEACgkQnKSrs4Gr
c8gOBgf/RYwLQpJtbDCfgLVmHJezfIq7b157N/UF1vXrmngWqKFd+R2RZ8XcYYln
BSzg178fzH9NrOn3JSf4LrMe1/Ryz1dp0fp9NNwpPHQTkAlJl9kB/Vit6c8sq4e/
8UypqUM+A3G3ZVokhT7W31NRxlBSLpK2w8GKZcqWxju0eod9HImtV5Ww49QL6qsF
GDm28a4APBDyDpvTJxGcDujuVdoEHztB8lNmLykrJfADIvMl1ZoyH43lVytenSjD
nBIpLuEb9F51VU6D/IZzaKhFY8AoABVqeroVa91cMaCwvvBjGDScq9Wx40sYigMY
A9p7zCiTUcqeQz9YhydXzNgDg62k5A==
=4n0q
-----END PGP SIGNATURE-----

--/QKKmeG/X/bPShih--

