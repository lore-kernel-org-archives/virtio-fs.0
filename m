Date: Mon, 29 Jul 2019 16:21:14 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190729152114.GA21033@stefanha-x1.localdomain>
References: <20190726082933.13314-1-stefanha@redhat.com>
	<20190726203941.GA3706@redhat.com>
	<20190729082149.GB3369@stefanha-x1.localdomain>
	<20190729124816.GA630@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20190729124816.GA630@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] fuse: implement FUSE_INIT map_alignment
	field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <mszeredi@redhat.com>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2019 at 08:48:16AM -0400, Vivek Goyal wrote:
> On Mon, Jul 29, 2019 at 09:21:49AM +0100, Stefan Hajnoczi wrote:
> > On Fri, Jul 26, 2019 at 04:39:41PM -0400, Vivek Goyal wrote:
> > > On Fri, Jul 26, 2019 at 09:29:33AM +0100, Stefan Hajnoczi wrote:
> > > > The device communicates FUSE_SETUPMAPPING/FUSE_REMOVMAPPING alignme=
nt
> > > > constraints via the FUST_INIT map_alignment field.  Parse this fiel=
d and
> > > > ensure our DAX mappings meet the alignment constraints.
> > >=20
> > > Hi Stefan,
> > >=20
> > > To meet alignment constraints, we also need to make sure dax window
> > > start/end address is 2MB aligned as well?
> >=20
> > No, because the mmap on the host is independent of the guest virtual
> > address at which the BAR is mapped inside the guest.
> >=20
> > QEMU hw/virtio/vhost-user-fs.c:vuf_device_realize() mmaps the DAX window
> > on the host side and that's where the mmap alignment requirement is in
> > effect.
>=20
> Ok.
>=20
> What about checking alignment constratins on inarg.moffset and
> inarg.foffset in fuse_setup_one_mapping().

foffset is already implicitly checked:

WARN_ON(offset % FUSE_DAX_MEM_RANGE_SZ);

And moffset is a multiple of FUSE_DAX_MEM_RANGE_SZ.

FUSE_DAX_MEM_RANGE_SZ was already checked against map_alignment when the
FUSE_INIT response was processed, so we're good here.

Stefan

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0/DuoACgkQnKSrs4Gr
c8jAewgAjvTWBWMvaG/82K2gtEHgBUX+fhfPcf8tSsFNjRT/pBo1SLsbcmMhA7hP
C+mJ1qJf0+1Qvhf6sqKKQk6nSdcC2l1vt1/4rSyEvpOK6e+you9BH/bBW020VAtG
VY+PK44OcWKdyLLVwzXlHtl7EBqBcqH5/6IMxF7u9+LJMVWHUG+yQV1o3BgcWgI2
92/u4QjSgvIjd2XBz6taSUUIQJFSUgpub1FNQ0WH63wBOImSaIFTeNATELWLFHFI
90w3Yg1wMwWllT97oyQvpfebrMGi4G0yFMpsFVS7CVOsyF6C4NRjKfPUei4gKadF
ZMDAKtvKdV+01qWR8kFe1zxBnKsFHQ==
=/4jM
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--

