Return-Path: <stefanha@redhat.com>
Date: Thu, 5 Oct 2023 13:46:25 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20231005174625.GG1342722@fedora>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-7-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="6sPmmG1cmDCEPdDX"
Content-Disposition: inline
In-Reply-To: <20231004125904.110781-7-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 6/8] vhost-user: Interface for migration
 state transfer
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


--6sPmmG1cmDCEPdDX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2023 at 02:59:02PM +0200, Hanna Czenczek wrote:
> Add the interface for transferring the back-end's state during migration
> as defined previously in vhost-user.rst.
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  include/hw/virtio/vhost-backend.h |  24 +++++
>  include/hw/virtio/vhost.h         |  78 ++++++++++++++++
>  hw/virtio/vhost-user.c            | 148 ++++++++++++++++++++++++++++++
>  hw/virtio/vhost.c                 |  37 ++++++++
>  4 files changed, 287 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--6sPmmG1cmDCEPdDX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUe9nEACgkQnKSrs4Gr
c8hPDgf+N8SSbfkTtcNSDYkblMnfmS7Td5y09f8PzEaPrBkdPa42BjmANVEjkMSA
vZu1F6Fm8JYY/Ytjbk7GTyA+gNrzggkUVBXnaisJfnnj9dtwkwct5R+v1XozZ6ZL
R4jm8KVpdQDf/Mz0scI33g7V5Uh+iWGnhUHipqXR3bU7hO+PfffPRoZbY/DSpIvB
+gUFh+KB/5jUJh3WDc7on1R3BqZGCB1LRq/9HUsLDog7brBUMDqJ9QSpYcZf4G3r
GpAB5hFjEOvWvsgnjT928Vqa6Mr8tcaIh3cUmWn/5t2njFZXwDmdajxKVrbeJ8+R
sJZ74c3RhFiIAhLJiMirrjAXYr6avg==
=DrRn
-----END PGP SIGNATURE-----

--6sPmmG1cmDCEPdDX--
