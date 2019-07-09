Date: Tue, 9 Jul 2019 10:15:20 +0200
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190709081520.GC25663@stefanha-x1.localdomain>
References: <20190704104650.GF1609@stefanha-x1.localdomain>
	<20190708150822.GK2746@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <20190708150822.GK2746@work-vm>
Subject: Re: [Virtio-fs] Achieving parallelism in virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, mszeredi@redhat.com


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 08, 2019 at 04:08:22PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > Hi,
> > Here are my plans for achieving parallelism in virtiofsd.  This will
> > improve performance for workloads that keep more than one request in
> > flight at a time.
> >=20
> > Today virtiofsd performance is limited because it only processes 1
> > request at a time.  This can be improved in two independent ways:
> > parallel request processing and multiqueue.
> >=20
> > Parallel request processing means working on more than one request at a
> > time.  A request that blocks should not prevent the next request from
> > executing.  The FUSE protocol is asynchronous so it's just a question of
> > adjusting virtiofsd.
>=20
> Are there any ordering constraints? Or barriers etc?

FUSE_INIT must be processed before the session is usable for
general-purpose requests.  So there is at least one ordering constraint
in the FUSE protocol :).

Miklos: Can you confirm that fuse.ko does not assume ordering
constraints on general-purpose requests (lookup, create, read, write,
etc)?  For example, does it ever queue up requests and expect them to be
processed in order?

> > Multiqueue means providing several request virtqueues instead of just
> > one.  This can be used with CPU and NUMA pinning so that request
> > processing takes place on a core and NUMA node.  Better locality can
> > result in higher performance.
> >=20
> > virtiofsd needs to offer both of these features.  The model I'm
> > proposing is one thread per virtqueue which distributes requests to a
> > thread pool for execution.  Each virtqueue thread and its thread pool
> > can be bound to a subset of CPUs.
> >=20
> > Separate optimizations such as virtqueue polling could be added later to
> > reduce latency.
> >=20
> > I plan to use the glib thread pool, which offers the basic functionality
> > that virtiofsd requires.  In the process of this work I will also audit
> > and fix passthrough_ll.c's thread-safety.
> >=20
> > Feedback is appreciated!
>=20
> I think that should work; it probably needs a bit more abstraction for
> some concept of a current command;=20
>=20
> I think currently we have that:
>=20
>   fuse_req_t req
> has  fuse_chan *ch
> has     fv_QueueInfo *qi
> has       VuVirtqElement *qe
>=20
> (There's also reply_sent and elem_bad_in that relate to the current
> request)
>=20
> and the filesystem code just passes 'req' in to calls where it wants
> to return data; with multiple threads you could have multiple
> fuse_chan's and thus multiple fv_QueueInfo's; but for a thread pool
> you really need to tie the qe directly to the req.
>=20
> It's a bit structurally differnt from normal fuse, since they just
> write on an fd, there's no concept of having to use particularly
> storage to return the result of a particular request.
>=20
> Perhaps the easiest thing would be to keep a hash of virtqelement's
> based on the unique id in each request?

My plan was 1 fuse_chan per worker thread.

Stefan

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0kTRgACgkQnKSrs4Gr
c8hqewf/ecFHlX/Lc+2YgbIXVOFgTvDoyUNzhBJCO89cppTV5iTfcqVIMcSkvUjL
h24AIlDx4lYp8jj3dkRjHk8X6SIIbchhnY4s/+he/kavUXAHcUzBWP7iteyJBLFM
7ei9h7xEm/T27u10B1uKxgE6NGZ9hAYJhf5O888R9LQEDcmXGNzuSJSjrt0Pv/r5
HFEpd8QF7zoB7pmEbaHO1Wq/2I38VSwpPvtfcJj2cEGKoPPhciAfYGWPRLqNd1/M
V9XZEgoDdqP0qx0kNUORyFkqfmEbVsiYw9xunPuKTvnuYmN43IPQwxO4Cn2JK3jN
vvxhR5bRC9Q/gHyzYa0guyw+dhAZnA==
=7TpQ
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--

