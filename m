Date: Mon, 15 Mar 2021 10:38:40 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YE85MJl5VNnsN6Y2@stefanha-x1.localdomain>
References: <20210312092212.782255-1-groug@kaod.org>
	<20210312092212.782255-6-groug@kaod.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="yUNiXaIpp1Pn1aSL"
Content-Disposition: inline
In-Reply-To: <20210312092212.782255-6-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH v2 5/7] vhost-user: Introduce nested event
 loop in vhost_user_read()
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


--yUNiXaIpp1Pn1aSL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 12, 2021 at 10:22:10AM +0100, Greg Kurz wrote:
> A deadlock condition potentially exists if a vhost-user process needs
> to request something to QEMU on the slave channel while processing a
> vhost-user message.
>=20
> This doesn't seem to affect any vhost-user implementation so far, but
> this is currently biting the upcoming enablement of DAX with virtio-fs.
> The issue is being observed when the guest does an emergency reboot while
> a mapping still exits in the DAX window, which is very easy to get with
> a busy enough workload (e.g. as simulated by blogbench [1]) :
>=20
> - QEMU sends VHOST_USER_GET_VRING_BASE to virtiofsd.
>=20
> - In order to complete the request, virtiofsd then asks QEMU to remove
>   the mapping on the slave channel.
>=20
> All these dialogs are synchronous, hence the deadlock.
>=20
> As pointed out by Stefan Hajnoczi:
>=20
> When QEMU's vhost-user master implementation sends a vhost-user protocol
> message, vhost_user_read() does a "blocking" read during which slave_fd
> is not monitored by QEMU.
>=20
> The natural solution for this issue is an event loop. The main event
> loop cannot be nested though since we have no guarantees that its
> fd handlers are prepared for re-entrancy.
>=20
> Introduce a new event loop that only monitors the chardev I/O for now
> in vhost_user_read() and push the actual reading to a one-shot handler.
> A subsequent patch will teach the loop to monitor and process messages
> from the slave channel as well.
>=20
> [1] https://github.com/jedisct1/Blogbench
>=20
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
> v2: - Document why a nested loop is needed in vhost_user_read() (Stefan)
> ---
>  hw/virtio/vhost-user.c | 65 ++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 60 insertions(+), 5 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--yUNiXaIpp1Pn1aSL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBPOTAACgkQnKSrs4Gr
c8iz3Qf9HMski1feNXJekhs+KM5/P/56ISBX8w6ypbdqlLk7oS72vh9mtXQ0Ydg9
uAcyK0A0rUR1Js7+ZNQwp+zGAeBicsNn4aEn52cnKW343c7KjtSox5b+czgun9Rz
HSB+pZqRlo4aj/yZr6ezHAoF4r1RTyZDnTPpiVHYPgZoODQDq/3HPI4N5IRdM9pm
PuZnEi+JHXIB4L9gbkC4895MPMhPqvPJiK7PRh7VPv05FXIm+FhFPghEYvcaVL9g
973Z6rfSBh7+W/YVLNrquQYoHBObJPp3CFWNPKpQDsjXIVVC3kjL35TBnoVMMM9N
/KUSBuD9CRimZrNg8irdNAlBO0u1EQ==
=KF9+
-----END PGP SIGNATURE-----

--yUNiXaIpp1Pn1aSL--

