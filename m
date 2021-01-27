Date: Wed, 27 Jan 2021 16:23:32 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210127162332.272e5a95@bahia.lan>
In-Reply-To: <20210127141430.GA310142@stefanha-x1.localdomain>
References: <20210127112131.308451-1-stefanha@redhat.com>
	<CAOssrKfY7zDOH3NNbtyARHMCdJJN1tKQJri8ec=igjBf=K6Dog@mail.gmail.com>
	<20210127141430.GA310142@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/HxQ/_/v7VufMnR3yXz6fS.6";
	protocol="application/pgp-signature"; micalg=pgp-sha256
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

--Sig_/HxQ/_/v7VufMnR3yXz6fS.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jan 2021 14:14:30 +0000
Stefan Hajnoczi <stefanha@redhat.com> wrote:

> On Wed, Jan 27, 2021 at 02:01:54PM +0100, Miklos Szeredi wrote:
> > On Wed, Jan 27, 2021 at 12:21 PM Stefan Hajnoczi <stefanha@redhat.com> =
wrote:
> >               }
> > > @@ -1654,9 +1677,11 @@ static void update_open_flags(int writeback, i=
nt allow_direct_io,
> > >  static void lo_create(fuse_req_t req, fuse_ino_t parent, const char =
*name,
> > >                        mode_t mode, struct fuse_file_info *fi)
> > >  {
> > > +    int open_flags =3D (fi->flags | O_CREAT) & ~O_NOFOLLOW;
> > >      int fd;
> > >      struct lo_data *lo =3D lo_data(req);
> > >      struct lo_inode *parent_inode;
> > > +    struct lo_inode *existing_inode =3D NULL;
> > >      struct fuse_entry_param e;
> > >      int err;
> > >      struct lo_cred old =3D {};
> > > @@ -1682,11 +1707,23 @@ static void lo_create(fuse_req_t req, fuse_in=
o_t parent, const char *name,
> > >
> > >      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
> > >
> > > -    fd =3D openat(parent_inode->fd, name, (fi->flags | O_CREAT) & ~O=
_NOFOLLOW,
> > > -                mode);
> > > +    /* First, try to create a new file but don't open existing files=
 */
> > > +    fd =3D openat(parent_inode->fd, name, open_flags | O_EXCL, mode)=
;
> > >      err =3D fd =3D=3D -1 ? errno : 0;
> > > +
> > >      lo_restore_cred(&old);
> > >
> > > +    /* Second, open existing files if O_EXCL was not specified */
> > > +    if (err =3D=3D EEXIST && !(fi->flags & O_EXCL)) {
> > > +        existing_inode =3D lookup_name(req, parent, name);
> > > +        if (existing_inode) {
> > > +            fd =3D lo_inode_open(lo, existing_inode, open_flags);
> > > +            if (fd < 0) {
> > > +                err =3D -fd;
> > > +            }
> > > +        }
> > > +    }
> > > +
> > >      if (!err) {
> > >          ssize_t fh;
> >=20
> > It's more of a mess than I thought.
> >=20
> > The problem here is there can also be a race between the open and the
> > subsequent lo_do_lookup().
> >=20
> > At this point it's probably enough to verify that fuse_entry_param
> > refers to the same object as the fh (using fstat and comparing st_dev
> > and st_ino).
>=20
> Can you describe the race in detail? FUSE_CREATE vs FUSE_OPEN?
> FUSE_CREATE vs FUSE_CREATE?
>=20
> > Also O_CREAT open is not supposed to return ENOENT, so failure to open
> > without O_CREAT (race between O_CREAT open and plain open) should at
> > least translate error to ESTALE or EIO.
>=20
> Thanks, will fix.
>=20

Please wait, as explained in another mail, ENOENT can happen with
O_CREAT and guest userspace should be ready to handle it.

> Sstefan


--Sig_/HxQ/_/v7VufMnR3yXz6fS.6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtIKLr5QxQM7yo0kQcdTV5YIvc9YFAmARhXUACgkQcdTV5YIv
c9akYRAAlybyFVdX0KgMb7bbqFLOfJ/NeuaF5WXAOvhaf/n7jY2SjWyUOIrckJIm
9twEGK4PKlOXeCIHn8471uUdKoynPbbsiq7CiW//rXfE7FToV9zLa8PjFzh+mbd7
x1mEg3dkBn7eVyTypeALlOHEbAVlpaaUnw2b+rPi8bW/DJNlhuikfHkTRcs/DyGi
RgyAcoYXt09fYDAX0svYb9pigBZD+ihq3fN2wLfqqu+3YR95nu5KOvnl9o7n07B5
0IXGRMCkrMRd6b4CUtEsDj4ltVItfGbGvUCb5rbKwQ/E7cq9pG57IercheLLe1qa
syoQLQYOo24bLLyX/sG5nr1Vx30pB7xuf5lpkDoCdbu9zXpekiXf+2kvvm0r3Fvo
Vy4DP0SpgCRzlpmUJXnwVYlCwh9XCkABT5CYWFonMSpZyEbo27A966bAhPFMvrao
PHQg39O/VAO5W8dw8BzjXk26nS3kQRdwCnj2Uc0uzzYRxZck+tNTc2STetjOcZ3q
4MkogchGdBGiREsjnwfYPYhtHjzUFqp2A6BnQKvGGZy0B9KVPYJPe51LhJjGk1hl
VbVWXbanGr/rNlB53b/Z/Nn0bXR5xx3uAJWjQECyg04JaXmYDl/Rm8s1Y3yhXObe
AvqTohVX8Lh+XF+qGRKFlKSJ0PA+FC2rIHiuNKhTFgRvsJRiwyY=
=xMQq
-----END PGP SIGNATURE-----

--Sig_/HxQ/_/v7VufMnR3yXz6fS.6--

