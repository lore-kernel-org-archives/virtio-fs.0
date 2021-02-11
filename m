Date: Thu, 11 Feb 2021 12:42:00 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211124200.GO247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-15-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="V7BlxAaPrdhzdIM1"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-15-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 14/24] DAX: virtiofsd: route se down to
	destroy method
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


--V7BlxAaPrdhzdIM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:14PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> We're going to need to pass the session down to destroy so that it can
> pass it back to do the remove mapping.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.c  | 6 +++---
>  tools/virtiofsd/fuse_lowlevel.h  | 2 +-
>  tools/virtiofsd/passthrough_ll.c | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--V7BlxAaPrdhzdIM1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlJhgACgkQnKSrs4Gr
c8hghwgAra6W5sssj/Tvl+kCSWvJKsc4e7drZ0BkASSShPe2fk2CuIVDhIdRv7UW
wMI/QMV274uzA7osBsW3NDVE7JjN64ixt9EeJzOQzpugLf9mnDMxy9WOWOegUzyP
mJvbzH36OWSj6TveM+vb0FhSh7AHQy2kZjLSUzdQhWicEnqaWgGXp6YQJyAX808Z
VKfiDTvVEC/o2qCK2NRJUgUxbnHJ4+5w3CHpSSRoJ5lcwYP9Q/MEZ4tFxcDpNtOr
w6p+z/nbIIf+i3JmGOqd9JI812tQrJDf2XZ8e1xz+E5TBlJZDjGImObvO7VqZKnv
BA32QbY5oTyIl/nsPEJ/tq8j0zcipQ==
=kiAP
-----END PGP SIGNATURE-----

--V7BlxAaPrdhzdIM1--

