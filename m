Return-Path: <stefanha@redhat.com>
Date: Mon, 25 Sep 2023 15:04:31 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230925190431.GB323580@fedora>
References: <20230915102531.55894-1-hreitz@redhat.com>
 <20230915102531.55894-2-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="G/2yNfBg+jWKHP+w"
Content-Disposition: inline
In-Reply-To: <20230915102531.55894-2-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 1/5] vhost-user.rst: Migrating
 back-end-internal state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, German Maglione <gmaglione@redhat.com>


--G/2yNfBg+jWKHP+w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 12:25:26PM +0200, Hanna Czenczek wrote:
> For vhost-user devices, qemu can migrate the virtio state, but not the
> back-end's internal state.  To do so, we need to be able to transfer
> this internal state between front-end (qemu) and back-end.
>=20
> At this point, this new feature is added for the purpose of virtio-fs
> migration.  Because virtiofsd's internal state will not be too large, we
> believe it is best to transfer it as a single binary blob after the
> streaming phase.
>=20
> These are the additions to the protocol:
> - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_DEVICE_STATE
> - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate a file
>   descriptor over which to transfer the state.
> - CHECK_DEVICE_STATE: After the state has been transferred through the
>   file descriptor, the front-end invokes this function to verify
>   success.  There is no in-band way (through the file descriptor) to
>   indicate failure, so we need to check explicitly.
>=20
> Once the transfer FD has been established via SET_DEVICE_STATE_FD
> (which includes establishing the direction of transfer and migration
> phase), the sending side writes its data into it, and the reading side
> reads it until it sees an EOF.  Then, the front-end will check for
> success via CHECK_DEVICE_STATE, which on the destination side includes
> checking for integrity (i.e. errors during deserialization).
>=20
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  docs/interop/vhost-user.rst | 170 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 170 insertions(+)

Great documentation!

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--G/2yNfBg+jWKHP+w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUR2b8ACgkQnKSrs4Gr
c8iMLwf/f5GkieEgVbXuahClGPFQAjBdciOmypJvZyRxcTvOhb4fu6UOJRRSe7Sr
+r8lF6GyaMpq3MyT58JgMVL9tKRaNNGNEEzVPVqrB2sugMet2ZHZA7pSaGKa8Y8R
q9dEeSTmBBZyX0DXlFcP64PCjU6GmooJ0evS0kIMdIFgv4wUW12MiDtP3YDgwphD
iALLapDCmcvMOUESc6KSpIeDjwU4qrUmpGzhqdQzoh4FJaKjuLaWZuye+Nlnvens
SXpvgTlMJNzBZrNuqtGJY7bnUPYbQfXvcTVQxMF241mq11IuiUndEi3D5SVLOvlK
+P3n0iB1UF6Jcz+R8mwswUxS91xs6g==
=2EeV
-----END PGP SIGNATURE-----

--G/2yNfBg+jWKHP+w--
