Date: Mon, 15 Mar 2021 12:20:39 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YE9RF+hA4lWKRjHq@stefanha-x1.localdomain>
References: <20210312092212.782255-1-groug@kaod.org>
	<20210312092212.782255-7-groug@kaod.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="37z4Rk9WiL0gM13E"
Content-Disposition: inline
In-Reply-To: <20210312092212.782255-7-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH v2 6/7] vhost-user: Monitor slave channel in
 vhost_user_read()
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


--37z4Rk9WiL0gM13E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 12, 2021 at 10:22:11AM +0100, Greg Kurz wrote:
> Now that everything is in place, have the nested event loop to monitor
> the slave channel. The source in the main event loop is destroyed and
> recreated to ensure any pending even for the slave channel that was
> previously detected is purged. This guarantees that the main loop
> wont invoke slave_read() based on an event that was already handled
> by the nested loop.
>=20
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
> v2: - also monitor G_IO_HUP (Stefan)
>     - refactored the code a bit
> ---
>  hw/virtio/vhost-user.c | 35 ++++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--37z4Rk9WiL0gM13E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBPURcACgkQnKSrs4Gr
c8jSCQf/T0FMmov+/SbUqDeW3aEh4UIYkwecrnfB6jNfsY12rbWOg/07e9nlyPPP
flb2C1OtiQPQobqO9/BD7yHJ6LGUuED2LBnhn/IFXZOgEXXlGv0nkdHkfD9mcfIM
wDzqZsjdgLIPd9ArIjDxL4po5NTMrOZWkU5MKpgZMGs0taHA9gwc/UxnNXjZ8to0
KKX64Ef6+btKfZ/PPSu5kWmwjFU2Wk3skabOwVdW7FH7QYbABm95KIP3Cxr1FcmC
cMQJQP9yzDBXlbPAvCHkrACj2jd4RA8GC/MVFdT9HJJIcYVNaEiRrQandTqtVEJN
wkDaQZZb+VIclI0Ar25UAeANpgFCVQ==
=cMOl
-----END PGP SIGNATURE-----

--37z4Rk9WiL0gM13E--

