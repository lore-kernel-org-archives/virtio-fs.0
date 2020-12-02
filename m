Date: Wed, 2 Dec 2020 13:59:09 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201202135909.GB655829@stefanha-x1.localdomain>
References: <20201202123410.GD3226@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <20201202123410.GD3226@work-vm>
Subject: Re: [Virtio-fs] virtiofsd-rs: A rust virtiofs daemon
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, ameynarkhede03@gmail.com


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 02, 2020 at 12:34:10PM +0000, Dr. David Alan Gilbert wrote:
>   Sergio has been working on virtiofsd-rs, a virtiofs daemon
> written in rust, and which can be found at:
>=20
>   https://gitlab.com/virtio-fs/virtiofsd-rs
>=20
> It started life originally as part of the crosvm project, got
> ported to vhost-user as part of the Cloud Hypervisor project, and
> has now been split out.
>=20
> While the C version of virtiofsd isn't going away for now, the hope
> is to stabilise virtiofsd-rs, add some missing features and start
> preferentially adding new features and new work onto the Rust version
> rather than the C version.
>=20
> So please try it, and let the list (and Sergio!) know how you get on.

Awesome, really happy that the Rust daemon has come so far. Thanks
Chirantan, Sebastien, Sergio, and everyone else who developed it.

I talked to Sergio and he is currently looking at what's missing for
feature parity with C virtiofsd. This is an opportunity for anyone who
wants to contribute.

Stefan

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/Hna0ACgkQnKSrs4Gr
c8ingAf/RKVz8Y8xO4DDt5KN5d/TtxxKOOAs5EmZzJ6GMJ9+H5vb6MMVqeddkJKg
9kv+fP2yKNtTnq6yhggF8lVNflXmpzSk+GH1yPxaunYPkaN92QHvzaLppf86b8wG
S/dZ8JhYVqdG+MunTPooor1639+R4r7cWiCd3doFshS4gvUMJ+KTZr7piuntcADQ
Pzy+lGma/jchd4tsi+oDGLdJXfkbfwZfTQn0Oofgnd70n0E1L/0cKdErAL5KpGyA
EQpcJhM9BFTMfycZbH3VyGYTHGUUe9JLkDASedcT1YrLQ94k3xMUC+K1IpRfu/oS
NWWhCiCgtR0ooeD/Tnm47lg9n1xBYA==
=x9qC
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--

