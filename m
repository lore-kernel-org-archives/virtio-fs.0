Date: Thu, 1 Aug 2019 10:15:27 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190801091527.GB15179@stefanha-x1.localdomain>
References: <20190726091103.23503-1-stefanha@redhat.com>
	<20190726091103.23503-6-stefanha@redhat.com>
	<20190731174452.GL3203@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <20190731174452.GL3203@work-vm>
Subject: Re: [Virtio-fs] [PATCH 5/5] virtiofsd: prevent races with
	lo_dirp_put()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2019 at 06:44:52PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > Introduce lo_dirp_put() so that FUSE_RELEASEDIR does not cause
> > use-after-free races with other threads that are accessing lo_dirp.
> >=20
> > Also make lo_releasedir() atomic to prevent FUSE_RELEASEDIR racing with
> > itself.  This prevents double-frees.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  contrib/virtiofsd/passthrough_ll.c | 42 +++++++++++++++++++++++++-----
> >  1 file changed, 36 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/pas=
sthrough_ll.c
> > index ad3abdd532..f74e7d2d21 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -1293,11 +1293,28 @@ static void lo_readlink(fuse_req_t req, fuse_in=
o_t ino)
> >  }
> > =20
> >  struct lo_dirp {
> > +	gint refcount;
> >  	DIR *dp;
> >  	struct dirent *entry;
> >  	off_t offset;
> >  };
> > =20
> > +static void lo_dirp_put(struct lo_dirp **dp)
> > +{
> > +	struct lo_dirp *d =3D *dp;
> > +
> > +	if (!d) {
> > +		return;
> > +	}
> > +	*dp =3D NULL;
> > +
> > +	if (g_atomic_int_dec_and_test(&d->refcount)) {
> > +		closedir(d->dp);
> > +		free(d);
> > +	}
> > +}
> > +
> > +/* Call lo_dirp_put() on the return value when no longer needed */
> >  static struct lo_dirp *lo_dirp(fuse_req_t req, struct fuse_file_info *=
fi)
> >  {
> >  	struct lo_data *lo =3D lo_data(req);
> > @@ -1305,6 +1322,9 @@ static struct lo_dirp *lo_dirp(fuse_req_t req, st=
ruct fuse_file_info *fi)
> > =20
> >  	pthread_mutex_lock(&lo->mutex);
> >  	elem =3D lo_map_get(&lo->dirp_map, fi->fh);
> > +	if (elem) {
> > +		g_atomic_int_inc(&elem->dirp->refcount);
>=20
> I don't understand what protects against reading the elem->dirp
> here at the same time it's free'd by lo_releasedir's call to lo_dirp_put

It is lo->mutex and not the refcount that prevents the race with
lo_releasedir().  Two cases:

1. lo_releasedir() runs before lo_dirp().  lo_map_get() returns NULL and
   lo_dirp() fails.

2. lo_releasedir() runs after lo_dirp().  lo_map_get() succeeds and the
   lo_dirp() caller keeps the object alive until lo_dirp_put(), when we
   finally free it.

There is no third case since lo->mutex ensures that lo_releasedir() and
lo_dirp() are serialized in the dirp_map lookup.

> > +	}
> >  	pthread_mutex_unlock(&lo->mutex);
> >  	if (!elem)
> >  		return NULL;
> > @@ -1335,6 +1355,8 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t=
 ino, struct fuse_file_info *fi
> >  	d->offset =3D 0;
> >  	d->entry =3D NULL;
> > =20
> > +	g_atomic_int_set(&d->refcount, 1); /* paired with lo_releasedir() */
> > +
> >  	fh =3D lo_add_dirp_mapping(req, d);
> >  	if (fh =3D=3D -1)
> >  		goto out_err;
> > @@ -1363,7 +1385,7 @@ static void lo_do_readdir(fuse_req_t req, fuse_in=
o_t ino, size_t size,
> >  			  off_t offset, struct fuse_file_info *fi, int plus)
> >  {
> >  	struct lo_data *lo =3D lo_data(req);
> > -	struct lo_dirp *d;
> > +	struct lo_dirp *d =3D NULL;
> >  	struct lo_inode *dinode;
> >  	char *buf =3D NULL;
> >  	char *p;
> > @@ -1451,6 +1473,8 @@ static void lo_do_readdir(fuse_req_t req, fuse_in=
o_t ino, size_t size,
> > =20
> >      err =3D 0;
> >  error:
> > +    lo_dirp_put(&d);
> > +
> >      // If there's an error, we can only signal it if we haven't stored
> >      // any entries yet - otherwise we'd end up with wrong lookup
> >      // counts for the entries that are already in the buffer. So we
> > @@ -1477,22 +1501,25 @@ static void lo_readdirplus(fuse_req_t req, fuse=
_ino_t ino, size_t size,
> >  static void lo_releasedir(fuse_req_t req, fuse_ino_t ino, struct fuse_=
file_info *fi)
> >  {
> >  	struct lo_data *lo =3D lo_data(req);
> > +	struct lo_map_elem *elem;
> >  	struct lo_dirp *d;
> > =20
> >  	(void) ino;
> > =20
> > -	d =3D lo_dirp(req, fi);
> > -	if (!d) {
> > +	pthread_mutex_lock(&lo->mutex);
> > +	elem =3D lo_map_get(&lo->dirp_map, fi->fh);
> > +	if (!elem) {
> > +		pthread_mutex_unlock(&lo->mutex);
> >  		fuse_reply_err(req, EBADF);
> >  		return;
> >  	}
> > =20
> > -	pthread_mutex_lock(&lo->mutex);
> > +	d =3D elem->dirp;
> >  	lo_map_remove(&lo->dirp_map, fi->fh);
> >  	pthread_mutex_unlock(&lo->mutex);
> > =20
> > -	closedir(d->dp);
> > -	free(d);
> > +	lo_dirp_put(&d); /* paired with lo_opendir() */
>=20
> Is the &d really what's intended? That's the local stack variable, so
> lo_dirp_put will set that local to NULL rather than the elem->dirp wont
> it?

Yes, the put(&ptr) pattern prevents user-after-free in the caller.  It's
slightly safer than put(ptr) since that leaves ptr initialized and the
caller might access it later by accident.

elem has already been returned to the freelist by lo_map_remove() and we
must not touch it anymore.

Stefan

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1Cra8ACgkQnKSrs4Gr
c8juYAgAvTx8ZYZ0Ze+4kmCyfBVgxQDFjjPk3gFGHe+1EcINGPD+Wrl7HmSxiw8r
eOuPILjhN/j9RdOhK6xCI+NO/jL0dPoLMmgvpjcNz6AFEvPcUPD6LZoStYmu/LJs
abKnUxv935GVQH/kSaVfa3+cyC/FChsLchrgezklmvXOHfRBc6Qt56GRHRymDbC2
eaYGyPZxU68KVDupECtNF+c033ZcJiwiNXD3bbFSCosWT1CdQsjfKFL70dnwTkps
0oMgA2DscQ2uR9X1njn97TvdojO1/d9cK7jRHZW3NdTHrDf43XcneKe3J6KSXaXw
Th1wM12NFVcSA8NwJasod6dVthtD5A==
=Xmwe
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--

