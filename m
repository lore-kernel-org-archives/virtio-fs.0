Date: Tue, 10 Nov 2020 11:45:48 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201110114548.GA1084668@stefanha-x1.localdomain>
References: <4bfe8bbd-282f-f271-735d-8892791327e1@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <4bfe8bbd-282f-f271-735d-8892791327e1@huawei.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/2] virtiofsd: fix some accessing NULL
 pointer problem
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Haotian Li <lihaotian9@huawei.com>
Cc: virtio-fs@redhat.com, linfeilong@huawei.com, qemu-devel@nongnu.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2020 at 02:32:17PM +0800, Haotian Li wrote:
> Haotian Li (2):
>   tools/virtiofsd/buffer.c: check whether buf is NULL in
>     fuse_bufvec_advance func
>   virtiofsd/passthrough_ll.c: check whether lo_map_reserve returns NULL
>     in main func
>=20
>  tools/virtiofsd/buffer.c         |  4 ++++
>  tools/virtiofsd/passthrough_ll.c | 10 +++++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)

Please consider printing an error message in Patch 2 so that users can
easily tell why the program refused to start.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+qfWwACgkQnKSrs4Gr
c8i4vAgArY87Y44cegiCYSJGX/urC4kN1AkNe1Ok5SEoDC3DQwiyG/4ESHQRCAfL
Iq2h2yAFR5tZoIXwNa2A1e5X7X+YRhaKqW9cqUjrSPSX/gxT01SsZCytpvtaIrKZ
mvPG6Yv9xczSkOF+er9KNOAKMTGwLLNBfKgdXougDRcmWYjSeUBOy0wMZgUkl6P/
9+EzMgh9fl0KrMtnTh3j3d41M3Gg9yRCiZQuC1wv2xybC/yTUaQhN535snQB1Qtf
nBO1unge8Gzq0r8jGb5A9qqW0yh7YQWKReOZDF3k9UgZZjDIKVCSelK+iF0pCQeW
KNWYdOwNrRziGieSoUdvp1kALzDHNQ==
=RT3g
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--

