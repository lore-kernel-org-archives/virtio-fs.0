Date: Wed, 6 Oct 2021 12:06:55 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YV2DT+EMqDN+gSHf@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<14205148.YOBg3JvQBA@silver>
	<YVxq8EwB8uXouiEj@stefanha-x1.localdomain>
	<1950551.Wq8TZpmmRU@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CbGrShKKTC1j3YmI"
Content-Disposition: inline
In-Reply-To: <1950551.Wq8TZpmmRU@silver>
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


--CbGrShKKTC1j3YmI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 05, 2021 at 06:32:46PM +0200, Christian Schoenebeck wrote:
> On Dienstag, 5. Oktober 2021 17:10:40 CEST Stefan Hajnoczi wrote:
> > On Tue, Oct 05, 2021 at 03:15:26PM +0200, Christian Schoenebeck wrote:
> > > On Dienstag, 5. Oktober 2021 14:45:56 CEST Stefan Hajnoczi wrote:
> > > > On Mon, Oct 04, 2021 at 09:38:04PM +0200, Christian Schoenebeck wro=
te:
> > > > > Refactor VIRTQUEUE_MAX_SIZE to effectively become a runtime
> > > > > variable per virtio user.
> > > >=20
> > > > virtio user =3D=3D virtio device model?
> > >=20
> > > Yes
> > >=20
> > > > > Reasons:
> > > > >=20
> > > > > (1) VIRTQUEUE_MAX_SIZE should reflect the absolute theoretical
> > > > >=20
> > > > >     maximum queue size possible. Which is actually the maximum
> > > > >     queue size allowed by the virtio protocol. The appropriate
> > > > >     value for VIRTQUEUE_MAX_SIZE would therefore be 32768:
> > > > >    =20
> > > > >     https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1=
=2E1-cs
> > > > >     01.h
> > > > >     tml#x1-240006
> > > > >    =20
> > > > >     Apparently VIRTQUEUE_MAX_SIZE was instead defined with a
> > > > >     more or less arbitrary value of 1024 in the past, which
> > > > >     limits the maximum transfer size with virtio to 4M
> > > > >     (more precise: 1024 * PAGE_SIZE, with the latter typically
> > > > >     being 4k).
> > > >=20
> > > > Being equal to IOV_MAX is a likely reason. Buffers with more iovecs=
 than
> > > > that cannot be passed to host system calls (sendmsg(2), pwritev(2),
> > > > etc).
> > >=20
> > > Yes, that's use case dependent. Hence the solution to opt-in if it is
> > > desired and feasible.
> > >=20
> > > > > (2) Additionally the current value of 1024 poses a hidden limit,
> > > > >=20
> > > > >     invisible to guest, which causes a system hang with the
> > > > >     following QEMU error if guest tries to exceed it:
> > > > >    =20
> > > > >     virtio: too many write descriptors in indirect table
> > > >=20
> > > > I don't understand this point. 2.6.5 The Virtqueue Descriptor Table=
=20
> says:
> > > >   The number of descriptors in the table is defined by the queue si=
ze
> > > >   for
> > > >=20
> > > > this virtqueue: this is the maximum possible descriptor chain lengt=
h.
> > > >=20
> > > > and 2.6.5.3.1 Driver Requirements: Indirect Descriptors says:
> > > >   A driver MUST NOT create a descriptor chain longer than the Queue=
 Size
> > > >   of
> > > >=20
> > > > the device.
> > > >=20
> > > > Do you mean a broken/malicious guest driver that is violating the s=
pec?
> > > > That's not a hidden limit, it's defined by the spec.
> > >=20
> > > https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00781.html
> > > https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00788.html
> > >=20
> > > You can already go beyond that queue size at runtime with the indirec=
tion
> > > table. The only actual limit is the currently hard coded value of 1k
> > > pages.
> > > Hence the suggestion to turn that into a variable.
> >=20
> > Exceeding Queue Size is a VIRTIO spec violation. Drivers that operate
> > outsided the spec do so at their own risk. They may not be compatible
> > with all device implementations.
>=20
> Yes, I am ware about that. And still, this practice is already done, whic=
h=20
> apparently is not limited to 9pfs.
>=20
> > The limit is not hidden, it's Queue Size as defined by the spec :).
> >=20
> > If you have a driver that is exceeding the limit, then please fix the
> > driver.
>=20
> I absolutely understand your position, but I hope you also understand tha=
t=20
> this violation of the specs is a theoretical issue, it is not a real-life=
=20
> problem right now, and due to lack of man power unfortunately I have to=
=20
> prioritize real-life problems over theoretical ones ATM. Keep in mind tha=
t=20
> right now I am the only person working on 9pfs actively, I do this volunt=
arily=20
> whenever I find a free time slice, and I am not paid for it either.
>=20
> I don't see any reasonable way with reasonable effort to do what you are=
=20
> asking for here in 9pfs, and Greg may correct me here if I am saying anyt=
hing=20
> wrong. If you are seeing any specific real-life issue here, then please t=
ell=20
> me which one, otherwise I have to postpone that "specs violation" issue.
>=20
> There is still a long list of real problems that I need to hunt down in 9=
pfs,=20
> afterwards I can continue with theoretical ones if you want, but right no=
w I=20
> simply can't, sorry.

I understand. If you don't have time to fix the Linux virtio-9p driver
then that's fine.

I still wanted us to agree on the spec position because the commit
description says it's a "hidden limit", which is incorrect. It might
seem pedantic, but my concern is that misconceptions can spread if we
let them. That could cause people to write incorrect code later on.
Please update the commit description either by dropping 2) or by
replacing it with something else. For example:

  2) The Linux virtio-9p guest driver does not honor the VIRTIO Queue
     Size value and can submit descriptor chains that exceed it. That is
     a spec violation but is accepted by QEMU's device implementation.

     When the guest creates a descriptor chain larger than 1024 the
     following QEMU error is printed and the guest hangs:

     virtio: too many write descriptors in indirect table

> > > > > (3) Unfortunately not all virtio users in QEMU would currently
> > > > >=20
> > > > >     work correctly with the new value of 32768.
> > > > >=20
> > > > > So let's turn this hard coded global value into a runtime
> > > > > variable as a first step in this commit, configurable for each
> > > > > virtio user by passing a corresponding value with virtio_init()
> > > > > call.
> > > >=20
> > > > virtio_add_queue() already has an int queue_size argument, why isn't
> > > > that enough to deal with the maximum queue size? There's probably a=
 good
> > > > reason for it, but please include it in the commit description.
> > >=20
> > > [...]
> > >=20
> > > > Can you make this value per-vq instead of per-vdev since virtqueues=
 can
> > > > have different queue sizes?
> > > >=20
> > > > The same applies to the rest of this patch. Anything using
> > > > vdev->queue_max_size should probably use vq->vring.num instead.
> > >=20
> > > I would like to avoid that and keep it per device. The maximum size s=
tored
> > > there is the maximum size supported by virtio user (or vortio device
> > > model,
> > > however you want to call it). So that's really a limit per device, no=
t per
> > > queue, as no queue of the device would ever exceed that limit.
> > >=20
> > > Plus a lot more code would need to be refactored, which I think is
> > > unnecessary.
> >=20
> > I'm against a per-device limit because it's a concept that cannot
> > accurately describe reality. Some devices have multiple classes of
>=20
> It describes current reality, because VIRTQUEUE_MAX_SIZE obviously is not=
 per=20
> queue either ATM, and nobody ever cared.
>=20
> All this series does, is allowing to override that currently project-wide=
=20
> compile-time constant to a per-driver-model compile-time constant. Which =
makes=20
> sense, because that's what it is: some drivers could cope with any transf=
er=20
> size, and some drivers are constrained to a certain maximum application=
=20
> specific transfer size (e.g. IOV_MAX).
>=20
> > virtqueues and they are sized differently, so a per-device limit is
> > insufficient. virtio-net has separate rx_queue_size and tx_queue_size
> > parameters (plus a control vq hardcoded to 64 descriptors).
>=20
> I simply find this overkill. This value semantically means "my driver mod=
el=20
> supports at any time and at any coincidence at the very most x * PAGE_SIZ=
E =3D=20
> max_transfer_size". Do you see any driver that might want a more fine gra=
ded=20
> control over this?

One reason why per-vq limits could make sense is that the maximum
possible number of struct elements is allocated upfront in some code
paths. Those code paths may need to differentiate between per-vq limits
for performance or memory utilization reasons. Today some places
allocate 1024 elements on the stack in some code paths, but maybe that's
not acceptable when the per-device limit is 32k. This can matter when a
device has vqs with very different sizes.

> As far as I can see, no other driver maintainer even seems to care to=20
> transition to 32k. So I simply doubt that anybody would even want a more=
=20
> fained graded control over this in practice, but anyway ...
>=20
> > The specification already gives us Queue Size (vring.num in QEMU). The
> > variable exists in QEMU and just needs to be used.
> >=20
> > If per-vq limits require a lot of work, please describe why. I think
> > replacing the variable from this patch with virtio_queue_get_num()
> > should be fairly straightforward, but maybe I'm missing something? (If
> > you prefer VirtQueue *vq instead of the index-based
> > virtio_queue_get_num() API, you can introduce a virtqueue_get_num()
> > API.)
> >=20
> > Stefan
>=20
> ... I leave that up to Michael or whoever might be in charge to decide. I=
=20
> still find this overkill, but I will adapt this to whatever the decision=
=20
> eventually will be in v3.
>=20
> But then please tell me the precise representation that you find appropri=
ate,=20
> i.e. whether you want a new function for that, or rather an additional=20
> argument to virtio_add_queue(). Your call.

virtio_add_queue() already takes an int queue_size argument. I think the
necessary information is already there.

This patch just needs to be tweaked to use the virtio_queue_get_num()
(or a new virtqueue_get_num() API if that's easier because only a
VirtQueue *vq pointer is available) instead of introducing a new
per-device limit.

The patch will probably become smaller.

Stefan

--CbGrShKKTC1j3YmI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFdg08ACgkQnKSrs4Gr
c8hfvAf9EBJ9k1y1JX4Z0L58qZezxnelszY8cAXsUbhfIgFyqE7qsvIWQ66DYPJS
QwX5YVhtsm0bAVVtca3hPrbdSdmQjyBMCuqKjGeIgjOcylWhuj84gOLVM33/ECBc
nGMPCBdn7a+AqN9VmrEaRq8UgAF26fjog2HBlZon6O1+X4rpNbaXZeGNBCEByD9U
grlw95CRJB+09TR2AL56HnXPwc03LitAwwhH8AvN/UcAdGCQ8Bplk2cRM1WIJ0oB
N02vEzGrZIiavJEp9EolZEipr1Q7K5Xl75VTXH6/bYFOmeGJF6oYggzWaJaT1hyB
Wd62FLRAlLJxvJi73S8jOU5JHFGjfg==
=FHL2
-----END PGP SIGNATURE-----

--CbGrShKKTC1j3YmI--

