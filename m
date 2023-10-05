Return-Path: <stefanha@redhat.com>
Date: Thu, 5 Oct 2023 13:46:57 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20231005174657.GI1342722@fedora>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-9-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="E3HnexntZWZGy08/"
Content-Disposition: inline
In-Reply-To: <20231004125904.110781-9-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 8/8] vhost-user-fs: Implement internal
 migration
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


--E3HnexntZWZGy08/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2023 at 02:59:04PM +0200, Hanna Czenczek wrote:
> A virtio-fs device's VM state consists of:
> - the virtio device (vring) state (VMSTATE_VIRTIO_DEVICE)
> - the back-end's (virtiofsd's) internal state
>=20
> We get/set the latter via the new vhost operations to transfer migratory
> state.  It is its own dedicated subsection, so that for external
> migration, it can be disabled.
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  hw/virtio/vhost-user-fs.c | 101 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 100 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--E3HnexntZWZGy08/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUe9pEACgkQnKSrs4Gr
c8gYjwgAxU2ww9s9PeIb8tYpVQ9//4vdONyEacrcqL+yQmGDV8hb4dXJe1K3g5y8
wOpaGhZ9z2dYOD3LD/5jNg45rK91k4rhZP/jcpNyEjCK0yjdf4jJEYvpVW1ENxc6
A+yTDdnzpzTxru+nxRAj7oBir+waOO/N2cLZ5aEMYCTJs/qMCQ04Na+ETsXKHbUB
AFStYKH+SQXQsHycVEg+uaimGyiZjghBWDuEz4PaDd2FhdfFrMCfHwkvr/C3avtJ
EPNLsbXlPraX4GScYonWU8VVKrXTo71nBMVTP+lLsDu1fNXDexqRo6xjgj9COe8w
BjvQ3Wfz/dUneQZzV7w2R6Xi7qONsQ==
=nlmV
-----END PGP SIGNATURE-----

--E3HnexntZWZGy08/--
