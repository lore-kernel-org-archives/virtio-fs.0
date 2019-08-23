Date: Fri, 23 Aug 2019 11:26:24 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190823102624.GF12092@stefanha-x1.localdomain>
References: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
	<20190822134018.GJ20491@stefanha-x1.localdomain>
	<d9757234-dacd-9366-bcc7-19afe5af84a6@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oFbHfjnMgUMsrGjO"
Content-Disposition: inline
In-Reply-To: <d9757234-dacd-9366-bcc7-19afe5af84a6@linux.alibaba.com>
Subject: Re: [Virtio-fs] [RFC PATCH 0/2] add stat tools for virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Gang Deng <gavin.dg@linux.alibaba.com>
Cc: virtio-fs@redhat.com


--oFbHfjnMgUMsrGjO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2019 at 10:41:48PM +0800, Gang Deng wrote:
> On 2019/8/22 21:40, Stefan Hajnoczi wrote:
> > On Mon, Aug 19, 2019 at 11:41:12AM +0800, Gang Deng wrote:
> >> There exist two components: vtrace && vstat. vtrace is embeded in virt=
iofsd,
> >> it will put raw statistics data into share memory. Then the vstat tool=
 could
> >> parse it and do some post processing works. The performance overhead of
> >> vtrace is very small because it does very simple things.
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
> >=20
>=20
> Thanks for your comments!
>=20
> The name of vtrace may be confused. We want the stat tool meets the follo=
wing
> constraints:
>=20
> *). has very small overhead;
> *). can be always on (e.g. detect hang, it's too late to enable trace whe=
n hang
>     was already occurred);
> *). can output the latency histogram if needed in future, to detect perfo=
rmance
>     jitter.

If the scope of vstat is well-defined then it may be okay to implement
it from scratch.  My concern is virtiofsd duplicating tracing
infrastructure.  Please rename "trace" in the code so it's clear this is
not a tracing mechanism but specifically just for vstat data collection.

> I think the difference of vtrae && qemu's tracing infrastructure looks li=
ke
> that of /proc/diskstats(iostat) && blktrace(blkparse) for linux kernel's =
block
> device. It depends on the use case. I'll measure the cost later to see wh=
ether
> qemu's tracer can meet our needs and whether it's enough to get statistic=
s.

Tracetool supports multiple tracers.  I suggest trying LTTng Userspace
Tracer because it is the lowest overhead tracer (using shared memory).

https://lttng.org/docs/v2.10/#doc-lttng-ust

I don't use LTTng much so I'm not sure how to consume a live trace from
a custom tool like vstat.  I've asked on the LTTng IRC channel and will
let you know what the answer is.

Stefan

--oFbHfjnMgUMsrGjO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1fv1AACgkQnKSrs4Gr
c8ijIwf/Q8to0eP/dNHpNMR8M8kGtpLf0iFnPI6lMlYJFiMgCqyM98ZQhDgUxg80
kxlw+YVDj/c0dEyclNDf6ViChYFVQTfLK7c7zBbDqJF4nE4EzWGt1bL1Wb/c+Y9I
JK5aYOqky6BJsWk3FsMC1h+XbKKf9Trlu3R6LQQl/UKRKxnfpj6nxZDwedoAPu7S
QXA9QBJH8JV95XBeAGbb0hrtMPovObhcjYSQDSPY7Cj6SL1ZHbumQrOHTPZGLk1C
4Y1KhhQhFvwV4NwddEwxaiVH/SLwzWDleX21nrE1BYibezIu1/iuGFFcCIbuEr6i
CCBfBWaljZ0FSi2crRI7T0T8rIK8wA==
=4TBW
-----END PGP SIGNATURE-----

--oFbHfjnMgUMsrGjO--

