Date: Mon, 12 Aug 2019 11:05:46 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190812100546.GB9959@stefanha-x1.localdomain>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190807180355.GA22758@stefanha-x1.localdomain>
	<20190807205715.GE18557@redhat.com>
	<20190808090213.GD31476@stefanha-x1.localdomain>
	<20190808095316.GC2852@work-vm>
	<20190809082102.GB25286@stefanha-x1.localdomain>
	<277d9cd6-a8fa-fa1f-9cbc-7a7cd0897c84@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <277d9cd6-a8fa-fa1f-9cbc-7a7cd0897c84@huawei.com>
Subject: Re: [Virtio-fs] [PATCH 0/4] virtiofsd: multithreading preparation
 part 3
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>, qemu-devel@nongnu.org


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 11, 2019 at 10:26:18AM +0800, piaojun wrote:
> On 2019/8/9 16:21, Stefan Hajnoczi wrote:
> > On Thu, Aug 08, 2019 at 10:53:16AM +0100, Dr. David Alan Gilbert wrote:
> >> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> >>> On Wed, Aug 07, 2019 at 04:57:15PM -0400, Vivek Goyal wrote:
> >>> 3. Can READ/WRITE be performed directly in QEMU via a separate virtqu=
eue
> >>>    to eliminate the bad address problem?
> >>
> >> Are you thinking of doing all read/writes that way, or just the corner
> >> cases? It doesn't seem worth it for the corner cases unless you're
> >> finding them cropping up in real work loads.
> >=20
> > Send all READ/WRITE requests to QEMU instead of virtiofsd.
> >=20
> > Only handle metadata requests in virtiofsd (OPEN, RELEASE, READDIR,
> > MKDIR, etc).
> >=20
>=20
> Sorry for not catching your point, and I like the virtiofsd to do
> READ/WRITE requests and qemu handle metadata requests, as virtiofsd is
> good at processing dataplane things due to thread-pool and CPU
> affinity(maybe in the future). As you said, virtiofsd is just acting as
> a vhost-user device which should care less about ctrl request.
>=20
> If our concern is improving mmap/write/read performance, why not adding
> a delay worker for unmmap which could decrease the ummap times. Maybe
> virtiofsd could still handle both data and meta requests by this way.

Doing READ/WRITE in QEMU solves the problem that vhost-user slaves only
have access to guest RAM regions.  If a guest transfers other memory,
like an address in the DAX Window, to/from the vhost-user device then
virtqueue buffer address translation fails.

Dave added a code path that bounces such accesses through the QEMU
process using the VHOST_USER_SLAVE_FS_IO slavefd request, but it would
be simpler, faster, and cleaner to do I/O in QEMU in the first place.

What I don't like about moving READ/WRITE into QEMU is that we need to
use even more virtqueues for multiqueue operation :).

Stefan

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1ROfoACgkQnKSrs4Gr
c8i7pAf/UJVpVsfhaGANERAC2RS0451GRendQAyY7OIsHn/AcPA3FPs3trDolMFc
HH5/5KXVoXYdBNxmD2Y+k8snYxE/oIfACdOtxtcrv6UXz0qkd1AuJZPCofFReqhm
GpTrurV6GiITCQy4wa2rKSmLArsag6SZF/M6DJnHttuvqyPAphGsueP6yVF4ya5/
elPfokel4IgsoWUr1apQ1dFA4CQ4bZT3ETs9+gy0QnIf707qnaEnsGFfGopwYAXi
NVpVyBqSWERHpGvMZ588wBMXHcQmwrjuhK3JbXapae26uyaG0YhTxwQWpEsz+AdV
SA5gybi8yPaNdYoTXR2hNbPpHzPG/Q==
=NNAf
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--

