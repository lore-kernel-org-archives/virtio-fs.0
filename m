Date: Thu, 7 Oct 2021 16:42:49 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YV8VeaWiwD8DRFtz@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<YV6EbwMFmcIEC+za@stefanha-x1.localdomain>
	<2233456.PtHKNz60go@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="epQAIsb/jN3pWb0S"
Content-Disposition: inline
In-Reply-To: <2233456.PtHKNz60go@silver>
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


--epQAIsb/jN3pWb0S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 07, 2021 at 02:51:55PM +0200, Christian Schoenebeck wrote:
> On Donnerstag, 7. Oktober 2021 07:23:59 CEST Stefan Hajnoczi wrote:
> > On Mon, Oct 04, 2021 at 09:38:00PM +0200, Christian Schoenebeck wrote:
> > > At the moment the maximum transfer size with virtio is limited to 4M
> > > (1024 * PAGE_SIZE). This series raises this limit to its maximum
> > > theoretical possible transfer size of 128M (32k pages) according to t=
he
> > > virtio specs:
> > >=20
> > > https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.=
html#
> > > x1-240006
> > Hi Christian,
> > I took a quick look at the code:
> >=20
> > - The Linux 9p driver restricts descriptor chains to 128 elements
> >   (net/9p/trans_virtio.c:VIRTQUEUE_NUM)
>=20
> Yes, that's the limitation that I am about to remove (WIP); current kerne=
l=20
> patches:
> https://lore.kernel.org/netdev/cover.1632327421.git.linux_oss@crudebyte.c=
om/

I haven't read the patches yet but I'm concerned that today the driver
is pretty well-behaved and this new patch series introduces a spec
violation. Not fixing existing spec violations is okay, but adding new
ones is a red flag. I think we need to figure out a clean solution.

> > - The QEMU 9pfs code passes iovecs directly to preadv(2) and will fail
> >   with EINVAL when called with more than IOV_MAX iovecs
> >   (hw/9pfs/9p.c:v9fs_read())
>=20
> Hmm, which makes me wonder why I never encountered this error during test=
ing.
>=20
> Most people will use the 9p qemu 'local' fs driver backend in practice, s=
o=20
> that v9fs_read() call would translate for most people to this implementat=
ion=20
> on QEMU side (hw/9p/9p-local.c):
>=20
> static ssize_t local_preadv(FsContext *ctx, V9fsFidOpenState *fs,
>                             const struct iovec *iov,
>                             int iovcnt, off_t offset)
> {
> #ifdef CONFIG_PREADV
>     return preadv(fs->fd, iov, iovcnt, offset);
> #else
>     int err =3D lseek(fs->fd, offset, SEEK_SET);
>     if (err =3D=3D -1) {
>         return err;
>     } else {
>         return readv(fs->fd, iov, iovcnt);
>     }
> #endif
> }
>=20
> > Unless I misunderstood the code, neither side can take advantage of the
> > new 32k descriptor chain limit?
> >=20
> > Thanks,
> > Stefan
>=20
> I need to check that when I have some more time. One possible explanation=
=20
> might be that preadv() already has this wrapped into a loop in its=20
> implementation to circumvent a limit like IOV_MAX. It might be another "i=
t=20
> works, but not portable" issue, but not sure.
>
> There are still a bunch of other issues I have to resolve. If you look at
> net/9p/client.c on kernel side, you'll notice that it basically does this=
 ATM
>=20
>     kmalloc(msize);
>=20
> for every 9p request. So not only does it allocate much more memory for e=
very=20
> request than actually required (i.e. say 9pfs was mounted with msize=3D8M=
, then=20
> a 9p request that actually would just need 1k would nevertheless allocate=
 8M),=20
> but also it allocates > PAGE_SIZE, which obviously may fail at any time.

The PAGE_SIZE limitation sounds like a kmalloc() vs vmalloc() situation.

I saw zerocopy code in the 9p guest driver but didn't investigate when
it's used. Maybe that should be used for large requests (file
reads/writes)? virtio-blk/scsi don't memcpy data into a new buffer, they
directly access page cache or O_DIRECT pinned pages.

Stefan

--epQAIsb/jN3pWb0S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFfFXkACgkQnKSrs4Gr
c8iaZQf/ZVwABlkbtrQRDNCsR25aycD9AB/7q3BPym+l38aKwaAAxgsbXO3i3OV9
NU+Q7crHqo3amfDhv5Fu0MOML1gw/pDj4mYJCZ0jBrG3Fztmo17R5NehXEc1NfmK
HRs1micAV0IPyYCF/BuDe78nv1fSrfZ1zcW0LXp/dFKFotXq2NGUh0nOZHVXzIrS
ZEaD5quVWv2rBcrNY3pz9Uc671RZy4Jue9PiSI4lV7C1JoeMfi9r/FogFiC0c67w
OMZBq0wS4yK3xg2JAZipjNXLXnrqAw5t2Ymc0lewYqu6JB8VlewwxCxXyWz7P0RL
GoONVlq9EpDAttmRFTQAkoNnZxs/nA==
=NoiZ
-----END PGP SIGNATURE-----

--epQAIsb/jN3pWb0S--

