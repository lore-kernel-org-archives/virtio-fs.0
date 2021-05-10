Date: Mon, 10 May 2021 10:05:09 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJj3RSxXKZHxmiKu@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-27-dgilbert@redhat.com>
	<YJQNIPaFCJlG7ZKc@stefanha-x1.localdomain>
	<20210506160223.GA277745@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="w7Kh2C8x/BnrcDxV"
Content-Disposition: inline
In-Reply-To: <20210506160223.GA277745@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 26/26] virtiofsd: Ask qemu to drop
 CAP_FSETID if client asked for it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--w7Kh2C8x/BnrcDxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 06, 2021 at 12:02:23PM -0400, Vivek Goyal wrote:
> On Thu, May 06, 2021 at 04:37:04PM +0100, Stefan Hajnoczi wrote:
> > On Wed, Apr 28, 2021 at 12:01:00PM +0100, Dr. David Alan Gilbert (git) =
wrote:
> > > From: Vivek Goyal <vgoyal@redhat.com>
> > >=20
> > > If qemu guest asked to drop CAP_FSETID upon write, send that info
> > > to qemu in SLAVE_FS_IO message so that qemu can drop capability
> > > before WRITE. This is to make sure that any setuid bit is killed
> > > on fd (if there is one set).
> > >=20
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >=20
> > I'm not sure if the QEMU FSETID patches make sense. QEMU shouldn't be
> > running with FSETID because QEMU is untrusted. FSETGID would allow QEMU
> > to create setgid files, thereby potentially allowing an attacker to gain
> > any GID.
>=20
> Sure, its not recommended to run QEMU as root, but we don't block that
> either and I do regularly test with qemu running as root.
>=20
> >=20
> > I think it's better not to implement QEMU FSETID functionality at all
> > and to handle it another way.
>=20
> One way could be that virtiofsd tries to clear setuid bit after I/O
> has finished. But that will be non-atomic operation and it is filled
> with perils as it requires virtiofsd to know what all kernel will
> do if this write has been done with CAP_FSETID dropped.
>=20
> > In the worst case I/O requests should just
> > fail, it seems like a rare case anyway:
>=20
> Is there a way for virtiofsd to know if qemu is running with CAP_FSETID
> or not. If there is one, it might be reasonable to error out. If we
> don't know, then we can't fail all the operations.
>=20
> > I/O to a setuid/setgid file with
> > a memory buffer that is not mapped in virtiofsd.
>=20
> With DAX it is easily triggerable. User has to append to a setuid file
> in virtiofs and this path will trigger.
>=20
> I am fine with not supporting this patch but will also need a reaosonable
> alternative solution.

One way to avoid this problem is by introducing DMA read/write functions
into the vhost-user protocol that can be used by all device types, not
just virtio-fs.

Today virtio-fs uses the IO slave request when it cannot access a region
of guest memory. It sends the file descriptor to QEMU and QEMU performs
the pread(2)/pwrite(2) on behalf of virtiofsd.

I mentioned in the past that this solution is over-specialized. It
doesn't solve the larger problem that vhost-user processes do not have
full access to the guest memory space (e.g. DAX window).

Instead of sending file I/O requests over to QEMU, the vhost-user
protocol should offer DMA read/write requests so any vhost-user process
can access the guest memory space where vhost's shared memory mechanism
is insufficient.

Here is how it would work:

1. Drop the IO slave request, replace it with DMA read/write slave
   requests.

   Note that these new requests can also be used in environments where
   maximum vIOMMU isolation is needed for security reasons and sharing
   all of guest RAM with the vhost-user process is considered
   unacceptable.

2. When virtqueue buffer mapping fails, send DMA read/write slave
   requests to transfer the data from/to QEMU. virtiofsd calls
   pread(2)/pwrite(2) itself with virtiofsd's Linux capabilities.

Stefan

--w7Kh2C8x/BnrcDxV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCY90UACgkQnKSrs4Gr
c8h3BwgAlI/ulK96gITaB0xcY0/luVnA4z75w7jGSqtRYR0y6o6YN/n5u2BVBG4f
iG1gi/KEAkNCgQ0c9WWyxZ9nc67gkaH7flriZm468HeE3bcMbY/cSN6CL9domICz
2OP/Zto5FudIvGh8zub0+A+Z2F+rxl/yHVTqaIntccEnmaif+OYScRdL6Y/X+w2h
hPm1AqX0GWpxAEABh+DiW4HhYisoZL/02qDgAPd9J4ODP1MbujExtP5+UjWN5wFJ
giEYCyQCtktPISDBx0D7ZLY74g0/kc1mExAoiZBP0tCFOlwP8g16uugadvECNrHm
hAEEYkUcKBkIXKhxCBa4yGe5LI/1JA==
=9W8O
-----END PGP SIGNATURE-----

--w7Kh2C8x/BnrcDxV--

