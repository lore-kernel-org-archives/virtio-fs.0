Date: Wed, 14 Aug 2019 13:52:35 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190814125235.GC23970@stefanha-x1.localdomain>
References: <5D4CC344.7030706@huawei.com>
 <5D4CC400.9040606@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <5D4CC400.9040606@huawei.com>
Subject: Re: [Virtio-fs] [PATCH v4 2/2] virtiofsd: use fuse_buf_writev to
 replace fuse_buf_write for better performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 09, 2019 at 08:53:20AM +0800, piaojun wrote:
> diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
> index cec762f..d127c45 100644
> --- a/contrib/virtiofsd/buffer.c
> +++ b/contrib/virtiofsd/buffer.c
> @@ -318,11 +318,22 @@ static int fuse_bufvec_advance(struct fuse_bufvec *=
bufv, size_t len)
>  ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv, struct f=
use_bufvec *srcv,
>  		      enum fuse_buf_copy_flags flags)
>  {
> +	size_t i;
>  	size_t copied =3D 0;
>=20
>  	if (dstv =3D=3D srcv)
>  		return fuse_buf_size(dstv);
>=20
> +	/* use writev to improve bandwidth when all the
> +	 * src buffers already mapped by the daemon
> +	 * process */

Some more checks to make this generic:

> +	for (i =3D 0; i < srcv->count; i++) {
> +		if (srcv->buf[i].flags & FUSE_BUF_PHYS_ADDR)
> +			break;

                if (srcv->buf[i].flags & FUSE_BUF_IS_FD)
		        break;

> +	}
> +	if (i =3D=3D srcv->count)

Please verify the preconditions for the destination buffer too:

  && dstv->count =3D=3D 1 && dstv->idx =3D=3D 0 && dstv->off =3D=3D 0 &&
  (dstv->buf[0].flags & FUSE_BUF_IS_FD)

> +		return fuse_buf_writev(req, &dstv->buf[0], srcv);

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1UBBMACgkQnKSrs4Gr
c8iIiQf9GiZUe4iKHBbLTsmFN6BdXfxgpb4WhmlibBMkdPAe97BK9uXr3ayDs7Lw
w01dTwMc3OQ6qaaBiMcv5UYNVFhfvl3rmEd003bzbKX9R16oaHd1Fi6GWlK5otLP
KGl6wYohboZYbubXk3o21ekYqTxCPDtRZKI/REA1EWi8Ptlx6RE9Pq77uLRlOSr8
VquS8XN9eCUr3/yl3Uop/Rq+bzwBH1q6XR5jZpfGa4ScNpm/PYO7xRBe5jTKPSjD
l9wn6D8+wdwcBaPLQyPPdIxkbrCiAt7/Zrkr2P+OA4nSIMW/hN9IPjP7gXApi6h9
LoteORD+4sh37135QGB/YO3WReaKEw==
=RfvT
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--

