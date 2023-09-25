Return-Path: <stefanha@redhat.com>
Date: Mon, 25 Sep 2023 16:23:53 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230925202353.GE323580@fedora>
References: <20230915102531.55894-1-hreitz@redhat.com>
 <20230915102531.55894-5-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="G1vLTDuBl/2qpJYj"
Content-Disposition: inline
In-Reply-To: <20230915102531.55894-5-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 4/5] vhost: Add high-level state
 save/load functions
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


--G1vLTDuBl/2qpJYj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 12:25:29PM +0200, Hanna Czenczek wrote:
> vhost_save_backend_state() and vhost_load_backend_state() can be used by
> vhost front-ends to easily save and load the back-end's state to/from
> the migration stream.
>=20
> Because we do not know the full state size ahead of time,
> vhost_save_backend_state() simply reads the data in 1 MB chunks, and
> writes each chunk consecutively into the migration stream, prefixed by
> its length.  EOF is indicated by a 0-length chunk.
>=20
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  include/hw/virtio/vhost.h |  35 +++++++
>  hw/virtio/vhost.c         | 204 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 239 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--G1vLTDuBl/2qpJYj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUR7FkACgkQnKSrs4Gr
c8g53gf/efNh2hqj0IptWY7I+2HpZ9C+MMwAw60jvMILi4MzWiZAJt625pYSEqB6
eR0ov0YpFTrcOAtiKyREswaYnZ5bLQMppoocjQh/qApgiOXR+7ugaW87Pj6itGf5
yMenJBO7gURkeXfmFSUNzhiev5XOrKuSbw1IwWXEFzXIstT/dDujfYZ5Pr/M4Fjs
aKbo/dAmPxUP3OzVSZe49igboCIHKop+6WH3d3kQlLb5mlNcbldDtg4scRKq9IRY
slf5P/Cs47CpHbo5+USYEMg2FYA5tbU7+dlo3rd88e1Xkp9TDnVdpx1Akkmtke8j
3fjYbcZ3uF2xHGxGejCKm1G/3Cg7xg==
=kLNj
-----END PGP SIGNATURE-----

--G1vLTDuBl/2qpJYj--
