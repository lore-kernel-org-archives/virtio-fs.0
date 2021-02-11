Date: Thu, 11 Feb 2021 10:17:23 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211101723.GF247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-6-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="DO5DiztRLs659m5i"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-6-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 05/24] DAX: virtio: Add shared memory
	capability
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


--DO5DiztRLs659m5i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:05PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Define a new capability type 'VIRTIO_PCI_CAP_SHARED_MEMORY_CFG'
> and the data structure 'virtio_pci_cap64' to go with it.
> They allow defining shared memory regions with sizes and offsets
> of 2^32 and more.
> Multiple instances of the capability are allowed and distinguished
> by the 'id' field in the base capability.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  hw/virtio/virtio-pci.c | 20 ++++++++++++++++++++
>  hw/virtio/virtio-pci.h |  4 ++++
>  2 files changed, 24 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--DO5DiztRLs659m5i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlBDMACgkQnKSrs4Gr
c8gveAgArWaZE1Fb9BZKC1pUHUzsnYYLBnOUihMMx0xOMzgF3A+OUXVgi+CkjOGz
CZ9rsnaV+Iy6+H8imuM91h06hi2NtZhY7dadwl1AlN8jUDMJ2k5pCXDQAaNCcPBX
6zsbhpGonzhaDBb9tEEm28aRKFA3PT3wy1qirXgnL+eXUv10seV5wHHN1ZlWj59z
b3XGri7GPpBL7+Crfw/kNdJ7M1R4qEMRhehaOk31QOqwuddDDEevpgGqnMI9Ac6+
Ju6j+Wqj4UO7rQB2GRSQeM+DAZLXWjpZKGKWbj5/BXIJDDf2v/LA43+9bKpDe3I5
EJJzN9W96XEqMvYNHZ0hk90/Nza7oQ==
=LU5a
-----END PGP SIGNATURE-----

--DO5DiztRLs659m5i--

