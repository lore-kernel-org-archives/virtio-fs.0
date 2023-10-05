Return-Path: <stefanha@redhat.com>
Date: Thu, 5 Oct 2023 13:44:47 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20231005174447.GE1342722@fedora>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-5-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="BiiMM0ypZsvH1hYP"
Content-Disposition: inline
In-Reply-To: <20231004125904.110781-5-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 4/8] vhost-user.rst: Introduce suspended
 state
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


--BiiMM0ypZsvH1hYP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2023 at 02:59:00PM +0200, Hanna Czenczek wrote:
> In vDPA, GET_VRING_BASE does not stop the queried vring, which is why
> SUSPEND was introduced so that the returned index would be stable.  In
> vhost-user, it does stop the vring, so under the same reasoning, it can
> get away without SUSPEND.
>=20
> Still, we do want to clarify that if the device is completely stopped,
> i.e. all vrings are stopped, the back-end should cease to modify any
> state relating to the guest.  Do this by calling it "suspended".
>=20
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  docs/interop/vhost-user.rst | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--BiiMM0ypZsvH1hYP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUe9g4ACgkQnKSrs4Gr
c8jqNQgAh3/NLIUfC62NRsbyqKCQI96jvjtfA0HkcxrLnE3mMOGCePEIMzhkBzqx
HLvjE79D5JGQKaiOQHlOFNj9xHHeIBoqan03Z8yhCWgNvW5NDD0I2xDGtsPm7eUj
urfyyCYxK9ldOQAW9iNJsDySgHZArZ1yGO9n4Gyl5fWU4GH0drK2dnrf0E7lYhw7
Mh63aI4YjkzQZgDyc/WZCWN5qUyxLveV34fmvlvGhzZeZYndJS/9s2bXp+2pCL/H
eCbuTDBcN9CW7zPk9uxcjcXIf3u0pklFDRxGJLatX5IRAycmgugXqQGCrwL9FXHe
4/pEoqDS6ylC06izJ3ZReEgLv+izLw==
=de4m
-----END PGP SIGNATURE-----

--BiiMM0ypZsvH1hYP--
