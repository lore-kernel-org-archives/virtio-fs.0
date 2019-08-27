Date: Tue, 27 Aug 2019 14:46:11 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190827134611.GB6901@stefanha-x1.localdomain>
References: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
	<20190822134018.GJ20491@stefanha-x1.localdomain>
	<20190823095743.GD2784@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <20190823095743.GD2784@work-vm>
Subject: Re: [Virtio-fs] [RFC PATCH 0/2] add stat tools for virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, Gang Deng <gavin.dg@linux.alibaba.com>


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2019 at 10:57:43AM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > On Mon, Aug 19, 2019 at 11:41:12AM +0800, Gang Deng wrote:
> > > There exist two components: vtrace && vstat. vtrace is embeded in vir=
tiofsd,
> > > it will put raw statistics data into share memory. Then the vstat too=
l could
> > > parse it and do some post processing works. The performance overhead =
of
> > > vtrace is very small because it does very simple things.
> >=20
> > The QEMU source tree already contains support for DTrace/SystemTap,
> > LTTng Userspace Tracer, ftrace, and other tracers via tracetool.  See
> > docs/devel/tracing.txt and scripts/tracetool.py.
> >=20
> > It would be good to use that tracing infrastructure instead of writing
> > tracing code from scratch.  Soon someone will want to record FUSE
> > request arguments and other information and then the trace file format
> > and code will become complex and duplicate what tracetool already does.
> >=20
> > With tracetool all trace events are defined in a trace-events file
> > (contrib/virtiofsd/trace-events):
> >=20
> >   virtiofs_op_begin(int opcode) "opcode 0x%x"
> >   virtiofs_op_end(int opcode, int64_t ns) "opcode 0x%x ns %" PRId64
> >=20
> > It would be nice to capture more information: fuse_in_header->unique (to
> > identify the request) and fuse_in_header->nodeid (the inode).
> >=20
> > The lowest overhead tracer that tracetool supports is LTTng UST (it uses
> > shared memory) and would be suitable for vstat.
> >=20
> > Adding tracetool to virtiofsd will require a little work to verify it
> > works with your tracer of choice (e.g. LTTng UST) despite the process
> > sandboxing, but in the long term I don't think writing tracing code from
> > scratch again makes sense.
>=20
> I'm used to using tracing as event logging; but how do they work for the
> type of measurement that Gang Deng is doing, where it's not really about
> logging each event; just being a place to hold some stats?

I think the approach in this patch series works better than tracing
would for this use case.  In the other sub-thread I've asked to avoid
using the "trace"/"tracing" to describe this feature.  This will prevent
confusion and reduces the temptation to grow this into yet another
tracer.

Stefan

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1lNCMACgkQnKSrs4Gr
c8jmXAgAsF5IYZwi2YE5+MWwBCS3EDa+PoQASwfAn9qB/14mfj+Oq9je4cADtPBj
tspGmKbzGKKzry5JuBh6mVUHiNP4tm6IXp2lo//ZEJVZrMGrVJdnRVZ/p8QwKk37
wDI46HNdZqyAvLi8J+CCqTrnB4c0sylzn/MlJXwTfZ2haT1q1UNfJFnw51pMzUTn
cbTWm2dyloub35lrjLfRBzaMcQJ+E3vyiz2DYoQU4oTpDAi/jBkXN8c7bFqkfVx9
Me0z7v6plqnirWyqoRJ88kwU6hl+fKCrFEYwKf9M4VNdPK6zfuqOMQFgQJqUtTFW
tmu700dypufplVnhQVzFFEzBMte79Q==
=De/N
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--

