Date: Thu, 11 Feb 2021 14:18:49 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211141849.GR247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-18-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="N+qDRRsDvMgizTft"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-18-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 17/24] DAX/unmap virtiofsd: Add wrappers for
 VHOST_USER_SLAVE_FS_IO
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


--N+qDRRsDvMgizTft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:17PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Add a wrapper to send VHOST_USER_SLAVE_FS_IO commands and a
> further wrapper for sending a fuse_buf write using the FS_IO
> slave command.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.h | 25 ++++++++++++++++++++++
>  tools/virtiofsd/fuse_virtio.c   | 38 +++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--N+qDRRsDvMgizTft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlPMkACgkQnKSrs4Gr
c8hZ1AgAiC4+Vz3v4FFdS92CamOrd+loZoji2loPcTfiag4R3fgNs2/xRpEEbF+t
Bq52sIe0ued8NYBHtwo6xYIeeJPQ06NBK3dTIf8iFdyXhh/QGtFeXX6+wLPppk+F
ziEPtk52dlMhE4fs/uxvsS5sIrqZoDdF02rw1hBJYS2Z1tBanCO6c+T7nQorhSp3
jxhQzXouIpXAkNUGFXFUP5SAZMZzFDpC1hWUwezMC3bRQT3pN8ox0Ya4TUZdx98K
YKtwXYL1InzoBvy/YI0asPdcotFj58oj9ACNECp4fuO67Xbp9HQtptbkROCAmYHt
6HXU09crj5KbAhATUEtpY1AWAmkq7A==
=Gajt
-----END PGP SIGNATURE-----

--N+qDRRsDvMgizTft--

