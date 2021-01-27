Date: Wed, 27 Jan 2021 14:14:30 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210127141430.GA310142@stefanha-x1.localdomain>
References: <20210127112131.308451-1-stefanha@redhat.com>
	<CAOssrKfY7zDOH3NNbtyARHMCdJJN1tKQJri8ec=igjBf=K6Dog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <CAOssrKfY7zDOH3NNbtyARHMCdJJN1tKQJri8ec=igjBf=K6Dog@mail.gmail.com>
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
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Vivek Goyal <vgoyal@redhat.com>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 27, 2021 at 02:01:54PM +0100, Miklos Szeredi wrote:
> On Wed, Jan 27, 2021 at 12:21 PM Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
>               }
> > @@ -1654,9 +1677,11 @@ static void update_open_flags(int writeback, int=
 allow_direct_io,
> >  static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *n=
ame,
> >                        mode_t mode, struct fuse_file_info *fi)
> >  {
> > +    int open_flags =3D (fi->flags | O_CREAT) & ~O_NOFOLLOW;
> >      int fd;
> >      struct lo_data *lo =3D lo_data(req);
> >      struct lo_inode *parent_inode;
> > +    struct lo_inode *existing_inode =3D NULL;
> >      struct fuse_entry_param e;
> >      int err;
> >      struct lo_cred old =3D {};
> > @@ -1682,11 +1707,23 @@ static void lo_create(fuse_req_t req, fuse_ino_=
t parent, const char *name,
> >
> >      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
> >
> > -    fd =3D openat(parent_inode->fd, name, (fi->flags | O_CREAT) & ~O_N=
OFOLLOW,
> > -                mode);
> > +    /* First, try to create a new file but don't open existing files */
> > +    fd =3D openat(parent_inode->fd, name, open_flags | O_EXCL, mode);
> >      err =3D fd =3D=3D -1 ? errno : 0;
> > +
> >      lo_restore_cred(&old);
> >
> > +    /* Second, open existing files if O_EXCL was not specified */
> > +    if (err =3D=3D EEXIST && !(fi->flags & O_EXCL)) {
> > +        existing_inode =3D lookup_name(req, parent, name);
> > +        if (existing_inode) {
> > +            fd =3D lo_inode_open(lo, existing_inode, open_flags);
> > +            if (fd < 0) {
> > +                err =3D -fd;
> > +            }
> > +        }
> > +    }
> > +
> >      if (!err) {
> >          ssize_t fh;
>=20
> It's more of a mess than I thought.
>=20
> The problem here is there can also be a race between the open and the
> subsequent lo_do_lookup().
>=20
> At this point it's probably enough to verify that fuse_entry_param
> refers to the same object as the fh (using fstat and comparing st_dev
> and st_ino).

Can you describe the race in detail? FUSE_CREATE vs FUSE_OPEN?
FUSE_CREATE vs FUSE_CREATE?

> Also O_CREAT open is not supposed to return ENOENT, so failure to open
> without O_CREAT (race between O_CREAT open and plain open) should at
> least translate error to ESTALE or EIO.

Thanks, will fix.

Sstefan

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmARdUUACgkQnKSrs4Gr
c8jciAf9FyW8VXDVqTl3unEErorqJH0YcYolxd4/L14XaZqJUqLKSEHm8DmVFfEM
T3O91pjNUrlqVvkE/UdRkOEufO8KqjKumQjcL+n2iX9GJ5+XgNpkzJc3Nh6obP61
lLU5pt6iYvPXqDJhRwRlVHV+Ib8dmA5/ZbD1aFcUa0s97ylouU4LTZV9ygS3mq36
2PqcxVo6yaw6qYyyJL0KDvPmdvQEEBGI8bFaAVxkYRyc5D2PR3lUmuYTVOno3tk+
FWZM82M6dohhHsXqu7x24ZvUqFEa82hh1+nxJ/Ff3AsmXSxzm4RgVGKlnTBJiT+T
8xdiVadSa/Xb7lnK7VGwf+NiuUuOSA==
=xq0v
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--

