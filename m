Return-Path: <stefanha@redhat.com>
Date: Mon, 25 Sep 2023 16:48:52 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230925204852.GG323580@fedora>
References: <20230915102531.55894-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="K/zCvWGQCDPOsVDG"
Content-Disposition: inline
In-Reply-To: <20230915102531.55894-1-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 0/5] vhost-user: Back-end state migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, German Maglione <gmaglione@redhat.com>


--K/zCvWGQCDPOsVDG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 12:25:25PM +0200, Hanna Czenczek wrote:
> RFC:
> https://lists.nongnu.org/archive/html/qemu-devel/2023-03/msg04263.html
>=20
> v1:
> https://lists.nongnu.org/archive/html/qemu-devel/2023-04/msg01575.html
>=20
> v2:
> https://lists.nongnu.org/archive/html/qemu-devel/2023-07/msg02604.html
>=20
> Hi,
>=20
> I=E2=80=99ve decided not to work on vhost-user SUSPEND/RESUME for now =E2=
=80=93 it is
> not technically required for virtio-fs migration, which is the actual
> priority for me now.  While we do want to have SUSPEND/RESUME at some
> point, the only practically existing reason for it is to be able to
> implement vhost-level resetting in virtiofsd, but that is not related to
> migration.

QEMU sends VHOST_USER_SET_STATUS 0 in vhost_dev_stop(). Are you assuming
that virtiofs back-ends do not reset the device upon receiving this
message?

> So one of the changes in v3 is that it no longer depends on the
> vhost-user SUSPEND/RESUME series, and describes the migration protocol
> without the device being suspended at any point, but merely that the
> vrings are stopped.
>=20
> Other changes include:
>=20
> - Patch 1:
>   - Rephrased a lot
>   - Added a description for the VHOST_USER_SET_DEVICE_STATE_FD
>     parameters
>   - Renamed VHOST_USER_PROTOCOL_F_MIGRATORY_STATE to
>     VHOST_USER_PROTOCOL_F_DEVICE_STATE
>   - enum variants changed in value due to dropping the SUSPEND/RESUME
>     dependency
>=20
> - Patch 2:
>   - Pulled in, was a stand-alone patch before
>   - Dropped a sentence about ring state before feature negotiations, as
>     the rings are not to be used during that period anyway
>   - Bit of rephrasing
>=20
> - Patch 3:
>   - Renamed =E2=80=9Cmigratory state=E2=80=9D to =E2=80=9Cdevice state=E2=
=80=9D
>   - enum variants changed in value due to dropping the SUSPEND/RESUME
>     dependency
>=20
> - Patch 4:
>   - Changed `f` to @f (referencing parameter =E2=80=9Cf=E2=80=9D) in comm=
ents
>   - Use g_autofree for the transfer buffer
>   - Note SUSPEND state as a future feature, not currently existing
>   - Wrap read() and write() in RETRY_ON_EINTR()
>=20
> - Patch 5:
>   - Renamed =E2=80=9Cmigratory state=E2=80=9D to =E2=80=9Cdevice state=E2=
=80=9D
>   - (kept R-b still)
>=20
>=20
> Hanna Czenczek (5):
>   vhost-user.rst: Migrating back-end-internal state
>   vhost-user.rst: Clarify enabling/disabling vrings
>   vhost-user: Interface for migration state transfer
>   vhost: Add high-level state save/load functions
>   vhost-user-fs: Implement internal migration
>=20
>  docs/interop/vhost-user.rst       | 188 ++++++++++++++++++++++-
>  include/hw/virtio/vhost-backend.h |  24 +++
>  include/hw/virtio/vhost.h         | 114 ++++++++++++++
>  hw/virtio/vhost-user-fs.c         | 101 ++++++++++++-
>  hw/virtio/vhost-user.c            | 148 ++++++++++++++++++
>  hw/virtio/vhost.c                 | 241 ++++++++++++++++++++++++++++++
>  6 files changed, 810 insertions(+), 6 deletions(-)
>=20
> --=20
> 2.41.0
>=20

--K/zCvWGQCDPOsVDG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUR8jMACgkQnKSrs4Gr
c8jKKwf8C5etjvYMEZYDYIJGeOPOVSRiR04zFVZS+/VEolLYYRW0lUzWinu1wjhF
PuPo+jaMNKTbuj/MAFiAhx6agRzKu/M57M1kQxjECSWHYYkKD0CkEz3xOQe0hvVu
hP3MDse57FlX3whkKNnUSE1aTBcwj4l7pMXLljUpM+UwkzjqlnbZq8DI7XdUe2jG
sTp9hYhA0h03V4ACXjd9Ov90QZWWRoOB1BvAawe4PClVdgaQQWM6DiPAsi8ELH6T
9Vyo403dpuek4UvySNWLe7yBDlCT0wv48oXo2NNttzHcJ3G2TfxiFQFma3KlX0Od
nlW5mEYBk8qwOgxXKjQU+dFjvRxKKg==
=qDLO
-----END PGP SIGNATURE-----

--K/zCvWGQCDPOsVDG--
