Date: Thu, 6 May 2021 16:37:04 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJQNIPaFCJlG7ZKc@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-27-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PfGM/wauBig6Rvke"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-27-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 26/26] virtiofsd: Ask qemu to drop
 CAP_FSETID if client asked for it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--PfGM/wauBig6Rvke
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:01:00PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: Vivek Goyal <vgoyal@redhat.com>
>=20
> If qemu guest asked to drop CAP_FSETID upon write, send that info
> to qemu in SLAVE_FS_IO message so that qemu can drop capability
> before WRITE. This is to make sure that any setuid bit is killed
> on fd (if there is one set).
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

I'm not sure if the QEMU FSETID patches make sense. QEMU shouldn't be
running with FSETID because QEMU is untrusted. FSETGID would allow QEMU
to create setgid files, thereby potentially allowing an attacker to gain
any GID.

I think it's better not to implement QEMU FSETID functionality at all
and to handle it another way. In the worst case I/O requests should just
fail, it seems like a rare case anyway: I/O to a setuid/setgid file with
a memory buffer that is not mapped in virtiofsd.

Stefan

--PfGM/wauBig6Rvke
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCUDSAACgkQnKSrs4Gr
c8gGrwgAkGekQKPO5m+cQG8Paqgzwv+Afen12zwjhvXkwGGUgAIwGdQ2hZJCpmZv
TFKZchZoQ/Ilx2tlFxdOFzOjMGpmZeX+nX5uisyXtn9SO09LGL80aFxnYYSpaFBB
LoOy273AdpC8dTFfqij1FNdg04Kc1I4rKUnbHo/5y0G9tZe3wY/uFHUIqMUUV0y+
r+CqCQzcpOzexzmFO5Qfz71p6mAL4QYzmUE6lMO/JnDD9+mGCTwIz3gFyxvGNiAI
QWU6ui4EC0wVWZYUfVfhVtqJ9rqg04r0wM2l3ytR4JhVZZzsH5dwwNFOBt3H9OHS
pz8CYwdblENhAxpXWm/ryUgFXdS1Lw==
=kOui
-----END PGP SIGNATURE-----

--PfGM/wauBig6Rvke--

