Date: Mon, 21 Jun 2021 14:36:12 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YNCVzPd1UGSzriMP@stefanha-x1.localdomain>
References: <20210617141518.304659-1-groug@kaod.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MxhdyQvhEUnzDHvM"
Content-Disposition: inline
In-Reply-To: <20210617141518.304659-1-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Don't allow file creation with
	FUSE_OPEN
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>


--MxhdyQvhEUnzDHvM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 17, 2021 at 04:15:18PM +0200, Greg Kurz wrote:
> A well behaved FUSE client uses FUSE_CREATE to create files. It isn't
> supposed to pass O_CREAT along a FUSE_OPEN request, as documented in
> the "fuse_lowlevel.h" header :
>=20
>     /**
>      * Open a file
>      *
>      * Open flags are available in fi->flags. The following rules
>      * apply.
>      *
>      *  - Creation (O_CREAT, O_EXCL, O_NOCTTY) flags will be
>      *    filtered out / handled by the kernel.
>=20
> But if it does anyway, virtiofsd crashes with:
>=20
> *** invalid openat64 call: O_CREAT or O_TMPFILE without mode ***: termina=
ted
>=20
> This is because virtiofsd ends up passing this flag to openat() without
> passing a mode_t 4th argument which is mandatory with O_CREAT, and glibc
> aborts.
>=20
> The offending path is:
>=20
> lo_open()
>     lo_do_open()
>         lo_inode_open()
>=20
> Other callers of lo_inode_open() only pass O_RDWR and lo_create()
> passes a valid fd to lo_do_open() which thus doesn't even call
> lo_inode_open() in this case.
>=20
> Specifying O_CREAT with FUSE_OPEN is a protocol violation. Check this
> in lo_open() and return an error to the client : EINVAL since this is
> already what glibc returns with other illegal flag combinations.
>=20
> The FUSE filesystem doesn't currently support O_TMPFILE, but the very
> same would happen if O_TMPFILE was passed in a FUSE_OPEN request. Check
> that as well.
>=20
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  tools/virtiofsd/passthrough_ll.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Thank you!

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--MxhdyQvhEUnzDHvM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDQlcwACgkQnKSrs4Gr
c8i5yQgAoA1RwiU9XZrYxYjIl7/w4K1i9JFxPmXtoSqaNpaaaSHCDs4qxZlquyA0
u4mFkwNvPxlFy0/LCw8f2ciHQdaW70TAxeXhr32tfW/Lps+dqarJvCT8wNB+V8oA
hF7q8RV3BlBSr4g1GzmvXblfF1ejPP2x+/jvnWItgyao+jUZy7vtQejXOeciDYGk
2FcjKwKoxr4PsoMCT7woR1NY9GeFkDfLCyDezc9BCcA4qh1REotnU1C0RWfWtgbU
VaCVOhWxqezIxiJG90lLyxwUZVX1c9JzVL4FtAeGS1JRA9cVOASUy/wv6NPjL3lT
Nip+qs7sIP5oSZONzHXoSOt9JYyODQ==
=LHv2
-----END PGP SIGNATURE-----

--MxhdyQvhEUnzDHvM--

