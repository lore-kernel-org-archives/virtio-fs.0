Date: Tue, 27 Aug 2019 14:02:07 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190827130207.GC4290@stefanha-x1.localdomain>
References: <5f49cefd-a051-8af4-86a2-3ea94acd9eee@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <5f49cefd-a051-8af4-86a2-3ea94acd9eee@redhat.com>
Subject: Re: [Virtio-fs] basic questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>
Cc: virtio-fs@redhat.com


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 24, 2019 at 01:09:18PM +0200, Laszlo Ersek wrote:
> Hi,
>=20
> (1) The howto document at <https://virtio-fs.gitlab.io/howto-qemu.html>
> contains the following snippet:
>=20
> > force use of memory sharable with the fuse daemon.
> >
> >   -m 4G,maxmem=3D4G -object memory-backend-file,id=3Dmem,size=3D4G,mem-=
path=3D/dev/shm,share=3Don -numa node,memdev=3Dmem
>=20
> Why is the "maxmem" property necessary? It's not larger than the
> (implicit) "size" property of "-m", and I don't think memory hotplug is
> relevant here.

Right, maxmem is not necessary.  I have updated the howto.  It takes a
few minutes for GitLab to regenerate the website, so you might not see
the changes yet if you access it right away.

>=20
> (2) what is the "fuse daemon"? Is that a reference to "virtiofsd"?

Yes, I have updated the howto to use "virtiofsd" instead.

>=20
> (3) Why is a NUMA node necessary, with a memory backend file explicitly
> allocated under /dev/shm?
>=20
> Will the virtio-fs device model exchange such references, over the
> socket, with virtiofsd, that point into shared memory?

The guest RAM file descriptor is sent by QEMU over the vhost-user UNIX
domain socket to virtiofsd.  virtiofsd must be able to mmap guest RAM
with the MAP_SHARED flag.

> (4) Couldn't we point mem-path to a normal (host disk based) directory?
>=20
> Performance aside, that should put less pressure on host RAM, and
> otherwise work the same. Is that correct?

Yes, that should work too.

> (5) Is the shared memory area necessary for the most basic virtio-fs
> usage?

Yes, it's required because shared memory access to guest RAM allows
virtiofsd to process the virtqueues.

> (6) I seem to recall that virtio-fs allows guests to notice if files
> have changed since they last looked.
>=20
> Is that functionality tied to "ireg" daemon, and to the "versiontable"
> property added in commit 8fb5b17bea63 ("virtio-fs: Allow mapping of meta
> data version table", 2019-08-23)?

Currently only virtiofsd -o cache=3Dnone guarantees fresh metadata (at a
performance cost).  The ireg daemon is experimental and incomplete, but
it will make coherent metadata cheaper in the future.

There is currently no inotify support in FUSE, so the guest does not
receive notifications when the file system changes.  Right now guests
would have to poll for changes.

> (7) Are guests required to access the virtio-fs device at the PCI level
> -- such as an MMIO region -- in order to observe async file changes, or
> is this functionality available purely at the virtio communication level
> (i.e., transport-independently)?
>=20
> It doesn't seem to be explained at
> <https://stefanha.github.io/virtio/virtio-fs.html>.

Coherent shared file system access is not supported yet (that's where
the ireg daemon comes in and it's still under development).  Today
virtio-fs is good for the use case where the guest is the only one
accessing the file system.

In terms of the VIRTIO spec, everything is done at the device model
level.  Even the DAX Window is a "shared memory region", which is a
well-defined device model concept.  The MMIO and PCI transports
implement shared memory regions differently, though.

Stefan

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1lKc8ACgkQnKSrs4Gr
c8gf7wgAjBCTWUZzZRDd2rHAyN2/GG8ngBu1h5NjIE1d8130toaFOw1dpy5VX0vO
xB4DFu2De4i+90ETrG+lwgdQRT7K7KNqA7LQseuEXIPh89C50H33LWqCr32ZG5n2
8PS0iwgiyNoGk//A6Jt8KHGDR5YiTe8Rq8v09zIx3jirrggQoMqtD6XD9Jmo7ORI
xkT695P3a71YRhyplEl2E86IjYZ1OeclfdXezRgdvTexR42PRbVgb6lxjpk8HKYy
RVBTfsBHJZkAqV97VKxrff1X4+5mf64zQq/b7R7/abRabNYGzbFbJhnsRrUnts4g
Zyruuf4xczUisKwOVC65cZHS+VWXoQ==
=UcvB
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--

