Date: Thu, 4 Jul 2019 11:46:50 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190704104650.GF1609@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gneEPciiIl/aKvOT"
Content-Disposition: inline
Subject: [Virtio-fs] Achieving parallelism in virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


--gneEPciiIl/aKvOT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
Here are my plans for achieving parallelism in virtiofsd.  This will
improve performance for workloads that keep more than one request in
flight at a time.

Today virtiofsd performance is limited because it only processes 1
request at a time.  This can be improved in two independent ways:
parallel request processing and multiqueue.

Parallel request processing means working on more than one request at a
time.  A request that blocks should not prevent the next request from
executing.  The FUSE protocol is asynchronous so it's just a question of
adjusting virtiofsd.

Multiqueue means providing several request virtqueues instead of just
one.  This can be used with CPU and NUMA pinning so that request
processing takes place on a core and NUMA node.  Better locality can
result in higher performance.

virtiofsd needs to offer both of these features.  The model I'm
proposing is one thread per virtqueue which distributes requests to a
thread pool for execution.  Each virtqueue thread and its thread pool
can be bound to a subset of CPUs.

Separate optimizations such as virtqueue polling could be added later to
reduce latency.

I plan to use the glib thread pool, which offers the basic functionality
that virtiofsd requires.  In the process of this work I will also audit
and fix passthrough_ll.c's thread-safety.

Feedback is appreciated!

Stefan

--gneEPciiIl/aKvOT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0d2RoACgkQnKSrs4Gr
c8iOeQgApBh3Z8X6U10/N6DiTZ/1lUcG1y28DRz7AyhcR4zw9W8xEWphbO16ZmxS
NKvBq2tVD48TusLWRmpkNbPpwSVtT47lf//3EeTWhIOlqBq40MwQzKp5b1xooCMY
dPMvcvNJrljspFKuyMJ7br3fpjoliA810yxuu8zcLQVY6iQdgxh/tXJPTpdfbeCR
FtpvAu90apXwSBo8MpOkewaLPJq9LM9syO5LF6rME3ml7ZeJUXRwcTIrMXQy9qgd
TZ2vxLp7vcgfYGqGv+om4hS1wICkQuLRyBatMo7qoWIvQyIZwFTCW3NMfOEzPz4Q
CaIXJabVEKv7bw0pn0izl9HsB0nhgA==
=UoJn
-----END PGP SIGNATURE-----

--gneEPciiIl/aKvOT--

