Date: Mon, 22 Mar 2021 15:47:37 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YFi8GYrRG/ks2BBz@stefanha-x1.localdomain>
References: <20210318135223.1342795-1-ckuehl@redhat.com>
	<20210318135223.1342795-3-ckuehl@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EBlwIFYriryzFVKW"
Content-Disposition: inline
In-Reply-To: <20210318135223.1342795-3-ckuehl@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/3] virtiofs: split requests that exceed
	virtqueue size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: miklos@szeredi.hu, jasowang@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com


--EBlwIFYriryzFVKW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 18, 2021 at 08:52:22AM -0500, Connor Kuehl wrote:
> If an incoming FUSE request can't fit on the virtqueue, the request is
> placed onto a workqueue so a worker can try to resubmit it later where
> there will (hopefully) be space for it next time.
>=20
> This is fine for requests that aren't larger than a virtqueue's maximum
> capacity. However, if a request's size exceeds the maximum capacity of
> the virtqueue (even if the virtqueue is empty), it will be doomed to a
> life of being placed on the workqueue, removed, discovered it won't fit,
> and placed on the workqueue yet again.
>=20
> Furthermore, from section 2.6.5.3.1 (Driver Requirements: Indirect
> Descriptors) of the virtio spec:
>=20
>   "A driver MUST NOT create a descriptor chain longer than the Queue
>   Size of the device."
>=20
> To fix this, limit the number of pages FUSE will use for an overall
> request. This way, each request can realistically fit on the virtqueue
> when it is decomposed into a scattergather list and avoid violating
> section 2.6.5.3.1 of the virtio spec.
>=20
> Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
> ---
>  fs/fuse/fuse_i.h    |  5 +++++
>  fs/fuse/inode.c     |  7 +++++++
>  fs/fuse/virtio_fs.c | 14 ++++++++++++++
>  3 files changed, 26 insertions(+)

Nice that FUSE already has max_pages :-).

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--EBlwIFYriryzFVKW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBYvBkACgkQnKSrs4Gr
c8gL7Qf+MIRWqCCYkNEZwL6tftu8+lg4QxBigZvpmryZKX9xCLbLzcTZuUzPQC6I
HiFj77t2jUhUbSv9edImKSWoSYad0kT0bCsWnwghojx+ta5lIXveKMwv4qHCkF9J
CsnZqKYSW+9gCyjC/mCLLl1lHKSoSHJsDSVuJQ7gwlGg1n1Bv5IKE4ZX2+hlXGY3
FWtCTz17sqzrlCIceUnG5jN10TcXqsXSDEH3oOV6ZSWl8HTXWFyJjcRWau4u9S2R
iIZJEcByDMVqWWCHWVySksdompYzM9xFbXLebPE5Rnn9BaK5m/BdISHbS1R5dZaU
LPExG+DiEtEx/j/imqIq7YtJlXxA5g==
=KXHl
-----END PGP SIGNATURE-----

--EBlwIFYriryzFVKW--

