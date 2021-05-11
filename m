Date: Tue, 11 May 2021 09:22:24 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJo+wCSffIZAx9aM@stefanha-x1.localdomain>
References: <20210215095410.85607-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LfalMhQMl7yvqHbp"
Content-Disposition: inline
In-Reply-To: <20210215095410.85607-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [virtio-dev] [PATCH v2 0/2] virtio-fs: add
	notification queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-dev@lists.oasis-open.org
Cc: virtio-fs@redhat.com, vgoyal@redhat.com


--LfalMhQMl7yvqHbp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 15, 2021 at 09:54:08AM +0000, Stefan Hajnoczi wrote:
> v2:
>  * Document empty virtqueue behavior for FUSE_NOTIFY_LOCK messages
>=20
> This patch series adds the notification queue to the VIRTIO specification.
> This new virtqueue carries device->driver FUSE notify messages.  They are
> currently unused but will be necessary for file locking, which can block =
for an
> unbounded amount of time and therefore needs a asynchronous completion ev=
ent
> instead of a request/response buffer that consumes space in the request
> virtqueue until the operation completes.
>=20
> Patch 1 corrects an oversight I noticed: the file system device was not a=
dded
> to the Conformance chapter.
>=20
> Stefan Hajnoczi (2):
>   virtio-fs: add file system device to Conformance chapter
>   virtio-fs: add notification queue
>=20
>  conformance.tex | 23 ++++++++++++++++
>  virtio-fs.tex   | 71 ++++++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 84 insertions(+), 10 deletions(-)

Reminder to anyone who needs the virtio-fs notification queue: please
review this series.

Stefan

--LfalMhQMl7yvqHbp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCaPsAACgkQnKSrs4Gr
c8jKyAgAvdV9eWuyUEztvoyXM+DmDjaGoya9E75/2TSVOTioENHkACoOfdu7vKpk
u2PaeWVOKMqFgnyUdmvZyEHgZmT821sjmjR0491ZS8CYFP9M25bUoKZSPHT8MyFd
epaa6jREdOU3/Z3dUQthtB+hefcsqH9MgBuQ/UktpTvahqILTE2G09wqlEO5svDJ
Ivb19YkalCTqimae+QNEwquLM2Cp3Lq+TWPnQ8h+T/HE8svpITU5tw5fpOxMvWru
aas8EGj4TUSH+nH4QCD21LlWt/MiAjRKSdQYi+96tzEtQqW2URFmzvMQ6ZAz4GYA
0jT0lCkGED7eyaS1y5R3MhQVAezzBA==
=jaJA
-----END PGP SIGNATURE-----

--LfalMhQMl7yvqHbp--

