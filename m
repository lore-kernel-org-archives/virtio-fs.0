Date: Thu, 11 Mar 2021 15:55:45 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YEo9gWc/4U+99mTs@stefanha-x1.localdomain>
References: <20210304174536.54446-1-dgilbert@redhat.com>
	<YEZNTFOT2noej13i@stefanha-x1.localdomain>
	<YEowAVzkMBo1oKTU@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="aQ/kJja5OJTSqn/y"
Content-Disposition: inline
In-Reply-To: <YEowAVzkMBo1oKTU@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Don't assume header layout
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, vgoyal@redhat.com


--aQ/kJja5OJTSqn/y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 11, 2021 at 02:58:09PM +0000, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > On Thu, Mar 04, 2021 at 05:45:36PM +0000, Dr. David Alan Gilbert (git) =
wrote:
> > > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > >=20
> > > virtiofsd incorrectly assumed a fixed set of header layout in the virt
> > > queue; assuming that the fuse and write headers were conveniently
> > > separated from the data;  the spec doesn't allow us to take that
> > > convenience, so fix it up to deal with it the hard way.
> > >=20
> > > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > ---
> > >  tools/virtiofsd/fuse_virtio.c | 84 ++++++++++++++++++++++++++-------=
--
> > >  1 file changed, 63 insertions(+), 21 deletions(-)
> > >=20
> > > diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_vir=
tio.c
> > > index 523ee64fb7..55e2e057ec 100644
> > > --- a/tools/virtiofsd/fuse_virtio.c
> > > +++ b/tools/virtiofsd/fuse_virtio.c
> > > @@ -129,18 +129,55 @@ static void fv_panic(VuDev *dev, const char *er=
r)
> > >   * Copy from an iovec into a fuse_buf (memory only)
> > >   * Caller must ensure there is space
> > >   */
> > > -static void copy_from_iov(struct fuse_buf *buf, size_t out_num,
> > > -                          const struct iovec *out_sg)
> > > +static size_t copy_from_iov(struct fuse_buf *buf, size_t out_num,
> > > +                            const struct iovec *out_sg,
> > > +                            size_t max)
> > >  {
> > >      void *dest =3D buf->mem;
> > > +    size_t copied =3D 0;
> > > =20
> > > -    while (out_num) {
> > > +    while (out_num && max) {
> > >          size_t onelen =3D out_sg->iov_len;
> > > +        onelen =3D MIN(onelen, max);
> > >          memcpy(dest, out_sg->iov_base, onelen);
> > >          dest +=3D onelen;
> > > +        copied +=3D onelen;
> > >          out_sg++;
> > >          out_num--;
> > > +        max -=3D onelen;
> > >      }
> > > +
> > > +    return copied;
> > > +}
> > > +
> > > +/*
> > > + * Skip 'skip' bytes in the iov; 'sg_1stindex' is set as
> > > + * the index for the 1st iovec to read data from, and
> > > + * 'sg_1stskip' is the number of bytes to skip in that entry.
> > > + *
> > > + * Returns True if there are at least 'skip' bytes in the iovec
> > > + *
> > > + */
> > > +static bool skip_iov(const struct iovec *sg, size_t sg_size,
> > > +                     size_t skip,
> > > +                     size_t *sg_1stindex, size_t *sg_1stskip)
> > > +{
> > > +    size_t vec;
> > > +
> > > +    for (vec =3D 0; vec < sg_size; vec++) {
> > > +        if (sg[vec].iov_len > skip) {
> > > +            *sg_1stskip =3D skip;
> > > +            *sg_1stindex =3D vec;
> > > +
> > > +            return true;
> > > +        }
> > > +
>  (1)         skip -=3D sg[vec].iov_len;
> > > +    }
> > > +
>  (2)     *sg_1stindex =3D vec;
> > > +    *sg_1stskip =3D 0;
>  (3)     return skip =3D=3D 0;
> > >  }
> >=20
> > This comment does not match the code: "Returns True if there are at
> > least 'skip' bytes in the iovec". When skip =3D=3D iov_length(sg, sg_si=
ze)
> > the function returns false.
>=20
> I'm not seeing how; in that case, it'll loop around executing (1) for
> each vector, so skip will reduce, then it falls out of the for loop
> and if it was equal to the size of the vector, (1) would have subtracted
> the whole vector out, so skip would now be 0, hence the 'skip =3D=3D 0' a=
t 2 and
> so it should return true.

You're right. I misread the code!

Stefan

--aQ/kJja5OJTSqn/y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBKPYEACgkQnKSrs4Gr
c8jy0wgAp0SqozlbukRbOmS5v9wqrPOkZWuMHagAufiJrNY83hpa6KmPjJc2zV/H
RGXbxwKZOn4sb/Re6GGNmfmHGmJmKXKQAJmGXjQBb4I1pjg115dIuabGZnAr1NCh
XiNfpZTBjMTWlQ5+reYuX13ve2rWgXcwvyHuU4/2xKU45uMz1DmXzY1VHdyvuiVG
wYgAXr56wbqohA+fzVt8UUuzCVw0K4/QKS5/1JaMCxgd5a6MDaSZx1azRvFhsQ16
JJWN7/M658avDLIfVkGqLKo6WFmGoW3VWbGt7uZAATt+ugNgBHFi/GhCSMwishFW
XJH89ol/DOw0WqJxnKGso0zu6y/ZyQ==
=IKdr
-----END PGP SIGNATURE-----

--aQ/kJja5OJTSqn/y--

