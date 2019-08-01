Date: Thu, 1 Aug 2019 10:07:38 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190801090738.GA15179@stefanha-x1.localdomain>
References: <20190726091103.23503-1-stefanha@redhat.com>
	<20190726091103.23503-5-stefanha@redhat.com>
	<20190731172716.GK3203@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20190731172716.GK3203@work-vm>
Subject: Re: [Virtio-fs] [PATCH 4/5] virtiofsd: drop lo_dirp->fd field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2019 at 06:27:16PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > fdopendir(3) takes ownership of the file descriptor.  The presence of
> > the lo_dirp->fd field could lead to someone incorrectly adding a
> > close(d->fd) cleanup call in the future.
> >=20
> > Do not store the file descriptor in struct lo_dirp since it is unused.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>=20
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>=20
>=20
> Thanks, applied; note:
>   a) This looks like it can go into upstream libfuse
>   b) I think we're probably leaking DIR *'s if we do an lo_shutdown;
> I've added that to my todo

FUSE_DESTROY is current broken, it leaks resources and is not
thread-safe.  It's something I'll tackle in multithreading preparation
part 3.

Stefan

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1Cq8AACgkQnKSrs4Gr
c8grRQf+LLnWRgrw2EwmjFKKptITHvEbhARQ4I7CDX5Zt5GONfH4qg9rG23XHM90
X/Nv4RLb+jYQfvtVtIz4ZSFm8gN+GosioguRp1rMQD07eQ8xyVAoShUfFTixeiKi
YN2+fyHBYpbCziWr60RRVkimdDnI6sqjSqT0pdf7mYuv+CRX+0rxdPh3DRBYv3x8
nU6cokgfSruGC1KAtyGvui5U2uRAHogmStHCCF90UCbJy73tQ4pld4zcoRcAWD6V
OMOa/NrWW27jz4eqygDt+QRlWHkX8Rxv+viN+0jII4gIc581EXu3IsszRitz2kqr
yyk8a7HE0ViTfdbc+qb6VwbpwTbO5g==
=qQqT
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--

