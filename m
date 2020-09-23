Date: Wed, 23 Sep 2020 13:22:53 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200923122253.GB51019@stefanha-x1.localdomain>
References: <20200921213216.GE13362@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <20200921213216.GE13362@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Used glib "shared" thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, qemu-devel@nongnu.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2020 at 05:32:16PM -0400, Vivek Goyal wrote:
> glib offers thread pools and it seems to support "exclusive" and "shared"
> thread pools.
>=20
> https://developer.gnome.org/glib/stable/glib-Thread-Pools.html#g-thread-p=
ool-new
>=20
> Currently we use "exlusive" thread pools but its performance seems to be
> poor. I tried using "shared" thread pools and performance seems much
> better. I posted performance results here.
>=20
> https://www.redhat.com/archives/virtio-fs/2020-September/msg00080.html
>=20
> So lets switch to shared thread pools. We can think of making it optional
> once somebody can show in what cases exclusive thread pools offer better
> results. For now, my simple performance tests across the board see
> better results with shared thread pools.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: qemu/tools/virtiofsd/fuse_virtio.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- qemu.orig/tools/virtiofsd/fuse_virtio.c	2020-09-21 17:28:27.444438015=
 -0400
> +++ qemu/tools/virtiofsd/fuse_virtio.c	2020-09-21 17:28:30.584568910 -0400
> @@ -695,7 +695,7 @@ static void *fv_queue_thread(void *opaqu
>      struct fuse_session *se =3D qi->virtio_dev->se;
>      GThreadPool *pool;
> =20
> -    pool =3D g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size=
, TRUE,
> +    pool =3D g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size=
, FALSE,
>                               NULL);
>      if (!pool) {
>          fuse_log(FUSE_LOG_ERR, "%s: g_thread_pool_new failed\n", __func_=
_);

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9rPh0ACgkQnKSrs4Gr
c8h95ggAhwmJLoaBHHsErEpHJKkma6Mx70WHmYZCr+JoAogEvV0TjYfj83oOzRMZ
IAeaS78kppwaYJf4nmbbU5VW0jz0U88wVFO43D6N8tt9sWNPD6u8Zr9hlWN1tkUz
SIPiRfa4h+vSpZNdzEL8L/cnO3gdp3m+IyYnwz+fa+IAD3wgO6OOB4naLUzJEmLb
RWYTL081LUCRuRABTZWTiemr1sLOBNCmIHkoRVszqbhfOFwKO7b3ygqLC7mg8+9n
ajlN+XuMR8/rL+El1cct9m0ef6iimme3oj2lF/ihxCb4EdC77FsHdgFJFTANih6j
MC5FfBdd+AC++n0IxrkIeQiEEAqe3w==
=Ub6E
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--

