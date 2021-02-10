Date: Wed, 10 Feb 2021 14:58:14 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210210145814.GA231286@stefanha-x1.localdomain>
References: <20210209224754.GG3171@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20210209224754.GG3171@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Fail dax mount if device does not
	support it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 05:47:54PM -0500, Vivek Goyal wrote:
> Right now "mount -t virtiofs -o dax myfs /mnt/virtiofs" succeeds even
> if filesystem deivce does not have a cache window and hence DAX can't
> be supported.
>=20
> This gives a false sense to user that they are using DAX with virtiofs
> but fact of the matter is that they are not.
>=20
> Fix this by returning error if dax can't be supported and user has asked
> for it.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> Index: redhat-linux/fs/fuse/virtio_fs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- redhat-linux.orig/fs/fuse/virtio_fs.c	2021-02-04 10:40:21.704370721 -=
0500
> +++ redhat-linux/fs/fuse/virtio_fs.c	2021-02-09 15:56:45.693653979 -0500
> @@ -1324,8 +1324,15 @@ static int virtio_fs_fill_super(struct s
> =20
>  	/* virtiofs allocates and installs its own fuse devices */
>  	ctx->fudptr =3D NULL;
> -	if (ctx->dax)
> +	if (ctx->dax) {
> +		if (!fs->dax_dev) {
> +			err =3D -EINVAL;
> +			pr_err("virtio-fs: dax can't be enabled as filesystem"
> +			       " device does not support it.\n");
> +			goto err_free_fuse_devs;
> +		}
>  		ctx->dax_dev =3D fs->dax_dev;
> +	}
>  	err =3D fuse_fill_super_common(sb, ctx);
>  	if (err < 0)
>  		goto err_free_fuse_devs;

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAj9IYACgkQnKSrs4Gr
c8hKswgAx8cnf0HAP8eDaXN2en5yHDUSGwKbvCKrRN5KNUKPcwK372PNnX+H2Kp2
/ngf5Umzb1oxvofxNWuZUuHRYl/LFVIcYlICW6IvccaR4DFHEKj9tHOA9SiEbg8j
o9F3P7wgB2V6Hq5fH4556VUJJjWYTKQQO9WRWoQKJL1zeRUHcuhJIIFsJOpWQgTP
k98uM6spvg21o0BFH+QVh3shizFkzYzYz6CtGhiKfPuEN0mMvr3zcwJpgETgNpOf
DuMdsxNLf/DZc1Y5K3Kzhc5tf3EszcunGrFbbxhU3dAXX2CUQbB1fVEBRWwNPrlf
8Kd8n7XyHtehZIGHabdIQNWGW0yyoA==
=X28C
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--

