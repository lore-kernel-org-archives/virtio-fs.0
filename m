Date: Tue, 20 Oct 2020 10:16:31 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201020091631.GB140014@stefanha-x1.localdomain>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-3-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <20201014180209.49299-3-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 2/5] tools/virtiofsd: xattr name
 mappings: Map client xattr names
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


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2020 at 07:02:06PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Map xattr names originating at the client; from get/set/remove xattr.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 101 ++++++++++++++++++++++++++++++-
>  1 file changed, 98 insertions(+), 3 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+Oqu8ACgkQnKSrs4Gr
c8hBwgf/a0FFCSCOuxxNg2bEstqHWmkIfIofDiLSh4sFr5JwZeRTeLTYAmBgheMF
JCnbRPkjbX7ympTqzH5g0dttGUcs7X/W2YBykVykhmitIJzglQua+I57fWmaYJbY
OcmNupFz+4IZmnvIWTQbrdCcsSZGYuTwCgt4jPOZUueM5OxYTShbHuxA67lFn/D4
IZRryWx8B638+OyW4wKQDMLqm/eppRKjR2U7z2ECcZplDkhN6p+SuqtzfcrxD1m7
6/arUGwnFAMtz11vKoqds7oBpt7xN/o4492iLyX/S89XdzxW5t1FnfHKAoAfF0A9
NaFagklDrOaUpOeF5Ddb9h/NMkmsvQ==
=TvIR
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--

