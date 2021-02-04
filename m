Date: Thu, 4 Feb 2021 09:47:34 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210204094734.GC344659@stefanha-x1.localdomain>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-4-stefanha@redhat.com>
	<20210203152850.GA3307@redhat.com>
	<20210203170237.0c98f95f@bahia.lan>
	<20210203160858.GC3307@redhat.com>
	<20210203170514.GL74271@stefanha-x1.localdomain>
	<20210203211441.GH3307@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <20210203211441.GH3307@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 3/3] virtiofsd: prevent opening of
 special files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 03, 2021 at 04:14:41PM -0500, Vivek Goyal wrote:
> On Wed, Feb 03, 2021 at 05:05:14PM +0000, Stefan Hajnoczi wrote:
> > On Wed, Feb 03, 2021 at 11:08:58AM -0500, Vivek Goyal wrote:
> > > On Wed, Feb 03, 2021 at 05:02:37PM +0100, Greg Kurz wrote:
> > > > On Wed, 3 Feb 2021 10:28:50 -0500
> > > > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >=20
> > > > > On Wed, Feb 03, 2021 at 11:37:19AM +0000, Stefan Hajnoczi wrote:
> > > > >=20
> > > > > [..]
> > > > > > @@ -1727,36 +1764,38 @@ static void lo_create(fuse_req_t req, f=
use_ino_t parent, const char *name,
> > > > > > =20
> > > > > >      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
> > > > > > =20
> > > > > > -    fd =3D openat(parent_inode->fd, name, (fi->flags | O_CREAT=
) & ~O_NOFOLLOW,
> > > > > > -                mode);
> > > > > > +    /* Try to create a new file but don't open existing files =
*/
> > > > > > +    fd =3D openat(parent_inode->fd, name, fi->flags | O_CREAT =
| O_EXCL, mode);
> > > > > >      err =3D fd =3D=3D -1 ? errno : 0;
> > > > > > +
> > > > > >      lo_restore_cred(&old);
> > > > > > =20
> > > > > > -    if (!err) {
> > > > > > -        ssize_t fh;
> > > > > > -
> > > > > > -        pthread_mutex_lock(&lo->mutex);
> > > > > > -        fh =3D lo_add_fd_mapping(lo, fd);
> > > > > > -        pthread_mutex_unlock(&lo->mutex);
> > > > > > -        if (fh =3D=3D -1) {
> > > > > > -            close(fd);
> > > > > > -            err =3D ENOMEM;
> > > > > > -            goto out;
> > > > > > -        }
> > > > > > +    /* Ignore the error if file exists and O_EXCL was not give=
n */
> > > > > > +    if (err && !(err =3D=3D EEXIST && !(fi->flags & O_EXCL))) {
> > > > >=20
> > > > > Can this check be simplified to.
> > > > >        if (err && (err =3D=3D EEXIST && (fi->flags & O_EXCL)) {
> > > >=20
> > > > I guess you meant :
> > > >=20
> > > >         if (err && (err !=3D EEXIST || fi->flags & O_EXCL) {
> > >=20
> > > This sounds correct. I forgot to take into account that if error is
> > > not -EEXIST, we still want to bail out irrespective of O_EXCL.
> >=20
> > I thought about De Morgan's law too but found the OR expression is not
> > easier to read than the AND expression :(. If you prefer it written this
> > way I can change it though.
>=20
> I personally find this one to read. And not because of AND but because
> of double logical negation (!x) in previous expression.
>=20
> But I am not particular about it. If you don't find it easier to
> read, I can live with previous one.

Okay, I'll convert it. Dave also mentioned he finds the AND version
strange.

Stefan

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAbwrYACgkQnKSrs4Gr
c8gfPggAyGK+i7L+A4oau0a74aVdaHkMYqvj5dQcZmO18mqU3e/p0tZ8rm27Qn+g
BSEQmIltXXTPcem0wc1rIWRmZpb50JgMN/VvmUIGUtCyGtOTzJgmjRNnHpgErZFC
I7PwN14ahmEe2kTAzJUlwbnAgim8Fnzf+IwqYfIld1uHJd97l2dimtesEN6O4dMY
klb1tb6h9RegnmiljxfiB5NbaGpM2UtIZ5saVWTRuupZ8zvrLDwDsT5lG7NZmOZO
JIkQJ79OPqLwh3Igq7JvS3PIMgT6E+fQOfKjju/3QBneEao6u84Bvql37brOrHrB
/X1ZbRUHj0vTMlbc4SdBHqdrkNm47A==
=NKQZ
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--

