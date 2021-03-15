Date: Mon, 15 Mar 2021 10:37:46 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YE84+q2TovYnEaOt@stefanha-x1.localdomain>
References: <20210312092212.782255-1-groug@kaod.org>
	<20210312092212.782255-5-groug@kaod.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="c85XUR3y/frWUTJ3"
Content-Disposition: inline
In-Reply-To: <20210312092212.782255-5-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH v2 4/7] vhost-user: Convert slave channel to
 QIOChannelSocket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>


--c85XUR3y/frWUTJ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 12, 2021 at 10:22:09AM +0100, Greg Kurz wrote:
> The slave channel is implemented with socketpair() : QEMU creates
> the pair, passes one of the socket to virtiofsd and monitors the
> other one with the main event loop using qemu_set_fd_handler().
>=20
> In order to fix a potential deadlock between QEMU and a vhost-user
> external process (e.g. virtiofsd with DAX), we want to be able to
> monitor and service the slave channel while handling vhost-user
> requests.
>=20
> Prepare ground for this by converting the slave channel to be a
> QIOChannelSocket. This will make monitoring of the slave channel
> as simple as calling qio_channel_add_watch_source(). Since the
> connection is already established between the two sockets, only
> incoming I/O (G_IO_IN) and disconnect (G_IO_HUP) need to be
> serviced.
>=20
> This also allows to get rid of the ancillary data parsing since
> QIOChannelSocket can do this for us. Note that the MSG_CTRUNC
> check is dropped on the way because QIOChannelSocket ignores this
> case. This isn't a problem since slave_read() provisions space for
> 8 file descriptors, but affected vhost-user slave protocol messages
> generally only convey one. If for some reason a buggy implementation
> passes more file descriptors, no need to break the connection, just
> like we don't break it if some other type of ancillary data is
> received : this isn't explicitely violating the protocol per-se so
> it seems better to ignore it.
>=20
> The current code errors out on short reads and writes. Use the
> qio_channel_*_all() variants to address this on the way.
>=20
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
> v2: - also monitor G_IO_HUP (Stefan)
>     - use the qio_channel_*_all() variants (Daniel)
>     - simplified thanks to previous refactoring
> ---
>  hw/virtio/vhost-user.c | 99 +++++++++++++++++-------------------------
>  1 file changed, 39 insertions(+), 60 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--c85XUR3y/frWUTJ3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBPOPoACgkQnKSrs4Gr
c8ijcQf/Qu2ubAfZz5af2E39xRaithVNomVYwwHT/O5lLGZS2pP36o++umCZMgzY
v4w6pSC0qUUmf5/4CIWr5NfY7beh7GG/O/lXD/eYzZlJ4Y2DqRx7TBZi8ZZR/lzd
3YQi/gwcmnkDHYC1LQDhNyF+I12D15+1Fv52UwXTWN89Pz/4YUxGiZ8yiFcZsCWe
QFc2VGzFOn1Iq65GYqj93/YTMj3kmxrGurp/ED0hnkp0QL3ckR2XDxJGvbwO1fhs
eLcwr28MgsCxCIbX/JkrJkrFXW/YxOE/GWnR5DpzBfUgG5IQ1kywekJyFuD5IqqK
qjAbY7oZAouuyexs+6D21XLWsE8fjg==
=VFJP
-----END PGP SIGNATURE-----

--c85XUR3y/frWUTJ3--

