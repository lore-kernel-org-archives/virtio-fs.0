Date: Fri, 25 Oct 2019 14:54:16 +0200
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191025125416.GE13314@stefanha-x1.localdomain>
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
	<20191017100528.GA24790@stefanha-x1.localdomain>
	<CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
	<20191017160953.GC1266@stefanha-x1.localdomain>
	<CAOssrKejcfVWXw6Nu1owyEeofTdVp6BNx4bL91ma2g7bg9-nmg@mail.gmail.com>
	<CAOssrKdbAT5s=CYG6PBtE6OYdqgwG8vp9T6QMJpwZ7X3tKjPmg@mail.gmail.com>
	<OSBPR01MB37835DC3A2F179AFD3A9074BE56C0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
	<20191021094047.GF22659@stefanha-x1.localdomain>
	<OSBPR01MB3783A810FEC4C2F3AE7248BAE56B0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0QFb0wBpEddLcDHQ"
Content-Disposition: inline
In-Reply-To: <OSBPR01MB3783A810FEC4C2F3AE7248BAE56B0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, 'Miklos Szeredi' <mszeredi@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>


--0QFb0wBpEddLcDHQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2019 at 11:42:50AM +0000, misono.tomohiro@fujitsu.com wrote:
> > -----Original Message-----
> > From: Stefan Hajnoczi [mailto:stefanha@redhat.com]
> > Sent: Monday, October 21, 2019 6:41 PM
> > To: Misono, Tomohiro/=E5=91=B3=E6=9B=BD=E9=87=8E =E6=99=BA=E7=A4=BC <mi=
sono.tomohiro@fujitsu.com>
> > Cc: 'Miklos Szeredi' <mszeredi@redhat.com>; virtio-fs@redhat.com; qemu-=
devel@nongnu.org
> > Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr opera=
tion
> >=20
> > On Fri, Oct 18, 2019 at 08:51:20AM +0000, misono.tomohiro@fujitsu.com w=
rote:
> > > > Doing unshare(CLONE_FS) after thread startup seems safe, though must
> > > > be careful to change the working directory to the root of the mount
> > > > *before* starting any threads.
> > >
> > > I think working directry is changed in setup_sandbox() -> setup_mount=
_namespace() -> setup_pivot_root().
> > > So, can we just add unshare(CLONE_FS) in fv_queue_worker()?
> >=20
> > fv_queue_worker() is the thread pool worker function that is called for=
 each request.  Calling unshare(CLONE_FS) for each request
> > is not necessary and will reduce performance.
> >=20
> > A thread-local variable can be used to avoid repeated calls to
> > unshare(CLONE_FS) from the same worker thread:
> >=20
> >   static __thread bool clone_fs_called;
> >=20
> >   static void fv_queue_worker(gpointer data, gpointer user_data)
> >   {
> >       ...
> >       if (!clone_fs_called) {
> >           int ret;
> >=20
> > 	  ret =3D unshare(CLONE_FS);
> > 	  assert(ret =3D=3D 0); /* errors not expected according to man page */
> >=20
> > 	  clone_fs_called =3D true;
> >       }
> >=20
> > Another issue is the seccomp policy.  Since worker threads are spawned =
at runtime it is necessary to add the unshare(2) syscall
> > to the seccomp whitelist in contrib/virtiofsd/seccomp.c.
> >=20
>=20
> Thanks for suggesting.
>=20
> I tried above code with fchdir() + ...xattr() + fchdir() in lo_...xattr
> and it solves all the problem about xattr I see.
>=20
> However, it seems the fix causes some performance issue in stress test
> as ACL check issues getxattr() and a lot of fchdir() happens. So, I may
> try to combine the old method for regular file and this method for special
> files.

Sounds good.

Stefan

--0QFb0wBpEddLcDHQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2y8HgACgkQnKSrs4Gr
c8irAAf+IexIlrCWNTmr7Bw95qqxQoiZwpMbrxoILzqDtHcZnzUIbCOaKov0rKRD
DzH+m/McH7o3+7yFOUhDuQN8TEkwZTA7WUChLQviRJXIw2ynn13XT7ZQx8XPcbfo
BkI4OE+pHunCyoRtWVgzt/oWo7Vrt+Y5x+gyHQBJPbkq9CWLHGpAgBdZ0c+CAEgS
FHjztRKeNJJ2Xoag52vOk0FvVHw1MxmvMevf+zdUHVTV6eu20VJpX0BRyXnAJoq9
XsHc57N3IJrpKr/YQzfzwCpZ21R/GNuyW5c7tv/X9Lp+PWdypSAAByM+lU/jTvXR
3p9F1uNOujEe7zZhetbREjRnBoYYsw==
=ckH9
-----END PGP SIGNATURE-----

--0QFb0wBpEddLcDHQ--

