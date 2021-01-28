Date: Thu, 28 Jan 2021 16:11:24 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210128161124.GB20377@stefanha-x1.localdomain>
References: <20210127112131.308451-1-stefanha@redhat.com>
	<CAOssrKfY7zDOH3NNbtyARHMCdJJN1tKQJri8ec=igjBf=K6Dog@mail.gmail.com>
	<20210127141430.GA310142@stefanha-x1.localdomain>
	<20210127162332.272e5a95@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <20210127162332.272e5a95@bahia.lan>
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: prevent opening of special
 files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Daniel Berrange <berrange@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Vivek Goyal <vgoyal@redhat.com>


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 27, 2021 at 04:23:32PM +0100, Greg Kurz wrote:
> On Wed, 27 Jan 2021 14:14:30 +0000
> Stefan Hajnoczi <stefanha@redhat.com> wrote:
>=20
> > On Wed, Jan 27, 2021 at 02:01:54PM +0100, Miklos Szeredi wrote:
> > > On Wed, Jan 27, 2021 at 12:21 PM Stefan Hajnoczi <stefanha@redhat.com=
> wrote:
> > >               }
> > > > @@ -1654,9 +1677,11 @@ static void update_open_flags(int writeback,=
 int allow_direct_io,
> > > >  static void lo_create(fuse_req_t req, fuse_ino_t parent, const cha=
r *name,
> > > >                        mode_t mode, struct fuse_file_info *fi)
> > > >  {
> > > > +    int open_flags =3D (fi->flags | O_CREAT) & ~O_NOFOLLOW;
> > > >      int fd;
> > > >      struct lo_data *lo =3D lo_data(req);
> > > >      struct lo_inode *parent_inode;
> > > > +    struct lo_inode *existing_inode =3D NULL;
> > > >      struct fuse_entry_param e;
> > > >      int err;
> > > >      struct lo_cred old =3D {};
> > > > @@ -1682,11 +1707,23 @@ static void lo_create(fuse_req_t req, fuse_=
ino_t parent, const char *name,
> > > >
> > > >      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
> > > >
> > > > -    fd =3D openat(parent_inode->fd, name, (fi->flags | O_CREAT) & =
~O_NOFOLLOW,
> > > > -                mode);
> > > > +    /* First, try to create a new file but don't open existing fil=
es */
> > > > +    fd =3D openat(parent_inode->fd, name, open_flags | O_EXCL, mod=
e);
> > > >      err =3D fd =3D=3D -1 ? errno : 0;
> > > > +
> > > >      lo_restore_cred(&old);
> > > >
> > > > +    /* Second, open existing files if O_EXCL was not specified */
> > > > +    if (err =3D=3D EEXIST && !(fi->flags & O_EXCL)) {
> > > > +        existing_inode =3D lookup_name(req, parent, name);
> > > > +        if (existing_inode) {
> > > > +            fd =3D lo_inode_open(lo, existing_inode, open_flags);
> > > > +            if (fd < 0) {
> > > > +                err =3D -fd;
> > > > +            }
> > > > +        }
> > > > +    }
> > > > +
> > > >      if (!err) {
> > > >          ssize_t fh;
> > >=20
> > > It's more of a mess than I thought.
> > >=20
> > > The problem here is there can also be a race between the open and the
> > > subsequent lo_do_lookup().
> > >=20
> > > At this point it's probably enough to verify that fuse_entry_param
> > > refers to the same object as the fh (using fstat and comparing st_dev
> > > and st_ino).
> >=20
> > Can you describe the race in detail? FUSE_CREATE vs FUSE_OPEN?
> > FUSE_CREATE vs FUSE_CREATE?
> >=20
> > > Also O_CREAT open is not supposed to return ENOENT, so failure to open
> > > without O_CREAT (race between O_CREAT open and plain open) should at
> > > least translate error to ESTALE or EIO.
> >=20
> > Thanks, will fix.
> >=20
>=20
> Please wait, as explained in another mail, ENOENT can happen with
> O_CREAT and guest userspace should be ready to handle it.

Thanks, I have now read the discussion between Miklos and yourself on
the previous revision. You showed an interesting O_CREAT case where
ENOENT does occur.

The O_NOFOLLOW issue is worth fixing but it's not directly related to
this CVE so it can be done in a separate patch.

Miklos, Greg: Any other topics to discuss regarding this patch or shall
we merge it?

Stefan

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAS4isACgkQnKSrs4Gr
c8i6yggApFSRgn1s8X4QjQIeBky4aqh2jScSu7YIGC0yTrq0sRJtxAei9l5N00Er
9wrsiWJwss2wIVZjW096Lss1OduGtrEfbp3RHL5PeDmYVzyN9ot+BS6x/LqPv1KY
Nk+O2vUAMHoAjFuIxJ4oXPg/erRwThbBgaUPrk1ktugNd1hLfxCEGT1rbfpeFiFv
zvR0QtbNlhPI3n0Ltgx0LrDMtOOFs6ndHgred5knuGZmznBp7kneqMSX4DDWbTPg
Ti3aFOlT8zxNueN4sLJhaOlS2PIeYxmco/6FkU6t1zmeEcwN3Jcgtr3FnDdxlYYz
XrNtfHQEqK3KTMt6nzihww7xtrtCwg==
=MR4L
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--

