Date: Fri, 6 Sep 2019 11:54:48 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906105448.GQ5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-10-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zywvytGCXzdVpkje"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-10-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 09/18] virtiofs: Add an helper to start all
	the queues
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org


--zywvytGCXzdVpkje
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 03:48:50PM -0400, Vivek Goyal wrote:
> This just marks are the queues are connected and ready to accept the
> request.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--zywvytGCXzdVpkje
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yOvgACgkQnKSrs4Gr
c8gpQQgAmqp0vUor8BWsHmF4f+In/ZlxHyIx8n3wydsF7FDmfDqnXBAAB1qRRErW
2msRa5bwjkk9CUJdE9qVsrep5CjgqpApmNEGuCREhZcRpS7RFyZJaXbPhRI4ipII
VjAcP0OhH1iVnyy2kWy4EaTdmDAgqjCLZjB3rDKldsYq37sfwAlX0xWyWBwKgRLm
3g0KmiJa8E4aVlG01KfLrGd7+aschTC8Jm5p6XPVE8yN4tFCf0Ax3DbZ6PZen+ah
+BQQSXjYiyszHGT+F0E70ihwnaxZkqtiSOluPk0+db+DAvRC11OgYv54YdGXv6Gf
g2HoRAtGSvMStmfuZfboifUBFXVhyw==
=cHMM
-----END PGP SIGNATURE-----

--zywvytGCXzdVpkje--

