Date: Wed, 15 Jan 2020 12:50:49 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200115125049.GD163546@stefanha-x1.localdomain>
References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Content-Disposition: inline
In-Reply-To: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
Subject: Re: [Virtio-fs] Ways to uniquely and persistently identify nodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2020 at 06:46:49PM +0100, Max Reitz wrote:
> (1) stat=E2=80=99s st_ino in the guest is not necessarily unique.  Curren=
tly, it
> just the st_ino from the host file, so if you have mounted multiple
> different filesystems in the exported directory tree, you may get
> collisions.

This must be fixed because POSIX file systems have unique and persistent
st_ino so that stat(2) can distinguish inodes from each other.

> (2) The FUSE 64-bit fuse_ino_t (which identifies an open file,
> basically) is not persistent.  It is just an index into a vector that
> contains all open inodes, and whenever virtiofsd is restarted, the
> vector is renewed.  That means that whenever this happens, all
> fuse_ino_t values the guest holds will become invalid.  (And when
> virtiofsd starts handing out new fuse_ino_t values, those will probably
> not point to the same inodes as before.)

fuse_ino_t only needs to be persistent when the FUSE_EXPORT_SUPPORT
protocol feature is enabled.  It means that nodeids persist even when
the last reference is dropped.  (If you implement an alternative
open_by_handle_at(2) approach then it would extend the semantics.)

However, it's more challenging to support power management freeze/thaw
(not a high priority since no one seems to use it) when fuse_ino_t is
not persistent.  The driver would have to do something during freeze
and/or thaw to be able to restore the FUSE session state (fuse_ino_t,
fh, etc).  If we end up not being able to implement freeze/that, I think
that would be acceptable.

> (3) name_to_handle_at()/open_by_handle_at() are implemented by FUSE just
> by handing out the fuse_ino_t value as the handle.  This is not only a
> problem as long as fuse_ino_t is not persistent (see (2)), but also in
> general, because the fuse_ino_t value is only valid (per FUSE protocol)
> as long as the inode is referenced by the guest.

open_by_handle_at() will be needed sooner or later.  For example, users
might wish to export a virtio-fs file system via an NFS server running
inside the guest.  We need this.

Stefan

--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl4fCqkACgkQnKSrs4Gr
c8iOqQf/bXW2iVlSOL+DQudWU//ohhNLYx6rM5zFJFcfDrddaFKO9s57b4ovGZGD
qlSPGYadpBsn08OOp0ZjIsfQwxZE8QCBXsaI1O/XNfGH7zrzPXVKr+nG3L7uWz1p
hQsug4EP1G2BfYOzLfXEHruh1t+0TG2C3jo+pNi3zrF8bxp+M7awYPFcGQsR9tyK
GHuW2c9T3y4uGonKcm5RyxlWmOLgfzms3gwd1uP5cd2MhP/vUHUqSO1pmzO0ELnZ
yezUEAgesv7jwVhoaaWaMxDYDx9BmAzd8z8Nct+x66uAb5Z/OyYxw+gdxDDGvtvM
WZ6eH4/cZtX6jxwceq6X3NtZ340gkg==
=quQx
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--

