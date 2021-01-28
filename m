Date: Thu, 28 Jan 2021 15:32:58 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210128153258.GA20377@stefanha-x1.localdomain>
References: <20210127112131.308451-1-stefanha@redhat.com>
	<CAOssrKfY7zDOH3NNbtyARHMCdJJN1tKQJri8ec=igjBf=K6Dog@mail.gmail.com>
	<20210127141430.GA310142@stefanha-x1.localdomain>
	<CAOssrKdmpjMG1fVRJBBG7DKy4Fy46HaBz5gHvWZfOTy6FGF+6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <CAOssrKdmpjMG1fVRJBBG7DKy4Fy46HaBz5gHvWZfOTy6FGF+6Q@mail.gmail.com>
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


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 27, 2021 at 03:27:23PM +0100, Miklos Szeredi wrote:
> On Wed, Jan 27, 2021 at 3:14 PM Stefan Hajnoczi <stefanha@redhat.com> wro=
te:
> >
> > On Wed, Jan 27, 2021 at 02:01:54PM +0100, Miklos Szeredi wrote:
>=20
> > > The problem here is there can also be a race between the open and the
> > > subsequent lo_do_lookup().
> > >
> > > At this point it's probably enough to verify that fuse_entry_param
> > > refers to the same object as the fh (using fstat and comparing st_dev
> > > and st_ino).
> >
> > Can you describe the race in detail? FUSE_CREATE vs FUSE_OPEN?
> > FUSE_CREATE vs FUSE_CREATE?
>=20
> A race between FUSE_CREATE and external modification:
>=20
> VIRTIOFSD: lo_create() {
> VIRTIOFSD:     fd =3D open(foo, O_CREAT | O_EXCL)
> EXTERNAL:  unlink(foo)
> EXTERNAL:  open(foo, O_CREAT)
> VIRTIOFSD:     lo_do_lookup() {
> VIRTIOFSD:         newfd =3D open(foo, O_PATH | O_NOFOLLOW)
>=20
> Nothing serious will happen, but there will be a discrepancy between
> the open file and the inode that it references.  I.e.  the following
> in the client will yield weird results:
>=20
> open(foo, O_CREAT) -> fd
> sprintf(procname, "/proc/self/fd/%i", fd);
> open(procname, O_RDONLY) -> fd2
> write(fd, buf, bufsize)
> read(fd2, buf, bufsize)
>=20
> This is probably not a security issue, more of a quality of
> implementation issue.

Thanks for explaining. This is related to consistency when the shared
directory is accessed by multiple systems (e.g. other guests or the
host). virtiofsd doesn't support consistency in that case yet.

Let's treat this as a separate issue.

Stefan

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAS2SYACgkQnKSrs4Gr
c8hKSQf/bjaMIB+c5JK/IX+azZaL78TpuZsbWwuA3cXr8zGhTCJUHURkH9qBJr6O
ySoxNFF1kUkHpF3VEbvSLJaoKrNVBQ1TC3l1nHhD2mhL9xQlJGOVq0oORUIaF5Vh
e47i7YqsLUYyA1WA+Z+d7vYmv8JaoFWkUXshtIHVGxUg0bSLEPelIcWuxsWyFTxM
jO+VFxFJ9UiZJyiu7X1XrwIeOnKaPUtPCEpMkhvxZjCYYaAHbnziklFL+aRX5wKr
8S3u64VU2ADDxoNPscMv8n0BTHbxMgIXdTxvz/w3JbAw9qkJeg/dFuUjlCLTZOqy
24cneiLEqmkVZyiXG6YBpJm2MjHwKw==
=9Ba+
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--

