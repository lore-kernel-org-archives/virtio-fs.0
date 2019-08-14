Date: Wed, 14 Aug 2019 13:53:45 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190814125345.GD23970@stefanha-x1.localdomain>
References: <5D53919A.4@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Content-Disposition: inline
In-Reply-To: <5D53919A.4@huawei.com>
Subject: Re: [Virtio-fs] [PATCH] virtio: clean up unused 'char *bar_name'
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2019 at 12:44:10PM +0800, piaojun wrote:
> Clean up 'char *bar_name' to avoid compile warning.
>=20
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> ---
>  drivers/virtio/virtio_pci_modern.c | 1 -
>  1 file changed, 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1UBFkACgkQnKSrs4Gr
c8j/awf/dMeTuZhYgHaHq7r79ouk9NUiALuiq3GJThfH/A3z4l9Z3p6cO28iu0/T
qubOb1XT2PDoMbRgPAVeyLHxO1240NVdOGnrShT8ZJtccJBaYpE9NATcIwg1vx2r
hnEHPsmf176OC1zQ4EblzeqBWTzU2/qr5xf5BoRy9ELObpvKzAOXpq9gzwsAXFwM
lGWjztfWes5oaRQXKfBUv9n8SAHRKE0VYervW6lSpxBGU2ZoaGteDieh7NlwsDPQ
N6qA3yw3IOIcb+D57Ws2SGj5TFlVS4TMSz5stIK1n/oVLVgT41zkJZkA6BJhk7zm
FCK7wHmNxP48q1FX/BzxcM+qvqqUzw==
=zEK9
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--

