Date: Wed, 4 Sep 2019 16:51:21 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190904155121.GA25679@stefanha-x1.localdomain>
References: <20190827095437.18819-1-stefanha@redhat.com>
	<20190827095437.18819-3-stefanha@redhat.com>
	<20190903172644.GS2744@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20190903172644.GS2744@work-vm>
Subject: Re: [Virtio-fs] [PATCH 2/4] virtiofsd: add --print-capabilities
	option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 03, 2019 at 06:26:44PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > Add the --print-capabilities option as per vhost-user.rst "Backend
> > programs conventions".  Currently there are no advertised features.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>=20
> That looks OK to me, but can someone who understands the json
> requirement explain what says whether a 'features' entry is optional?

I have defined a VHostUserBackendType ('fs') but no
VHostUserBackendCapabilities union field.

I guess this is allowed since many other VIRTIO device types are also
defined without a VHostUserBackendCapabilities union field (only 'gpu'
and 'input' have one).

Stefan

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1v3XkACgkQnKSrs4Gr
c8iPfQf9HxxowHmNAnWfUjP//GSjlfFJ9nQ6vXCm/RSY/74X+ZLQ8ldhNMk6872A
Bd5QFMhMYsvVelNVLwQP92IpPwlaUiPT/MR7mu75Gd0ZXY0xvCJEiDGdUQwBPAu/
rayK80/Q2CSBhz2aTyMI6M0RKAZk2Nau3CC991bhcW5zRwU+iC5mpftnfa31Ymwp
zYDrA2Kryc/WuDW0B6TtCDnbGaqTjP6brXfVxjKJcXTxVI2W4X3OttyyZvYbhcuC
AOLZeJaG4L51NwAnxRy81BT3iP1299i4o7QfnpDs6q8hL1lADgDhRdauDTDwGP2Z
+h4ZA44OUYOqwn6gNpC2vTqRj9akLw==
=gnzr
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--

