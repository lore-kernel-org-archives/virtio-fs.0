Return-Path: <stefanha@redhat.com>
Date: Thu, 5 Oct 2023 13:46:08 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20231005174608.GF1342722@fedora>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-6-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="jDuzzalqjlJwX7Gx"
Content-Disposition: inline
In-Reply-To: <20231004125904.110781-6-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 5/8] vhost-user.rst: Migrating
 back-end-internal state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, German Maglione <gmaglione@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>


--jDuzzalqjlJwX7Gx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2023 at 02:59:01PM +0200, Hanna Czenczek wrote:
> For vhost-user devices, qemu can migrate the virtio state, but not the
> back-end's internal state.  To do so, we need to be able to transfer
> this internal state between front-end (qemu) and back-end.
>=20
> At this point, this new feature is added for the purpose of virtio-fs
> migration.  Because virtiofsd's internal state will not be too large, we
> believe it is best to transfer it as a single binary blob after the
> streaming phase.
>=20
> These are the additions to the protocol:
> - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_DEVICE_STATE
> - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate a file
>   descriptor over which to transfer the state.
> - CHECK_DEVICE_STATE: After the state has been transferred through the
>   file descriptor, the front-end invokes this function to verify
>   success.  There is no in-band way (through the file descriptor) to
>   indicate failure, so we need to check explicitly.
>=20
> Once the transfer FD has been established via SET_DEVICE_STATE_FD
> (which includes establishing the direction of transfer and migration
> phase), the sending side writes its data into it, and the reading side
> reads it until it sees an EOF.  Then, the front-end will check for
> success via CHECK_DEVICE_STATE, which on the destination side includes
> checking for integrity (i.e. errors during deserialization).
>=20
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  docs/interop/vhost-user.rst | 172 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 172 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--jDuzzalqjlJwX7Gx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUe9mAACgkQnKSrs4Gr
c8j0pggAg8UjrOpW1KQrqs75pbu8eO2gSx9HQGModw59J4CVl1GHySIhKzi7VFQO
Cyvq1wm3vbBJbDwvdeT1al791zvbu1yZgz6nFJZfzJnQ3p9OVYZY9gVSNN4S1gNK
0C71HUGh7Z+9Kf/IeGipgZHkr8VEgFNLZ1VdtvzLzadROBn4fQ71Pp5V54bnkSej
WYOr05CvcUhZKXiudbRVHgddIK+/E1ghxAy1ITi9d2jGOFpHnKX7uKtalAiTLW81
lPTPl+YNJh5ks9IJ06u1NKnOXJMD37SqN6jv47WYtwRQRSsjZQ+ryxWQB2lCjnoc
TAYgRoiG+6pBUPTkGkGKpEDpqM2l8A==
=B0Ah
-----END PGP SIGNATURE-----

--jDuzzalqjlJwX7Gx--
