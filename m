Date: Mon, 15 Mar 2021 10:34:16 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YE84KNmp83FLmT36@stefanha-x1.localdomain>
References: <20210312092212.782255-1-groug@kaod.org>
	<20210312092212.782255-2-groug@kaod.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="h7ASQcmT1/dJBGxR"
Content-Disposition: inline
In-Reply-To: <20210312092212.782255-2-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH v2 1/7] vhost-user: Drop misleading EAGAIN
 checks in slave_read()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>


--h7ASQcmT1/dJBGxR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 12, 2021 at 10:22:06AM +0100, Greg Kurz wrote:
> slave_read() checks EAGAIN when reading or writing to the socket
> fails. This gives the impression that the slave channel is in
> non-blocking mode, which is certainly not the case with the current
> code base. And the rest of the code isn't actually ready to cope
> with non-blocking I/O.
>=20
> Just drop the checks everywhere in this function for the sake of
> clarity.
>=20
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  hw/virtio/vhost-user.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--h7ASQcmT1/dJBGxR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBPOCgACgkQnKSrs4Gr
c8jKGwf+ItwXJlgnHNQ6Ge+37OeUgwiUHr3roZ8idwRXNqxYil7KpCOXcu/8cHvP
t3YW7Hb7LgPCg6IYNcgMr2bIZSS/znBuMnthbnmnBkpfPYVXvuWTXFJRufa3z61g
kyoQ3DJn2nB+lWFt3MZgYSBAq134wSg01AeLAARAF0NQ0mcfT1sZYlsqRChRJU/S
lBSbzSv2RGUCagd0q8kfaz5AZOvTY8RCxWCAaPCkEPKG6WGOv5WKhZSGAyXbiWAd
1wE4JbCq4AC7QNORBiEgDaz0GRT5zxxJDj3uw3+sTZF5xFoWTrhu2N8EYz/yLLjd
E6nOvYzG82cC/Pe9GBsPnDlXQyYm5A==
=OjTR
-----END PGP SIGNATURE-----

--h7ASQcmT1/dJBGxR--

