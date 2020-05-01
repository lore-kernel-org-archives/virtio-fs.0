Date: Fri, 1 May 2020 16:22:58 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200501152258.GB221440@stefanha-x1.localdomain>
References: <20200430171814.GA275398@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <20200430171814.GA275398@redhat.com>
Subject: Re: [Virtio-fs] [PATCH][v2] fuse,
 virtiofs: Do not alloc/install fuse device in
 fuse_fill_super_common()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, miklos@szeredi.hu


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2020 at 01:18:14PM -0400, Vivek Goyal wrote:
> As of now fuse_fill_super_common() allocates and installs one fuse device.
> Filesystems like virtiofs can have more than one filesystem queues and
> can have one fuse device per queue. Give, fuse_fill_super_common() only
> handles one device, virtiofs allocates and installes fuse devices for
> all queues except one.
>=20
> This makes logic little twisted and hard to understand. It probably
> is better to not do any device allocation/installation in
> fuse_fill_super_common() and let caller take care of it instead.
>=20
> v2: Removed fuse_dev_alloc_install() call from fuse_fill_super_common().
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/fuse_i.h    |  3 ---
>  fs/fuse/inode.c     | 30 ++++++++++++++----------------
>  fs/fuse/virtio_fs.c |  9 +--------
>  3 files changed, 15 insertions(+), 27 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6sPtIACgkQnKSrs4Gr
c8hliQgAot+qe3sDadrMM/5bgjSPMJ98MqyVdtboP5q7pS53Uw52QJyEZpWm4o2/
G3ACgq4R5RXhWfD4MZjHDRM2Co3RlINGaGCT6VqEdozxdZ+iNjkSvo62mdVjNRjC
T7xqJYZlm7rDOqXqV3KG3jAEUmnPVikG4wsm+nJAlpUhH52ygQdhRWT8H0/tlSgV
RE2Y8PZaafSHvJf8SnCNz4SQskUj77kSHjN4JpmS0iKRyQCyVlz64ZJ3VW92HJWM
P13604JeZ95E0g0L4fRSSnw5ZsA1QuCrVpsKto+GgLEiqTmH5wuLiTMNKg8XdL/F
qEQAGGrtIgt/27/FLmF4uYQkDFAEJA==
=3pgI
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--

