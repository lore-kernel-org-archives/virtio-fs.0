Date: Mon, 29 Jul 2019 09:21:49 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190729082149.GB3369@stefanha-x1.localdomain>
References: <20190726082933.13314-1-stefanha@redhat.com>
	<20190726203941.GA3706@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <20190726203941.GA3706@redhat.com>
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


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2019 at 04:39:41PM -0400, Vivek Goyal wrote:
> On Fri, Jul 26, 2019 at 09:29:33AM +0100, Stefan Hajnoczi wrote:
> > The device communicates FUSE_SETUPMAPPING/FUSE_REMOVMAPPING alignment
> > constraints via the FUST_INIT map_alignment field.  Parse this field and
> > ensure our DAX mappings meet the alignment constraints.
>=20
> Hi Stefan,
>=20
> To meet alignment constraints, we also need to make sure dax window
> start/end address is 2MB aligned as well?

No, because the mmap on the host is independent of the guest virtual
address at which the BAR is mapped inside the guest.

QEMU hw/virtio/vhost-user-fs.c:vuf_device_realize() mmaps the DAX window
on the host side and that's where the mmap alignment requirement is in
effect.

The guest can map the DAX window at any address compatible with its own
virtual memory constraints (i.e. page size).

Stefan

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0+rJ0ACgkQnKSrs4Gr
c8gw5Af7BMrjnBVenwkd3atS6jscLpzTVpASPVoJa+PAQmWTUhi4c8nxiwMNPeE0
7AGgNSzlXKuFDZID0N9DQegvIh2IUkaNc+fEPDoeHwydUZBeuQLI9gyxTCeTbrAW
h3PhfbsZk/H44GWtSJumuC3i1fAtgzYKjwasRseuSIUvDPg4xhg6kmHGFnVb2y0R
GvvssfwDJOTGKuGcYAPpOcIncdlQuVVNmqgCJPawqRMdjS2AXY0uG6koDJnZMwJe
ANWgMEyZbzxWp9qJSLz7nrv5We/XF7z9WuBqrsfWbTpBoVjUgti/Xsy5adTw3zeK
mP53UnppGEr6PVHYfL9lphyF71pw2A==
=Axqc
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--

