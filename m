Date: Thu, 17 Oct 2019 17:09:53 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191017160953.GC1266@stefanha-x1.localdomain>
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
	<20191017100528.GA24790@stefanha-x1.localdomain>
	<CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2019 at 01:23:57PM +0200, Miklos Szeredi wrote:
> On Thu, Oct 17, 2019 at 12:05 PM Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
> >
> > On Wed, Oct 16, 2019 at 07:37:52PM +0900, Misono Tomohiro wrote:
> > > Hello,
> > >
> > > I test xattr operation on virtiofs using xfstest generic/062
> > > (with -o xattr option and XFS backend) and see some problems.
> > >
> > > These patches fixes the two of the problems.
> > >
> > > The remaining problems are:
> > >  1. we cannot xattr to block device created by mknod
> > >     which does not have actual device (since open in virtiofsd fails)
> > >  2. we cannot xattr to symbolic link
> > >
> > > I don't think 1 is a big problem but can we fix 2?
> >
> > Sorry, I don't know the answer.  Maybe it would be necessary to add a
> > new O_SYMLINK open flag to open(2) so that fgetxattr()/fsetxattr()
> > operations can be performed.  A kernel change like that would take some
> > time to get accepted upstream and shipped by distros, but it might be
> > the only way since the current syscall interface doesn't seem to offer a
> > way to do this.
>=20
> The real problem is that open() on a non-regular, non-directory file
> may have side effects (unless O_PATH is used).  These patches try to
> paper over that, but the fact is: opening special files from a file
> server is forbidden.
>=20
> I see why this is being done, and it's not easy to fix properly
> without the ..at() versions of these syscalls.  One idea is to fork()
> + fchdir(lo->proc_self_fd) + ..xattr().  Another related idea is to do
> a unshare(CLONE_FS) after each thread's startup (will pthread library
> balk?  I don't know) so that it's safe to do fchdir(lo->proc_self_fd)
> + ...xattr() + fchdir(lo->root_fd).

Looking at the f*xattr() code in the kernel, it doesn't really care
about the file descriptor, it wants the inode instead.  So the O_SYMLINK
idea I mentioned could also be called O_XATTR and be similar to O_PATH,
except that only f*xattr() calls are allowed on this file descriptor.

Stefan

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2oklEACgkQnKSrs4Gr
c8iiaAgAhKZnZLjRSpcFf1nJFWVOr+mJG0FqTEaivYCCOF73tUkhrRdfYz2J45Km
kkOJen8ZDZuNZPFl+y9WVn1OH7qtHHzYpNKXbmhyEa1FB1nPStM5+AGs5qNHIQgf
sXpFoQ56an1JyXg1IBqsH9V0blNVbH1vwlSsy7IkTXSNNFLz314CinvYe1RcfaWe
1EGL15xV8pEw1Zw5rHmhNx4c/E4HOcI5vBz9FwO/HGI9Z/Dui/bAyatb/Ko54YAS
lWObKy1P4ugUmz5COJzX/utS0SBEeidbjWhr81qs4p42fQYrDYZj/JsG2U/Ys8+H
t6XaGP9hT3Hoghq0e39FkATwyF72TQ==
=qReH
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--

