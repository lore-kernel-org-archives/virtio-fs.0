Date: Tue, 9 Nov 2021 10:56:35 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YYpT4ybSiaon19UP@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<136317874.cAzoFBZ3UR@silver>
	<YYJzjRg5F/DUi9M5@stefanha-x1.localdomain>
	<10421947.PG2v2feK4y@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="YlhwJtpVs6k35bMG"
Content-Disposition: inline
In-Reply-To: <10421947.PG2v2feK4y@silver>
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
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>, Raphael Norwitz <raphael.norwitz@nutanix.com>


--YlhwJtpVs6k35bMG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 04, 2021 at 03:41:23PM +0100, Christian Schoenebeck wrote:
> On Mittwoch, 3. November 2021 12:33:33 CET Stefan Hajnoczi wrote:
> > On Mon, Nov 01, 2021 at 09:29:26PM +0100, Christian Schoenebeck wrote:
> > > On Donnerstag, 28. Oktober 2021 11:00:48 CET Stefan Hajnoczi wrote:
> > > > On Mon, Oct 25, 2021 at 05:03:25PM +0200, Christian Schoenebeck wro=
te:
> > > > > On Montag, 25. Oktober 2021 12:30:41 CEST Stefan Hajnoczi wrote:
> > > > > > On Thu, Oct 21, 2021 at 05:39:28PM +0200, Christian Schoenebeck=
 wrote:
> > > > > > > On Freitag, 8. Oktober 2021 18:08:48 CEST Christian Schoenebe=
ck wrote:
> > > > > > > > On Freitag, 8. Oktober 2021 16:24:42 CEST Christian Schoene=
beck wrote:
> > > > > > > > > On Freitag, 8. Oktober 2021 09:25:33 CEST Greg Kurz wrote:
> > > > > > > > > > On Thu, 7 Oct 2021 16:42:49 +0100
> > > > > > > > > >=20
> > > > > > > > > > Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > > > > > > > > > > On Thu, Oct 07, 2021 at 02:51:55PM +0200, Christian S=
choenebeck wrote:
> > > > > > > > > > > > On Donnerstag, 7. Oktober 2021 07:23:59 CEST Stefan=
 Hajnoczi wrote:
> > > > > > > > > > > > > On Mon, Oct 04, 2021 at 09:38:00PM +0200, Christi=
an
> > > > > > > > > > > > > Schoenebeck
> > > > > > > >=20
> > > > > > > > wrote:
> > > > > > > > > > > > > > At the moment the maximum transfer size with vi=
rtio
> > > > > > > > > > > > > > is
> > > > > > > > > > > > > > limited
> > > > > > > > > > > > > > to
> > > > > > > > > > > > > > 4M
> > > > > > > > > > > > > > (1024 * PAGE_SIZE). This series raises this lim=
it to
> > > > > > > > > > > > > > its
> > > > > > > > > > > > > > maximum
> > > > > > > > > > > > > > theoretical possible transfer size of 128M (32k
> > > > > > > > > > > > > > pages)
> > > > > > > > > > > > > > according
> > > > > > > > > > > > > > to
> > > > > > > > > > > > > > the
> > > > > > > > > > > > > > virtio specs:
> > > > > > > > > > > > > >=20
> > > > > > > > > > > > > > https://docs.oasis-open.org/virtio/virtio/v1.1/=
cs01/
> > > > > > > > > > > > > > virt
> > > > > > > > > > > > > > io-v
> > > > > > > > > > > > > > 1.1-
> > > > > > > > > > > > > > cs
> > > > > > > > > > > > > > 01
> > > > > > > > > > > > > > .html#
> > > > > > > > > > > > > > x1-240006
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > Hi Christian,
> > > > > > > > > >=20
> > > > > > > > > > > > > I took a quick look at the code:
> > > > > > > > > > Hi,
> > > > > > > > > >=20
> > > > > > > > > > Thanks Stefan for sharing virtio expertise and helping
> > > > > > > > > > Christian
> > > > > > > > > > !
> > > > > > > > > >=20
> > > > > > > > > > > > > - The Linux 9p driver restricts descriptor chains=
 to
> > > > > > > > > > > > > 128
> > > > > > > > > > > > > elements
> > > > > > > > > > > > >=20
> > > > > > > > > > > > >   (net/9p/trans_virtio.c:VIRTQUEUE_NUM)
> > > > > > > > > > > >=20
> > > > > > > > > > > > Yes, that's the limitation that I am about to remove
> > > > > > > > > > > > (WIP);
> > > > > > > > > > > > current
> > > > > > > > > > > > kernel
> > > > > > > > > > > > patches:
> > > > > > > > > > > > https://lore.kernel.org/netdev/cover.1632327421.git=
=2Elinu
> > > > > > > > > > > > x_os
> > > > > > > > > > > > s@cr
> > > > > > > > > > > > udeb
> > > > > > > > > > > > yt
> > > > > > > > > > > > e.
> > > > > > > > > > > > com/>
> > > > > > > > > > >=20
> > > > > > > > > > > I haven't read the patches yet but I'm concerned that
> > > > > > > > > > > today
> > > > > > > > > > > the
> > > > > > > > > > > driver
> > > > > > > > > > > is pretty well-behaved and this new patch series
> > > > > > > > > > > introduces a
> > > > > > > > > > > spec
> > > > > > > > > > > violation. Not fixing existing spec violations is oka=
y,
> > > > > > > > > > > but
> > > > > > > > > > > adding
> > > > > > > > > > > new
> > > > > > > > > > > ones is a red flag. I think we need to figure out a c=
lean
> > > > > > > > > > > solution.
> > > > > > > > >=20
> > > > > > > > > Nobody has reviewed the kernel patches yet. My main conce=
rn
> > > > > > > > > therefore
> > > > > > > > > actually is that the kernel patches are already too compl=
ex,
> > > > > > > > > because
> > > > > > > > > the
> > > > > > > > > current situation is that only Dominique is handling 9p
> > > > > > > > > patches on
> > > > > > > > > kernel
> > > > > > > > > side, and he barely has time for 9p anymore.
> > > > > > > > >=20
> > > > > > > > > Another reason for me to catch up on reading current kern=
el
> > > > > > > > > code
> > > > > > > > > and
> > > > > > > > > stepping in as reviewer of 9p on kernel side ASAP, indepe=
ndent
> > > > > > > > > of
> > > > > > > > > this
> > > > > > > > > issue.
> > > > > > > > >=20
> > > > > > > > > As for current kernel patches' complexity: I can certainly
> > > > > > > > > drop
> > > > > > > > > patch
> > > > > > > > > 7
> > > > > > > > > entirely as it is probably just overkill. Patch 4 is then=
 the
> > > > > > > > > biggest
> > > > > > > > > chunk, I have to see if I can simplify it, and whether it
> > > > > > > > > would
> > > > > > > > > make
> > > > > > > > > sense to squash with patch 3.
> > > > > > > > >=20
> > > > > > > > > > > > > - The QEMU 9pfs code passes iovecs directly to
> > > > > > > > > > > > > preadv(2)
> > > > > > > > > > > > > and
> > > > > > > > > > > > > will
> > > > > > > > > > > > > fail
> > > > > > > > > > > > >=20
> > > > > > > > > > > > >   with EINVAL when called with more than IOV_MAX
> > > > > > > > > > > > >   iovecs
> > > > > > > > > > > > >   (hw/9pfs/9p.c:v9fs_read())
> > > > > > > > > > > >=20
> > > > > > > > > > > > Hmm, which makes me wonder why I never encountered =
this
> > > > > > > > > > > > error
> > > > > > > > > > > > during
> > > > > > > > > > > > testing.
> > > > > > > > > > > >=20
> > > > > > > > > > > > Most people will use the 9p qemu 'local' fs driver
> > > > > > > > > > > > backend
> > > > > > > > > > > > in
> > > > > > > > > > > > practice,
> > > > > > > > > > > > so
> > > > > > > > > > > > that v9fs_read() call would translate for most peop=
le to
> > > > > > > > > > > > this
> > > > > > > > > > > > implementation on QEMU side (hw/9p/9p-local.c):
> > > > > > > > > > > >=20
> > > > > > > > > > > > static ssize_t local_preadv(FsContext *ctx,
> > > > > > > > > > > > V9fsFidOpenState
> > > > > > > > > > > > *fs,
> > > > > > > > > > > >=20
> > > > > > > > > > > >                             const struct iovec *iov,
> > > > > > > > > > > >                             int iovcnt, off_t offse=
t)
> > > > > > > > > > > >=20
> > > > > > > > > > > > {
> > > > > > > > > > > > #ifdef CONFIG_PREADV
> > > > > > > > > > > >=20
> > > > > > > > > > > >     return preadv(fs->fd, iov, iovcnt, offset);
> > > > > > > > > > > >=20
> > > > > > > > > > > > #else
> > > > > > > > > > > >=20
> > > > > > > > > > > >     int err =3D lseek(fs->fd, offset, SEEK_SET);
> > > > > > > > > > > >     if (err =3D=3D -1) {
> > > > > > > > > > > >    =20
> > > > > > > > > > > >         return err;
> > > > > > > > > > > >    =20
> > > > > > > > > > > >     } else {
> > > > > > > > > > > >    =20
> > > > > > > > > > > >         return readv(fs->fd, iov, iovcnt);
> > > > > > > > > > > >    =20
> > > > > > > > > > > >     }
> > > > > > > > > > > >=20
> > > > > > > > > > > > #endif
> > > > > > > > > > > > }
> > > > > > > > > > > >=20
> > > > > > > > > > > > > Unless I misunderstood the code, neither side can=
 take
> > > > > > > > > > > > > advantage
> > > > > > > > > > > > > of
> > > > > > > > > > > > > the
> > > > > > > > > > > > > new 32k descriptor chain limit?
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > Thanks,
> > > > > > > > > > > > > Stefan
> > > > > > > > > > > >=20
> > > > > > > > > > > > I need to check that when I have some more time. One
> > > > > > > > > > > > possible
> > > > > > > > > > > > explanation
> > > > > > > > > > > > might be that preadv() already has this wrapped int=
o a
> > > > > > > > > > > > loop
> > > > > > > > > > > > in
> > > > > > > > > > > > its
> > > > > > > > > > > > implementation to circumvent a limit like IOV_MAX. =
It
> > > > > > > > > > > > might
> > > > > > > > > > > > be
> > > > > > > > > > > > another
> > > > > > > > > > > > "it
> > > > > > > > > > > > works, but not portable" issue, but not sure.
> > > > > > > > > > > >=20
> > > > > > > > > > > > There are still a bunch of other issues I have to
> > > > > > > > > > > > resolve.
> > > > > > > > > > > > If
> > > > > > > > > > > > you
> > > > > > > > > > > > look
> > > > > > > > > > > > at
> > > > > > > > > > > > net/9p/client.c on kernel side, you'll notice that =
it
> > > > > > > > > > > > basically
> > > > > > > > > > > > does
> > > > > > > > > > > > this ATM> >
> > > > > > > > > > > >=20
> > > > > > > > > > > >     kmalloc(msize);
> > > > > > > > > >=20
> > > > > > > > > > Note that this is done twice : once for the T message
> > > > > > > > > > (client
> > > > > > > > > > request)
> > > > > > > > > > and
> > > > > > > > > > once for the R message (server answer). The 9p driver c=
ould
> > > > > > > > > > adjust
> > > > > > > > > > the
> > > > > > > > > > size
> > > > > > > > > > of the T message to what's really needed instead of
> > > > > > > > > > allocating
> > > > > > > > > > the
> > > > > > > > > > full
> > > > > > > > > > msize. R message size is not known though.
> > > > > > > > >=20
> > > > > > > > > Would it make sense adding a second virtio ring, dedicate=
d to
> > > > > > > > > server
> > > > > > > > > responses to solve this? IIRC 9p server already calculates
> > > > > > > > > appropriate
> > > > > > > > > exact sizes for each response type. So server could just =
push
> > > > > > > > > space
> > > > > > > > > that's
> > > > > > > > > really needed for its responses.
> > > > > > > > >=20
> > > > > > > > > > > > for every 9p request. So not only does it allocate =
much
> > > > > > > > > > > > more
> > > > > > > > > > > > memory
> > > > > > > > > > > > for
> > > > > > > > > > > > every request than actually required (i.e. say 9pfs=
 was
> > > > > > > > > > > > mounted
> > > > > > > > > > > > with
> > > > > > > > > > > > msize=3D8M, then a 9p request that actually would j=
ust
> > > > > > > > > > > > need 1k
> > > > > > > > > > > > would
> > > > > > > > > > > > nevertheless allocate 8M), but also it allocates >
> > > > > > > > > > > > PAGE_SIZE,
> > > > > > > > > > > > which
> > > > > > > > > > > > obviously may fail at any time.>
> > > > > > > > > > >=20
> > > > > > > > > > > The PAGE_SIZE limitation sounds like a kmalloc() vs
> > > > > > > > > > > vmalloc()
> > > > > > > > > > > situation.
> > > > > > > > >=20
> > > > > > > > > Hu, I didn't even consider vmalloc(). I just tried the
> > > > > > > > > kvmalloc()
> > > > > > > > > wrapper
> > > > > > > > > as a quick & dirty test, but it crashed in the same way as
> > > > > > > > > kmalloc()
> > > > > > > > > with
> > > > > > > > > large msize values immediately on mounting:
> > > > > > > > >=20
> > > > > > > > > diff --git a/net/9p/client.c b/net/9p/client.c
> > > > > > > > > index a75034fa249b..cfe300a4b6ca 100644
> > > > > > > > > --- a/net/9p/client.c
> > > > > > > > > +++ b/net/9p/client.c
> > > > > > > > > @@ -227,15 +227,18 @@ static int parse_opts(char *opts, s=
truct
> > > > > > > > > p9_client
> > > > > > > > > *clnt)
> > > > > > > > >=20
> > > > > > > > >  static int p9_fcall_init(struct p9_client *c, struct p9_=
fcall
> > > > > > > > >  *fc,
> > > > > > > > > =20
> > > > > > > > >                          int alloc_msize)
> > > > > > > > > =20
> > > > > > > > >  {
> > > > > > > > >=20
> > > > > > > > > -       if (likely(c->fcall_cache) && alloc_msize =3D=3D =
c->msize)
> > > > > > > > > {
> > > > > > > > > +       //if (likely(c->fcall_cache) && alloc_msize =3D=3D
> > > > > > > > > c->msize) {
> > > > > > > > > +       if (false) {
> > > > > > > > >=20
> > > > > > > > >                 fc->sdata =3D kmem_cache_alloc(c->fcall_c=
ache,
> > > > > > > > >                 GFP_NOFS);
> > > > > > > > >                 fc->cache =3D c->fcall_cache;
> > > > > > > > >        =20
> > > > > > > > >         } else {
> > > > > > > > >=20
> > > > > > > > > -               fc->sdata =3D kmalloc(alloc_msize, GFP_NO=
FS);
> > > > > > > > > +               fc->sdata =3D kvmalloc(alloc_msize, GFP_N=
OFS);
> > > > > > > >=20
> > > > > > > > Ok, GFP_NOFS -> GFP_KERNEL did the trick.
> > > > > > > >=20
> > > > > > > > Now I get:
> > > > > > > >    virtio: bogus descriptor or out of resources
> > > > > > > >=20
> > > > > > > > So, still some work ahead on both ends.
> > > > > > >=20
> > > > > > > Few hacks later (only changes on 9p client side) I got this
> > > > > > > running
> > > > > > > stable
> > > > > > > now. The reason for the virtio error above was that kvmalloc()
> > > > > > > returns
> > > > > > > a
> > > > > > > non-logical kernel address for any kvmalloc(>4M), i.e. an add=
ress
> > > > > > > that
> > > > > > > is
> > > > > > > inaccessible from host side, hence that "bogus descriptor" me=
ssage
> > > > > > > by
> > > > > > > QEMU.
> > > > > > > So I had to split those linear 9p client buffers into sparse =
ones
> > > > > > > (set
> > > > > > > of
> > > > > > > individual pages).
> > > > > > >=20
> > > > > > > I tested this for some days with various virtio transmission =
sizes
> > > > > > > and
> > > > > > > it
> > > > > > > works as expected up to 128 MB (more precisely: 128 MB read s=
pace
> > > > > > > +
> > > > > > > 128 MB
> > > > > > > write space per virtio round trip message).
> > > > > > >=20
> > > > > > > I did not encounter a show stopper for large virtio transmiss=
ion
> > > > > > > sizes
> > > > > > > (4 MB ... 128 MB) on virtio level, neither as a result of tes=
ting,
> > > > > > > nor
> > > > > > > after reviewing the existing code.
> > > > > > >=20
> > > > > > > About IOV_MAX: that's apparently not an issue on virtio level.
> > > > > > > Most of
> > > > > > > the
> > > > > > > iovec code, both on Linux kernel side and on QEMU side do not=
 have
> > > > > > > this
> > > > > > > limitation. It is apparently however indeed a limitation for
> > > > > > > userland
> > > > > > > apps
> > > > > > > calling the Linux kernel's syscalls yet.
> > > > > > >=20
> > > > > > > Stefan, as it stands now, I am even more convinced that the u=
pper
> > > > > > > virtio
> > > > > > > transmission size limit should not be squeezed into the queue=
 size
> > > > > > > argument of virtio_add_queue(). Not because of the previous
> > > > > > > argument
> > > > > > > that
> > > > > > > it would waste space (~1MB), but rather because they are two
> > > > > > > different
> > > > > > > things. To outline this, just a quick recap of what happens
> > > > > > > exactly
> > > > > > > when
> > > > > > > a bulk message is pushed over the virtio wire (assuming virtio
> > > > > > > "split"
> > > > > > > layout here):
> > > > > > >=20
> > > > > > > ---------- [recap-start] ----------
> > > > > > >=20
> > > > > > > For each bulk message sent guest <-> host, exactly *one* of t=
he
> > > > > > > pre-allocated descriptors is taken and placed (subsequently) =
into
> > > > > > > exactly
> > > > > > > *one* position of the two available/used ring buffers. The ac=
tual
> > > > > > > descriptor table though, containing all the DMA addresses of =
the
> > > > > > > message
> > > > > > > bulk data, is allocated just in time for each round trip mess=
age.
> > > > > > > Say,
> > > > > > > it
> > > > > > > is the first message sent, it yields in the following structu=
re:
> > > > > > >=20
> > > > > > > Ring Buffer   Descriptor Table      Bulk Data Pages
> > > > > > >=20
> > > > > > >    +-+              +-+           +-----------------+
> > > > > > >   =20
> > > > > > >    |D|------------->|d|---------->| Bulk data block |
> > > > > > >   =20
> > > > > > >    +-+              |d|--------+  +-----------------+
> > > > > > >   =20
> > > > > > >    | |              |d|------+ |
> > > > > > >   =20
> > > > > > >    +-+               .       | |  +-----------------+
> > > > > > >   =20
> > > > > > >    | |               .       | +->| Bulk data block |
> > > > > > >    =20
> > > > > > >     .                .       |    +-----------------+
> > > > > > >     .               |d|-+    |
> > > > > > >     .               +-+ |    |    +-----------------+
> > > > > > >    =20
> > > > > > >    | |                  |    +--->| Bulk data block |
> > > > > > >   =20
> > > > > > >    +-+                  |         +-----------------+
> > > > > > >   =20
> > > > > > >    | |                  |                 .
> > > > > > >   =20
> > > > > > >    +-+                  |                 .
> > > > > > >   =20
> > > > > > >                         |                 .
> > > > > > >                         |        =20
> > > > > > >                         |         +-----------------+
> > > > > > >                        =20
> > > > > > >                         +-------->| Bulk data block |
> > > > > > >                        =20
> > > > > > >                                   +-----------------+
> > > > > > >=20
> > > > > > > Legend:
> > > > > > > D: pre-allocated descriptor
> > > > > > > d: just in time allocated descriptor
> > > > > > > -->: memory pointer (DMA)
> > > > > > >=20
> > > > > > > The bulk data blocks are allocated by the respective device d=
river
> > > > > > > above
> > > > > > > virtio subsystem level (guest side).
> > > > > > >=20
> > > > > > > There are exactly as many descriptors pre-allocated (D) as the
> > > > > > > size of
> > > > > > > a
> > > > > > > ring buffer.
> > > > > > >=20
> > > > > > > A "descriptor" is more or less just a chainable DMA memory
> > > > > > > pointer;
> > > > > > > defined
> > > > > > > as:
> > > > > > >=20
> > > > > > > /* Virtio ring descriptors: 16 bytes.  These can chain togeth=
er
> > > > > > > via
> > > > > > > "next". */ struct vring_desc {
> > > > > > >=20
> > > > > > > 	/* Address (guest-physical). */
> > > > > > > 	__virtio64 addr;
> > > > > > > 	/* Length. */
> > > > > > > 	__virtio32 len;
> > > > > > > 	/* The flags as indicated above. */
> > > > > > > 	__virtio16 flags;
> > > > > > > 	/* We chain unused descriptors via this, too */
> > > > > > > 	__virtio16 next;
> > > > > > >=20
> > > > > > > };
> > > > > > >=20
> > > > > > > There are 2 ring buffers; the "available" ring buffer is for
> > > > > > > sending a
> > > > > > > message guest->host (which will transmit DMA addresses of gue=
st
> > > > > > > allocated
> > > > > > > bulk data blocks that are used for data sent to device, and
> > > > > > > separate
> > > > > > > guest allocated bulk data blocks that will be used by host si=
de to
> > > > > > > place
> > > > > > > its response bulk data), and the "used" ring buffer is for se=
nding
> > > > > > > host->guest to let guest know about host's response and that =
it
> > > > > > > could
> > > > > > > now
> > > > > > > safely consume and then deallocate the bulk data blocks
> > > > > > > subsequently.
> > > > > > >=20
> > > > > > > ---------- [recap-end] ----------
> > > > > > >=20
> > > > > > > So the "queue size" actually defines the ringbuffer size. It =
does
> > > > > > > not
> > > > > > > define the maximum amount of descriptors. The "queue size" ra=
ther
> > > > > > > defines
> > > > > > > how many pending messages can be pushed into either one ringb=
uffer
> > > > > > > before
> > > > > > > the other side would need to wait until the counter side would
> > > > > > > step up
> > > > > > > (i.e. ring buffer full).
> > > > > > >=20
> > > > > > > The maximum amount of descriptors (what VIRTQUEUE_MAX_SIZE
> > > > > > > actually
> > > > > > > is)
> > > > > > > OTOH defines the max. bulk data size that could be transmitted
> > > > > > > with
> > > > > > > each
> > > > > > > virtio round trip message.
> > > > > > >=20
> > > > > > > And in fact, 9p currently handles the virtio "queue size" as
> > > > > > > directly
> > > > > > > associative with its maximum amount of active 9p requests the
> > > > > > > server
> > > > > > > could
> > > > > > >=20
> > > > > > > handle simultaniously:
> > > > > > >   hw/9pfs/9p.h:#define MAX_REQ         128
> > > > > > >   hw/9pfs/9p.h:    V9fsPDU pdus[MAX_REQ];
> > > > > > >   hw/9pfs/virtio-9p-device.c:    v->vq =3D virtio_add_queue(v=
dev,
> > > > > > >   MAX_REQ,
> > > > > > >  =20
> > > > > > >                                  handle_9p_output);
> > > > > > >=20
> > > > > > > So if I would change it like this, just for the purpose to
> > > > > > > increase
> > > > > > > the
> > > > > > > max. virtio transmission size:
> > > > > > >=20
> > > > > > > --- a/hw/9pfs/virtio-9p-device.c
> > > > > > > +++ b/hw/9pfs/virtio-9p-device.c
> > > > > > > @@ -218,7 +218,7 @@ static void
> > > > > > > virtio_9p_device_realize(DeviceState
> > > > > > > *dev,
> > > > > > > Error **errp)>
> > > > > > >=20
> > > > > > >      v->config_size =3D sizeof(struct virtio_9p_config) +
> > > > > > >      strlen(s->fsconf.tag);
> > > > > > >      virtio_init(vdev, "virtio-9p", VIRTIO_ID_9P, v->config_s=
ize,
> > > > > > >     =20
> > > > > > >                  VIRTQUEUE_MAX_SIZE);
> > > > > > >=20
> > > > > > > -    v->vq =3D virtio_add_queue(vdev, MAX_REQ, handle_9p_outp=
ut);
> > > > > > > +    v->vq =3D virtio_add_queue(vdev, 32*1024, handle_9p_outp=
ut);
> > > > > > >=20
> > > > > > >  }
> > > > > > >=20
> > > > > > > Then it would require additional synchronization code on both=
 ends
> > > > > > > and
> > > > > > > therefore unnecessary complexity, because it would now be pos=
sible
> > > > > > > that
> > > > > > > more requests are pushed into the ringbuffer than server could
> > > > > > > handle.
> > > > > > >=20
> > > > > > > There is one potential issue though that probably did justify=
 the
> > > > > > > "don't
> > > > > > > exceed the queue size" rule:
> > > > > > >=20
> > > > > > > ATM the descriptor table is allocated (just in time) as *one*
> > > > > > > continuous
> > > > > > > buffer via kmalloc_array():
> > > > > > > https://github.com/torvalds/linux/blob/2f111a6fd5b5297b4e92f5=
3798c
> > > > > > > a086
> > > > > > > f7c7
> > > > > > > d33a4/drivers/virtio/virtio_ring.c#L440
> > > > > > >=20
> > > > > > > So assuming transmission size of 2 * 128 MB that kmalloc_arra=
y()
> > > > > > > call
> > > > > > > would
> > > > > > > yield in kmalloc(1M) and the latter might fail if guest had h=
ighly
> > > > > > > fragmented physical memory. For such kind of error case there=
 is
> > > > > > > currently a fallback path in virtqueue_add_split() that would=
 then
> > > > > > > use
> > > > > > > the required amount of pre-allocated descriptors instead:
> > > > > > > https://github.com/torvalds/linux/blob/2f111a6fd5b5297b4e92f5=
3798c
> > > > > > > a086
> > > > > > > f7c7
> > > > > > > d33a4/drivers/virtio/virtio_ring.c#L525
> > > > > > >=20
> > > > > > > That fallback recovery path would no longer be viable if the =
queue
> > > > > > > size
> > > > > > > was
> > > > > > > exceeded. There would be alternatives though, e.g. by allowin=
g to
> > > > > > > chain
> > > > > > > indirect descriptor tables (currently prohibited by the virtio
> > > > > > > specs).
> > > > > >=20
> > > > > > Making the maximum number of descriptors independent of the que=
ue
> > > > > > size
> > > > > > requires a change to the VIRTIO spec since the two values are
> > > > > > currently
> > > > > > explicitly tied together by the spec.
> > > > >=20
> > > > > Yes, that's what the virtio specs say. But they don't say why, no=
r did
> > > > > I
> > > > > hear a reason in this dicussion.
> > > > >=20
> > > > > That's why I invested time reviewing current virtio implementatio=
n and
> > > > > specs, as well as actually testing exceeding that limit. And as I
> > > > > outlined in detail in my previous email, I only found one theoret=
ical
> > > > > issue that could be addressed though.
> > > >=20
> > > > I agree that there is a limitation in the VIRTIO spec, but violatin=
g the
> > > > spec isn't an acceptable solution:
> > > >=20
> > > > 1. QEMU and Linux aren't the only components that implement VIRTIO.=
 You
> > > >=20
> > > >    cannot make assumptions about their implementations because it m=
ay
> > > >    break spec-compliant implementations that you haven't looked at.
> > > >   =20
> > > >    Your patches weren't able to increase Queue Size because some de=
vice
> > > >    implementations break when descriptor chains are too long. This =
shows
> > > >    there is a practical issue even in QEMU.
> > > >=20
> > > > 2. The specific spec violation that we discussed creates the problem
> > > >=20
> > > >    that drivers can no longer determine the maximum description cha=
in
> > > >    length. This in turn will lead to more implementation-specific
> > > >    assumptions being baked into drivers and cause problems with
> > > >    interoperability and future changes.
> > > >=20
> > > > The spec needs to be extended instead. I included an idea for how t=
o do
> > > > that below.
> > >=20
> > > Sure, I just wanted to see if there was a non-neglectable "hard" show
> > > stopper per se that I probably haven't seen yet. I have not questioned
> > > aiming a clean solution.
> > >=20
> > > Thanks for the clarification!
> > >=20
> > > > > > Before doing that, are there benchmark results showing that 1 M=
B vs
> > > > > > 128
> > > > > > MB produces a performance improvement? I'm asking because if
> > > > > > performance
> > > > > > with 1 MB is good then you can probably do that without having =
to
> > > > > > change
> > > > > > VIRTIO and also because it's counter-intuitive that 9p needs 12=
8 MB
> > > > > > for
> > > > > > good performance when it's ultimately implemented on top of dis=
k and
> > > > > > network I/O that have lower size limits.
> > > > >=20
> > > > > First some numbers, linear reading a 12 GB file:
> > > > >=20
> > > > > msize    average      notes
> > > > >=20
> > > > > 8 kB     52.0 MB/s    default msize of Linux kernel <v5.15
> > > > > 128 kB   624.8 MB/s   default msize of Linux kernel >=3Dv5.15
> > > > > 512 kB   1961 MB/s    current max. msize with any Linux kernel <=
=3Dv5.15
> > > > > 1 MB     2551 MB/s    this msize would already violate virtio spe=
cs
> > > > > 2 MB     2521 MB/s    this msize would already violate virtio spe=
cs
> > > > > 4 MB     2628 MB/s    planned max. msize of my current kernel pat=
ches
> > > > > [1]
> > > >=20
> > > > How many descriptors are used? 4 MB can be covered by a single
> > > > descriptor if the data is physically contiguous in memory, so this =
data
> > > > doesn't demonstrate a need for more descriptors.
> > >=20
> > > No, in the last couple years there was apparently no kernel version t=
hat
> > > used just one descriptor, nor did my benchmarked version. Even though=
 the
> > > Linux 9p client uses (yet) simple linear buffers (contiguous physical
> > > memory) on 9p client level, these are however split into PAGE_SIZE ch=
unks
> > > by function pack_sg_list() [1] before being fed to virtio level:
> > >=20
> > > static unsigned int rest_of_page(void *data)
> > > {
> > >=20
> > > 	return PAGE_SIZE - offset_in_page(data);
> > >=20
> > > }
> > > ...
> > > static int pack_sg_list(struct scatterlist *sg, int start,
> > >=20
> > > 			int limit, char *data, int count)
> > >=20
> > > {
> > >=20
> > > 	int s;
> > > 	int index =3D start;
> > > =09
> > > 	while (count) {
> > > =09
> > > 		s =3D rest_of_page(data);
> > > 		...
> > > 		sg_set_buf(&sg[index++], data, s);
> > > 		count -=3D s;
> > > 		data +=3D s;
> > > =09
> > > 	}
> > > 	...
> > >=20
> > > }
> > >=20
> > > [1]
> > > https://github.com/torvalds/linux/blob/19901165d90fdca1e57c9baa0d5b4c=
63d1
> > > 5c476a/net/9p/trans_virtio.c#L171
> > >=20
> > > So when sending 4MB over virtio wire, it would yield in 1k descriptors
> > > ATM.
> > >=20
> > > I have wondered about this before, but did not question it, because d=
ue to
> > > the cross-platform nature I couldn't say for certain whether that's
> > > probably needed somewhere. I mean for the case virtio-PCI I know for =
sure
> > > that one descriptor (i.e. >PAGE_SIZE) would be fine, but I don't know=
 if
> > > that applies to all buses and architectures.
> >=20
> > VIRTIO does not limit descriptor the descriptor len field to PAGE_SIZE,
> > so I don't think there is a limit at the VIRTIO level.
>=20
> So you are viewing this purely from virtio specs PoV: in the sense, if it=
 is
> not prohibited by the virtio specs, then it should work. Maybe.

Limitations must be specified either in the 9P protocol or the VIRTIO
specification. Drivers and devices will not be able to operate correctly
if there are limitations that aren't covered by the specs.

Do you have something in mind that isn't covered by the specs?

> > If this function coalesces adjacent pages then the descriptor chain
> > length issues could be reduced.
> >=20
> > > > > But again, this is not just about performance. My conclusion as
> > > > > described
> > > > > in my previous email is that virtio currently squeezes
> > > > >=20
> > > > > 	"max. simultanious amount of bulk messages"
> > > > >=20
> > > > > vs.
> > > > >=20
> > > > > 	"max. bulk data transmission size per bulk messaage"
> > > > >=20
> > > > > into the same configuration parameter, which is IMO inappropriate=
 and
> > > > > hence
> > > > > splitting them into 2 separate parameters when creating a queue m=
akes
> > > > > sense, independent of the performance benchmarks.
> > > > >=20
> > > > > [1]
> > > > > https://lore.kernel.org/netdev/cover.1632327421.git.linux_oss@cru=
debyt
> > > > > e.c
> > > > > om/
> > > >=20
> > > > Some devices effectively already have this because the device adver=
tises
> > > > a maximum number of descriptors via device-specific mechanisms like=
 the
> > > > struct virtio_blk_config seg_max field. But today these fields can =
only
> > > > reduce the maximum descriptor chain length because the spec still l=
imits
> > > > the length to Queue Size.
> > > >=20
> > > > We can build on this approach to raise the length above Queue Size.=
 This
> > > > approach has the advantage that the maximum number of segments isn'=
t per
> > > > device or per virtqueue, it's fine-grained. If the device supports =
two
> > > > requests types then different max descriptor chain limits could be =
given
> > > > for them by introducing two separate configuration space fields.
> > > >=20
> > > > Here are the corresponding spec changes:
> > > >=20
> > > > 1. A new feature bit called VIRTIO_RING_F_LARGE_INDIRECT_DESC is ad=
ded
> > > >=20
> > > >    to indicate that indirect descriptor table size and maximum
> > > >    descriptor chain length are not limited by Queue Size value. (Ma=
ybe
> > > >    there still needs to be a limit like 2^15?)
> > >=20
> > > Sounds good to me!
> > >=20
> > > AFAIK it is effectively limited to 2^16 because of vring_desc->next:
> > >=20
> > > /* Virtio ring descriptors: 16 bytes.  These can chain together via
> > > "next". */ struct vring_desc {
> > >=20
> > >         /* Address (guest-physical). */
> > >         __virtio64 addr;
> > >         /* Length. */
> > >         __virtio32 len;
> > >         /* The flags as indicated above. */
> > >         __virtio16 flags;
> > >         /* We chain unused descriptors via this, too */
> > >         __virtio16 next;
> > >=20
> > > };
> >=20
> > Yes, Split Virtqueues have a fundamental limit on indirect table size
> > due to the "next" field. Packed Virtqueue descriptors don't have a
> > "next" field so descriptor chains could be longer in theory (currently
> > forbidden by the spec).
> >=20
> > > > One thing that's messy is that we've been discussing the maximum
> > > > descriptor chain length but 9p has the "msize" concept, which isn't
> > > > aware of contiguous memory. It may be necessary to extend the 9p dr=
iver
> > > > code to size requests not just according to their length in bytes b=
ut
> > > > also according to the descriptor chain length. That's how the Linux
> > > > block layer deals with queue limits (struct queue_limits max_segmen=
ts vs
> > > > max_hw_sectors).
> > >=20
> > > Hmm, can't follow on that one. For what should that be needed in case=
 of
> > > 9p? My plan was to limit msize by 9p client simply at session start to
> > > whatever is the max. amount virtio descriptors supported by host and
> > > using PAGE_SIZE as size per descriptor, because that's what 9p client
> > > actually does ATM (see above). So you think that should be changed to
> > > e.g. just one descriptor for 4MB, right?
> >=20
> > Limiting msize to the 9p transport device's maximum number of
> > descriptors is conservative (i.e. 128 descriptors =3D 512 KB msize)
> > because it doesn't take advantage of contiguous memory. I suggest
> > leaving msize alone, adding a separate limit at which requests are split
> > according to the maximum descriptor chain length, and tweaking
> > pack_sg_list() to coalesce adjacent pages.
> >=20
> > That way msize can be large without necessarily using lots of
> > descriptors (depending on the memory layout).
>=20
> That was actually a tempting solution. Because it would neither require
> changes to the virtio specs (at least for a while) and it would also work=
 with
> older QEMU versions. And for that pack_sg_list() portion of the code it w=
ould
> work well and easy as the buffer passed to pack_sg_list() is contiguous
> already.
>=20
> However I just realized for the zero-copy version of the code that would =
be
> more tricky. The ZC version already uses individual pages (struct page, h=
ence
> PAGE_SIZE each) which are pinned, i.e. it uses pack_sg_list_p() [1] in
> combination with p9_get_mapped_pages() [2]
>=20
> [1] https://github.com/torvalds/linux/blob/7ddb58cb0ecae8e8b6181d736a8766=
7cc9ab8389/net/9p/trans_virtio.c#L218
> [2] https://github.com/torvalds/linux/blob/7ddb58cb0ecae8e8b6181d736a8766=
7cc9ab8389/net/9p/trans_virtio.c#L309
>=20
> So that would require much more work and code trying to sort and coalesce
> individual pages to contiguous physical memory for the sake of reducing v=
irtio
> descriptors. And there is no guarantee that this is even possible. The ke=
rnel
> may simply return a non-contiguous set of pages which would eventually en=
d up
> exceeding the virtio descriptor limit again.

Order must be preserved so pages cannot be sorted by physical address.
How about simply coalescing when pages are adjacent?

> So looks like it was probably still easier and realistic to just add virt=
io
> capabilities for now for allowing to exceed current descriptor limit.

I'm still not sure why virtio-net, virtio-blk, virtio-fs, etc perform
fine under today's limits while virtio-9p needs a much higher limit to
achieve good performance. Maybe there is an issue in a layer above the
vring that's causing the virtio-9p performance you've observed?

Stefan

--YlhwJtpVs6k35bMG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmGKU+MACgkQnKSrs4Gr
c8jpWQgAlOkbpDw5oqhl/rk+lmIFnBS/pw3zuR0kih64c9jlpJzmA78P9qJyiB5O
c2evLZ80mxfeiuf7udEl/zMotYLB2Wdg4Fhu3RJAhSg/55YxVaPjSxpErrRIZvnm
e/fN87eG9ohOM8jEK1JAx8sJ9Ze5lvJF8WXm5ORE5ERXQA+RxQfv5mSotFLigRiT
ugMHYqLbhr3AU8Y3SUvX5mAN47NOYa0VKfKpngKo+5JmaBzdU6Eu01PZwL2U8wKJ
Gn460nTX/YtGZQ4UiwJiKpKSXHArriOxm0eTa4Dr/uFMFHwMY0WzsvhEMxXt6/Wt
HAiDKQ6dwF1Y/KDbNNiVDpyqhJvhQA==
=xg5T
-----END PGP SIGNATURE-----

--YlhwJtpVs6k35bMG--

