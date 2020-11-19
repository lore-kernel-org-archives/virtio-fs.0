Date: Thu, 19 Nov 2020 15:42:08 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201119154208.GA919560@stefanha-x1.localdomain>
References: <20201112182418.25395-1-vgoyal@redhat.com>
	<20201112182418.25395-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20201112182418.25395-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 2/2] viriofsd: Add support for
 FUSE_HANDLE_KILLPRIV_V2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2020 at 01:24:18PM -0500, Vivek Goyal wrote:
> This patch adds basic support for FUSE_HANDLE_KILLPRIV_V2. virtiofsd
> can enable/disable this by specifying option "-o killpriv_v2/no_killpriv_=
v2".
> By default this is enabled as long as client supports it
>=20
> Enabling this option helps with performance in write path. Without this
> option, currently every write is first preceeded with a getxattr() operat=
ion
> to find out if security.capability is set. (Write is supposed to clear
> security.capability). With this option enabled, server is signing up for
> clearing security.capability on every WRITE and also clearing suid/sgid
> subject to certain rules. This gets rid of extra getxattr() call for every
> WRITE and improves performance. This is true when virtiofsd is run with
> option -o xattr.
>=20
> What does enabling FUSE_HANDLE_KILLPRIV_V2 mean for file server implement=
ation.
> It needs to adhere to following rules. Thanks to Miklos for this summary.
>=20
> - clear "security.capability" on write, truncate and chown unconditionally
> - clear suid/sgid in case of following. Note, sgid is cleared only if
>   group executable bit is set.
>     o setattr has FATTR_SIZE and FATTR_KILL_SUIDGID set.
>     o setattr has FATTR_UID or FATTR_GID
>     o open has O_TRUNC and FUSE_OPEN_KILL_SUIDGID
>     o create has O_TRUNC and FUSE_OPEN_KILL_SUIDGID flag set.
>     o write has FUSE_WRITE_KILL_SUIDGID
>=20
> >From Linux VFS client perspective, here are the requirements.
>=20
> - caps are always cleared on chown/write/truncate
> - suid is always cleared on chown, while for truncate/write it is cleared
>   only if caller does not have CAP_FSETID.
> - sgid is always cleared on chown, while for truncate/write it is cleared
>   only if caller does not have CAP_FSETID as well as file has group execu=
te
>   permission.
>=20
> virtiofsd implementation has not changed much to adhere to above ruls. And
> reason being that current assumption is that we are running on Linux
> and on top of filesystems like ext4/xfs which already follow above rules.
> On write, truncate, chown, seucurity.capability is cleared. And virtiofsd
> drops CAP_FSETID if need be and that will lead to clearing of suid/sgid.
>=20
> But if virtiofsd is running on top a filesystem which breaks above assump=
tions,
> then it will have to take extra actions to emulate above. That's a TODO
> for later when need arises.
>=20
> Note: create normally is supposed to be called only when file does not
>       exist. So generally there should not be any question of clearing
>       setuid/setgid. But it is possible that after client checks that
>       file is not present, some other client creates file on server
>       and this race can trigger sending FUSE_CREATE. In that case, if
>       O_TRUNC is set, we should clear suid/sgid if FUSE_OPEN_KILL_SUIDGID
>       is also set.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  include/standard-headers/linux/fuse.h |  28 ++++++-
>  tools/virtiofsd/fuse_common.h         |  15 ++++
>  tools/virtiofsd/fuse_lowlevel.c       |  11 ++-
>  tools/virtiofsd/fuse_lowlevel.h       |   1 +
>  tools/virtiofsd/passthrough_ll.c      | 108 +++++++++++++++++++++++---
>  5 files changed, 148 insertions(+), 15 deletions(-)

Looks complicated but the implementation is simple since we rely on the
host file system to honor the semantics.

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+2klAACgkQnKSrs4Gr
c8ggWgf7BgztJEmZ0GMLHiMeAwew4JmhyfF2ZR2fJhYKu1My7CypEti0MjdtrMPM
BITDHZFytuL9VagDaZCD21Oo4Ou9HK5KXUeUuHUEmI3Cth0vNYcD7RRL0Of0isvZ
c9DsPqcWftGXlBqlQSi4KG5Cc0xhd4PmoxB9egaSTBeK/mT5corGXFDTOMmDjr61
42LSVKlsGw4x2i4kUriOY8UdM0odHqMypC9Fo9KR/UsUErhjGlUGcDHT7rJ5ZjrO
+lXhzrhKJD6JQ4dA5k6l3N6IKgQmkLrE4Dl2vF8uTnz7mQP68GsVZr/TjbuAXrgV
v5umuYGEBcH7ue+zx8AWrAlfQLRvkQ==
=/wtT
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--

