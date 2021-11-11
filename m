Date: Thu, 11 Nov 2021 16:31:52 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YY1FeMyvTOOWYEhV@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<2300275.fgjvgC56zr@silver>
	<YYvhy5Lm7YaqCWix@stefanha-x1.localdomain>
	<1965987.S3ubrJPkfX@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8umAcu99m7SDsc3t"
Content-Disposition: inline
In-Reply-To: <1965987.S3ubrJPkfX@silver>
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtio: increase VIRTQUEUE_MAX_SIZE
	to 32k
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, Raphael Norwitz <raphael.norwitz@nutanix.com>


--8umAcu99m7SDsc3t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 10, 2021 at 04:53:33PM +0100, Christian Schoenebeck wrote:
> On Mittwoch, 10. November 2021 16:14:19 CET Stefan Hajnoczi wrote:
> > On Wed, Nov 10, 2021 at 02:14:43PM +0100, Christian Schoenebeck wrote:
> > > On Mittwoch, 10. November 2021 11:05:50 CET Stefan Hajnoczi wrote:
> > > As you are apparently reluctant for changing the virtio specs, what a=
bout
> > > introducing those discussed virtio capabalities either as experimental
> > > ones
> > > without specs changes, or even just as 9p specific device capabilitie=
s for
> > > now. I mean those could be revoked on both sides at any time anyway.
> >=20
> > I would like to understand the root cause before making changes.
> >=20
> > "It's faster when I do X" is useful information but it doesn't
> > necessarily mean doing X is the solution. The "it's faster when I do X
> > because Y" part is missing in my mind. Once there is evidence that shows
> > Y then it will be clearer if X is a good solution, if there's a more
> > general solution, or if it was just a side-effect.
>=20
> I think I made it clear that the root cause of the observed performance g=
ain=20
> with rising transmission size is latency (and also that performance is no=
t the=20
> only reason for addressing this queue size issue).
>=20
> Each request roundtrip has a certain minimum latency, the virtio ring alo=
ne=20
> has its latency, plus latency of the controller portion of the file serve=
r=20
> (e.g. permissions, sandbox checks, file IDs) that is executed with *every=
*=20
> request, plus latency of dispatching the request handling between threads=
=20
> several times back and forth (also for each request).
>=20
> Therefore when you split large payloads (e.g. reading a large file) into=
=20
> smaller n amount of chunks, then that individual latency per request=20
> accumulates to n times the individual latency, eventually leading to degr=
aded=20
> transmission speed as those requests are serialized.

It's easy to increase the blocksize in benchmarks, but real applications
offer less control over the I/O pattern. If latency in the device
implementation (QEMU) is the root cause then reduce the latency to speed
up all applications, even those that cannot send huge requests.

One idea is request merging on the QEMU side. If the application sends
10 sequential read or write requests, coalesce them together before the
main part of request processing begins in the device. Process a single
large request to spread the cost of the file server over the 10
requests. (virtio-blk has request merging to help with the cost of lots
of small qcow2 I/O requests.) The cool thing about this is that the
guest does not need to change its I/O pattern to benefit from the
optimization.

Stefan

--8umAcu99m7SDsc3t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmGNRXgACgkQnKSrs4Gr
c8iGFggAv4oGiMttfre5NapGzSdD/VF4Pm7sQUgs7v3CBlUtsyiBSExNrEtTpWdw
/9RDjpLVxcsStB5rnQtQ6Dk8AqAFuetwRdVMUMUmjouY1sGl263h78L6LeWJ9HnC
5QYd7Hy600+ldKtRoFqHOwpqpoGtTOStfxiOFiR0ievwkX0kUeHE81EBmkqbjBEm
Mlmgu+BdJWGxtpPQm/1m2vG21+xOXWxuwOzDwIx7mpZGUaNUqteueBhdw1Fl0n1y
GwviY3a4sW00x1n31by8KQ2laZbxnV5hwMwJ9Kae+aPDdNvSPi5HqD3OqHrn3eBI
Lg5js5lrBMIjm0FH15JRAFUeiDJ49g==
=xKav
-----END PGP SIGNATURE-----

--8umAcu99m7SDsc3t--

