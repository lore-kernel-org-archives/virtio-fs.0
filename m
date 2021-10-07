Date: Thu, 7 Oct 2021 16:18:03 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YV8Pqwap4oR8fpvc@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<6923459.JjrQbDWbmU@silver>
	<YV212nXgIuxtKZmS@stefanha-x1.localdomain>
	<5138892.89BctLniTh@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LAHpfhj4GA/IJNp6"
Content-Disposition: inline
In-Reply-To: <5138892.89BctLniTh@silver>
Subject: Re: [Virtio-fs] [PATCH v2 1/3] virtio: turn VIRTQUEUE_MAX_SIZE into
	a variable
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


--LAHpfhj4GA/IJNp6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 07, 2021 at 03:09:16PM +0200, Christian Schoenebeck wrote:
> On Mittwoch, 6. Oktober 2021 16:42:34 CEST Stefan Hajnoczi wrote:
> > On Wed, Oct 06, 2021 at 02:50:07PM +0200, Christian Schoenebeck wrote:
> > > On Mittwoch, 6. Oktober 2021 13:06:55 CEST Stefan Hajnoczi wrote:
> > > > On Tue, Oct 05, 2021 at 06:32:46PM +0200, Christian Schoenebeck wro=
te:
> > > > > On Dienstag, 5. Oktober 2021 17:10:40 CEST Stefan Hajnoczi wrote:
> > > > > > On Tue, Oct 05, 2021 at 03:15:26PM +0200, Christian Schoenebeck=
=20
> wrote:
> > > > > > > On Dienstag, 5. Oktober 2021 14:45:56 CEST Stefan Hajnoczi wr=
ote:
> > > > > > > > On Mon, Oct 04, 2021 at 09:38:04PM +0200, Christian Schoene=
beck
> > >=20
> > > wrote:
> > > > > > > > > Refactor VIRTQUEUE_MAX_SIZE to effectively become a runti=
me
> > > > > > > > > variable per virtio user.
> > > > > > > >=20
> > > > > > > > virtio user =3D=3D virtio device model?
> > > > > > >=20
> > > > > > > Yes
> > > > > > >=20
> > > > > > > > > Reasons:
> > > > > > > > >=20
> > > > > > > > > (1) VIRTQUEUE_MAX_SIZE should reflect the absolute theore=
tical
> > > > > > > > >=20
> > > > > > > > >     maximum queue size possible. Which is actually the ma=
ximum
> > > > > > > > >     queue size allowed by the virtio protocol. The approp=
riate
> > > > > > > > >     value for VIRTQUEUE_MAX_SIZE would therefore be 32768:
> > > > > > > > >    =20
> > > > > > > > >     https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/v=
irtio
> > > > > > > > >     -v1.
> > > > > > > > >     1-cs
> > > > > > > > >     01.h
> > > > > > > > >     tml#x1-240006
> > > > > > > > >    =20
> > > > > > > > >     Apparently VIRTQUEUE_MAX_SIZE was instead defined wit=
h a
> > > > > > > > >     more or less arbitrary value of 1024 in the past, whi=
ch
> > > > > > > > >     limits the maximum transfer size with virtio to 4M
> > > > > > > > >     (more precise: 1024 * PAGE_SIZE, with the latter typi=
cally
> > > > > > > > >     being 4k).
> > > > > > > >=20
> > > > > > > > Being equal to IOV_MAX is a likely reason. Buffers with more
> > > > > > > > iovecs
> > > > > > > > than
> > > > > > > > that cannot be passed to host system calls (sendmsg(2),
> > > > > > > > pwritev(2),
> > > > > > > > etc).
> > > > > > >=20
> > > > > > > Yes, that's use case dependent. Hence the solution to opt-in =
if it
> > > > > > > is
> > > > > > > desired and feasible.
> > > > > > >=20
> > > > > > > > > (2) Additionally the current value of 1024 poses a hidden
> > > > > > > > > limit,
> > > > > > > > >=20
> > > > > > > > >     invisible to guest, which causes a system hang with t=
he
> > > > > > > > >     following QEMU error if guest tries to exceed it:
> > > > > > > > >    =20
> > > > > > > > >     virtio: too many write descriptors in indirect table
> > > > > > > >=20
> > > > > > > > I don't understand this point. 2.6.5 The Virtqueue Descript=
or
> > > > > > > > Table
> > > > >=20
> > > > > says:
> > > > > > > >   The number of descriptors in the table is defined by the =
queue
> > > > > > > >   size
> > > > > > > >   for
> > > > > > > >=20
> > > > > > > > this virtqueue: this is the maximum possible descriptor cha=
in
> > > > > > > > length.
> > > > > > > >=20
> > > > > > > > and 2.6.5.3.1 Driver Requirements: Indirect Descriptors say=
s:
> > > > > > > >   A driver MUST NOT create a descriptor chain longer than t=
he
> > > > > > > >   Queue
> > > > > > > >   Size
> > > > > > > >   of
> > > > > > > >=20
> > > > > > > > the device.
> > > > > > > >=20
> > > > > > > > Do you mean a broken/malicious guest driver that is violati=
ng
> > > > > > > > the
> > > > > > > > spec?
> > > > > > > > That's not a hidden limit, it's defined by the spec.
> > > > > > >=20
> > > > > > > https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg0078=
1.htm
> > > > > > > l
> > > > > > > https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg0078=
8.htm
> > > > > > > l
> > > > > > >=20
> > > > > > > You can already go beyond that queue size at runtime with the
> > > > > > > indirection
> > > > > > > table. The only actual limit is the currently hard coded valu=
e of
> > > > > > > 1k
> > > > > > > pages.
> > > > > > > Hence the suggestion to turn that into a variable.
> > > > > >=20
> > > > > > Exceeding Queue Size is a VIRTIO spec violation. Drivers that
> > > > > > operate
> > > > > > outsided the spec do so at their own risk. They may not be
> > > > > > compatible
> > > > > > with all device implementations.
> > > > >=20
> > > > > Yes, I am ware about that. And still, this practice is already do=
ne,
> > > > > which
> > > > > apparently is not limited to 9pfs.
> > > > >=20
> > > > > > The limit is not hidden, it's Queue Size as defined by the spec=
 :).
> > > > > >=20
> > > > > > If you have a driver that is exceeding the limit, then please f=
ix
> > > > > > the
> > > > > > driver.
> > > > >=20
> > > > > I absolutely understand your position, but I hope you also unders=
tand
> > > > > that
> > > > > this violation of the specs is a theoretical issue, it is not a
> > > > > real-life
> > > > > problem right now, and due to lack of man power unfortunately I h=
ave
> > > > > to
> > > > > prioritize real-life problems over theoretical ones ATM. Keep in =
mind
> > > > > that
> > > > > right now I am the only person working on 9pfs actively, I do this
> > > > > voluntarily whenever I find a free time slice, and I am not paid =
for
> > > > > it
> > > > > either.
> > > > >=20
> > > > > I don't see any reasonable way with reasonable effort to do what =
you
> > > > > are
> > > > > asking for here in 9pfs, and Greg may correct me here if I am say=
ing
> > > > > anything wrong. If you are seeing any specific real-life issue he=
re,
> > > > > then
> > > > > please tell me which one, otherwise I have to postpone that "specs
> > > > > violation" issue.
> > > > >=20
> > > > > There is still a long list of real problems that I need to hunt d=
own
> > > > > in
> > > > > 9pfs, afterwards I can continue with theoretical ones if you want=
, but
> > > > > right now I simply can't, sorry.
> > > >=20
> > > > I understand. If you don't have time to fix the Linux virtio-9p dri=
ver
> > > > then that's fine.
> > >=20
> > > I will look at this again, but it might be tricky. On doubt I'll post=
pone
> > > it.>=20
> > > > I still wanted us to agree on the spec position because the commit
> > > > description says it's a "hidden limit", which is incorrect. It might
> > > > seem pedantic, but my concern is that misconceptions can spread if =
we
> > > > let them. That could cause people to write incorrect code later on.
> > > > Please update the commit description either by dropping 2) or by
> > > >=20
> > > > replacing it with something else. For example:
> > > >   2) The Linux virtio-9p guest driver does not honor the VIRTIO Que=
ue
> > > >  =20
> > > >      Size value and can submit descriptor chains that exceed it. Th=
at is
> > > >      a spec violation but is accepted by QEMU's device implementati=
on.
> > > >     =20
> > > >      When the guest creates a descriptor chain larger than 1024 the
> > > >      following QEMU error is printed and the guest hangs:
> > > >     =20
> > > >      virtio: too many write descriptors in indirect table
> > >=20
> > > I am fine with both, probably preferring the text block above instead=
 of
> > > silently dropping the reason, just for clarity.
> > >=20
> > > But keep in mind that this might not be limited to virtio-9p as your =
text
> > > would suggest, see below.
> > >=20
> > > > > > > > > (3) Unfortunately not all virtio users in QEMU would curr=
ently
> > > > > > > > >=20
> > > > > > > > >     work correctly with the new value of 32768.
> > > > > > > > >=20
> > > > > > > > > So let's turn this hard coded global value into a runtime
> > > > > > > > > variable as a first step in this commit, configurable for=
 each
> > > > > > > > > virtio user by passing a corresponding value with
> > > > > > > > > virtio_init()
> > > > > > > > > call.
> > > > > > > >=20
> > > > > > > > virtio_add_queue() already has an int queue_size argument, =
why
> > > > > > > > isn't
> > > > > > > > that enough to deal with the maximum queue size? There's
> > > > > > > > probably a
> > > > > > > > good
> > > > > > > > reason for it, but please include it in the commit descript=
ion.
> > > > > > >=20
> > > > > > > [...]
> > > > > > >=20
> > > > > > > > Can you make this value per-vq instead of per-vdev since
> > > > > > > > virtqueues
> > > > > > > > can
> > > > > > > > have different queue sizes?
> > > > > > > >=20
> > > > > > > > The same applies to the rest of this patch. Anything using
> > > > > > > > vdev->queue_max_size should probably use vq->vring.num inst=
ead.
> > > > > > >=20
> > > > > > > I would like to avoid that and keep it per device. The maximum
> > > > > > > size
> > > > > > > stored
> > > > > > > there is the maximum size supported by virtio user (or vortio
> > > > > > > device
> > > > > > > model,
> > > > > > > however you want to call it). So that's really a limit per de=
vice,
> > > > > > > not
> > > > > > > per
> > > > > > > queue, as no queue of the device would ever exceed that limit.
> > > > > > >=20
> > > > > > > Plus a lot more code would need to be refactored, which I thi=
nk is
> > > > > > > unnecessary.
> > > > > >=20
> > > > > > I'm against a per-device limit because it's a concept that cann=
ot
> > > > > > accurately describe reality. Some devices have multiple classes=
 of
> > > > >=20
> > > > > It describes current reality, because VIRTQUEUE_MAX_SIZE obviousl=
y is
> > > > > not
> > > > > per queue either ATM, and nobody ever cared.
> > > > >=20
> > > > > All this series does, is allowing to override that currently
> > > > > project-wide
> > > > > compile-time constant to a per-driver-model compile-time constant.
> > > > > Which
> > > > > makes sense, because that's what it is: some drivers could cope w=
ith
> > > > > any
> > > > > transfer size, and some drivers are constrained to a certain maxi=
mum
> > > > > application specific transfer size (e.g. IOV_MAX).
> > > > >=20
> > > > > > virtqueues and they are sized differently, so a per-device limi=
t is
> > > > > > insufficient. virtio-net has separate rx_queue_size and
> > > > > > tx_queue_size
> > > > > > parameters (plus a control vq hardcoded to 64 descriptors).
> > > > >=20
> > > > > I simply find this overkill. This value semantically means "my dr=
iver
> > > > > model
> > > > > supports at any time and at any coincidence at the very most x *
> > > > > PAGE_SIZE
> > > > > =3D max_transfer_size". Do you see any driver that might want a m=
ore
> > > > > fine
> > > > > graded control over this?
> > > >=20
> > > > One reason why per-vq limits could make sense is that the maximum
> > > > possible number of struct elements is allocated upfront in some code
> > > > paths. Those code paths may need to differentiate between per-vq li=
mits
> > > > for performance or memory utilization reasons. Today some places
> > > > allocate 1024 elements on the stack in some code paths, but maybe t=
hat's
> > > > not acceptable when the per-device limit is 32k. This can matter wh=
en a
> > > > device has vqs with very different sizes.
> > >=20
> > > [...]
> > >=20
> > > > > ... I leave that up to Michael or whoever might be in charge to
> > > > > decide. I
> > > > > still find this overkill, but I will adapt this to whatever the
> > > > > decision
> > > > > eventually will be in v3.
> > > > >=20
> > > > > But then please tell me the precise representation that you find
> > > > > appropriate, i.e. whether you want a new function for that, or ra=
ther
> > > > > an
> > > > > additional argument to virtio_add_queue(). Your call.
> > > >=20
> > > > virtio_add_queue() already takes an int queue_size argument. I thin=
k the
> > > > necessary information is already there.
> > > >=20
> > > > This patch just needs to be tweaked to use the virtio_queue_get_num=
()
> > > > (or a new virtqueue_get_num() API if that's easier because only a
> > > > VirtQueue *vq pointer is available) instead of introducing a new
> > > > per-device limit.
> > >=20
> > > My understanding is that both the original 9p virtio device authors, =
as
> > > well as other virtio device authors in QEMU have been and are still u=
sing
> > > this as a default value (i.e. to allocate some upfront, and the rest =
on
> > > demand).
> > >=20
> > > So yes, I know your argument about the specs, but AFAICS if I would j=
ust
> > > take this existing numeric argument for the limit, then it would prob=
ably
> > > break those other QEMU devices as well.
> >=20
> > This is a good point that I didn't consider. If guest drivers currently
> > violate the spec, then restricting descriptor chain length to vring.num
> > will introduce regressions.
> >=20
> > We can't use virtio_queue_get_num() directly. A backwards-compatible
> > limit is required:
> >=20
> >   int virtio_queue_get_desc_chain_max(VirtIODevice *vdev, int n)
> >   {
> >       /*
> >        * QEMU historically allowed 1024 descriptors even if the
> >        * descriptor table was smaller.
> >        */
> >       return MAX(virtio_queue_get_num(vdev, qidx), 1024);
> >   }
>=20
> That was an alternative that I thought about as well, but decided against=
=2E It=20
> would require devices (that would want to support large transmissions siz=
es)=20
> to create the virtio queue(s) with the maximum possible size, i.e:
>=20
>   virtio_add_queue(32k);

The spec allows drivers to set the size of the vring as long as they do
not exceed Queue Size.

The Linux drivers accept the device's default size, so you're right that
this would cause large vrings to be allocated if the device sets the
virtqueue size to 32k.

> And that's the point where my current lack of knowledge, of what this wou=
ld=20
> precisely mean to the resulting allocation set, decided against it. I mea=
n=20
> would that mean would QEMU's virtio implementation would just a) allocate=
 32k=20
> scatter gather list entries? Or would it rather b) additionally also allo=
cate=20
> the destination memory pages as well?

The vring consumes guest RAM but it just consists of descriptors, not
the buffer memory pages. The guest RAM requirements are:
- split layout: 32k * 16 + 6 + 32k * 2 + 6 + 8 * 32k =3D 851,980 bytes
- packed layout: 32k * 16 + 4 + 4 =3D 524,296 bytes

That's still quite large!

By the way, virtio-blk currently uses a virtqueue size of 256
descriptors and this has been found reasonable for disk I/O performance.
The Linux block layer splits requests at around 1.25 MB for virtio-blk.
The virtio-blk queue limits are reported by the device and the guest
Linux block layer uses them to size/split requests appropriately. I'm
not sure 9p really needs 32k, although you're right that fragmented
physical memory requires 32k descriptors to describe 128 MB of buffers.

Going back to the original problem, a vring feature bit could be added
to the VIRTIO specification indicating that indirect descriptor tables
are limited to the maximum (32k) instead of Queue Size. This way the
device's default vring size could be small but drivers could allocate
indirect descriptor tables that are large when necessary. Then the Linux
virtio driver API would need to report the maximum supported sglist
length for a given virtqueue so drivers can take advantage of this
information.

Stefan

--LAHpfhj4GA/IJNp6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFfD6sACgkQnKSrs4Gr
c8haHQgArCAWxGJT52W8n4BpLRlj+nF5Imb7lTc6RilzPt7fdsplpMIYa0wnoSuP
Xi7FROy/DtBanu6gmTh7AspN9gdgQhXziSVP6GGR+2FXnBiDGTxfG5QpAvViJN87
mXgkgH1na/xU0dGO62//vubMwfIg5FUdLgs2OpZWUQyrRE0XnnYoZ4b9l0fm2GPl
4KOqjpmOQRnoYTbP6eW4Y+kjkPOIdtfryY4OsjBHDWEagViLxchCFJwKXt3oRjHY
rUvq/yrhSn3BbBA7+T3nTOpa1LMdUBuDx3HrJk38Ap3MS8dSlD7UYaeWbjxbAJ6Z
AlaXX7/F26eZ/gvaj9/qrypA6oLHHg==
=wq6c
-----END PGP SIGNATURE-----

--LAHpfhj4GA/IJNp6--

