Date: Wed, 31 Mar 2021 11:12:33 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YGRLERYNqhZrsWiK@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-17-dgilbert@redhat.com>
	<20210211141734.GQ247031@stefanha-x1.localdomain>
	<YFEOP+zJF4ciZ3ap@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bDzkdXzQdU6j8nqA"
Content-Disposition: inline
In-Reply-To: <YFEOP+zJF4ciZ3ap@work-vm>
Subject: Re: [Virtio-fs] [PATCH 16/24] DAX/unmap: virtiofsd: Add
	VHOST_USER_SLAVE_FS_IO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com


--bDzkdXzQdU6j8nqA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 16, 2021 at 07:59:59PM +0000, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > On Tue, Feb 09, 2021 at 07:02:16PM +0000, Dr. David Alan Gilbert (git) =
wrote:
> > > +            if (!mrs_size) {
> > > +                error_report("No guest region found for 0x%" HWADDR_=
PRIx, gpa);
> > > +                res =3D -EFAULT;
> > > +                break;
> > > +            }
> > > +
> > > +            trace_vhost_user_fs_slave_io_loop(mrs.mr->name,
> > > +                                          (uint64_t)mrs.offset_withi=
n_region,
> > > +                                          memory_region_is_ram(mrs.m=
r),
> > > +                                          memory_region_is_romd(mrs.=
mr),
> > > +                                          (size_t)mrs_size);
> > > +
> > > +            void *hostptr =3D qemu_map_ram_ptr(mrs.mr->ram_block,
> > > +                                             mrs.offset_within_regio=
n);
> > > +            ssize_t transferred;
> > > +            if (sm->flags[i] & VHOST_USER_FS_FLAG_MAP_R) {
> >=20
> > The flag name is specific to map requests but it's shared with the IO
> > request. Perhaps rename the flags?
>=20
> They're both read/write's; do you have a preferred alternative?

VHOST_USER_FS_FLAG_<what it does> (read? readwrite? etc)

Stefan

--bDzkdXzQdU6j8nqA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBkSxEACgkQnKSrs4Gr
c8jfDAf+L4BV1nKhkV3QM9yHyn2ypD2dql7Qt780o5QMbd7zpNHdMifVuOcNA6LH
f3lqPQ6+NnQXjsOjiJNgkJ4Yd/AW1nNi4YitlYtDpf7p62fwGZjfUc/FJwvo0gih
vb1qEoskPLWChQuh6SGGL/pFV+B8vCKsSlXI7pKoRLuz/96ezJXOEAKSYK3M5/yh
mYSfGz7r5bLNM7rn6zRsINziPhCYxeISR+dh9qSL4vDGxFmywxdQ+aWHZyKTzWtn
03nUiG7ah40uRudsA7ewn3gdqXJg0GdZPhTg2qA5w/jJyoUW+zlIQ6yugumN+C2n
JPKb2Xg3/c916R0C6F4IvWnAKYVK7g==
=Ny5n
-----END PGP SIGNATURE-----

--bDzkdXzQdU6j8nqA--

