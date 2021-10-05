Date: Tue, 5 Oct 2021 16:10:40 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVxq8EwB8uXouiEj@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<c9dea2e27ae19b2b9a51e8f08687067bf3e47bd5.1633376313.git.qemu_oss@crudebyte.com>
	<YVxJBKqsytKlos6M@stefanha-x1.localdomain>
	<14205148.YOBg3JvQBA@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0TV9MjxZ6i5UeWtD"
Content-Disposition: inline
In-Reply-To: <14205148.YOBg3JvQBA@silver>
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
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, Raphael Norwitz <raphael.norwitz@nutanix.com>


--0TV9MjxZ6i5UeWtD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 05, 2021 at 03:15:26PM +0200, Christian Schoenebeck wrote:
> On Dienstag, 5. Oktober 2021 14:45:56 CEST Stefan Hajnoczi wrote:
> > On Mon, Oct 04, 2021 at 09:38:04PM +0200, Christian Schoenebeck wrote:
> > > Refactor VIRTQUEUE_MAX_SIZE to effectively become a runtime
> > > variable per virtio user.
> >=20
> > virtio user =3D=3D virtio device model?
>=20
> Yes
>=20
> > > Reasons:
> > >=20
> > > (1) VIRTQUEUE_MAX_SIZE should reflect the absolute theoretical
> > >=20
> > >     maximum queue size possible. Which is actually the maximum
> > >     queue size allowed by the virtio protocol. The appropriate
> > >     value for VIRTQUEUE_MAX_SIZE would therefore be 32768:
> > >    =20
> > >     https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-c=
s01.h
> > >     tml#x1-240006
> > >    =20
> > >     Apparently VIRTQUEUE_MAX_SIZE was instead defined with a
> > >     more or less arbitrary value of 1024 in the past, which
> > >     limits the maximum transfer size with virtio to 4M
> > >     (more precise: 1024 * PAGE_SIZE, with the latter typically
> > >     being 4k).
> >=20
> > Being equal to IOV_MAX is a likely reason. Buffers with more iovecs than
> > that cannot be passed to host system calls (sendmsg(2), pwritev(2),
> > etc).
>=20
> Yes, that's use case dependent. Hence the solution to opt-in if it is des=
ired=20
> and feasible.
>=20
> > > (2) Additionally the current value of 1024 poses a hidden limit,
> > >=20
> > >     invisible to guest, which causes a system hang with the
> > >     following QEMU error if guest tries to exceed it:
> > >    =20
> > >     virtio: too many write descriptors in indirect table
> >=20
> > I don't understand this point. 2.6.5 The Virtqueue Descriptor Table say=
s:
> >=20
> >   The number of descriptors in the table is defined by the queue size f=
or
> > this virtqueue: this is the maximum possible descriptor chain length.
> >=20
> > and 2.6.5.3.1 Driver Requirements: Indirect Descriptors says:
> >=20
> >   A driver MUST NOT create a descriptor chain longer than the Queue Siz=
e of
> > the device.
> >=20
> > Do you mean a broken/malicious guest driver that is violating the spec?
> > That's not a hidden limit, it's defined by the spec.
>=20
> https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00781.html
> https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00788.html
>=20
> You can already go beyond that queue size at runtime with the indirection=
=20
> table. The only actual limit is the currently hard coded value of 1k page=
s.=20
> Hence the suggestion to turn that into a variable.

Exceeding Queue Size is a VIRTIO spec violation. Drivers that operate
outsided the spec do so at their own risk. They may not be compatible
with all device implementations.

The limit is not hidden, it's Queue Size as defined by the spec :).

If you have a driver that is exceeding the limit, then please fix the
driver.

> > > (3) Unfortunately not all virtio users in QEMU would currently
> > >=20
> > >     work correctly with the new value of 32768.
> > >=20
> > > So let's turn this hard coded global value into a runtime
> > > variable as a first step in this commit, configurable for each
> > > virtio user by passing a corresponding value with virtio_init()
> > > call.
> >=20
> > virtio_add_queue() already has an int queue_size argument, why isn't
> > that enough to deal with the maximum queue size? There's probably a good
> > reason for it, but please include it in the commit description.
> [...]
> > Can you make this value per-vq instead of per-vdev since virtqueues can
> > have different queue sizes?
> >=20
> > The same applies to the rest of this patch. Anything using
> > vdev->queue_max_size should probably use vq->vring.num instead.
>=20
> I would like to avoid that and keep it per device. The maximum size store=
d=20
> there is the maximum size supported by virtio user (or vortio device mode=
l,=20
> however you want to call it). So that's really a limit per device, not pe=
r=20
> queue, as no queue of the device would ever exceed that limit.
>
> Plus a lot more code would need to be refactored, which I think is=20
> unnecessary.

I'm against a per-device limit because it's a concept that cannot
accurately describe reality. Some devices have multiple classes of
virtqueues and they are sized differently, so a per-device limit is
insufficient. virtio-net has separate rx_queue_size and tx_queue_size
parameters (plus a control vq hardcoded to 64 descriptors).

The specification already gives us Queue Size (vring.num in QEMU). The
variable exists in QEMU and just needs to be used.

If per-vq limits require a lot of work, please describe why. I think
replacing the variable from this patch with virtio_queue_get_num()
should be fairly straightforward, but maybe I'm missing something? (If
you prefer VirtQueue *vq instead of the index-based
virtio_queue_get_num() API, you can introduce a virtqueue_get_num()
API.)

Stefan

--0TV9MjxZ6i5UeWtD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFcau8ACgkQnKSrs4Gr
c8iaYwgAmwRQZpE3jGmWAGCowPQDYDW5GPepW7Ot+FHPDs9DOdaXfBbYwxmbHvWx
d2vLlf+mjNFeNUKRH3o5AE5YIJxxLnEVqEIkT2LV9F3fO6ZUzZqsiYFENxwLVSet
pkwruBwa8wGjvHJBE7Clq6UQK+hI1t/ISr3CfpAYTGvBnsZPB4nY8jhILPO/SFvg
3FPGswWBW/FCjvpIwrL9MMPLCcvNNZXbEbbbs82Lure5dBNupQmFTaplhqM1p631
sbSCfXicHy6YgV0Sdeo3iKBlQW8Aubo6EPoHdweNuOX0RUP3PY7OP5g7wRK66TPN
zfVbFAR+eK8jmL0cctGLWxztlD7KVQ==
=WgIn
-----END PGP SIGNATURE-----

--0TV9MjxZ6i5UeWtD--

