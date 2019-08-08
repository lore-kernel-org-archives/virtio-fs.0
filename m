Date: Thu, 8 Aug 2019 09:33:21 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190808083321.GC31476@stefanha-x1.localdomain>
References: <20190807211057.GF18557@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Content-Disposition: inline
In-Reply-To: <20190807211057.GF18557@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Change FUSE_MAP_ALIGNMENT bit
 position for 5.3 kernel
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


--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 07, 2019 at 05:10:57PM -0400, Vivek Goyal wrote:
> Due to rebase to 5.3-rc kernel, change bit position of FUSE_MAP_ALIGNMENT.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  contrib/virtiofsd/fuse_kernel.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: qemu/contrib/virtiofsd/fuse_kernel.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- qemu.orig/contrib/virtiofsd/fuse_kernel.h	2019-08-05 16:32:14.3585647=
55 -0400
> +++ qemu/contrib/virtiofsd/fuse_kernel.h	2019-08-07 16:31:27.882640763 -0=
400
> @@ -292,7 +292,7 @@ struct fuse_file_lock {
>  #define FUSE_MAX_PAGES		(1 << 22)
>  #define FUSE_CACHE_SYMLINKS	(1 << 23)
>  #define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
> -#define FUSE_MAP_ALIGNMENT      (1 << 25)
> +#define FUSE_MAP_ALIGNMENT      (1 << 26)
> =20
>  /**
>   * CUSE INIT request/reply flags
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1L3lAACgkQnKSrs4Gr
c8jUeQf/ZFiiOFcXL8Yt9NY18fZ3nBs9Kw+qUtCBuaJl0IdOXdy/7eV3Fep/on2X
9n26mczFxY3SFTCDUj+7YNGTYR6XYzqpKmjO+7yLsHBV5wysLEeh4p1JZmyaGBH8
IajVyNpVosDiJcwygj2EsgtWbAhWFvn4XJaWRvdFf3Cb+AD1PnJvykQepJAp6WdZ
N/fkl8EkXotgECj6ehREPYC5QMhF202vyVLsg4MK9lL2+7k1lnMo/bNyViR3j1JM
dXEc5LRUxczIyp9kX01g8/9uTIY4jY4XCRyqsClzBnvLtx4AetemajrtPLLXCTOU
uZcfDHQOQKTpOF2Vnlc+mCHkSZzpBQ==
=1lSY
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--

