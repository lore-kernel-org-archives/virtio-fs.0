Date: Mon, 29 Jul 2019 11:15:37 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190729101537.GE3369@stefanha-x1.localdomain>
References: <20190725204934.GG15543@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HnQK338I3UIa/qiP"
Content-Disposition: inline
In-Reply-To: <20190725204934.GG15543@redhat.com>
Subject: Re: [Virtio-fs] [RFC][PATCH] init: Allow mounting virtio_fs
	instance as rootfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


--HnQK338I3UIa/qiP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2019 at 04:49:34PM -0400, Vivek Goyal wrote:
> Hi Stefan,
>=20
> I think following patch might allow you to mount virtio_fs as rootfs
> with new syntax.

Thanks, I've sent a similar patch too.  My patch changes mount_root()
(where the nfs root code also lives) and uses do_mount_root() instead of
mount_block_root() to avoid block/partition error messages.  But I think
they are very similar in terms of functionality.

> I have only compiled it and not tested it. Plase have a look.
>=20
> Thanks
> Vivek
>=20
> virtio_fs passes root=3D<fs-instance-name> as identifier of virtio_fs ins=
tance
> to be mounted. None of the existing primitives seems to fit virito_fs nee=
ds.
>=20
> So check rootfstype and if it is "virtio_fs", do not parse root=3D further
> and call mount_block_root().
>=20
> This is similar to carving out special paths for ubifs. Now virtio_fs
> users should be able to pass "root=3Dmyfs rootfstype=3Dvirtio_fs" and be
> able to mount that particular instance of virtio_fs as rootfs.
> =20
> Yet-To-Be-Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  init/do_mounts.c |    4 ++++
>  1 file changed, 4 insertions(+)
>=20
> Index: rhvgoyal-linux-fuse/init/do_mounts.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- rhvgoyal-linux-fuse.orig/init/do_mounts.c	2019-04-09 15:42:17.0966029=
71 -0400
> +++ rhvgoyal-linux-fuse/init/do_mounts.c	2019-07-25 16:40:29.226348627 -0=
400
> @@ -595,6 +595,10 @@ void __init prepare_namespace(void)
>  			mount_block_root(root_device_name, root_mountflags);
>  			goto out;
>  		}
> +		if (root_fs_names && !strncmp(root_fs_names, "virtio_fs", 3)) {

The entire string, not just the first 3 characters:

  !strcmp(root_fs_names, "virtio_fs")

--HnQK338I3UIa/qiP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0+x0kACgkQnKSrs4Gr
c8joMgf9Gzbhj2ICPvOxBRXegnGWT+ZqXndHWjhi50wViE74z3gr0ZwyzfbUoQbE
EzdCX3z4o9R8xs5DmGKyO0Mg8lokR+cYJ1hXMBXXPkmZLsweRQYIU837BRmTSKZ4
oj+EZMI9gaOpFhbjFVKyJKH618iHYRmL+kzuZ1ksuwhEt0IGMP2XzUZPvA3UT/tN
rGQ7SKY5njgptGblV8b/SXEVmi+3wkMHOSHhXI+svy3Zzm3Ei9AS6UolWV+tH16l
GmxhwW3QuuD45mu05ISQ1TbJpzPs1fQ8ES12qAqhgCQemyL2gz2CX3fK7/RXT6Ll
ogY3iyeCqXU4rHNs7p84hmVord2+NQ==
=nCgP
-----END PGP SIGNATURE-----

--HnQK338I3UIa/qiP--

