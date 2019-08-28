Date: Wed, 28 Aug 2019 12:36:39 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190828113639.GI5573@stefanha-x1.localdomain>
References: <5f49cefd-a051-8af4-86a2-3ea94acd9eee@redhat.com>
	<20190827130207.GC4290@stefanha-x1.localdomain>
	<b2d18411-d518-788a-0783-1d55a11407c6@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0XMZdl/q8hSSmFeD"
Content-Disposition: inline
In-Reply-To: <b2d18411-d518-788a-0783-1d55a11407c6@redhat.com>
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


--0XMZdl/q8hSSmFeD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2019 at 11:05:45PM +0200, Laszlo Ersek wrote:
> On 08/27/19 15:02, Stefan Hajnoczi wrote:
> > On Sat, Aug 24, 2019 at 01:09:18PM +0200, Laszlo Ersek wrote:
> >> [...]
> > [...]
>=20
> Thanks for the updates for / answers to my questions (1) through (5). In
> particular I hadn't realized that it's virtiofsd to process the virtqueue=
s!
>=20
> >> (6) I seem to recall that virtio-fs allows guests to notice if files
> >> have changed since they last looked.
> >>
> >> Is that functionality tied to "ireg" daemon, and to the "versiontable"
> >> property added in commit 8fb5b17bea63 ("virtio-fs: Allow mapping of me=
ta
> >> data version table", 2019-08-23)?
> >=20
> > Currently only virtiofsd -o cache=3Dnone guarantees fresh metadata (at a
> > performance cost).  The ireg daemon is experimental and incomplete, but
> > it will make coherent metadata cheaper in the future.
> >=20
> > There is currently no inotify support in FUSE, so the guest does not
> > receive notifications when the file system changes.  Right now guests
> > would have to poll for changes.
>=20
> Sorry, I was unclear. It's fine for my use case if the guest has to ask
> actively about intermittent metadata changes. My interest is not in
> notifications.
>=20
> E.g. assume the guest tries to read or write a file it has opened
> earlier. (With explicit FUSE_READ / FUSE_WRITE requests, wrapped into
> the usual virtio descriptor chains.) Can the guest ask, in the read or
> write request, "please reject this request of mine if the file has
> changed since I last looked"? [1]

No, FUSE_READ/FUSE_WRITE don't support that.

> Is the "ireg" daemon, or "-o cache=3Dnone", required for that?

No.  Userspace applications that share access to a file with at least
one writer need to synchronize via file locks or out-of-band
communication.  This is how existing applications work so even if
virtio-fs offered Compare-and-Swap semantics or similar conditional I/O
primitives, I think very few applications would use them.

> However: is another (different) shared memory region planned, for the
> kind of stale metadata detection that I describe above, at [1]?

Yes, there will be a second region containing inode version numbers.
This way FUSE clients can check if the inode was modified by another
client without making a FUSE request to the server.

Stefan

--0XMZdl/q8hSSmFeD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1mZ0cACgkQnKSrs4Gr
c8gpuAgAm7tTfBoZletLqLQHTyN9oOvDnDrL6zq6UeXprFKdKhhiUnc6n2MNwRhr
DU0G7DO1WWVCFKB0sypXl+T8QFt3ILpnHp3+YOknnyEfDLiTRiX+Be0nizQjkO73
YdV/GEE5SjglxXuxOdQuk/GO9nmZdxDnWJvyiChCB9HjAIzs49scD+lYu+5pDWI5
x49kzpYYyggUiHURCOPoAM+jzsxAyYRuckl/mFeMs8xqJCM0bj+B4m5OfpvZ022E
IeEKadK01lG3cAX9Uamu2VL6Y7C0h1bQePMiOstgAavkX0HTAv+fbci0LYgm11xk
kpPSBraK4J4QJis8bGyhSebI6h/KHw==
=7f8E
-----END PGP SIGNATURE-----

--0XMZdl/q8hSSmFeD--

