Date: Fri, 1 May 2020 16:47:52 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200501154752.GA222606@stefanha-x1.localdomain>
References: <20200424062540.23679-1-chirantan@chromium.org>
	<20200424062540.23679-2-chirantan@chromium.org>
	<20200427151934.GB1042399@stefanha-x1.localdomain>
	<CAJFHJrr2DAgQC9ZWx78OudX1x6A57_vpLf4rJu80ceR6bnpbaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <CAJFHJrr2DAgQC9ZWx78OudX1x6A57_vpLf4rJu80ceR6bnpbaQ@mail.gmail.com>
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


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 01, 2020 at 04:14:38PM +0900, Chirantan Ekbote wrote:
> On Tue, Apr 28, 2020 at 12:20 AM Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
> > On Fri, Apr 24, 2020 at 03:25:40PM +0900, Chirantan Ekbote wrote:
> > Even if you don't care about SMP performance, using multiqueue as a
> > workaround for missing request parallelism still won't yield the best
> > results.  The guest should be able to submit up to the maximum queue
> > depth of the physical storage device.  Many Linux block drivers have max
> > queue depths of 64.  This would require 64 virtqueues (plus the queue
> > selection algorithm would have to utilize each one) and shows how
> > wasteful this approach is.
> >
>=20
> I understand this but in practice unlike the virtio-blk workload,
> which is nothing but reads and writes to a single file, the virtio-fs
> workload tends to mix a bunch of metadata operations with data
> transfers.  The metadata operations should be mostly handled out of
> the host's file cache so it's unlikely virtio-fs would really be able
> to fully utilize the underlying storage short of reading or writing a
> really huge file.

I agree that a proportion of heavy I/O workloads on virtio-blk become
heavy metadata I/O workloads on virtio-fs.

However, workloads consisting mostly of READ, WRITE, and FLUSH
operations still exist on virtio-fs.  Databases, audio/video file
streaming, etc are bottlenecked on I/O performance.  They need to
perform well and virtio-fs should strive to do that.

> > Instead of modifying the guest driver, please implement request
> > parallelism in your device implementation.
>=20
> Yes, we have tried this already [1][2].  As I mentioned above, having
> additional threads in the server actually made performance worse.  My
> theory is that when the device only has 2 cpus, having additional
> threads on the host that need cpu time ends up taking time away from
> the guest vcpu.  We're now looking at switching to io_uring so that we
> can submit multiple requests from a single thread.

The host has 2 CPUs?  How many vCPUs does the guest have?  What is the
physical storage device?  What is the host file system?

io_uring's vocabulary is expanding.  It can now do openat2(2), close(2),
statx(2), but not mkdir(2), unlink(2), rename(2), etc.

I guess there are two options:
1. Fall back to threads for FUSE operations that cannot yet be done via
   io_uring.
2. Process FUSE operations that cannot be done via io_uring
   synchronously.

Stefan

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6sRKgACgkQnKSrs4Gr
c8h8+Qf+OzvyP48D9hLuOZVVhenfnSlBCUT6zBp/IW7s/1jEcFk7ZGrJkjzkxUuA
tqKIFIwb9boA3A6LmsXcRm14pzJUsSRNzsghQIgXF8xKU3l7DZoAva+7rft4vaac
FnOvkrLc8iwqv+dAPyKB1JOo0OGarOBwqBOEQxzV8tNMM9nDEgs2TgrvuU/+10vi
+STUtM0lZ4WnXBU0gJsRph4oUlPZ1CWESFBtixUxCpYm3pJMm2slzWucBqRq4Vh9
HhQxqORs4MVGxu9jFx0hrfUSv9OLOEn8JBWXX2c2qOb4UiplLRytaDel17broZfv
9afiTkvNatBw3tiDZLGholv0gjZq6A==
=K5hN
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--

