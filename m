Date: Fri, 12 Jul 2019 10:04:46 +0200
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190712080446.GC24428@stefanha-x1.localdomain>
References: <5e2722ade8346b09cbc4a147757a45b527b5a846.1562763758.git.renzhen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
In-Reply-To: <5e2722ade8346b09cbc4a147757a45b527b5a846.1562763758.git.renzhen@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: conditional compile seccomp flag
 support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eric Ren <renzhen@linux.alibaba.com>
Cc: virtio-fs@redhat.com


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2019 at 09:06:42PM +0800, Eric Ren wrote:
> SCMP_FLTATTR_CTL_TSYNC flag is only available on
> Linux Kernel 3.17 or greater. So, conditional compile
> to make virtio-fs work on older host kernel.
>=20
> Signed-off-by: Eric Ren <renzhen@linux.alibaba.com>
> ---
>  contrib/virtiofsd/seccomp.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
> index 4e388adc9c..5a28a90859 100644
> --- a/contrib/virtiofsd/seccomp.c
> +++ b/contrib/virtiofsd/seccomp.c
> @@ -11,6 +11,7 @@
>  #include <errno.h>
>  #include <seccomp.h>
>  #include <glib.h>
> +#include <linux/version.h>
>  #include "seccomp.h"
> =20
>  static const int syscall_whitelist[] =3D {
> @@ -92,9 +93,12 @@ void setup_seccomp(void)
>  		err(1, "seccomp_init()");
>  	}
> =20
> +#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(3,17,0)
> +	// SCMP_FLTATR_CTL_TSYNC flag is only available on Linux Kernel 3.17 or=
 greater
>  	if (seccomp_attr_set(ctx, SCMP_FLTATR_CTL_TSYNC, 1) !=3D 0) {
>  		err(1, "seccomp_attr_set(ctx, SCMP_FLTATTR_CTL_TSYNC, 1)");
>  	}
> +#endif

There are no threads when setup_seccomp() is invoked so the TSYNC
attribute is not required.

Please remove the TSYNC call.  Then we don't need to worry about version
or feature checks.

Thanks,
Stefan

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0oPx4ACgkQnKSrs4Gr
c8iT6QgAmDvIZMSNvQ6MTCQlGHuNRYULC5O0uyqT7bBDNxXQbDiplVZkILa9dQ0E
Y0yji8/XIJ9sv7a6Juyv5SJkkjyygBJ3D2umW1VQ3ML/AeHkAgMLQ2YFqWOOMUt5
eTDPWlzSZOigib0Krv9ECNUVAMGF71FGvqJet+urPwLCJMjOxz2uv7N4CT/nSxcA
761cUT8ZUJltFKwlKUz2QitudChl6+4q7gTvpG053diIWY1qTkR1G4iKD85qBHZU
g40DUf4ZyNuVDIqcf5JCES07JhOkusrQ7yxozg40UVZfbYqvF1XDmKyBWareYZR+
u0GjiERlkNSgigwedYBGdpjCtjBkKg==
=eG+7
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--

