Date: Fri, 6 Sep 2019 11:47:08 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906104708.GN5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-7-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="yK/6QRnH3Zanb0EF"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-7-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 06/18] virtiofs: ->remove should not clean
 virtiofs fuse devices
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


--yK/6QRnH3Zanb0EF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 03:48:47PM -0400, Vivek Goyal wrote:
> We maintain a fuse device per virt queue. This fuse devices are allocated
> and installed during mount time and should be cleaned up when super block
> is going away. Device removal should not clean it. Device removal should
> stop queues and virtuques can go away.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--yK/6QRnH3Zanb0EF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yOSwACgkQnKSrs4Gr
c8h6Qwf/WpO4mnEca0Q5mo2lnzp1LNn53yJFIz8baldN1jOcw33zkeKDoJ8jQ4ij
1MbNgXpZWvKRM3ne2pDWOTfgU+JfCLruMSB7cgawvizBo2wsehRoCQ7Y+rEFrPhT
QkfKngAlQfkxdMH0s3efds0D/ra9rWftywFg4BxtNrwWwq85JA5bA6IulJBeydlL
kYibfDTxusBufOj57M6CzGNkcrhbBbGoGp29/WKGDTJPYr10IOINpG1VLMRalyyY
DR1y94cFvWz3qNz1CduPxLeBXjCfAjd9u9RNV+U/JnsmVDm6+csXA70wr7tmPjEY
mc+3IOwSwASzAjknAwn7k4QHKwpUmA==
=TIQ2
-----END PGP SIGNATURE-----

--yK/6QRnH3Zanb0EF--

