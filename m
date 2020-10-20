Date: Tue, 20 Oct 2020 10:52:37 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201020095237.GC140014@stefanha-x1.localdomain>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-4-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <20201014180209.49299-4-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 3/5] tools/virtiofsd: xattr name
 mappings: Map server xattr names
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


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2020 at 07:02:07PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Map xattr names coming from the server, i.e. the host filesystem;
> currently this is only from listxattr.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 89 ++++++++++++++++++++++++++++++++
>  1 file changed, 89 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+Os2UACgkQnKSrs4Gr
c8harwf/QbnDmhsN2ddgSULa0eG4vqrBqKHj7Fqj4d+cf4NGQ8Ff/2jC30T6DgcE
ilC/kF/f2xp0PgXxRXro3A6pcYVcoqYpnpmyxeatVfSK0j7IPim/R7hBr27wATdF
0xa2qlPHoxS23e3+BK0M/Mb48jerBHf4lAaun58J4EkxN5GsLw7uI8ySWOKTIQKC
5sQ3zKXadQ0DvEjfZCd1OYaVyTISO7RPoB/bDsGDP6j1CWdbPer717jiv6JwfU6z
hCWD5ord9vyyY1Y6Pg8FoWE+uUJtgCRxoTmLKS0E79eu5DNcVfUHWCPRaND5Hrhc
LiWwR0exq+RsuBB8P1C4+tbrOUY8VA==
=Szjr
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--

