Date: Tue, 4 May 2021 15:54:04 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJFgDGYi93A27ZFa@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4m2MJm0AwSkuqQK6"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-2-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 01/26] virtiofs: Fixup printf args
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--4m2MJm0AwSkuqQK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:35PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> @@ -3097,9 +3097,10 @@ static void lo_copy_file_range(fuse_req_t req, fus=
e_ino_t ino_in, off_t off_in,
> =20
>      fuse_log(FUSE_LOG_DEBUG,
>               "lo_copy_file_range(ino=3D%" PRIu64 "/fd=3D%d, "
> -             "off=3D%lu, ino=3D%" PRIu64 "/fd=3D%d, "
> -             "off=3D%lu, size=3D%zd, flags=3D0x%x)\n",
> -             ino_in, in_fd, off_in, ino_out, out_fd, off_out, len, flags=
);
> +             "off=3D%ju, ino=3D%" PRIu64 "/fd=3D%d, "
> +             "off=3D%ju, size=3D%zd, flags=3D0x%x)\n",
> +             ino_in, in_fd, (intmax_t)off_in,
> +             ino_out, out_fd, (intmax_t)off_out, len, flags);

The rest of the patch used uint64_t. Why intmax_t here?

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--4m2MJm0AwSkuqQK6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCRYAwACgkQnKSrs4Gr
c8jNoAgAjuZja+sEpmXicpAP4B9/6+799vxYU2fb0N9OAXC8T0P4ZIsHLnEqFiwz
GUnjXeSa546UGaG8RGOeqBnvmTfE2sPVOOVLckFyvsCAPxR/DVP+F649u7xSwZeY
mbmuHAxX0cGViOjTwsICFizW0/Ter8NwuUZQbQF6dgqmhdGwDFlBmAng36jM83Zb
YpcDVVIJLWxS5I6ms44xquyDwnKG3WM+Ktc/c/YguVp7qrGkJ9xxFVDBukIt0XO5
qoqytqKr1aklj3OiL+5vMU7N6XKON6Ea/9JpdbwF6nyINKaHSbimTeeLOtXA3KFO
AC+TRheE6Z9L25hpvp2mT61CxlSUrg==
=9pnz
-----END PGP SIGNATURE-----

--4m2MJm0AwSkuqQK6--

