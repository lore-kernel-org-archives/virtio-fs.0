Return-Path: <stefanha@redhat.com>
Date: Thu, 5 Oct 2023 13:46:39 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20231005174639.GH1342722@fedora>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-8-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="8SCwRJLZuG5agDQG"
Content-Disposition: inline
In-Reply-To: <20231004125904.110781-8-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 7/8] vhost: Add high-level state
 save/load functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, German Maglione <gmaglione@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>


--8SCwRJLZuG5agDQG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2023 at 02:59:03PM +0200, Hanna Czenczek wrote:
> vhost_save_backend_state() and vhost_load_backend_state() can be used by
> vhost front-ends to easily save and load the back-end's state to/from
> the migration stream.
>=20
> Because we do not know the full state size ahead of time,
> vhost_save_backend_state() simply reads the data in 1 MB chunks, and
> writes each chunk consecutively into the migration stream, prefixed by
> its length.  EOF is indicated by a 0-length chunk.
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  include/hw/virtio/vhost.h |  35 +++++++
>  hw/virtio/vhost.c         | 204 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 239 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--8SCwRJLZuG5agDQG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUe9n8ACgkQnKSrs4Gr
c8hHRwgAsniNhUQF6fB3+pYk91OUG/cI8VpaQx+w5MzEm7V9JLDFr95NlSEa2AwE
Ujxpk47hsn0XcTvZw24iPuTQCORllr3KZaghJHRh4C9f4HYq99n5CGU3qfSBjcgi
5Bu7h3H0pa9rb2W1hzYHDCquuEVMBMG2Y29VuHRUx3oTpcrWozLe9YiTJnfP5S+P
sqMTLc0HXKmeIOh8pcEA6i7tKkRE/baIjivjE/nIlO13hmdXFMqYitMJNWWlhlOQ
BBdh07Y7LD40a7J0O9+PJsmvkOcaHCjRHjcdkeRviDLkKrBTim6+x5A2JCXTHu4r
W+7G3WTBe5vuFfhkHp2dMispEbYm6A==
=oRVw
-----END PGP SIGNATURE-----

--8SCwRJLZuG5agDQG--
