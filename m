Date: Fri, 9 Aug 2019 09:27:59 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190809082759.GD25286@stefanha-x1.localdomain>
References: <20190807093152.10964-1-dgilbert@redhat.com>
	<20190807124537.GA18557@redhat.com> <20190807131715.GE2867@work-vm>
	<20190807132955.GC18557@redhat.com>
	<20190808094546.GC31963@stefanha-x1.localdomain>
	<20190808102651.GD2852@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UoPmpPX/dBe4BELn"
Content-Disposition: inline
In-Reply-To: <20190808102651.GD2852@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix lo_destroy crash in
 g_hash_table_foreach_remove
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>


--UoPmpPX/dBe4BELn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2019 at 11:26:51AM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > On Wed, Aug 07, 2019 at 09:29:55AM -0400, Vivek Goyal wrote:
> > > On Wed, Aug 07, 2019 at 02:17:15PM +0100, Dr. David Alan Gilbert wrot=
e:
> > > > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > > > On Wed, Aug 07, 2019 at 10:31:52AM +0100, Dr. David Alan Gilbert =
(git) wrote:
> > > > > - Also before destroying lo, should we sever connection so that a=
ny
> > > > >   requests which come after lo_destroy() are not entertained.
> > > >=20
> > > > No, because in some situations lo_destroy does not happen at the en=
d;
> > > > e.g. it happens during a umount and we still have the connection
> > > > to be able to remount it.
> > >=20
> > > Ok, so we don't sever the connection completely. But we don't expect =
to
> > > process further requests till a new INIT has been done, isn't it?
> > >=20
> > > IOW, once lo_destroy() is received, we cleanup any pending state from
> > > the mount and if any requests are received from client, we error them
> > > out.
> > >=20
> > > And start processing requests normally when a new INIT has been
> > > received.
> > >=20
> > > Atleast that was my understanding of the design.
> >=20
> > There is a state machine that does:
> >=20
> > 1. Drain in-flight requests when DESTROY is received.
>=20
> Hmm does that drain happen in the reboot case where there wasn't
> actually a destroy message? (fuse_session_process_buf_int=20
> where it calls se->op.destroy explicitly)

struct fuse_session::init_rwlock has these semantics:

INIT and DESTROY requests acquire a write lock.  All other requests
acquire a read lock.

A write lock must wait for in-progress readers to complete.  This is the
drain.  New readers must wait for writers (even for waiting writers, to
ensure fairness).

In the reboot case INIT message acts as the drain operation.

Stefan

--UoPmpPX/dBe4BELn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1NLo8ACgkQnKSrs4Gr
c8h3KAgAqUhCANQC5NvZcFpMLyRIN/I8DI9Zees+rEnxjUPDBib/GW7bGFOazgi1
eAg8WhgJzzKAdYMMSJqB4Tioxa9oeZ0N4fvwGe1qrqavZ9r84d8Q9XFBQPrHTIJS
vQ2RsrHaCutCQAKyYeIJSW+oMXqCb1gUeus52iY8WQjuiZOBy48G4PuRiAIdv6ya
psuJtXX4lTjj3YwyWQHM15JosHBKWgeEpYWTN7MzSPa6aN0euLEKxnCxi/9Ciz4u
lzVTjnO9m5lOt/4h3YRT4CM/nqLZct7SOQMuQiWm0M9Vt8uxa+1J7EmFUE9usani
BQFXaJr422DCM3Q6+ZCCXOXpEq4p0A==
=cjIz
-----END PGP SIGNATURE-----

--UoPmpPX/dBe4BELn--

