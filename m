Date: Thu, 8 Aug 2019 10:02:13 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190808090213.GD31476@stefanha-x1.localdomain>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190807180355.GA22758@stefanha-x1.localdomain>
	<20190807205715.GE18557@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gE7i1rD7pdK0Ng3j"
Content-Disposition: inline
In-Reply-To: <20190807205715.GE18557@redhat.com>
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


--gE7i1rD7pdK0Ng3j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 07, 2019 at 04:57:15PM -0400, Vivek Goyal wrote:
> Kernel also serializes MAP/UNMAP on one inode. So you will need to run
> multiple jobs operating on different inodes to see parallel MAP/UNMAP
> (atleast from kernel's point of view).

Okay, there is still room to experiment with how MAP and UNMAP are
handled by virtiofsd and QEMU even if the host kernel ultimately becomes
the bottleneck.

One possible optimization is to eliminate REMOVEMAPPING requests when
the guest driver knows a SETUPMAPPING will follow immediately.  I see
the following request pattern in a fio randread iodepth=64 job:

  unique: 995348, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80, pid: 1351
  lo_setupmapping(ino=135, fi=0x(nil), foffset=3860856832, len=2097152, moffset=859832320, flags=0)
     unique: 995348, success, outsize: 16
  unique: 995350, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60, pid: 12
     unique: 995350, success, outsize: 16
  unique: 995352, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80, pid: 1351
  lo_setupmapping(ino=135, fi=0x(nil), foffset=16777216, len=2097152, moffset=861929472, flags=0)
     unique: 995352, success, outsize: 16
  unique: 995354, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60, pid: 12
     unique: 995354, success, outsize: 16
  virtio_send_msg: elem 9: with 1 in desc of length 16
  unique: 995356, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80, pid: 1351
  lo_setupmapping(ino=135, fi=0x(nil), foffset=383778816, len=2097152, moffset=864026624, flags=0)
     unique: 995356, success, outsize: 16
  unique: 995358, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60, pid: 12

The REMOVEMAPPING requests are unnecessary since we can map over the top
of the old mapping instead of taking the extra step of removing it
first.

Some more questions to consider for DAX performance optimization:

1. Is FUSE_READ/FUSE_WRITE more efficient than DAX for some I/O patterns?
2. Can MAP/UNMAP be performed directly in QEMU via a separate virtqueue?
3. Can READ/WRITE be performed directly in QEMU via a separate virtqueue
   to eliminate the bad address problem?
4. Can OPEN+MAP be fused into a single request for small files, avoiding
   the 2nd request?

I'm not going to tackle DAX optimization myself right now but wanted to
share these ideas.

Stefan

--gE7i1rD7pdK0Ng3j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1L5RUACgkQnKSrs4Gr
c8incggAoZCwEuTXkyQ6ttuPr8P1Rdi6m087BP7xgEgY9DGCioI13VAgBAoqG/YK
G+RLw90se/SMsxwjLFFgR1jRr+0yuxjLiy16Z35o9gSjEQAZ1MH9LVMm+3SECNYi
eV6Y1Dg73ilBjWPeLl9fw8QvWXy0mzZfpR8QsRvDQodCRsa+Ow9uNSafNPPCFQjS
OdxO0XIm8rpLAFC9ihganIFwAtJqJ8xw2F0tB7XO1Tm/eAv7AAHW2qjpQKblDcaD
zoq+56Nhr4lAu0gf4B/5+3czo9RVSUS+C5gJiYx7b7iisIGgB8GgniTmKaN7gQV6
tACb6kmjhl94zgP9yyzWxBuUjbWmlw==
=5pmm
-----END PGP SIGNATURE-----

--gE7i1rD7pdK0Ng3j--

