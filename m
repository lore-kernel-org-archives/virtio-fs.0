Return-Path: <stefanha@redhat.com>
Date: Thu, 5 Oct 2023 13:38:59 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20231005173859.GC1342722@fedora>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-3-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="3aeG8c6RWYFkvt5Y"
Content-Disposition: inline
In-Reply-To: <20231004125904.110781-3-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 2/8] vhost-user.rst: Improve
 [GS]ET_VRING_BASE doc
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


--3aeG8c6RWYFkvt5Y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2023 at 02:58:58PM +0200, Hanna Czenczek wrote:
> GET_VRING_BASE does not mention that it stops the respective ring.  Fix
> that.
>=20
> Furthermore, it is not fully clear what the "base offset" these
> commands' documentation refers to is; an offset could be many things.
> Be more precise and verbose about it, especially given that these
> commands use different payload structures depending on whether the vring
> is split or packed.
>=20
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  docs/interop/vhost-user.rst | 66 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 62 insertions(+), 4 deletions(-)
>=20
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index 2f68e67a1a..50f5acebe5 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -108,6 +108,37 @@ A vring state description
> =20
>  :num: a 32-bit number
> =20
> +A vring descriptor index for split virtqueues
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> ++-------------+---------------------+
> +| vring index | index in avail ring |
> ++-------------+---------------------+
> +
> +:vring index: 32-bit index of the respective virtqueue
> +
> +:index in avail ring: 32-bit value, of which currently only the lower 16
> +  bits are used:
> +
> +  - Bits 0=E2=80=9315: Next descriptor index in the *Available Ring*

I think we need to say more to make this implementable just by reading
the spec:

  Index of the next *Available Ring* descriptor that the back-end will
  process. This is a free-running index that is not wrapped by the ring
  size.

Feel free to rephrase.

> +  - Bits 16=E2=80=9331: Reserved (set to zero)
> +
> +Vring descriptor indices for packed virtqueues
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> ++-------------+--------------------+
> +| vring index | descriptor indices |
> ++-------------+--------------------+
> +
> +:vring index: 32-bit index of the respective virtqueue
> +
> +:descriptor indices: 32-bit value:
> +
> +  - Bits 0=E2=80=9314: Index in the *Available Ring*

Same here.

> +  - Bit 15: Driver (Available) Ring Wrap Counter
> +  - Bits 16=E2=80=9330: Index in the *Used Ring*

Same here.

> +  - Bit 31: Device (Used) Ring Wrap Counter
> +
>  A vring address description
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> =20
> @@ -1031,18 +1062,45 @@ Front-end message types
>  ``VHOST_USER_SET_VRING_BASE``
>    :id: 10
>    :equivalent ioctl: ``VHOST_SET_VRING_BASE``
> -  :request payload: vring state description
> +  :request payload: vring descriptor index/indices
>    :reply payload: N/A
> =20
> -  Sets the base offset in the available vring.
> +  Sets the next index to use for descriptors in this vring:
> +
> +  * For a split virtqueue, sets only the next descriptor index in the
> +    *Available Ring*.  The device is supposed to read the next index in
> +    the *Used Ring* from the respective vring structure in guest memory.
> +
> +  * For a packed virtqueue, both indices are supplied, as they are not
> +    explicitly available in memory.
> +
> +  Consequently, the payload type is specific to the type of virt queue
> +  (*a vring descriptor index for split virtqueues* vs. *vring descriptor
> +  indices for packed virtqueues*).
> =20
>  ``VHOST_USER_GET_VRING_BASE``
>    :id: 11
>    :equivalent ioctl: ``VHOST_USER_GET_VRING_BASE``
>    :request payload: vring state description
> -  :reply payload: vring state description
> +  :reply payload: vring descriptor index/indices
> +
> +  Stops the vring and returns the current descriptor index or indices:
> +
> +    * For a split virtqueue, returns only the 16-bit next descriptor
> +      index in the *Available Ring*.  The index in the *Used Ring* is
> +      controlled by the guest driver and can be read from the vring

I find "is controlled by the guest driver" confusing. The device writes
the Used Ring index. The driver only reads it. The device is the active
party here.

The sentence can be shortened to omit the "controlled by the guest
driver" part.

> +      structure in memory, so is not covered.
> +
> +    * For a packed virtqueue, neither index is explicitly available to
> +      read from memory, so both indices (as maintained by the device) are
> +      returned.
> +
> +  Consequently, the payload type is specific to the type of virt queue
> +  (*a vring descriptor index for split virtqueues* vs. *vring descriptor
> +  indices for packed virtqueues*).
> =20
> -  Get the available vring base offset.
> +  The request payload=E2=80=99s *num* field is currently reserved and mu=
st be
> +  set to 0.
> =20
>  ``VHOST_USER_SET_VRING_KICK``
>    :id: 12
> --=20
> 2.41.0
>=20

--3aeG8c6RWYFkvt5Y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUe9LMACgkQnKSrs4Gr
c8j5sAgAx70mqH6wDD8GaWjcjyhDVPb1Svcp9dAx4Ns/Z+AmMgzOI1fZw6BVOXiO
dtWTEbRlpSqd5Tc50DMnZSVFpVWakVWOOkKzLZlUmghjsKlPQgEKWBhniUhUycUF
XQMASuUbMkib8ecIFwHhbjpTABgD0RKk7leKNpiXPtF7HoGewXhGbEdk3DwD3UDL
aCKYqH/3LGmbQI9mGwmyjK01b4SRJ5sWg5hzMDHF9WkUX/Yr6CWJisctFaVwEQ+5
IY3NpPkSfO5+TwpNk7WTXrxKE/4eYbZN71ct0kfG9ntUxfUpYwmWItEmTyc2u93c
l/jBNW3fG4MJ7Tyo+oAGDDzvaEiDSg==
=tg6b
-----END PGP SIGNATURE-----

--3aeG8c6RWYFkvt5Y--
