Date: Fri, 8 Oct 2021 10:27:01 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20211008102701.59f7d8cd@bahia.huguette>
In-Reply-To: <20211008092533.376b568b@bahia.huguette>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<YV6EbwMFmcIEC+za@stefanha-x1.localdomain>
	<2233456.PtHKNz60go@silver>
	<YV8VeaWiwD8DRFtz@stefanha-x1.localdomain>
	<20211008092533.376b568b@bahia.huguette>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2X0SMrq2HtjoB4IVTwvJP0l";
	protocol="application/pgp-signature"; micalg=pgp-sha256
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Zheng <fam@euphon.net>, Jason, "Michael S. Tsirkin" <mst@redhat.com>, Wang <jasowang@redhat.com>, Schoenebeck <qemu_oss@crudebyte.com>, qemu-devel@nongnu.org, Gerd@redhat.com, Hoffmann <kraxel@redhat.com>, virtio-fs@redhat.com, qemu-block@nongnu.org, David Hildenbrand <david@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Christian, Amit Shah <amit@kernel.org>, Eric Auger <eric.auger@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Norwitz <raphael.norwitz@nutanix.com>, Raphael, Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>

--Sig_/2X0SMrq2HtjoB4IVTwvJP0l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Oct 2021 09:25:33 +0200
Greg Kurz <groug@kaod.org> wrote:

> On Thu, 7 Oct 2021 16:42:49 +0100
> Stefan Hajnoczi <stefanha@redhat.com> wrote:
>=20
> > On Thu, Oct 07, 2021 at 02:51:55PM +0200, Christian Schoenebeck wrote:
> > > On Donnerstag, 7. Oktober 2021 07:23:59 CEST Stefan Hajnoczi wrote:
> > > > On Mon, Oct 04, 2021 at 09:38:00PM +0200, Christian Schoenebeck wro=
te:
> > > > > At the moment the maximum transfer size with virtio is limited to=
 4M
> > > > > (1024 * PAGE_SIZE). This series raises this limit to its maximum
> > > > > theoretical possible transfer size of 128M (32k pages) according =
to the
> > > > > virtio specs:
> > > > >=20
> > > > > https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-c=
s01.html#
> > > > > x1-240006
> > > > Hi Christian,
> > > > I took a quick look at the code:
> > > >=20
>=20
>=20
> Hi,
>=20
> Thanks Stefan for sharing virtio expertise and helping Christian !
>=20
> > > > - The Linux 9p driver restricts descriptor chains to 128 elements
> > > >   (net/9p/trans_virtio.c:VIRTQUEUE_NUM)
> > >=20
> > > Yes, that's the limitation that I am about to remove (WIP); current k=
ernel=20
> > > patches:
> > > https://lore.kernel.org/netdev/cover.1632327421.git.linux_oss@crudeby=
te.com/
> >=20
> > I haven't read the patches yet but I'm concerned that today the driver
> > is pretty well-behaved and this new patch series introduces a spec
> > violation. Not fixing existing spec violations is okay, but adding new
> > ones is a red flag. I think we need to figure out a clean solution.
> >=20
> > > > - The QEMU 9pfs code passes iovecs directly to preadv(2) and will f=
ail
> > > >   with EINVAL when called with more than IOV_MAX iovecs
> > > >   (hw/9pfs/9p.c:v9fs_read())
> > >=20
> > > Hmm, which makes me wonder why I never encountered this error during =
testing.
> > >=20
> > > Most people will use the 9p qemu 'local' fs driver backend in practic=
e, so=20
> > > that v9fs_read() call would translate for most people to this impleme=
ntation=20
> > > on QEMU side (hw/9p/9p-local.c):
> > >=20
> > > static ssize_t local_preadv(FsContext *ctx, V9fsFidOpenState *fs,
> > >                             const struct iovec *iov,
> > >                             int iovcnt, off_t offset)
> > > {
> > > #ifdef CONFIG_PREADV
> > >     return preadv(fs->fd, iov, iovcnt, offset);
> > > #else
> > >     int err =3D lseek(fs->fd, offset, SEEK_SET);
> > >     if (err =3D=3D -1) {
> > >         return err;
> > >     } else {
> > >         return readv(fs->fd, iov, iovcnt);
> > >     }
> > > #endif
> > > }
> > >=20
> > > > Unless I misunderstood the code, neither side can take advantage of=
 the
> > > > new 32k descriptor chain limit?
> > > >=20
> > > > Thanks,
> > > > Stefan
> > >=20
> > > I need to check that when I have some more time. One possible explana=
tion=20
> > > might be that preadv() already has this wrapped into a loop in its=20
> > > implementation to circumvent a limit like IOV_MAX. It might be anothe=
r "it=20
> > > works, but not portable" issue, but not sure.
> > >
> > > There are still a bunch of other issues I have to resolve. If you loo=
k at
> > > net/9p/client.c on kernel side, you'll notice that it basically does =
this ATM
> > >=20
> > >     kmalloc(msize);
> > >=20
>=20
> Note that this is done twice : once for the T message (client request) an=
d once
> for the R message (server answer). The 9p driver could adjust the size of=
 the T
> message to what's really needed instead of allocating the full msize. R m=
essage
> size is not known though.
>=20
> > > for every 9p request. So not only does it allocate much more memory f=
or every=20
> > > request than actually required (i.e. say 9pfs was mounted with msize=
=3D8M, then=20
> > > a 9p request that actually would just need 1k would nevertheless allo=
cate 8M),=20
> > > but also it allocates > PAGE_SIZE, which obviously may fail at any ti=
me.
> >=20
> > The PAGE_SIZE limitation sounds like a kmalloc() vs vmalloc() situation.
> >=20
> > I saw zerocopy code in the 9p guest driver but didn't investigate when
> > it's used. Maybe that should be used for large requests (file
> > reads/writes)?
>=20
> This is the case already : zero-copy is only used for reads/writes/readdir
> if the requested size is 1k or more.
>=20
> Also you'll note that in this case, the 9p driver doesn't allocate msize
> for the T/R messages but only 4k, which is largely enough to hold the
> header.
>=20
> 	/*
> 	 * We allocate a inline protocol data of only 4k bytes.
> 	 * The actual content is passed in zero-copy fashion.
> 	 */
> 	req =3D p9_client_prepare_req(c, type, P9_ZC_HDR_SZ, fmt, ap);
>=20
> and
>=20
> /* size of header for zero copy read/write */
> #define P9_ZC_HDR_SZ 4096
>=20
> A huge msize only makes sense for Twrite, Rread and Rreaddir because
> of the amount of data they convey. All other messages certainly fit
> in a couple of kilobytes only (sorry, don't remember the numbers).
>=20
> A first change should be to allocate MIN(XXX, msize) for the
> regular non-zc case, where XXX could be a reasonable fixed
> value (8k?).=20


Note that this would violate the 9p spec since the server
can legitimately use the negotiated msize for all R messages
even if all of them only need a couple of bytes in practice,
at worse a couple of kilobytes if a path is involved.

In a ideal world, this would call for a spec refinement to
special case Rread and Rreaddir, which are the only ones
where a high msize is useful AFAICT.

> In the case of T messages, it is even possible
> to adjust the size to what's exactly needed, ala snprintf(NULL).
>=20
> > virtio-blk/scsi don't memcpy data into a new buffer, they
> > directly access page cache or O_DIRECT pinned pages.
> >=20
> > Stefan
>=20
> Cheers,
>=20
> --
> Greg


--Sig_/2X0SMrq2HtjoB4IVTwvJP0l
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtIKLr5QxQM7yo0kQcdTV5YIvc9YFAmFgANUACgkQcdTV5YIv
c9ZTUA//ap7D5YkQcQ9Yrgs6z8bAln++wwuTYWHP4PJQIk68LSDR6CsKavVcDh0q
C423RZRMVbjt+EjUFOGi0WqSF7jHwC6Gn92oMdp/QgH4j8zK6cW9dULeEl8W+cum
aEEYgTR24ldS4vi8buto914PFPMQlYn61f12K2ALBCxqcnN73orRuF6Znc+bZtkM
obJNN8MTebwTRsolqnsMfWZ/V6dq06c1Zl0vMqhqXEmlyhXpHz8tsj2Xrc8yHRG3
YQ1yMW38Hsv41NgcpX9BTafAds4/5F9avxzc44u1ZjLNliGVWEsEq+/TJDKjMUfx
yr/GgOxAmhzNFOnDUNXoGVFy1GXnYKJkDzu0MTD5zLGa9rBO1c2wmPZt8ebsn16v
EYKc6dOheyItANaIFV7JpbBp1YQc8xaImWUTEpw04gcSzvmWlYeNLSrDxVlcp4D0
NcezehMt5g+orkHHt/mrhWLr1draCM2R+BR0+KWi8k5KTtflOBAYxkvAjnocyJpD
iazRSPoj1KHJxRTRsDy+TNbEGqgekswHIA3KMMa/rwLfjcUribgz7tfKjVuXhJS/
SQddSj8T/ABD9yjl0iFHK3ZqsVupdlDcIJMKcrgBtgPY6JzG71gHrCaeQcdAT/Al
Pfp0l8jDAWF4MzdelgplAmI1hI4zbhtrdCLK+PR4tBWzr4qwWig=
=KTgp
-----END PGP SIGNATURE-----

--Sig_/2X0SMrq2HtjoB4IVTwvJP0l--

