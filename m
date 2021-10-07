Date: Thu, 7 Oct 2021 06:23:59 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YV6EbwMFmcIEC+za@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LLz5XnO6Go+Dl95d"
Content-Disposition: inline
In-Reply-To: <cover.1633376313.git.qemu_oss@crudebyte.com>
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
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>


--LLz5XnO6Go+Dl95d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 04, 2021 at 09:38:00PM +0200, Christian Schoenebeck wrote:
> At the moment the maximum transfer size with virtio is limited to 4M
> (1024 * PAGE_SIZE). This series raises this limit to its maximum
> theoretical possible transfer size of 128M (32k pages) according to the
> virtio specs:
>=20
> https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html=
#x1-240006

Hi Christian,
I took a quick look at the code:

- The Linux 9p driver restricts descriptor chains to 128 elements
  (net/9p/trans_virtio.c:VIRTQUEUE_NUM)

- The QEMU 9pfs code passes iovecs directly to preadv(2) and will fail
  with EINVAL when called with more than IOV_MAX iovecs
  (hw/9pfs/9p.c:v9fs_read())

Unless I misunderstood the code, neither side can take advantage of the
new 32k descriptor chain limit?

Thanks,
Stefan

--LLz5XnO6Go+Dl95d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFehGkACgkQnKSrs4Gr
c8jj7gf9EP8iLDkVsPB3DsimosA2K+3PrRXVRZWUEysCY3blc2e8dVorH4rww8C/
vwch1sIXYASWLhrVEWFpMhKFQZCsh29C+t0q2frOrpnsjejrCJHlf+FLStR+FOiD
Db/ayZJHInR7nb6slwIB9gGPPNILC1xFQ/8WbLB6WjHIsG73Ur8vLK4+UT7/ch09
Ujos43uYCTYGpETa896a9cVxqAyo7BLzXng3uunl52Npwr77VQEvqzAoHAKGgZ1f
ByC8/QpNHVbyb/r5U85NOHBsmz7/a4xpAKY3Yhl/UO0fXeAeJ90ulxyLVVXxeeBn
f9aWXdSM66XYPVv3cMKPfTDpxys6Ag==
=RoOJ
-----END PGP SIGNATURE-----

--LLz5XnO6Go+Dl95d--

