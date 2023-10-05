Return-Path: <stefanha@redhat.com>
Date: Thu, 5 Oct 2023 13:43:33 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20231005174333.GD1342722@fedora>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-4-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="t+JYja1hNqvjfZWk"
Content-Disposition: inline
In-Reply-To: <20231004125904.110781-4-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 3/8] vhost-user.rst: Clarify
 enabling/disabling vrings
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


--t+JYja1hNqvjfZWk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2023 at 02:58:59PM +0200, Hanna Czenczek wrote:
> Currently, the vhost-user documentation says that rings are to be
> initialized in a disabled state when VHOST_USER_F_PROTOCOL_FEATURES is
> negotiated.  However, by the time of feature negotiation, all rings have
> already been initialized, so it is not entirely clear what this means.
>=20
> At least the vhost-user-backend Rust crate's implementation interpreted
> it to mean that whenever this feature is negotiated, all rings are to
> put into a disabled state, which means that every SET_FEATURES call
> would disable all rings, effectively halting the device.  This is
> problematic because the VHOST_F_LOG_ALL feature is also set or cleared
> this way, which happens during migration.  Doing so should not halt the
> device.
>=20
> Other implementations have interpreted this to mean that the device is
> to be initialized with all rings disabled, and a subsequent SET_FEATURES
> call that does not set VHOST_USER_F_PROTOCOL_FEATURES will enable all of
> them.  Here, SET_FEATURES will never disable any ring.
>=20
> This interpretation does not suffer the problem of unintentionally
> halting the device whenever features are set or cleared, so it seems
> better and more reasonable.
>=20
> We can clarify this in the documentation by making it explicit that the
> enabled/disabled state is tracked even while the vring is stopped.
> Every vring is initialized in a disabled state, and SET_FEATURES without
> VHOST_USER_F_PROTOCOL_FEATURES simply becomes one way to enable all
> vrings.
>=20
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  docs/interop/vhost-user.rst | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--t+JYja1hNqvjfZWk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUe9cUACgkQnKSrs4Gr
c8hqeQf+J8jHFezwIR2ygsUKJwEjYNdeoaFotnS5EMqR8I+Hw2lPWz6qeWKBKCxt
97zucS5Cuae/QH8sMKlb+c9FvGAG+3ibNFTQNo0U51s7eZzUQVLTjRYFLY+q7e1Q
fcXqP0ju7ZoXvEYsjuaLqXMyfPNWLMesoOpE9nmPErW7QtZXMd5utSFphqUNIp3O
GQGKynO33pfkolMqLBBa9tcYV6bSfKV/jlJMmMz2AZIYvmfj1uajomU08JLuVznt
Lpx/fZj8QLkyKeTK63Xr0YcyV/XnSRlW/UuJIluis0Uagc42G03wNVmD32TAL5NE
30sSwJAK+GI5q+Ae8UI4msWvN0BuMQ==
=8Kbw
-----END PGP SIGNATURE-----

--t+JYja1hNqvjfZWk--
