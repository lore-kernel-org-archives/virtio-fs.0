Date: Mon, 4 Oct 2021 14:17:59 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVr/ByKopdRQwsy3@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-4-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cd8PZTVNGSp+cJAL"
Content-Disposition: inline
In-Reply-To: <20210930153037.1194279-4-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 03/13] virtiofsd: Remove unused
 virtio_fs_config definition
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com


--cd8PZTVNGSp+cJAL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:30:27AM -0400, Vivek Goyal wrote:
> "struct virtio_fs_config" definition seems to be unused in fuse_virtio.c.
> Remove it.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 6 ------
>  1 file changed, 6 deletions(-)

In fact, this struct is defined in
include/standard-headers/linux/virtio_fs.h!

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--cd8PZTVNGSp+cJAL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFa/wcACgkQnKSrs4Gr
c8jSRgf8D+ASkKju5k9TA7ysqEU9d7oUWZukON6366Nx212dd4d0IMHKvfPtpTDp
18od7zCIt+sqY+TRNp/sH7eiwNpu5mvyutB+5CiY+0pSdy/kRTTAb6yoQM+8TEDe
8wNOP121pSLYJxS9XCF0PrdxUcpzQLLpDtNzFf+VoMMaZSxJFgzJIpauQexMF85L
OHHUz58jQF37nn4TgMjouaFallWfA3DLiIQFRP2x5RV2VYbr743qCHD89jp1pv82
xFwib4GHE1yocO/zD5RokbR48xOI6RSl87A615WSP0kiho0SyXdEnCbDmpTl5qHK
5FFtIvTrH448OBt8+DY1LUgvih2wGg==
=E/mV
-----END PGP SIGNATURE-----

--cd8PZTVNGSp+cJAL--

