Date: Mon, 27 Apr 2020 16:19:34 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200427151934.GB1042399@stefanha-x1.localdomain>
References: <20200424062540.23679-1-chirantan@chromium.org>
	<20200424062540.23679-2-chirantan@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20200424062540.23679-2-chirantan@chromium.org>
Subject: Re: [Virtio-fs] [PATCH 2/2] fuse: virtiofs: Add basic multiqueue
	support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 24, 2020 at 03:25:40PM +0900, Chirantan Ekbote wrote:
> Use simple round-robin scheduling based on the `unique` field of the
> fuse request to spread requests across multiple queues, if supported by
> the device.

Multiqueue is not intended to be used this way and this patch will
reduce performance*.  I don't think it should be merged.

* I know it increases performance for you :) but hear me out:

The purpose of multiqueue is for SMP scalability.  It allows queues to
be processed with CPU/NUMA affinity to the vCPU that submitted the
request (i.e. the virtqueue processing thread runs on a sibling physical
CPU core).  Each queue has its own MSI-X interrupt so that completion
interrupts can be processed on the same vCPU that submitted the request.

Spreading requests across queues defeats all this.  Virtqueue processing
threads that are located in the wrong place will now process the
requests.  Completion interrupts will wake up a vCPU that did not submit
the request and IPIs are necessary to notify the vCPU that originally
submitted the request.

Even if you don't care about SMP performance, using multiqueue as a
workaround for missing request parallelism still won't yield the best
results.  The guest should be able to submit up to the maximum queue
depth of the physical storage device.  Many Linux block drivers have max
queue depths of 64.  This would require 64 virtqueues (plus the queue
selection algorithm would have to utilize each one) and shows how
wasteful this approach is.

Instead of modifying the guest driver, please implement request
parallelism in your device implementation.  Device implementations
should pop a virtqueue element, submit I/O, and then move on to the next
virtqueue element instead of waiting for the I/O to complete.  This can
be done with a thread pool, coroutines, async I/O APIs, etc.

The C implementation of virtiofsd has request parallelism and there is
work underway to do it in Rust for cloud-hypervisor too.  Perhaps you
can try the cloud-hypervisor code, I have CCed Sergio Lopez?

Thanks,
Stefan

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6m+AUACgkQnKSrs4Gr
c8imWgf/V4XVxd+mfF/0LjS2cGvQJD+RnPu9weUhvBRIq/vNdeEeD0iGNWNIL/hM
YGnuLcWnkk02/Lx9riaHVyiM8/Qbn5mCy2O3akAzPAZOQNeDu8fR6Dz0yYONPNVy
eQ+oN1/GHAN5TJ43UcFLs61Cp9UQkko+5Rx5EcxL43UULGILYpN8SyfwidO+YhBm
6i2IqsQop/T7D4t5VLSZvXSvBtua4xDmFkQm4NHiA1yB3Se+q8MBpiRWTLbtrZVY
v5DInOiMEBIY7owjC1iD8Knx0HQpjZzDMxhqnC9hMTgC8of1BvzWdxIQk6zYGsXq
WBaI4wD39nIanroTQVExKX5F8H1wPg==
=MjR+
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--

