Date: Mon, 8 Mar 2021 08:54:17 +0100
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210308075351.f27qzek6nqmbfcwi@mhamilton>
References: <20210303195339.GB3793@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6vu3aumytw2is7vc"
Content-Disposition: inline
In-Reply-To: <20210303195339.GB3793@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add qemu version and copyright
	info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org


--6vu3aumytw2is7vc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 03, 2021 at 02:53:39PM -0500, Vivek Goyal wrote:
> Option "-V" currently displays the fuse protocol version virtiofsd is
> using. For example, I see this.
>=20
> $ ./virtiofsd -V
> "using FUSE kernel interface version 7.33"
>=20
> People also want to know software version of virtiofsd so that they can
> figure out if a certain fix is part of currently running virtiofsd or
> not. Eric Ernst ran into this issue.
>=20
> David Gilbert thinks that it probably is best that we simply carry the
> qemu version and display that information given we are part of qemu
> tree.=20
>=20
> So this patch enhances version information and also adds qemu version
> and copyright info. Not sure if copyright information is supposed
> to be displayed along with version info. Given qemu-storage-daemon
> and other utilities are doing it, so I continued with same pattern.
> This is how now output looks like.
>=20
> $ ./virtiofsd -V
> virtiofsd version 5.2.50 (v5.2.0-2357-gcbcf09872a-dirty)
> Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
> using FUSE kernel interface version 7.33
>=20
> Reported-by: Eric Ernst <eric.g.ernst@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c |    8 ++++++++
>  1 file changed, 8 insertions(+)

Reviewed-by: Sergio Lopez <slp@redhat.com>

> Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2021-03-03 14:28:=
04.893672524 -0500
> +++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2021-03-03 14:37:29.38=
1712706 -0500
> @@ -37,6 +37,8 @@
> =20
>  #include "qemu/osdep.h"
>  #include "qemu/timer.h"
> +#include "qemu-version.h"
> +#include "qemu-common.h"
>  #include "fuse_virtio.h"
>  #include "fuse_log.h"
>  #include "fuse_lowlevel.h"
> @@ -3591,6 +3593,11 @@ static void fuse_lo_data_cleanup(struct
>      free(lo->source);
>  }
> =20
> +static void qemu_version(void)
> +{
> +    printf("virtiofsd version " QEMU_FULL_VERSION "\n" QEMU_COPYRIGHT "\=
n");
> +}
> +
>  int main(int argc, char *argv[])
>  {
>      struct fuse_args args =3D FUSE_ARGS_INIT(argc, argv);
> @@ -3662,6 +3669,7 @@ int main(int argc, char *argv[])
>          ret =3D 0;
>          goto err_out1;
>      } else if (opts.show_version) {
> +        qemu_version();
>          fuse_lowlevel_version();
>          ret =3D 0;
>          goto err_out1;
>=20
>=20

--6vu3aumytw2is7vc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmBF2CgACgkQ9GknjS8M
AjWnYBAAhTrft37VvzPpmwhUEvRe5FjCJxn6RpHmMPH05QuDEIF8RktS3upDfxVj
UD68Aa/XZTVMfW4fpjPYxsQhtr85Fb1cqfISAK8awnYpozLlPbBO2H7tTg79oXsS
Kiuf0GfO3Q7W0fIZLtUc1CW3GPVVeK44nRc5gRDOc5bAqpWxw50p2qIZs+u2ol+O
97LlNPR2krVC3ZftkBRx0fI9h3mTDLhkdAtl+EtBNtx4+WeHi1Yw1Xl1nn3sqNdj
XXGQzsnaSdmu7FqNzOlXd2EEutjBxr1CEP+CxiMWobcQiH52ejCP8t8V0gqAeTgp
ghZAT9VEsvY0+srlcqv1jo9Uk4Mm0pvQtQmpDQXBgr0z75pppQC1Ko7lnLQnWpaq
Gp7KRLbUNuq5lx1Dszhfle9y7ekNqwn34B8ifq2wVXhCj+c8n5K8F3h2CtLp4Ji4
wKDVKvlXDtkrAHbB1N45vFGU/B0Wc0e03RsRlbdNwuq2DDsE2ustOg6yDTkIVlpi
lyKVAbT6uBrk6qi9K5Ku9r50mVc8b2sRjoqmaM1WffmeQqRAcYYXI176q0bKFf+N
5kvGhEQIwGUqpkp846kPbooTpkp9dX2GW1csIxQis0dZdG4lTYeRfQX+j7NVIgkt
t+HhfCyZd5kWKZjxoywbvgOK58ekBwff0aJmnniJLRrmsR9kcx0=
=e5r9
-----END PGP SIGNATURE-----

--6vu3aumytw2is7vc--

