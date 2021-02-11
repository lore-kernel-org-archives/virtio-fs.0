Date: Thu, 11 Feb 2021 10:12:03 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211101203.GD247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-4-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Qrgsu6vtpU/OV/zm"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-4-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 03/24] DAX: libvhost-user: Allow popping a
 queue element with bad pointers
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


--Qrgsu6vtpU/OV/zm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:03PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Allow a daemon implemented with libvhost-user to accept an
> element with pointers to memory that aren't in the mapping table.
> The daemon might have some special way to deal with some special
> cases of this.
>=20
> The default behaviour doesn't change.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  block/export/vhost-user-blk-server.c      |  2 +-
>  contrib/vhost-user-blk/vhost-user-blk.c   |  3 +-
>  contrib/vhost-user-gpu/vhost-user-gpu.c   |  5 ++-
>  contrib/vhost-user-input/main.c           |  4 +-
>  contrib/vhost-user-scsi/vhost-user-scsi.c |  2 +-
>  subprojects/libvhost-user/libvhost-user.c | 51 ++++++++++++++++++-----
>  subprojects/libvhost-user/libvhost-user.h |  8 +++-
>  tests/vhost-user-bridge.c                 |  4 +-
>  tools/virtiofsd/fuse_virtio.c             |  3 +-
>  9 files changed, 60 insertions(+), 22 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Qrgsu6vtpU/OV/zm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlAvMACgkQnKSrs4Gr
c8ilsQf8CSqsiNBkY6EsYDPIyLsiF1zWKe6HBkpeVe4EH6SLuof7IGHKbXhWAH2m
Ro/wB4i2YLydIJAkNcibQb9MpC/N92trxjefaWiCIDZlv23xy74o10neWVuFz/cl
02cHnaORj0I62338RCdeHoowNP47Wr1D1e2tOpcIRIdtFxglrqdxeGxUz4QHP4J5
2zGYlhltqb/ABJ6dCIYDB9CliEL2j3Dkg7LvToW9Iu3yRa2PnTmmd1YpgN0XTeME
uXuxQCt3GHQ9nfVae5lUFPnOy/3EmNED5j/zI4Xf9/GKWnNH7yT+mYQIuGeBgguO
DQPz4KEZb9B+CqzgFVGBp6jfJRgXpQ==
=5yjg
-----END PGP SIGNATURE-----

--Qrgsu6vtpU/OV/zm--

