Date: Wed, 26 Jan 2022 10:03:34 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YfEcdsTdIBc9nIdN@stefanha-x1.localdomain>
References: <YfBGoriS38eBQrAb@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jSvtBYRQZ+4qrsEh"
Content-Disposition: inline
In-Reply-To: <YfBGoriS38eBQrAb@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Drop membership of all
 supplementary groups (CVE-2022-0358)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: JIETAO XIAO <shawtao1125@gmail.com>, Mauro Matteo Cascella <mcascell@redhat.com>, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, P J P <pj.pandit@yahoo.co.in>


--jSvtBYRQZ+4qrsEh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 25, 2022 at 01:51:14PM -0500, Vivek Goyal wrote:
> At the start, drop membership of all supplementary groups. This is
> not required.
>=20
> If we have membership of "root" supplementary group and when we switch
> uid/gid using setresuid/setsgid, we still retain membership of existing
> supplemntary groups. And that can allow some operations which are not
> normally allowed.
>=20
> For example, if root in guest creates a dir as follows.
>=20
> $ mkdir -m 03777 test_dir
>=20
> This sets SGID on dir as well as allows unprivileged users to write into
> this dir.=20
>=20
> And now as unprivileged user open file as follows.
>=20
> $ su test
> $ fd =3D open("test_dir/priviledge_id", O_RDWR|O_CREAT|O_EXCL, 02755);
>=20
> This will create SGID set executable in test_dir/.
>=20
> And that's a problem because now an unpriviliged user can execute it,
> get egid=3D0 and get access to resources owned by "root" group. This is
> privilege escalation.
>=20
> Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=3D2044863
> Fixes: CVE-2022-0358
> Reported-by: JIETAO XIAO <shawtao1125@gmail.com>
> Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>=20
> Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2022-01-25 13:38:=
59.349534531 -0500
> +++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2022-01-25 13:39:10.14=
0177868 -0500
> @@ -54,6 +54,7 @@
>  #include <sys/wait.h>
>  #include <sys/xattr.h>
>  #include <syslog.h>
> +#include <grp.h>
> =20
>  #include "qemu/cutils.h"
>  #include "passthrough_helpers.h"
> @@ -1161,6 +1162,29 @@ static void lo_lookup(fuse_req_t req, fu
>  #define OURSYS_setresuid SYS_setresuid
>  #endif
> =20
> +static void drop_supplementary_groups(void)
> +{
> +    int ret;
> +
> +    ret =3D getgroups(0, NULL);
> +    if (ret =3D=3D -1) {
> +        fuse_log(FUSE_LOG_ERR, "getgroups() failed with error=3D%d:%s\n",
> +                 errno, strerror(errno));
> +        exit(1);
> +    }
> +
> +    if (!ret)
> +        return;
> +
> +    /* Drop all supplementary groups. We should not need it */
> +    ret =3D setgroups(0, NULL);
> +    if (ret =3D=3D -1) {
> +        fuse_log(FUSE_LOG_ERR, "setgroups() failed with error=3D%d:%s\n",
> +                 errno, strerror(errno));
> +        exit(1);
> +    }
> +}
> +
>  /*
>   * Change to uid/gid of caller so that file is created with
>   * ownership of caller.
> @@ -3926,6 +3950,8 @@ int main(int argc, char *argv[])
> =20
>      qemu_init_exec_dir(argv[0]);
> =20
> +    drop_supplementary_groups();
> +
>      pthread_mutex_init(&lo.mutex, NULL);
>      lo.inodes =3D g_hash_table_new(lo_key_hash, lo_key_equal);
>      lo.root.fd =3D -1;
>=20

Thanks, applied to my block tree:
https://gitlab.com/stefanha/qemu/commits/block

Stefan

--jSvtBYRQZ+4qrsEh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmHxHHYACgkQnKSrs4Gr
c8jbUggAh+7Be0D4ZOGQInjB24fvp2LnX7kIXpz5dDjsiII+PRgLdpGR+7I/qSnn
td4RDMFfmrroRD2wUqBs6btnnIYfYh6H1c6K3Nd7Ntc1ARiTJ1E5/fQZFtcHIKFK
lq6NSoDAzhGijIr0LOHuzwhdJjI3EGsWyPtp36qGXTijCVxOBHwNMexPIDtpfue6
YnvnN8WSK9wfdIIVqeCtg2PhKMtK7qs2TChyXhvIv6huxUNSF5rHcuLrEqfSHSVC
dD3XLP37eKdQMCmIaFk3PF8xNbX5gw3RpEYrB0Ujpcbs2w2PBn5qiZduDlBq1oTV
Nav1bJ9JL0OOt2dylN4rhZaCe2hMPQ==
=6Trd
-----END PGP SIGNATURE-----

--jSvtBYRQZ+4qrsEh--

