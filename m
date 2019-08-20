Date: Tue, 20 Aug 2019 19:03:22 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190820180322.GH9855@stefanha-x1.localdomain>
References: <20190813200645.13819-1-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2xzXx3ruJf7hsAzo"
Content-Disposition: inline
In-Reply-To: <20190813200645.13819-1-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: Prevent multiply running with
 same vhost_user_socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>


--2xzXx3ruJf7hsAzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2019 at 04:06:45PM -0400, Masayoshi Mizuma wrote:

Two minor comments below.  They can be squashed in when merging this
patch.

If users find it problematic that pid files are never deleted we could
make this feature optional with --pidfile=3DPATH.  But I think we can
merge this patch for now and see if anyone encounters issues before the
next virtio-fs release.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

> +static int fv_socket_lock(struct fuse_session *se)
> +{
> +        char *dir, *sk_name;
> +        Error *local_err =3D NULL;
> +        int ret =3D -1;
> +
> +        dir =3D qemu_get_local_state_pathname("run/virtiofsd");
> +
> +        if (g_mkdir_with_parents(dir, S_IRWXU) < -1) {
> +                fuse_err("%s: Failed to create directory %s: %s",
> +                        __func__, dir, strerror(errno));

Missing g_free(dir).

> @@ -876,6 +916,17 @@ static int fv_create_listen_socket(struct fuse_sessi=
on *se)
>                  return -1;
>          }
> =20
> +        if (!strlen(se->vu_socket_path)) {
> +                fuse_err("Socket path is NULL\n");

s/NULL/empty/

--2xzXx3ruJf7hsAzo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1cNeoACgkQnKSrs4Gr
c8g6Owf+PIbne1lpQNuvlYjzt+cpYSnBD93R4+aBTnczips8p4bD91gDOUOC1a27
09+miVLqhGyhyBHgJtNgFQfo8X1EFJLce/v8kCK5vN/AEU59xuFqBu8NKuG/IEQL
GIVUF/Gk6qPvQIiZfEYXziiIiJ+FKwsJzCQExM5TsQuwWwr0u3Bn2g1TAgWsvoSv
9piSQWjxpURzdn1R/xcSMi7a4uPbWvqMhmUEKL+IVRH4uEZsdlhsqiBiYvur1xVe
XEozEueEjR0j1VH2CAsM9bSp2PA6tzq4txHma0hQJom/RFjzu19i/ZNd+ecUz9fN
J3bC3KzV9/f3VWCS1Lic5xI4T3nr0w==
=aBfl
-----END PGP SIGNATURE-----

--2xzXx3ruJf7hsAzo--

