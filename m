Date: Mon, 25 Oct 2021 11:30:41 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YXaHUbtGoHRbcBBO@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<1853723.Wj769PA2Ue@silver> <2657765.azTuxnmmC0@silver>
	<4038040.djDU9dF7GM@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="eir9ZgXyQXGTf0zf"
Content-Disposition: inline
In-Reply-To: <4038040.djDU9dF7GM@silver>
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


--eir9ZgXyQXGTf0zf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 21, 2021 at 05:39:28PM +0200, Christian Schoenebeck wrote:
> On Freitag, 8. Oktober 2021 18:08:48 CEST Christian Schoenebeck wrote:
> > On Freitag, 8. Oktober 2021 16:24:42 CEST Christian Schoenebeck wrote:
> > > On Freitag, 8. Oktober 2021 09:25:33 CEST Greg Kurz wrote:
> > > > On Thu, 7 Oct 2021 16:42:49 +0100
> > > >=20
> > > > Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > > > > On Thu, Oct 07, 2021 at 02:51:55PM +0200, Christian Schoenebeck w=
rote:
> > > > > > On Donnerstag, 7. Oktober 2021 07:23:59 CEST Stefan Hajnoczi wr=
ote:
> > > > > > > On Mon, Oct 04, 2021 at 09:38:00PM +0200, Christian Schoenebe=
ck
> >=20
> > wrote:
> > > > > > > > At the moment the maximum transfer size with virtio is limi=
ted
> > > > > > > > to
> > > > > > > > 4M
> > > > > > > > (1024 * PAGE_SIZE). This series raises this limit to its ma=
ximum
> > > > > > > > theoretical possible transfer size of 128M (32k pages) acco=
rding
> > > > > > > > to
> > > > > > > > the
> > > > > > > > virtio specs:
> > > > > > > >=20
> > > > > > > > https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-=
v1.1-
> > > > > > > > cs
> > > > > > > > 01
> > > > > > > > .html#
> > > > > > > > x1-240006
> > > > > > >=20
> > > > > > > Hi Christian,
> > > >=20
> > > > > > > I took a quick look at the code:
> > > > Hi,
> > > >=20
> > > > Thanks Stefan for sharing virtio expertise and helping Christian !
> > > >=20
> > > > > > > - The Linux 9p driver restricts descriptor chains to 128 elem=
ents
> > > > > > >=20
> > > > > > >   (net/9p/trans_virtio.c:VIRTQUEUE_NUM)
> > > > > >=20
> > > > > > Yes, that's the limitation that I am about to remove (WIP); cur=
rent
> > > > > > kernel
> > > > > > patches:
> > > > > > https://lore.kernel.org/netdev/cover.1632327421.git.linux_oss@c=
rudeb
> > > > > > yt
> > > > > > e.
> > > > > > com/>
> > > > >=20
> > > > > I haven't read the patches yet but I'm concerned that today the d=
river
> > > > > is pretty well-behaved and this new patch series introduces a spec
> > > > > violation. Not fixing existing spec violations is okay, but addin=
g new
> > > > > ones is a red flag. I think we need to figure out a clean solutio=
n.
> > >=20
> > > Nobody has reviewed the kernel patches yet. My main concern therefore
> > > actually is that the kernel patches are already too complex, because =
the
> > > current situation is that only Dominique is handling 9p patches on ke=
rnel
> > > side, and he barely has time for 9p anymore.
> > >=20
> > > Another reason for me to catch up on reading current kernel code and
> > > stepping in as reviewer of 9p on kernel side ASAP, independent of this
> > > issue.
> > >=20
> > > As for current kernel patches' complexity: I can certainly drop patch=
 7
> > > entirely as it is probably just overkill. Patch 4 is then the biggest
> > > chunk, I have to see if I can simplify it, and whether it would make
> > > sense to squash with patch 3.
> > >=20
> > > > > > > - The QEMU 9pfs code passes iovecs directly to preadv(2) and =
will
> > > > > > > fail
> > > > > > >=20
> > > > > > >   with EINVAL when called with more than IOV_MAX iovecs
> > > > > > >   (hw/9pfs/9p.c:v9fs_read())
> > > > > >=20
> > > > > > Hmm, which makes me wonder why I never encountered this error d=
uring
> > > > > > testing.
> > > > > >=20
> > > > > > Most people will use the 9p qemu 'local' fs driver backend in
> > > > > > practice,
> > > > > > so
> > > > > > that v9fs_read() call would translate for most people to this
> > > > > > implementation on QEMU side (hw/9p/9p-local.c):
> > > > > >=20
> > > > > > static ssize_t local_preadv(FsContext *ctx, V9fsFidOpenState *f=
s,
> > > > > >=20
> > > > > >                             const struct iovec *iov,
> > > > > >                             int iovcnt, off_t offset)
> > > > > >=20
> > > > > > {
> > > > > > #ifdef CONFIG_PREADV
> > > > > >=20
> > > > > >     return preadv(fs->fd, iov, iovcnt, offset);
> > > > > >=20
> > > > > > #else
> > > > > >=20
> > > > > >     int err =3D lseek(fs->fd, offset, SEEK_SET);
> > > > > >     if (err =3D=3D -1) {
> > > > > >    =20
> > > > > >         return err;
> > > > > >    =20
> > > > > >     } else {
> > > > > >    =20
> > > > > >         return readv(fs->fd, iov, iovcnt);
> > > > > >    =20
> > > > > >     }
> > > > > >=20
> > > > > > #endif
> > > > > > }
> > > > > >=20
> > > > > > > Unless I misunderstood the code, neither side can take advant=
age
> > > > > > > of
> > > > > > > the
> > > > > > > new 32k descriptor chain limit?
> > > > > > >=20
> > > > > > > Thanks,
> > > > > > > Stefan
> > > > > >=20
> > > > > > I need to check that when I have some more time. One possible
> > > > > > explanation
> > > > > > might be that preadv() already has this wrapped into a loop in =
its
> > > > > > implementation to circumvent a limit like IOV_MAX. It might be
> > > > > > another
> > > > > > "it
> > > > > > works, but not portable" issue, but not sure.
> > > > > >=20
> > > > > > There are still a bunch of other issues I have to resolve. If y=
ou
> > > > > > look
> > > > > > at
> > > > > > net/9p/client.c on kernel side, you'll notice that it basically=
 does
> > > > > > this ATM> >
> > > > > >=20
> > > > > >     kmalloc(msize);
> > > >=20
> > > > Note that this is done twice : once for the T message (client reque=
st)
> > > > and
> > > > once for the R message (server answer). The 9p driver could adjust =
the
> > > > size
> > > > of the T message to what's really needed instead of allocating the =
full
> > > > msize. R message size is not known though.
> > >=20
> > > Would it make sense adding a second virtio ring, dedicated to server
> > > responses to solve this? IIRC 9p server already calculates appropriate
> > > exact sizes for each response type. So server could just push space t=
hat's
> > > really needed for its responses.
> > >=20
> > > > > > for every 9p request. So not only does it allocate much more me=
mory
> > > > > > for
> > > > > > every request than actually required (i.e. say 9pfs was mounted=
 with
> > > > > > msize=3D8M, then a 9p request that actually would just need 1k =
would
> > > > > > nevertheless allocate 8M), but also it allocates > PAGE_SIZE, w=
hich
> > > > > > obviously may fail at any time.>
> > > > >=20
> > > > > The PAGE_SIZE limitation sounds like a kmalloc() vs vmalloc()
> > > > > situation.
> > >=20
> > > Hu, I didn't even consider vmalloc(). I just tried the kvmalloc() wra=
pper
> > > as a quick & dirty test, but it crashed in the same way as kmalloc() =
with
> > > large msize values immediately on mounting:
> > >=20
> > > diff --git a/net/9p/client.c b/net/9p/client.c
> > > index a75034fa249b..cfe300a4b6ca 100644
> > > --- a/net/9p/client.c
> > > +++ b/net/9p/client.c
> > > @@ -227,15 +227,18 @@ static int parse_opts(char *opts, struct p9_cli=
ent
> > > *clnt)
> > >=20
> > >  static int p9_fcall_init(struct p9_client *c, struct p9_fcall *fc,
> > > =20
> > >                          int alloc_msize)
> > > =20
> > >  {
> > >=20
> > > -       if (likely(c->fcall_cache) && alloc_msize =3D=3D c->msize) {
> > > +       //if (likely(c->fcall_cache) && alloc_msize =3D=3D c->msize) {
> > > +       if (false) {
> > >=20
> > >                 fc->sdata =3D kmem_cache_alloc(c->fcall_cache, GFP_NO=
FS);
> > >                 fc->cache =3D c->fcall_cache;
> > >        =20
> > >         } else {
> > >=20
> > > -               fc->sdata =3D kmalloc(alloc_msize, GFP_NOFS);
> > > +               fc->sdata =3D kvmalloc(alloc_msize, GFP_NOFS);
> >=20
> > Ok, GFP_NOFS -> GFP_KERNEL did the trick.
> >=20
> > Now I get:
> >=20
> >    virtio: bogus descriptor or out of resources
> >=20
> > So, still some work ahead on both ends.
>=20
> Few hacks later (only changes on 9p client side) I got this running stable
> now. The reason for the virtio error above was that kvmalloc() returns a
> non-logical kernel address for any kvmalloc(>4M), i.e. an address that is
> inaccessible from host side, hence that "bogus descriptor" message by QEM=
U.
> So I had to split those linear 9p client buffers into sparse ones (set of
> individual pages).
>=20
> I tested this for some days with various virtio transmission sizes and it
> works as expected up to 128 MB (more precisely: 128 MB read space + 128 MB
> write space per virtio round trip message).
>=20
> I did not encounter a show stopper for large virtio transmission sizes
> (4 MB ... 128 MB) on virtio level, neither as a result of testing, nor af=
ter
> reviewing the existing code.
>=20
> About IOV_MAX: that's apparently not an issue on virtio level. Most of the
> iovec code, both on Linux kernel side and on QEMU side do not have this
> limitation. It is apparently however indeed a limitation for userland apps
> calling the Linux kernel's syscalls yet.
>=20
> Stefan, as it stands now, I am even more convinced that the upper virtio
> transmission size limit should not be squeezed into the queue size argume=
nt of
> virtio_add_queue(). Not because of the previous argument that it would wa=
ste
> space (~1MB), but rather because they are two different things. To outline
> this, just a quick recap of what happens exactly when a bulk message is p=
ushed
> over the virtio wire (assuming virtio "split" layout here):
>=20
> ---------- [recap-start] ----------
>=20
> For each bulk message sent guest <-> host, exactly *one* of the pre-alloc=
ated
> descriptors is taken and placed (subsequently) into exactly *one* positio=
n of
> the two available/used ring buffers. The actual descriptor table though,
> containing all the DMA addresses of the message bulk data, is allocated j=
ust
> in time for each round trip message. Say, it is the first message sent, it
> yields in the following structure:
>=20
> Ring Buffer   Descriptor Table      Bulk Data Pages
>=20
>    +-+              +-+           +-----------------+
>    |D|------------->|d|---------->| Bulk data block |
>    +-+              |d|--------+  +-----------------+
>    | |              |d|------+ |
>    +-+               .       | |  +-----------------+
>    | |               .       | +->| Bulk data block |
>     .                .       |    +-----------------+
>     .               |d|-+    |
>     .               +-+ |    |    +-----------------+
>    | |                  |    +--->| Bulk data block |
>    +-+                  |         +-----------------+
>    | |                  |                 .
>    +-+                  |                 .
>                         |                 .
>                         |         +-----------------+
>                         +-------->| Bulk data block |
>                                   +-----------------+
> Legend:
> D: pre-allocated descriptor
> d: just in time allocated descriptor
> -->: memory pointer (DMA)
>=20
> The bulk data blocks are allocated by the respective device driver above
> virtio subsystem level (guest side).
>=20
> There are exactly as many descriptors pre-allocated (D) as the size of a =
ring
> buffer.
>=20
> A "descriptor" is more or less just a chainable DMA memory pointer; defin=
ed
> as:
>=20
> /* Virtio ring descriptors: 16 bytes.  These can chain together via "next=
". */
> struct vring_desc {
> 	/* Address (guest-physical). */
> 	__virtio64 addr;
> 	/* Length. */
> 	__virtio32 len;
> 	/* The flags as indicated above. */
> 	__virtio16 flags;
> 	/* We chain unused descriptors via this, too */
> 	__virtio16 next;
> };
>=20
> There are 2 ring buffers; the "available" ring buffer is for sending a me=
ssage
> guest->host (which will transmit DMA addresses of guest allocated bulk da=
ta
> blocks that are used for data sent to device, and separate guest allocated
> bulk data blocks that will be used by host side to place its response bulk
> data), and the "used" ring buffer is for sending host->guest to let guest=
 know
> about host's response and that it could now safely consume and then deall=
ocate
> the bulk data blocks subsequently.
>=20
> ---------- [recap-end] ----------
>=20
> So the "queue size" actually defines the ringbuffer size. It does not def=
ine
> the maximum amount of descriptors. The "queue size" rather defines how ma=
ny
> pending messages can be pushed into either one ringbuffer before the other
> side would need to wait until the counter side would step up (i.e. ring b=
uffer
> full).
>=20
> The maximum amount of descriptors (what VIRTQUEUE_MAX_SIZE actually is) O=
TOH
> defines the max. bulk data size that could be transmitted with each virtio
> round trip message.
>=20
> And in fact, 9p currently handles the virtio "queue size" as directly
> associative with its maximum amount of active 9p requests the server could
> handle simultaniously:
>=20
>   hw/9pfs/9p.h:#define MAX_REQ         128
>   hw/9pfs/9p.h:    V9fsPDU pdus[MAX_REQ];
>   hw/9pfs/virtio-9p-device.c:    v->vq =3D virtio_add_queue(vdev, MAX_REQ,
>                                  handle_9p_output);
>=20
> So if I would change it like this, just for the purpose to increase the m=
ax.
> virtio transmission size:
>=20
> --- a/hw/9pfs/virtio-9p-device.c
> +++ b/hw/9pfs/virtio-9p-device.c
> @@ -218,7 +218,7 @@ static void virtio_9p_device_realize(DeviceState *dev=
, Error **errp)
>      v->config_size =3D sizeof(struct virtio_9p_config) + strlen(s->fscon=
f.tag);
>      virtio_init(vdev, "virtio-9p", VIRTIO_ID_9P, v->config_size,
>                  VIRTQUEUE_MAX_SIZE);
> -    v->vq =3D virtio_add_queue(vdev, MAX_REQ, handle_9p_output);
> +    v->vq =3D virtio_add_queue(vdev, 32*1024, handle_9p_output);
>  }
> =20
> Then it would require additional synchronization code on both ends and
> therefore unnecessary complexity, because it would now be possible that m=
ore
> requests are pushed into the ringbuffer than server could handle.
>=20
> There is one potential issue though that probably did justify the "don't
> exceed the queue size" rule:
>=20
> ATM the descriptor table is allocated (just in time) as *one* continuous
> buffer via kmalloc_array():
> https://github.com/torvalds/linux/blob/2f111a6fd5b5297b4e92f53798ca086f7c=
7d33a4/drivers/virtio/virtio_ring.c#L440
>=20
> So assuming transmission size of 2 * 128 MB that kmalloc_array() call wou=
ld
> yield in kmalloc(1M) and the latter might fail if guest had highly fragme=
nted
> physical memory. For such kind of error case there is currently a fallback
> path in virtqueue_add_split() that would then use the required amount of
> pre-allocated descriptors instead:
> https://github.com/torvalds/linux/blob/2f111a6fd5b5297b4e92f53798ca086f7c=
7d33a4/drivers/virtio/virtio_ring.c#L525
>=20
> That fallback recovery path would no longer be viable if the queue size w=
as
> exceeded. There would be alternatives though, e.g. by allowing to chain
> indirect descriptor tables (currently prohibited by the virtio specs).

Making the maximum number of descriptors independent of the queue size
requires a change to the VIRTIO spec since the two values are currently
explicitly tied together by the spec.

Before doing that, are there benchmark results showing that 1 MB vs 128
MB produces a performance improvement? I'm asking because if performance
with 1 MB is good then you can probably do that without having to change
VIRTIO and also because it's counter-intuitive that 9p needs 128 MB for
good performance when it's ultimately implemented on top of disk and
network I/O that have lower size limits.

Stefan

--eir9ZgXyQXGTf0zf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF2h1EACgkQnKSrs4Gr
c8idoAgAoWh+aZi4+a7YnrY/LJhceoSvpU7hs4naMfswg5JEdVX0UJnws8t5wfbE
5UwLr3aRv3xgLWfsT0TFMh3iffH9W2hhHCa3MvoC72Aau7BFwUgHIqUwwcyEBseZ
ILNKcjUBkTjqwEUmocz+wwII3stA9eeXMK356jecD8gk1RnMpDFgHNeRQUB6cdg1
2RX8mmq2vtUdi3HIH1RiBVaPPK/KBXEF2TYVxviWq8ds5R7Zvfz7IUqbcNxZ9uoU
qfUkmBZzvwtAk7p6vek1kC0Ox+5rKhEBhOCReNlm4tpOzQRs4zsgCK36TeOZWKdb
508Oc7zRmgmQOXUVDgx2xMu8m43d2g==
=J4PW
-----END PGP SIGNATURE-----

--eir9ZgXyQXGTf0zf--

