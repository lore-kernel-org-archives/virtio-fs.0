Date: Tue, 4 May 2021 16:26:28 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJFnpIwjrbdo2LPn@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-5-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="F71rP5MikdgOjNDk"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-5-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 04/26] DAX: libvhost-user: Route slave
	message payload
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--F71rP5MikdgOjNDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:38PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Route the uint64 payload from message replies on the slave back up
> through vu_process_message_reply and to the callers.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  subprojects/libvhost-user/libvhost-user.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--F71rP5MikdgOjNDk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCRZ6QACgkQnKSrs4Gr
c8ifswgAgMDIRKx/euJ0SnqqG+CY/C6cO5s87C7O3k2SEnpq9y0eJdWVaJWO10Bk
VnKPx5AXC7oJXnwOnzxfcLAI4rlzkRY2vHNxPwAmFRRR0cUU8u8DffSVKAb8gveQ
gXIxMmURaLsd8jsKKYMLPngRy9D7us5E4731LceAKWnOh+YFSqeGom/rmgs8CFMM
PyFt5RDJyXzyzSTL67dBNLVfa3CwuQxtocDvMlCNDrKYhLN2pkibOsT4ZQs5Wezz
ZzddCVUwvyYokfn1TW+VIdTBsarh0R3p5dskD3lX5kXrnTjSFYKDUKpCr8Y7cW16
7cdAMEWC695FR/A9HfQ5jQd3v9QNPw==
=Jv90
-----END PGP SIGNATURE-----

--F71rP5MikdgOjNDk--

