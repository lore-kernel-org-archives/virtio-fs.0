Return-Path: <stefanha@redhat.com>
Date: Tue, 18 Jul 2023 14:44:05 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230718184405.GN44841@fedora>
References: <20230712111703.28031-1-hreitz@redhat.com>
 <20230712111703.28031-5-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="6wa/D7BRPF2G8XTF"
Content-Disposition: inline
In-Reply-To: <20230712111703.28031-5-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 4/4] vhost-user-fs: Implement internal
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, German Maglione <gmaglione@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>


--6wa/D7BRPF2G8XTF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 12, 2023 at 01:17:02PM +0200, Hanna Czenczek wrote:
> A virtio-fs device's VM state consists of:
> - the virtio device (vring) state (VMSTATE_VIRTIO_DEVICE)
> - the back-end's (virtiofsd's) internal state
>=20
> We get/set the latter via the new vhost operations to transfer migratory
> state.  It is its own dedicated subsection, so that for external
> migration, it can be disabled.
>=20
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  hw/virtio/vhost-user-fs.c | 101 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 100 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--6wa/D7BRPF2G8XTF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmS23XUACgkQnKSrs4Gr
c8iXVAf+NllGwBz6+X27TWFo5xx0UhMghIuI6ybXbutx9lQSuSTdmc3hwtlKRU7y
5cxaw9fKGXsYF7zi6LxFn4onRSmjGFe2uAnk5vPmff+idaI5XOV25Vlg6Bb/RbNm
c8asN3q8B7petk/Jc9x5BZZTgNBhBqezCJoWUCP/L/hgIrs+geh0e2+ARukaK8RV
GJutJnXg3fxoijcmbmAU/q3NPQ8fr440buDrNaeSlmopeg+ikcHDAD+aneakojbs
oTvnsAJchJ1GPPQPjZJWpe536j9XhUX7Y40WFd4luRLpkBIUIRQTe+JmiAemSp5u
xEoHG6dQPLyw1VEcwOD3XzyaRiSrlQ==
=Awnu
-----END PGP SIGNATURE-----

--6wa/D7BRPF2G8XTF--
