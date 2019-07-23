Date: Tue, 23 Jul 2019 14:20:08 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190723132008.GF5445@stefanha-x1.localdomain>
References: <20190718151355.11461-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cpvLTH7QU4gwfq3S"
Content-Disposition: inline
In-Reply-To: <20190718151355.11461-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] Fixes to id field for virtio-spec change
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, vgoyal@redhat.com


--cpvLTH7QU4gwfq3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2019 at 04:13:53PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Hi,
>   The current edition of the virtio spec changes for the
> shared memory capability change how we find our DAX
> (and version) mappings.
>=20
>   We now use a byte in the existing capability header
> as 'id', and now the new capability structure is a
> generic 64 bit structure.
>=20
>   This set goes with the current -dev qemu/virtiofsd branch.
>=20
>=20
> Dr. David Alan Gilbert (2):
>   virito: Add 'id' field to capability header
>   virto/shared memory: Rework for standardised id field
>=20
>  drivers/virtio/virtio_pci_modern.c |  8 ++++----
>  include/uapi/linux/virtio_pci.h    | 17 ++++++++---------
>  2 files changed, 12 insertions(+), 13 deletions(-)
>=20
> --=20
> 2.21.0
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--cpvLTH7QU4gwfq3S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl03CYgACgkQnKSrs4Gr
c8jedgf+LGHYDSXdDyrnz1eZ+7QyWVtlyD6FwBYPJz5UJel09p3IaNvaOSEaJypL
9MKytS24WE2F3GYQdBIuFsRnzNq9ITA0fvAhZlOsVAntB0fO3b0Rybz18+8hhADc
Pw4mYpWIgF5MpXYXocj+2nzU+ofDI6g3TtjjeAS9SkG4++u7yEsMvvbS0mpVmsvY
RAPhIa4hGEOn3Wuex53MCVeGrb7B6upx7c5j/D+b6hAe4PrSr0m6J7xQaawNSye9
MyXdqCV582AKRZCRXSMEhqjG/aocq7QrTZKZ3TxlQFeoVcPoiDMI0jisHN0qZxjN
tOzvLiDPEP/i3tEPsqg84sh3Cn2RnA==
=Ht59
-----END PGP SIGNATURE-----

--cpvLTH7QU4gwfq3S--

