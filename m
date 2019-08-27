Date: Tue, 27 Aug 2019 14:33:47 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190827133347.GA6901@stefanha-x1.localdomain>
References: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
	<20190822134018.GJ20491@stefanha-x1.localdomain>
	<d9757234-dacd-9366-bcc7-19afe5af84a6@linux.alibaba.com>
	<20190823102624.GF12092@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20190823102624.GF12092@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [RFC PATCH 0/2] add stat tools for virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Gang Deng <gavin.dg@linux.alibaba.com>
Cc: virtio-fs@redhat.com


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2019 at 11:26:24AM +0100, Stefan Hajnoczi wrote:
> On Thu, Aug 22, 2019 at 10:41:48PM +0800, Gang Deng wrote:
> > On 2019/8/22 21:40, Stefan Hajnoczi wrote:
> > > On Mon, Aug 19, 2019 at 11:41:12AM +0800, Gang Deng wrote:
> > I think the difference of vtrae && qemu's tracing infrastructure looks =
like
> > that of /proc/diskstats(iostat) && blktrace(blkparse) for linux kernel'=
s block
> > device. It depends on the use case. I'll measure the cost later to see =
whether
> > qemu's tracer can meet our needs and whether it's enough to get statist=
ics.
>=20
> Tracetool supports multiple tracers.  I suggest trying LTTng Userspace
> Tracer because it is the lowest overhead tracer (using shared memory).
>=20
> https://lttng.org/docs/v2.10/#doc-lttng-ust
>=20
> I don't use LTTng much so I'm not sure how to consume a live trace from
> a custom tool like vstat.  I've asked on the LTTng IRC channel and will
> let you know what the answer is.

I asked on the LTTng IRC channel and it seems they currently don't offer
a public API for processing trace events in shared memory.  This makes
writing an efficient vstat tool using LTTng harder and there probably
won't be much difference compared to other tracers.

Stefan

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1lMTsACgkQnKSrs4Gr
c8jZXgf/S2ruqjkq5ihK5ldVa0wZLtoAZILlBy/TdjwoiBsYuPWjmWXpPRUW1CLn
kuepeaG1kj/lLGivy2uI1rYAY/gpWxJqszepsqQuUW2drZMpHnITpeOBqhLKwIcQ
Q5rCkwAsx7DwgrLR1M50LWGWGHIUx0Xjn3jPiED+DWs5vBr3c9umV0XJIyg7l/nc
fKCUb4FHvZwHHElEnOccA1IxvKiC05EuLtjD47qCSifvbQhu4ASVnU7+TFgsOZav
9oPgnVqyt/98hkcA9im/Sd0Uni2o43/ppD/KlsUeEhOqgh8EeViVbGdiYfMquH6l
yBwl31cizw8iSgMXDh2OJYDSk3O8+A==
=Jc5x
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--

