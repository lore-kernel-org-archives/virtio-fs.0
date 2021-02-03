Date: Wed, 3 Feb 2021 17:00:06 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210203170006.GK74271@stefanha-x1.localdomain>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-3-stefanha@redhat.com>
	<20210203152014.443a8b29@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GmiNL4+5WUWrod5m"
Content-Disposition: inline
In-Reply-To: <20210203152014.443a8b29@bahia.lan>
Subject: Re: [Virtio-fs] [PATCH v4 2/3] virtiofsd: optionally return inode
 pointer from lo_do_lookup()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com


--GmiNL4+5WUWrod5m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 03, 2021 at 03:20:14PM +0100, Greg Kurz wrote:
> On Wed,  3 Feb 2021 11:37:18 +0000
> Stefan Hajnoczi <stefanha@redhat.com> wrote:
>=20
> > lo_do_lookup() finds an existing inode or allocates a new one. It
> > increments nlookup so that the inode stays alive until the client
> > releases it.
> >=20
> > Existing callers don't need the struct lo_inode so the function doesn't
> > return it. Extend the function to optionally return the inode. The next
> > commit will need it.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 29 +++++++++++++++++++++--------
> >  1 file changed, 21 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthr=
ough_ll.c
> > index e63cbd3fb7..c87a1f3d72 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -831,11 +831,13 @@ static int do_statx(struct lo_data *lo, int dirfd=
, const char *pathname,
> >  }
> > =20
> >  /*
> > - * Increments nlookup and caller must release refcount using
> > - * lo_inode_put(&parent).
> > + * Increments nlookup on the inode on success. unref_inode_lolocked() =
must be
> > + * called eventually to decrement nlookup again. If inodep is non-NULL=
, the
> > + * inode pointer is stored and the caller must call lo_inode_put().
> >   */
> >  static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char =
*name,
> > -                        struct fuse_entry_param *e)
> > +                        struct fuse_entry_param *e,
> > +                        struct lo_inode **inodep)
> >  {
> >      int newfd;
> >      int res;
> > @@ -845,6 +847,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t=
 parent, const char *name,
> >      struct lo_inode *inode =3D NULL;
> >      struct lo_inode *dir =3D lo_inode(req, parent);
> > =20
> > +    if (inodep) {
> > +        *inodep =3D NULL;
> > +    }
> > +
>=20
> Is this side-effect needed ? If lo_do_lookup() returns an error, it
> rather seems that the caller shouldn't expect anything to be written
> here, i.e. the content of *inodep still belongs to the caller and
> whatever value it previously put in there (as patch 3/3 does) should
> be preserved IMHO.
>=20
> Apart from that LGTM.

I like this approach because it prevents accessing uninitialized memory
in the caller:

  struct lo_inode *inode;

  if (lo_do_lookup(..., &inodep) !=3D 0) {
    goto err;
  }
  ...

  err:
  lo_inode_put(&inode); <-- uninitialized in the error case!

--GmiNL4+5WUWrod5m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAa1pYACgkQnKSrs4Gr
c8jP2wf/Tu5nMtwBnFs0/I4vcUvXpTOtYx4f2JQU29z8RnrO9a3PEuD2hzjqSTtV
VTuBV8LIvnrKMV34HPiDgydHE3C7q1aTiBTrIsNH+/TW8W9RJmHrd8ntp9iQmY3k
ioNADcxAdnwmF8dBxwoUI5DIc8Wgdv0pI65R0PPhlUOgPr67qBgTDySJ4nyM5u3R
+1P8dxXiD3TBoKrSWp5WPvHN/lJM7wuh1b00FNB+mGZiG0bRN+nkK8kL4OkOA4Qv
pFewMug12MW2Akh+8EA/BWKqxqE7rND7UiADoj2a6kFAd4M1sWsz7WhpfbHTd+vd
imsyYX5K9A6BQqwphB1RtTMcEkGv5g==
=X3iH
-----END PGP SIGNATURE-----

--GmiNL4+5WUWrod5m--

