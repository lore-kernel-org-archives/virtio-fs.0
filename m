Date: Thu, 15 Jul 2021 11:04:27 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YPAIK9wfhk7V6Xi9@stefanha-x1.localdomain>
References: <20210714202321.59729-1-vgoyal@redhat.com>
	<20210714202321.59729-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JuHm8BGS67qlvg5y"
Content-Disposition: inline
In-Reply-To: <20210714202321.59729-2-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 1/3] init: split get_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, hch@lst.de


--JuHm8BGS67qlvg5y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 14, 2021 at 04:23:19PM -0400, Vivek Goyal wrote:
> From: Christoph Hellwig <hch@lst.de>
>=20
> Split get_fs_names into one function that splits up the command line
> argument, and one that gets the list of all registered file systems.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  init/do_mounts.c | 48 ++++++++++++++++++++++++++----------------------
>  1 file changed, 26 insertions(+), 22 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--JuHm8BGS67qlvg5y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDwCCsACgkQnKSrs4Gr
c8hXjwgAnj/tXk8SQSwMuw8hoXxqRU6EXvbwTvctsNlGAIONbV1sIb3Bn9/QZp6W
qeaiRi1GFk8aM5sMnlW+F+wRCsmW18Qhq3Umr9NcAVqjmbriRWTQ5lt8Z+/m8WQl
mawAlrsHrCX2gu+HjWRp+najwQ/VDUXCwAuX76rWtx6Mn1BBtLywe02oZwDEAGOg
+/r7MnZ18FeFtAd3qntCjBrLwgdFaTCwe8MCC1rpVwSqGaxTRGMiwSG+MOV1MKDv
fLdONf5m00nxtjArJIEh3deMWm/T5dKBLnHaMCuXz8QOhfXdYvy7IweX3nSfqIJJ
2iV6nJTNeOMTAJ4IEJyp5fNL36qc9Q==
=h3T0
-----END PGP SIGNATURE-----

--JuHm8BGS67qlvg5y--

