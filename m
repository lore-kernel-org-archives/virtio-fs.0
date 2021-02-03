Date: Wed, 3 Feb 2021 17:06:32 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210203170632.GM74271@stefanha-x1.localdomain>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-4-stefanha@redhat.com>
	<20210203165759.352a7f64@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="iUV/lbBrmPtUT9dM"
Content-Disposition: inline
In-Reply-To: <20210203165759.352a7f64@bahia.lan>
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
To: Greg Kurz <groug@kaod.org>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com


--iUV/lbBrmPtUT9dM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 03, 2021 at 04:57:59PM +0100, Greg Kurz wrote:
> On Wed,  3 Feb 2021 11:37:19 +0000
> Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >  static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
> > -                      struct fuse_file_info *fi)
> > +                      int existing_fd, struct fuse_file_info *fi)
> >  {
> > -    char buf[64];
> >      ssize_t fh;
> > -    int fd;
> > +    int fd =3D existing_fd;
> > =20
> >      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
> > =20
> > -    sprintf(buf, "%i", inode->fd);
> > -    fd =3D openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
> > -    if (fd =3D=3D -1) {
> > -        return -errno;
> > +    if (fd < 0) {
> > +        fd =3D lo_inode_open(lo, inode, fi->flags);
> > +        if (fd =3D=3D -1) {
> > +            return -errno;
> > +        }
>=20
> lo_inode_open() returns a negative errno already so
> this should be converted to:
>=20
>         if (fd < 0) {
>             return fd;
>         }
>=20
> Apart from that LGTM.

Thanks, will fix.

Stefan

--iUV/lbBrmPtUT9dM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAa2BgACgkQnKSrs4Gr
c8jx4wf/UmitQcttkvQqMMvvVqX6f1n6h+BSvp2oyj7q59GXztl4/vOtC662vAFG
/1KSIn0BsNFbTx0Jy2P1AoRB/RpMVhCSMgOfI+taE8wZlCATBZZLWCKfVrlJgPm7
g7DrrypucyipQSDrnHwYFp/caoaGlvBPHOzDaFZqbh2eXsrlZxGNPjFqm8FMxvfL
9U1Id0ieWMHKW6kBB+7+n6+B+mTfbcphgb/XgTXCT198mD7L4biDbpoyN97f/xtK
4HCTYlDoBoDQim9HEBz7Bhrk+eQ22UTKS6VIcF8m9TLL9gBj7NbS8xYqHYLse0nT
xsKh9Y+y7Vsew2+XLlKp2RC0co7U/A==
=SM32
-----END PGP SIGNATURE-----

--iUV/lbBrmPtUT9dM--

