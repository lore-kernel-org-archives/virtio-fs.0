Date: Wed, 29 Apr 2020 16:26:59 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200429152659.GA134868@stefanha-x1.localdomain>
References: <20200429124733.22488-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20200429124733.22488-1-mszeredi@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: jail lo->proc_self_fd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2020 at 02:47:33PM +0200, Miklos Szeredi wrote:
> While it's not possible to escape the proc filesystem through
> lo->proc_self_fd, it is possible to escape to the root of the proc
> filesystem itself through "../..".
>=20
> Use a temporary mount for opening lo->proc_self_fd, that has it's root at
> /proc/self/fd/, preventing access to the ancestor directories.
>=20
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)

Good idea!

It's important to note that the proc file system is already mounted
within a new pid namespace.  Therefore the only process visible is our
own process and we don't need to worry about /proc/$PID.  However, there
are a bunch of other files in /proc.  Some of them are protected by
capability checks like /proc/kcore and virtiofsd is unable to access
them, but it's hard to guarantee that they are all off limits.  Better
safe than sorry!

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6pnMMACgkQnKSrs4Gr
c8gVhAf9HxQ28zYG8KXMDIkOoF+8g4feaj3fdMjwcC9JV56+AJ7oKPJo+hMFqarF
UR41YIMTHhbojaSjnlWLWL0rUIrBre+YlQft1tzpc4B7BXuVrqbZgVwuhztVjs2R
Cpjc/9SiB/nBslL6USs18A46x3pI40XQYCDlgZ0P6aC7vtCLkGEcjYNa630rvZhQ
KqZpMPu4e2Xvl/iEo0oeExr2xmRJnrI1ECjL+pRS02HZpWoNRYB2K0JT+AQnvwsT
Lcoe0y9UXciq/UvvpL8ZtAkNoheK//PG8zx/HxCE9LO9O4z9/fdwjQuK5by1kV9o
Fpwybg8jn/dUP8JxX2ceXK64wDDQyg==
=S+XI
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--

