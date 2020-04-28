Date: Tue, 28 Apr 2020 15:51:43 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200428145143.GB107541@stefanha-x1.localdomain>
References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <20200427175902.GM2923@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Max Reitz <mreitz@redhat.com>


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2020 at 06:59:02PM +0100, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
> > Currently, setup_mounts() bind-mounts the shared directory without
> > MS_REC.  This makes all submounts disappear.
> >=20
> > Pass MS_REC so that the guest can see submounts again.
>=20
> Thanks!
>=20
> > Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
>=20
> Should this actually be 5baa3b8e95064c2434bd9e2f312edd5e9ae275dc ?
>=20
> > Signed-off-by: Max Reitz <mreitz@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthr=
ough_ll.c
> > index 4c35c95b25..9d7f863e66 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)
> >      int oldroot;
> >      int newroot;
> > =20
> > -    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
> > +    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
> >          fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", source,=
 source);
> >          exit(1);
> >      }
>=20
> Do we want MS_SLAVE to pick up future mounts that might happenf rom the
> host?

There are two separate concepts:

1. Mount namespaces.  The virtiofsd process is sandboxed and lives in
   its own mount namespace.  Therefore it does not share the mounts that
   the rest of the host system sees.

2. Propagation type.  This is related to bind mounts so that mount
   operations that happen in one bind-mounted location can also appear
   in other bind-mounted locations.

Since virtiofsd is in a separate mount namespace, does the propagation
type even have any effect?

Stefan

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6oQv8ACgkQnKSrs4Gr
c8hp/Af+L4ecOtUnrwQ5w8BALWGRS8+H4FBMpp9yQLC9GAnJ9ALCfXZ7eaA0E2Us
mPXWs6Tj8FROnIDlqxj3JxEEiSRnb3CG/HYPJE41y0EQYhkY+/ECKpdBlrmANqX/
J+I+dmQO4Ni/PqTu7wfvPSXkCJxUG4IS1vpvBNzjwcoDgDN5oDqW/jcnJc0oqGXi
BLfvoJw6hcuxDO78R9dfyXDRQe4KfdDsaPIwqZUhpy2IEBTR5++c6IeuhzmW9bvv
0cL4dL5y7jTv9/ZQmq02x8us89B/rcEGGdgmB2uN1J0xGSV1RhQK3gL1ABVMOIgh
1aHzkg47gj+f10K1jNEiT/nMm45/gQ==
=5joq
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--

