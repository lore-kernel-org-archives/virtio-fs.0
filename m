Return-Path: <stefanha@redhat.com>
Date: Tue, 18 Jul 2023 14:32:02 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230718183202.GL44841@fedora>
References: <20230712111703.28031-1-hreitz@redhat.com>
 <20230712111703.28031-3-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="OFXlAdfcAqaoeCSw"
Content-Disposition: inline
In-Reply-To: <20230712111703.28031-3-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 2/4] vhost-user: Interface for migration
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
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, German Maglione <gmaglione@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>


--OFXlAdfcAqaoeCSw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 12, 2023 at 01:17:00PM +0200, Hanna Czenczek wrote:
> Add the interface for transferring the back-end's state during migration
> as defined previously in vhost-user.rst.
>=20
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  include/hw/virtio/vhost-backend.h |  24 +++++
>  include/hw/virtio/vhost.h         |  79 ++++++++++++++++
>  hw/virtio/vhost-user.c            | 147 ++++++++++++++++++++++++++++++
>  hw/virtio/vhost.c                 |  37 ++++++++
>  4 files changed, 287 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--OFXlAdfcAqaoeCSw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmS22qEACgkQnKSrs4Gr
c8hGpgf8CyYr73yfcwyeNjwvgo7NRU8Cjbdh3JG93gfcdq+YlTKoWb1H40sgSDOm
gQzamo9tsxmVqzLEZi5OTtyXFykgqMUSA3hJS52RbgyjCVG5iqP431aM0zvMrQAC
ZIUQVSNtE0ssZEm1PZB65Q+41/uiHBe1447Qsk3hcCxOi8r5XItv2B5iey54owNf
Mcg4VuDSpRxhHSJlUXS4xyuR5wdS5KQqdnv3qhewqme0HK8Kuc8f6ZAcHnrDFL9c
cEwGWUGB64JlrJsu5RqorOoxTRE7n1lwAu8bq1CcmMYEGQALVgY4NIHtT0716bSG
/xShMZH4PlAxpB4j4nbx5HBw4yu4fA==
=bf6d
-----END PGP SIGNATURE-----

--OFXlAdfcAqaoeCSw--
