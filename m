Date: Fri, 30 Oct 2020 09:12:50 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201030091250.GC307361@stefanha-x1.localdomain>
References: <20201029171744.150726-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
In-Reply-To: <20201029171744.150726-1-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/7] virtiofsd: Announce submounts to the
	guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2020 at 06:17:37PM +0100, Max Reitz wrote:
> RFC: https://www.redhat.com/archives/virtio-fs/2020-May/msg00024.html
> v1: https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg03598.html
>=20
> Branch: https://github.com/XanClic/qemu.git virtiofs-submounts-v3
> Branch: https://git.xanclic.moe/XanClic/qemu.git virtiofs-submounts-v3
>=20
> Based-on: <160390309510.12234.8858324597971641979.stgit@gimli.home>
>           (Alex=E2=80=99s pull request
>           =E2=80=9CVFIO updates 2020-10-28 (for QEMU 5.2 soft-freeze)=E2=
=80=9D,
>           notably the =E2=80=9Clinux-headers: update against 5.10-rc1=E2=
=80=9D patch)
>=20
>=20
> Hi,
>=20
> We want to (be able to) announce the host mount structure of the shared
> directory to the guest so it can replicate that structure.  This ensures
> that whenever the combination of st_dev and st_ino is unique on the
> host, it will be unique in the guest as well.
>=20
> This feature is optional and needs to be enabled explicitly, so that the
> mount structure isn=E2=80=99t leaked to the guest if the user doesn=E2=80=
=99t want it to
> be.
>=20
> The last patch in this series adds a test script.  For it to pass, you
> need to compile a kernel that includes the =E2=80=9Cfuse: Mirror virtio-fs
> submounts=E2=80=9D patch series (e.g. 5.10-rc1), and provide it to the te=
st (as
> described in the test patch).
>=20
>=20
> Known caveats:
> - stat(2) doesn=E2=80=99t trigger auto-mounting.  Therefore, issuing a st=
at() on
>   a sub-mountpoint before it=E2=80=99s been auto-mounted will show its pa=
rent=E2=80=99s
>   st_dev together with the st_ino it has in the sub-mounted filesystem.
>=20
>   For example, imagine you want to share a whole filesystem with the
>   guest, which on the host first looks like this:
>=20
>     root/           (st_dev=3D64, st_ino=3D128)
>       sub_fs/       (st_dev=3D64, st_ino=3D234)
>=20
>   And then you mount another filesystem under sub_fs, so it looks like
>   this:
>=20
>     root/           (st_dev=3D64, st_ino=3D128)
>       sub_fs/       (st_dev=3D96, st_ino=3D128)
>         ...
>=20
>   As you can see, sub_fs becomes a mount point, so its st_dev and st_ino
>   change from what they were on root=E2=80=99s filesystem to what they ar=
e in
>   the sub-filesystem.  In fact, root and sub_fs now have the same
>   st_ino, which is not unlikely given that both are root nodes in their
>   respective filesystems.
>=20
>   Now, this filesystem is shared with the guest through virtiofsd.
>   There is no way for virtiofsd to uncover sub_fs=E2=80=99s original st_i=
no
>   value of 234, so it will always provide st_ino=3D128 to the guest.
>   However, virtiofsd does notice that sub_fs is a mount point and
>   announces this fact to the guest.
>=20
>   We want this to result in something like the following tree in the
>   guest:
>=20
>     root/           (st_dev=3D32, st_ino=3D128)
>       sub_fs/       (st_dev=3D33, st_ino=3D128)
>         ...
>=20
>   That is, sub_fs should be a different filesystem that=E2=80=99s auto-mo=
unted.
>   However, as stated above, stat(2) doesn=E2=80=99t trigger auto-mounting=
, so
>   before it happens, the following structure will be visible:
>=20
>     root/           (st_dev=3D32, st_ino=3D128)
>       sub_fs/       (st_dev=3D32, st_ino=3D128)
>=20
>   That is, sub_fs and root will have the same st_dev/st_ino combination.
>=20
>   This can easily be seen by executing find(1) on root in the guest,
>   which will subsequently complain about an alleged filesystem loop.
>=20
>   To properly fix this problem, we probably would have to be able to
>   uncover sub_fs=E2=80=99s original st_ino value (i.e. 234) and let the g=
uest
>   use that until the auto-mount happens.  However, there is no way to
>   get that value (from userspace at least).
>=20
>   Note that NFS with crossmnt has the exact same issue.
>=20
>=20
> - You can unmount auto-mounted submounts in the guest, but then you
>   still cannot unmount them on the host.  The guest still holds a
>   reference to the submount=E2=80=99s root directory, because that=E2=80=
=99s just a
>   normal entry in its parent directory (on the submount=E2=80=99s parent
>   filesystem).
>=20
>   This is kind of related to the issue noted above: When the submount is
>   unmounted, the guest shouldn=E2=80=99t have a reference to sub_fs as the
>   submount=E2=80=99s root directory (host=E2=80=99s st_dev=3D96, st_ino=
=3D128), but to it as
>   a normal entry in its parent filesystem (st_dev=3D64, st_ino=3D234).
>=20
>   (When you have multiple nesting levels, you can unmount inner mounts
>   when the outer ones have been unmounted in the guest.  For example,
>   say you have a structure A/B/C/D, where each is a mount point, then
>   unmounting D, C, and B in the guest will allow the host to unmount D
>   and C.)
>=20
>=20
> - You can mount a filesystem twice on the host, and then it will show
>   the same st_dev for all files within both mounts.  However, the mounts
>   are still distinct, so that if you e.g. mount another filesystem in
>   one of the trees, it will not show up in the other.
>=20
>   With this version of the series, both mounts will show up as different
>   filesystems in the guest (i.e., both will have their own st_dev).
>   That is because the guest receives no information to correlate
>   different mounts; it just sees that some directory is a mount point,
>   so it allocates a dedicated anonymous block device and uses it for
>   that mounted filesystem, independently of what other submounts there
>   may be.
>=20
>   That means if a combination of st_dev+st_ino is unique in the guest,
>   it may not be unique on the host.
>=20
>=20
> v2:
> - Switch from the FUSE_ATTR_FLAGS to the FUSE_SUBMOUNTS capability
>=20
> - Include Miklos=E2=80=99s patch for using statx() to include the mount I=
D as an
>   additional key for lo_inodes (besides st_dev and st_ino).
>=20
>   On one hand, this fixes a bug where if you mount the same filesystem
>   twice in the shared directory, virtiofsd used to see it as the exact
>   same tree (so you couldn=E2=80=99t mount another filesystem in one of b=
oth
>   trees, but not in the other -- in the guest, it would either appear in
>   both or neither).  Now it sees both trees and all nodes within as
>   separate.
>=20
>   On the other, Miklos's patch allows us to simplify the submount
>   detection a bit, because we don=E2=80=99t actually have to store every =
node
>   parent=E2=80=99s st_dev.  It turns out that in all code that actually n=
eeds to
>   check for submounts, we already have the parent lo_inode around and
>   can just query its mount ID and st_dev.
>=20
>   (While the code was pretty much taken from Miklos as he posted it
>   (with minor adjustments), I didn=E2=80=99t add his S-o-b, because he di=
dn=E2=80=99t
>   give it.  I hope using Suggested-by, linking to his original mail, and
>   CC-ing him on this series will suffice.)
>=20
>=20
> git-backport-diff against v1:
>=20
> Key:
> [----] : patches are identical
> [####] : number of functional differences between upstream/downstream pat=
ch
> [down] : patch is downstream-only
> The flags [FC] indicate (F)unctional and (C)ontextual differences, respec=
tively
>=20
> 001/7:[down] 'virtiofsd: Check FUSE_SUBMOUNTS'
> 002/7:[0013] [FC] 'virtiofsd: Add attr_flags to fuse_entry_param'
> 003/7:[down] 'meson.build: Check for statx()'
> 004/7:[down] 'virtiofsd: Add mount ID to the lo_inode key'
> 005/7:[0077] [FC] 'virtiofsd: Announce sub-mount points'
> 006/7:[----] [--] 'tests/acceptance/boot_linux: Accept SSH pubkey'
> 007/7:[----] [--] 'tests/acceptance: Add virtiofs_submounts.py'
>=20
>=20
> Max Reitz (7):
>   virtiofsd: Check FUSE_SUBMOUNTS
>   virtiofsd: Add attr_flags to fuse_entry_param
>   meson.build: Check for statx()
>   virtiofsd: Add mount ID to the lo_inode key
>   virtiofsd: Announce sub-mount points
>   tests/acceptance/boot_linux: Accept SSH pubkey
>   tests/acceptance: Add virtiofs_submounts.py
>=20
>  meson.build                                   |  16 +
>  tools/virtiofsd/fuse_common.h                 |   7 +
>  tools/virtiofsd/fuse_lowlevel.h               |   5 +
>  tools/virtiofsd/fuse_lowlevel.c               |   5 +
>  tools/virtiofsd/helper.c                      |   1 +
>  tools/virtiofsd/passthrough_ll.c              | 117 ++++++-
>  tools/virtiofsd/passthrough_seccomp.c         |   1 +
>  tests/acceptance/boot_linux.py                |  13 +-
>  tests/acceptance/virtiofs_submounts.py        | 289 ++++++++++++++++++
>  .../virtiofs_submounts.py.data/cleanup.sh     |  46 +++
>  .../guest-cleanup.sh                          |  30 ++
>  .../virtiofs_submounts.py.data/guest.sh       | 138 +++++++++
>  .../virtiofs_submounts.py.data/host.sh        | 127 ++++++++
>  13 files changed, 779 insertions(+), 16 deletions(-)
>  create mode 100644 tests/acceptance/virtiofs_submounts.py
>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/cleanup.sh
>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest-cle=
anup.sh
>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest.sh
>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/host.sh
>=20
> --=20
> 2.26.2
>=20

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+b2REACgkQnKSrs4Gr
c8jiiQf9FfLVgQSkXAvFnDQIXP7AfTpliBPz7+mOYPil1BS3YDyGC1i9ynZYi7xs
LRk1anh1ejVtlJ4dAm/tvvf7vS2h79r2iOr1708T8fZEhW0bKJKRirqHTEZMUUkc
HwS4Wi+qC0XdLoAJ7BjAAM5X3ZjNP0HxH9TMQdxLXCdSWaVCHlH6i/k4iZ1V9h82
9WuF0aYOdAp2maPlaIsoxgCNn+AKIemLMpnhFsOd+I8V7XEdFqPhT5RdGFvKQOAF
CbEsDrqDPwJvbha+7bJrmPGmrnvTLw+AvagLF062cRRQeetVbePh/6XjJ7PnJTom
62ckeU1IJbGEACuboRQGhGKE2WiOyQ==
=CKOu
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--

