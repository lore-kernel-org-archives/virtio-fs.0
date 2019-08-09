Date: Fri, 9 Aug 2019 09:23:56 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190809082356.GC25286@stefanha-x1.localdomain>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190807180355.GA22758@stefanha-x1.localdomain>
	<20190807205715.GE18557@redhat.com>
	<20190808090213.GD31476@stefanha-x1.localdomain>
	<20190808095316.GC2852@work-vm> <20190808125320.GB3147@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Content-Disposition: inline
In-Reply-To: <20190808125320.GB3147@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/4] virtiofsd: multithreading preparation
 part 3
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2019 at 08:53:20AM -0400, Vivek Goyal wrote:
> On Thu, Aug 08, 2019 at 10:53:16AM +0100, Dr. David Alan Gilbert wrote:
> > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > On Wed, Aug 07, 2019 at 04:57:15PM -0400, Vivek Goyal wrote:
> > > > Kernel also serializes MAP/UNMAP on one inode. So you will need to =
run
> > > > multiple jobs operating on different inodes to see parallel MAP/UNM=
AP
> > > > (atleast from kernel's point of view).
> > >=20
> > > Okay, there is still room to experiment with how MAP and UNMAP are
> > > handled by virtiofsd and QEMU even if the host kernel ultimately beco=
mes
> > > the bottleneck.
> > >=20
> > > One possible optimization is to eliminate REMOVEMAPPING requests when
> > > the guest driver knows a SETUPMAPPING will follow immediately.  I see
> > > the following request pattern in a fio randread iodepth=3D64 job:
> > >=20
> > >   unique: 995348, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80,=
 pid: 1351
> > >   lo_setupmapping(ino=3D135, fi=3D0x(nil), foffset=3D3860856832, len=
=3D2097152, moffset=3D859832320, flags=3D0)
> > >      unique: 995348, success, outsize: 16
> > >   unique: 995350, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60=
, pid: 12
> > >      unique: 995350, success, outsize: 16
> > >   unique: 995352, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80,=
 pid: 1351
> > >   lo_setupmapping(ino=3D135, fi=3D0x(nil), foffset=3D16777216, len=3D=
2097152, moffset=3D861929472, flags=3D0)
> > >      unique: 995352, success, outsize: 16
> > >   unique: 995354, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60=
, pid: 12
> > >      unique: 995354, success, outsize: 16
> > >   virtio_send_msg: elem 9: with 1 in desc of length 16
> > >   unique: 995356, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80,=
 pid: 1351
> > >   lo_setupmapping(ino=3D135, fi=3D0x(nil), foffset=3D383778816, len=
=3D2097152, moffset=3D864026624, flags=3D0)
> > >      unique: 995356, success, outsize: 16
> > >   unique: 995358, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60=
, pid: 12
> > >=20
> > > The REMOVEMAPPING requests are unnecessary since we can map over the =
top
> > > of the old mapping instead of taking the extra step of removing it
> > > first.
> >=20
> > Yep, those should go - I think Vivek likes to keep them for testing
> > since they make things fail more completely if there's a screwup.
>=20
> I like to keep them because otherwise they keep the resources busy
> on host. If DAX range is being used immediately, then this optimization
> makes more sense. I will keep this in mind.

Skipping all unmaps is has drawbacks, as you've said.  I'm just thinking
about the case where a mapping is replaced with a new one.

> >=20
> > > Some more questions to consider for DAX performance optimization:
> > >=20
> > > 1. Is FUSE_READ/FUSE_WRITE more efficient than DAX for some I/O patte=
rns?
> >=20
> > Probably for cases where the data is only accessed once, and you can't
> > preemptively map.
> > Another variant on (1) is whether we could do read/writes while the mmap
> > is happening to absorb the latency.
>=20
> For small random I/O, dax might not be very effective. Overhead of
> setting up mapping and tearing it down is significant.

Plus there is still an EPT violation and the host page cache needs to be
filled if we haven't prefetched it.  So I imagine FUSE_READ/FUSE_WRITE
will be faster than DAX here.  DAX will be better for repeated,
long-lived accesses.

Stefan

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1NLZwACgkQnKSrs4Gr
c8haKQf/XDBFBSlJUHtGbmAeiJLkNMMmc3oabsCjQ+KUava1ZfbiG/bITLuQNUI3
LuKB0L8/LnXGU6F4Ua+YmOOPbmhdamoXVdRE9N5dN3sWz7j3kndS3zgETcR74OTL
cQIf3LLsKJ2vbnsQriQtZZpwdIbl71AYwAPUym20DE4JbjAV8IviiankxjxhCtgM
QIgYAdFDi5BHyl02wT883vd3RGnURZhOW+oGLrQX5PtSP3rLiOpfrUHnoRY4pksM
z1O98qAYH9iPxOah0LgPHfH8a+24rYXVk8pzCGX81DVoj63/xi3kqSvo9XAggHl4
/djr9k5hTfMkLondNe7vxBZg+dc6iA==
=IvQY
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--

