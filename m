Date: Wed, 3 Feb 2021 17:05:14 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210203170514.GL74271@stefanha-x1.localdomain>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-4-stefanha@redhat.com>
	<20210203152850.GA3307@redhat.com>
	<20210203170237.0c98f95f@bahia.lan>
	<20210203160858.GC3307@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zH41lVBEV8cLJnCl"
Content-Disposition: inline
In-Reply-To: <20210203160858.GC3307@redhat.com>
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


--zH41lVBEV8cLJnCl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 03, 2021 at 11:08:58AM -0500, Vivek Goyal wrote:
> On Wed, Feb 03, 2021 at 05:02:37PM +0100, Greg Kurz wrote:
> > On Wed, 3 Feb 2021 10:28:50 -0500
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> >=20
> > > On Wed, Feb 03, 2021 at 11:37:19AM +0000, Stefan Hajnoczi wrote:
> > >=20
> > > [..]
> > > > @@ -1727,36 +1764,38 @@ static void lo_create(fuse_req_t req, fuse_=
ino_t parent, const char *name,
> > > > =20
> > > >      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
> > > > =20
> > > > -    fd =3D openat(parent_inode->fd, name, (fi->flags | O_CREAT) & =
~O_NOFOLLOW,
> > > > -                mode);
> > > > +    /* Try to create a new file but don't open existing files */
> > > > +    fd =3D openat(parent_inode->fd, name, fi->flags | O_CREAT | O_=
EXCL, mode);
> > > >      err =3D fd =3D=3D -1 ? errno : 0;
> > > > +
> > > >      lo_restore_cred(&old);
> > > > =20
> > > > -    if (!err) {
> > > > -        ssize_t fh;
> > > > -
> > > > -        pthread_mutex_lock(&lo->mutex);
> > > > -        fh =3D lo_add_fd_mapping(lo, fd);
> > > > -        pthread_mutex_unlock(&lo->mutex);
> > > > -        if (fh =3D=3D -1) {
> > > > -            close(fd);
> > > > -            err =3D ENOMEM;
> > > > -            goto out;
> > > > -        }
> > > > +    /* Ignore the error if file exists and O_EXCL was not given */
> > > > +    if (err && !(err =3D=3D EEXIST && !(fi->flags & O_EXCL))) {
> > >=20
> > > Can this check be simplified to.
> > >        if (err && (err =3D=3D EEXIST && (fi->flags & O_EXCL)) {
> >=20
> > I guess you meant :
> >=20
> >         if (err && (err !=3D EEXIST || fi->flags & O_EXCL) {
>=20
> This sounds correct. I forgot to take into account that if error is
> not -EEXIST, we still want to bail out irrespective of O_EXCL.

I thought about De Morgan's law too but found the OR expression is not
easier to read than the AND expression :(. If you prefer it written this
way I can change it though.

Stefan

--zH41lVBEV8cLJnCl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAa18oACgkQnKSrs4Gr
c8g1rAf/XJtMnuMThrGmuMVWlc6cAhxTiwwyPYAb+CFiECa2hVjFaoX3paOxWkDG
8PPXQWvUVz1VaCX23CKsvAdX8QNW4RbjUwphBjHnDNkHGviLapu25ZmiNuGplKDx
WUUWMwE5BOujGc0rBnvwEP+H9A3Zvdg7SkMcrly97b3pnLCQ97DSmvCbt9dSPegc
S4CDg9Y04f9RZeL2t8rKW/G7cNM9RRgDjZzm62s58rLk1jVfn8k1qGyjuScwBezt
m/6UKYYV58uSUkbPb8zjXM5F0S1JdJ6RRpG2RW4hfyCg2vmUzAVbQk1IFUaBl/iq
2nEic75Xa+vOtvib6oiFfprvv/QyAg==
=CTe+
-----END PGP SIGNATURE-----

--zH41lVBEV8cLJnCl--

