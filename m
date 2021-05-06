Date: Thu, 6 May 2021 16:28:03 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJQLA1S2DcJzrKds@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-23-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sB5T+Uov0QsJqPIM"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-23-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 22/26] DAX/unmap virtiofsd: route
 unmappable write to slave command
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


--sB5T+Uov0QsJqPIM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:56PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> When a fuse_buf_copy is performed on an element with FUSE_BUF_PHYS_ADDR
> route it to a fuse_virtio_write request that does a slave command to
> perform the write.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/buffer.c         | 14 +++++++++++---
>  tools/virtiofsd/fuse_common.h    |  6 +++++-
>  tools/virtiofsd/fuse_lowlevel.h  |  3 ---
>  tools/virtiofsd/passthrough_ll.c |  2 +-
>  4 files changed, 17 insertions(+), 8 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--sB5T+Uov0QsJqPIM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCUCwMACgkQnKSrs4Gr
c8ihLQf/cxQloZQ/KGMBKJR4MJDSL8dxCCJ8fYx+caqn08M6MFdQFKc/Dsw3nkY1
err4xoubUXzLeOejUW/8ZXhoXASmtV19X1myceXsvMq+/SAxNSpwwCvJJtxTOAiI
DluEY1mXmr86ySiv9Cb/FK/57hqmtDzFkoWqzLaf7v//oSeGlGZNgWk/2YK8eP2y
+EZN8nywzuN8Jg3WDW3HrFfkk82TNhteToQg/WGDwC49meJkhD7qv3X+tM3UYi93
mAn/APoFWs4W3NZzq+HcOXlY99zM/gN03E7ZqyurexsbDobfsBWEJyEb1xZZWa1R
v/81mS4+ebySdNeA5MXBh1FYyaDEYg==
=nEyR
-----END PGP SIGNATURE-----

--sB5T+Uov0QsJqPIM--

