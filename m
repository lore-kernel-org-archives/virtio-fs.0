Return-Path: <stefanha@redhat.com>
Date: Mon, 25 Sep 2023 16:18:38 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230925201838.GD323580@fedora>
References: <20230915102531.55894-1-hreitz@redhat.com>
 <20230915102531.55894-4-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="muhzgkgoTP5FcE5Q"
Content-Disposition: inline
In-Reply-To: <20230915102531.55894-4-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 3/5] vhost-user: Interface for migration
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
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, German Maglione <gmaglione@redhat.com>


--muhzgkgoTP5FcE5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 12:25:28PM +0200, Hanna Czenczek wrote:
> Add the interface for transferring the back-end's state during migration
> as defined previously in vhost-user.rst.
>=20
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  include/hw/virtio/vhost-backend.h |  24 +++++
>  include/hw/virtio/vhost.h         |  79 ++++++++++++++++
>  hw/virtio/vhost-user.c            | 148 ++++++++++++++++++++++++++++++
>  hw/virtio/vhost.c                 |  37 ++++++++
>  4 files changed, 288 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--muhzgkgoTP5FcE5Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUR6x4ACgkQnKSrs4Gr
c8ikuAgAxVyVj19bGYPACb0rP8tXyXpMj+bzYHrVoB1XOdkKo/Knw46Eu9I4Ljtz
8eHonM7YAOz6/3DTvMk6/wuiC3iMzs4FS0WZ+cKkfdiM6Opt9z8ultvuH4ZGbxQa
nf/TVaQJY7rVditSx+0h8oBiQk0GbCS5cwSzItdfPYLF8/Q1ZeyG/0Qt2Iy3kRHe
9s1Wuix6YZRNTLYi7uvlbAzVpKDzbnnCnVPwCznDSf2qZKWQg1xQdNxH79JSPaDn
ujmwTstFEs8heh0ZxD3DZaxRXeSHIyqIe1RdpDn0u+YL7/45IMJrFXMGlLDj5h3w
7lIu/+H92bNwLkMKL1OWGhWTa++tng==
=ifEH
-----END PGP SIGNATURE-----

--muhzgkgoTP5FcE5Q--
