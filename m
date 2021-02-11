Date: Thu, 11 Feb 2021 12:42:24 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211124224.GP247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-16-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zn4k3Q+N5puqXur4"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-16-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 15/24] DAX: virtiofsd: Perform an unmap on
	destroy
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com


--zn4k3Q+N5puqXur4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:15PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Force unmap all remaining dax cache entries on a destroy.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--zn4k3Q+N5puqXur4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlJjAACgkQnKSrs4Gr
c8h0QQf/Y+nocbSfwxxIWY1gxZT7QmiUhimJdTWI2u1GigEhfgOmZv/YMXPwTlcj
IkmkAHd0m0FOgPhywjK+bN6xW8r/+MFuDGoCZEE+yt2mjZQByzkQOmL7xIXN3BBg
seJQ50AeqYoFw9iE6zVlGUX6boFZEAEhA4ArzEH4t7Hl8nl+pwBw7YQtxUJxfVC/
EGbZt2bxiLSPRooJ4aL4lc1HLeQmL1ByV5yJLRxyQbF5NgaihZOwz1TlaoJ4Laoc
KGVadJxDX+T1AjS6q7kBRv3l4AW4Nh/WPkHEt6J8JRMMIzdhR6GmEwqLYGrsx60m
BlUVIXsFwTd/EKdkbyfxqvPn309A3w==
=rSU5
-----END PGP SIGNATURE-----

--zn4k3Q+N5puqXur4--

