Return-Path: <stefanha@redhat.com>
Date: Tue, 18 Jul 2023 12:12:56 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230718161256.GK44841@fedora>
References: <20230712111703.28031-1-hreitz@redhat.com>
 <20230712111703.28031-2-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="BwtCgPh9YPz5qIap"
Content-Disposition: inline
In-Reply-To: <20230712111703.28031-2-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 1/4] vhost-user.rst: Migrating
 back-end-internal state
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


--BwtCgPh9YPz5qIap
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 12, 2023 at 01:16:59PM +0200, Hanna Czenczek wrote:
> @@ -1471,6 +1511,53 @@ Front-end message types
>    before.  The back-end must again begin processing rings that are not
>    stopped, and it may resume background operations.
> =20
> +``VHOST_USER_SET_DEVICE_STATE_FD``
> +  :id: 43
> +  :equivalent ioctl: N/A
> +  :request payload: device state transfer parameters

Where are these defined?

--BwtCgPh9YPz5qIap
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmS2ugcACgkQnKSrs4Gr
c8jU9wgAshYvAU9ZweVQwO2k4C2yAujjDZVLSrcViz/ewOrYM/+tWMRoQZwq4Z77
edpbdLcgGvcQglIwUfYdUXX1EA071YprhLx1SMQM/52u53c/eenzV31WQi5q6+LF
DcyHIv5wTo0Ei5GE6hjZCZC3ejdQCraN9MOxmuhGeWrFPK+jYuhaqOg8TY03M46o
1rMYDoV7/Ukb/lVV3YsL3HbEwM0EfEkB9uNZeQwW7XmRJue4105clF627Yd9J1ZF
Dw2KE7uLrO/SBYbO6kBge4loMJkQh88JBx4nM9DGp5tfkf6lDJdylVF+OHpbmGlZ
2irLnLsqD5SQ9a147SuUNqRCAh2ryQ==
=qMQA
-----END PGP SIGNATURE-----

--BwtCgPh9YPz5qIap--
