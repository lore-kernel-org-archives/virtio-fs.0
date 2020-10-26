Date: Mon, 26 Oct 2020 15:53:58 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201026155358.GE52035@stefanha-x1.localdomain>
References: <20201023165812.36028-1-dgilbert@redhat.com>
	<20201023165812.36028-4-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OZkY3AIuv2LYvjdk"
Content-Disposition: inline
In-Reply-To: <20201023165812.36028-4-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 3/5] tools/virtiofsd: xattr name
 mappings: Map server xattr names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--OZkY3AIuv2LYvjdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2020 at 05:58:10PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Map xattr names coming from the server, i.e. the host filesystem;
> currently this is only from listxattr.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 90 ++++++++++++++++++++++++++++++++
>  1 file changed, 90 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--OZkY3AIuv2LYvjdk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+W8RYACgkQnKSrs4Gr
c8hMJwf/Sn0wMUCvqqgiy4EUkBNuDyRs+bXMyL2GACXnXK6Msk1xDqvLKDQyAOjn
4uKawLy55UkoX1HQ6qoDtgOc7h4kNxirMnEH3G6weWO6FbZS0N5skDqI/0/F+Uwh
CWdCdTTKmnma3r2/UA67mm+yIqkd9308RqgIoJ6VTtwJD1ZHPfPh2UzcR6rXBCy/
+KkLaldP5kqhCBOEuZzaeLPFAeWTSDZbm2Xzbj2A8WwaYiY+HN3c3FnD+BSmyiKj
xvGlvxXTQm4Q7sslnasvfW/iRNVVP070D5HvG97LkRi8mOF9Oy+F/0KmekIzOEtd
PhlAVHdPAXtB7U6Bm11Qg/dZaK9Hvg==
=U14g
-----END PGP SIGNATURE-----

--OZkY3AIuv2LYvjdk--

