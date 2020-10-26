Date: Mon, 26 Oct 2020 15:55:00 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201026155500.GG52035@stefanha-x1.localdomain>
References: <20201023165812.36028-1-dgilbert@redhat.com>
	<20201023165812.36028-6-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="S5HS5MvDw4DmbRmb"
Content-Disposition: inline
In-Reply-To: <20201023165812.36028-6-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 5/5] tools/virtiofsd: xattr name
	mappings: Simple 'map'
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--S5HS5MvDw4DmbRmb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2020 at 05:58:12PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> The mapping rule system implemented in the last few patches is
> extremely flexible, but not easy to use.  Add a simple
> 'map' type as a sprinkling of sugar to make it easy.
>=20
> e.g.
>=20
>   -o xattrmap=3D":map::user.virtiofs.:"
>=20
> would be sufficient to prefix all xattr's
> or
>=20
>   -o xattrmap=3D":map:trusted.:user.virtiofs.:"
>=20
> would just prefix 'trusted.' xattr's and leave
> everything else alone.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  docs/tools/virtiofsd.rst         |  19 ++++++
>  tools/virtiofsd/passthrough_ll.c | 112 ++++++++++++++++++++++++++++++-
>  2 files changed, 130 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--S5HS5MvDw4DmbRmb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+W8VMACgkQnKSrs4Gr
c8gMrgf/U9bEIcTXJKwnINyZQtQyBUXrrtVMMYXln8oRZ4667nGP6xf7Ei4HEqjb
4uAx3Gfwq/HeKgq9G8nZk340kKYOpTntA3PIemcv2yJ7neVElt8/f5XuGyY+ztfx
WheSPs4RO9mBMzp1VFcgTqbb4OnnJD1jFRCZqSabAx5ljyv/5vQooYOMd/o5GUbJ
vtf5ac4WIC1KpbdaEd4qcCZiLcO/a+0UQJThd9zBumxkdpl6AQOAMpoE/ZTkpOzk
z4pUCe7Tlp6kUQta4EdpQnlistHrm1u2uDVSRdyALa+zSHpCwVqTHV8hUWotGacj
OjhRacNKKmZrvk8n63Pc6CGBC6D74w==
=ny2B
-----END PGP SIGNATURE-----

--S5HS5MvDw4DmbRmb--

