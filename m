Date: Wed, 5 May 2021 17:43:01 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJLLFXehKyXayNIq@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-11-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="F3c50sBpJ9aMwZoo"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-11-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 10/26] DAX: virtio-fs: Fill in slave
 commands for mapping
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


--F3c50sBpJ9aMwZoo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:44PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Fill in definitions for map, unmap and sync commands.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> with fix by misono.tomohiro@fujitsu.com
> ---
>  hw/virtio/vhost-user-fs.c | 117 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 113 insertions(+), 4 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--F3c50sBpJ9aMwZoo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCSyxUACgkQnKSrs4Gr
c8gi+gf+IFLEzO1ZQG4Lj1PEn2BLl6lilZMGbZ7VsxvHKCTTk69kZ/SNhagzdQli
sSXknu5qjGZ0aH4IvpGLRiRQQXR81Fecb6yYHhOZTPpxBd48wlnlIXmKk/jAdjNY
4WFPeS2qXLhMpkgu2LWWWm41cD1TQkCWtE7e7kQLCEYoI9ZLwLxJSZAkmQHx7wek
tGLj0EP83qzDtEe/BXuIMLdcvrLwSg8Ylnp3yoAIseBq2pQBSlhrykjnDcWk7Vkg
Y+AIpalYsbpiEKr9pqUoLvU+UXka1GoSF2s8BYKrvRAvmisWQ8vDLF49+kLRJCO9
Wqv2FLEvjh3dARKqvk+toLFlLy7e0g==
=fbHz
-----END PGP SIGNATURE-----

--F3c50sBpJ9aMwZoo--

