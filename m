Date: Mon, 21 Oct 2019 10:40:47 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191021094047.GF22659@stefanha-x1.localdomain>
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
	<20191017100528.GA24790@stefanha-x1.localdomain>
	<CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
	<20191017160953.GC1266@stefanha-x1.localdomain>
	<CAOssrKejcfVWXw6Nu1owyEeofTdVp6BNx4bL91ma2g7bg9-nmg@mail.gmail.com>
	<CAOssrKdbAT5s=CYG6PBtE6OYdqgwG8vp9T6QMJpwZ7X3tKjPmg@mail.gmail.com>
	<OSBPR01MB37835DC3A2F179AFD3A9074BE56C0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rMWmSaSbD7nr+du9"
Content-Disposition: inline
In-Reply-To: <OSBPR01MB37835DC3A2F179AFD3A9074BE56C0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
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


--rMWmSaSbD7nr+du9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2019 at 08:51:20AM +0000, misono.tomohiro@fujitsu.com wrote:
> > Doing unshare(CLONE_FS) after thread startup seems safe, though must be=
 careful to change the working directory to the root of
> > the mount
> > *before* starting any threads.
>=20
> I think working directry is changed in setup_sandbox() -> setup_mount_nam=
espace() -> setup_pivot_root().
> So, can we just add unshare(CLONE_FS) in fv_queue_worker()?

fv_queue_worker() is the thread pool worker function that is called for
each request.  Calling unshare(CLONE_FS) for each request is not
necessary and will reduce performance.

A thread-local variable can be used to avoid repeated calls to
unshare(CLONE_FS) from the same worker thread:

  static __thread bool clone_fs_called;

  static void fv_queue_worker(gpointer data, gpointer user_data)
  {
      ...
      if (!clone_fs_called) {
          int ret;

	  ret =3D unshare(CLONE_FS);
	  assert(ret =3D=3D 0); /* errors not expected according to man page */

	  clone_fs_called =3D true;
      }

Another issue is the seccomp policy.  Since worker threads are spawned
at runtime it is necessary to add the unshare(2) syscall to the seccomp
whitelist in contrib/virtiofsd/seccomp.c.

Stefan

--rMWmSaSbD7nr+du9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2tfR8ACgkQnKSrs4Gr
c8izkQf9HxlTQy7DcT+pdpRQd6UUnU5d8j/LAJQKySzzdGOYE6xf84D/YZy2AevH
rJOFV20qZJxzDWUvlSrLD9se98SE6pcnBSTAom+RR+XOjZm4/+9pzax5Ss3vbgqK
74hv+d7rLPwNEqs/CZMzt1GaM7YyRycTGzbTosRwVfpBOO5oAcjHGjco2TelyrsF
kdjvSgTd+jTfr+KdUbB0NOX+58RpiA4Yn1MQpEctkh0wOJZdL2kSqpTiwiRu5qDm
jqPlPsIpdkCRxbvzn4bcEWfoRchgvtJ/L3CQJ1zHL14IJ3LmG5wat0Bn0tMdH/eU
Tq37p22dYRjkN3twX6S/+Tmu+PlfMQ==
=u3k2
-----END PGP SIGNATURE-----

--rMWmSaSbD7nr+du9--

