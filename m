Date: Tue, 13 Aug 2019 16:51:53 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190813155153.GD32090@stefanha-x1.localdomain>
References: <20190811225534.9040-1-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
Content-Disposition: inline
In-Reply-To: <20190811225534.9040-1-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: Prevent multiply running with
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


--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 11, 2019 at 06:55:34PM -0400, Masayoshi Mizuma wrote:
> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_l=
owlevel.c
> index 8adc4b1ab8..ab18b86435 100644
> --- a/contrib/virtiofsd/fuse_lowlevel.c
> +++ b/contrib/virtiofsd/fuse_lowlevel.c
> @@ -2587,6 +2587,9 @@ void fuse_session_destroy(struct fuse_session *se)
>  	free(se->vu_socket_path);
>  	se->vu_socket_path =3D NULL;
> =20
> +	unlink(se->vu_socket_lock_file);

Are you sure this works?  We should be inside the chroot here, so this
is probably not the same file that we created!

> +        socket_name =3D malloc(strlen(se->vu_socket_path) + 1);
> +        memset(socket_name, 0, strlen(se->vu_socket_path) + 1);
> +        memcpy(socket_name, se->vu_socket_path, strlen(se->vu_socket_pat=
h));

These lines can be replaced with:

  socket_name =3D g_strdup(se->vu_socket_path);
  ...
  g_free(socket_name);

> +        strreplace(socket_name, '/', '.');
> +
> +        se->vu_socket_lock_file =3D malloc(NAME_MAX);
> +        memset(se->vu_socket_lock_file, 0, NAME_MAX);
> +        snprintf(se->vu_socket_lock_file, NAME_MAX, "%s/%s.pid",
> +			dir, socket_name);

These lines can be replaced with:

  se->vu_socket_lock_file =3D g_strdup_printf("%s/%s.pid", dir, socket_name=
);

The difference here is that it won't silently truncate to NAME_MAX.
This is probably a good thing since an ENAMETOOLONG error should be
reported instead of silently truncating the path.

--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1S3JkACgkQnKSrs4Gr
c8iDhAgAlNH6rtnbCqFCQgRqFavGgVy2e2S//brq9HWVepuUrsc5PmTvisZuHg2f
Dt9rIEpuCxxLunJ+yW0bJ4UAgVJyX+srKhsLBxXTeAofonKjCNIZCkn3wkn0b2BW
zY1Ld6QN/lXPdBH+IJCIF37fK0Ej75duKTIgwSRLlzosyZp4+F2u23fQFcCpKgz0
rZj5v4VpPdzIuNK7A00YOgX1WyQpIYzx4+iby9R+LrA6yXnaBwRE2NjjAwDd4uIv
Egt05Fzc4pLdvl9mo7ZTMXE3R4UXmGNNc/q8LXrNV1rqutkXi8kKhVWiOvle3m00
TfrIYYZUZqzypGeYf6pzcVcmmmJeDw==
=AY0R
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--

