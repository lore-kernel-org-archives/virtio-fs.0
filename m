Date: Wed, 3 Feb 2021 16:57:42 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210203165742.GJ74271@stefanha-x1.localdomain>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-2-stefanha@redhat.com>
	<20210203152035.374924b9@bahia.lan> <20210203144730.GJ2950@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3MMMIZFJzhAsRj/+"
Content-Disposition: inline
In-Reply-To: <20210203144730.GJ2950@work-vm>
Subject: Re: [Virtio-fs] [PATCH v4 1/3] virtiofsd: extract lo_do_open() from
	lo_open()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com


--3MMMIZFJzhAsRj/+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 03, 2021 at 02:47:30PM +0000, Dr. David Alan Gilbert wrote:
> * Greg Kurz (groug@kaod.org) wrote:
> > On Wed,  3 Feb 2021 11:37:17 +0000
> > Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >=20
> > > Both lo_open() and lo_create() have similar code to open a file. Extr=
act
> > > a common lo_do_open() function from lo_open() that will be used by
> > > lo_create() in a later commit.
> > >=20
> > > Since lo_do_open() does not otherwise need fuse_req_t req, convert
> > > lo_add_fd_mapping() to use struct lo_data *lo instead.
> > >=20
> > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > ---
> >=20
> > With the s/ENOMEM/-ENOMEM/ change in lo_do_open() suggested by patchew,
>=20
> Isn't it actually the return -errno that's different from the original?

Yes. It should be return errno since lo_open() expected err =3D 0
(success) or a positive errno.

Will fix.

Stefan

--3MMMIZFJzhAsRj/+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAa1gYACgkQnKSrs4Gr
c8hc2ggAlN00+yDd+ank1WYMzb3Jnjlx+XzbdyK0pDPTy0gk3e8j3qw9qt1ayXDc
kVo5oFPLEgkkT9fsOatZ9Cs0yPwLnLJMKBpqOIqwUwqTXcee4tiUxfMSCRM1KwcR
WZp1FPBAGd3w7Bx1UUQjtoW5joVw/lC60eX/ajJr1taOeG0yJ4EA+ZxK4mFmVSKv
PhQ5VnabPJQiyYrL6ThRfc2GMRhkKFGq6Lu+VcrlStuzEeYmP6FaJUO8MTbGTsKa
oWkFzIv+5V7Be0+IFVJoeJRwBrf1+0MSyOHaxRz0R0jKDGQLboztjt4wVZ6E0Tga
rJe/EQ+yCggA33mH7uz0K71ceHG1Rg==
=KVQk
-----END PGP SIGNATURE-----

--3MMMIZFJzhAsRj/+--

